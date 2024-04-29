const express = require('express');
const cors = require('cors')
const jwt = require('jsonwebtoken');
const multer = require("multer");

// Set up storage for uploaded files
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname);
    }
});

const upload = multer({ storage: storage });

// const { prisma } = require('./db');
const bcrypt = require('bcrypt');
const { v4: uuidv4 } = require('uuid');
const { generateTokens } = require('./jwt');

const {
    addRefreshTokenToWhitelist,
    findRefreshTokenById,
    deleteRefreshToken,
    revokeTokens
} = require('./tokenservice');

const {
    findUserByEmail,
    createUserByEmailAndPassword,
    findUserById,
    addUploadedFile,
    addDeposit,
    findDepositById,
    findSingleDepositById,
} = require('./services');
const { hashToken } = require('./hasshtoken');
const { isAuthenticated } = require('./middlewares/middleware');


const app = express();
app.use(express.json())
app.use(cors());
const corsOptions = {
    origin: "http://localhost:3000"
};

app.get('/profile', cors(corsOptions), async (req, res, next) => {
    try {
        const { userId } = req.payload;
        const user = await findUserById(userId);
        delete user.password;
        res.json(user);
    } catch (err) {
        next(err);
    }
});

app.post('/user/deposits/fund/add', cors(corsOptions), async (req, res, next) => {
    const { paytype, amount, wallet_address, payerid } = req.body
    try {
        let d = {
            paytype: paytype,
            amount: amount,
            addresspaidt: wallet_address,
            payerid: payerid
        }

        const depsoit = await addDeposit(d);

        res.status(200);
        res.json({
            status: 200,
            message: 'deposit initiated',
            depositID: depsoit.id
        })
    } catch (err) {
        next(err);
    }
});

app.post('/user/deposits/fund/proof', cors(corsOptions), upload.array("files"), async (req, res, next) => {
    const { filename, path } = req.files[0];

    let d = {
        filename: filename,
        filepath: path,
        uploader_id: parseInt(req.body.uploader_id),
        uploadDesc: "Deposit proof upload"
    }

    const filed = await addUploadedFile(d)

    res.status(200);
    res.json({
        status: 200,
        fileID: filed.id,
        message: "Upload successful"
    })

});

app.post('/user/deposits/fund/all', cors(corsOptions), async (req, res, next) => {
    const {depositor} = req.body;
    try {
        const deposits = await findDepositById(depositor)
        res.status(200);
        res.json({
            status: 200,
            deposits: deposits,
            message: "successful"
        })
    } catch (err) {
        next(err);
    }
});

app.post('/user/deposits/fund/:id', cors(corsOptions), async (req, res, next) => {
    const {id} = req.params.id;
    try {
        const SingleDeposit = await findSingleDepositById(id)
        res.status(200);
        res.json({
            status: 200,
            deposit: SingleDeposit,
            message: "successful"
        })
    } catch (err) {
        next(err);
    }
});

app.post('/user/verification/identity-upload', cors(corsOptions), upload.array("files"), async (req, res, next) => {
    const { filename, path } = req.files[0];

    let d = {
        filename: filename,
        filepath: path,
        uploader_id: parseInt(req.body.uploader_id),
        uploadDesc: "Identity upload"
    }

    const filed = await addUploadedFile(d)

    res.status(200);
    res.json({
        status: 200,
        fileID: filed.id,
        message: "Upload successful"
    })


});

app.post('/user/verification/address-upload', cors(corsOptions), upload.array("files"), async (req, res, next) => {
    const { filename, path } = req.files[0];

    let d = {
        filename: filename,
        filepath: path,
        uploader_id: parseInt(req.body.uploader_id),
        uploadDesc: "Address upload"
    }

    const filed = await addUploadedFile(d)

    res.status(200);
    res.json({
        status: 200,
        fileID: filed.id,
        message: "Upload successful"
    })
});

app.post('/user/register', cors(corsOptions), async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            res.status(400);
            res.json({
                message: 'You must provide an email and a password.'
            })
        }

        const existingUser = await findUserByEmail(email);

        if (existingUser) {
            res.status(400);
            res.json({
                message: 'Email already in use.'
            })
        }

        const user = await createUserByEmailAndPassword(req.body);
        const jti = uuidv4();
        const { accessToken, refreshToken } = generateTokens(user, jti);
        await addRefreshTokenToWhitelist({ jti, refreshToken, userId: user.id });

        res.json({
            status: 200,
            accessToken,
            refreshToken,
            user
        });
    } catch (err) {
        console.log(err)
        next();
    }
});

app.post('/user/login', cors(corsOptions), async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            res.status(400).json({
                message: 'You must provide an email and a password.'
            });
        }

        const existingUser = await findUserByEmail(email);

        if (!existingUser) {
            res.status(403).json({
                message: 'Invalid login credentials.'
            });
        }

        const validPassword = await bcrypt.compare(password, existingUser.password);
        if (!validPassword) {
            res.status(403).json({
                message: 'Invalid login credentials.'
            });
        }

        const jti = uuidv4();
        const { accessToken, refreshToken } = generateTokens(existingUser, jti);
        await addRefreshTokenToWhitelist({ jti, refreshToken, userId: existingUser.id });

        res.status(200);
        res.json({
            status: 200,
            accessToken,
            refreshToken,
            user: existingUser
        });
    } catch (err) {
        next(err);
    }
});


app.post('/refreshToken', cors(corsOptions), async (req, res, next) => {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken) {
            res.status(400);
            throw new Error('Missing refresh token.');
        }
        const payload = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
        const savedRefreshToken = await findRefreshTokenById(payload.jti);

        if (!savedRefreshToken || savedRefreshToken.revoked === true) {
            res.status(401);
            throw new Error('Unauthorized');
        }

        const hashedToken = hashToken(refreshToken);
        if (hashedToken !== savedRefreshToken.hashedToken) {
            res.status(401);
            throw new Error('Unauthorized');
        }

        const user = await findUserById(payload.userId);
        if (!user) {
            res.status(401);
            throw new Error('Unauthorized');
        }

        await deleteRefreshToken(savedRefreshToken.id);
        const jti = uuidv4();
        const { accessToken, refreshToken: newRefreshToken } = generateTokens(user, jti);
        await addRefreshTokenToWhitelist({ jti, refreshToken: newRefreshToken, userId: user.id });

        res.json({
            accessToken,
            refreshToken: newRefreshToken
        });
    } catch (err) {
        next(err);
    }
});

// This endpoint is only for demo purpose.
// Move this logic where you need to revoke the tokens( for ex, on password reset)
app.post('/revokeRefreshTokens', cors(corsOptions), async (req, res, next) => {
    try {
        const { userId } = req.body;
        await revokeTokens(userId);
        res.json({ message: `Tokens revoked for user with id #${userId}` });
    } catch (err) {
        next(err);
    }
});

app.listen(4500, () => console.log('Server is running on port 4500'));
