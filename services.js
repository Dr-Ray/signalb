const bcrypt = require('bcrypt');
const { prisma } = require('./db');

function findUserByEmail(email) {
    return prisma.user.findUnique({
        
        where: {
            email,
        },
        include: {
            wallet_balance: true
        },

    });
}

function createUserByEmailAndPassword(user) {
    user.password = bcrypt.hashSync(user.password, 12);
    user.emailverpin = parseInt(`${Math.floor(Math.random() * 2) + 1}${Math.floor(Math.random() * 2) + 1}${Math.floor(Math.random() * 2) + 1}${Math.floor(Math.random() * 2) + 1}`)
    let ff = {
        password,
        email,
        fullname,
        country,
        phone,
        currency,
        state,
        city,
        emailverpin
    } = user;
    return prisma.user.create({
        data: {
            password,
            email,
            fullname,
            country,
            phone,
            currency,
            state,
            city,
            emailverpin,
            wallet_balance: {
                create: {
                    trading_profit: 0.00,
                    trading_deposit: 0.00,
                    btc_mining: 0.00,
                    eth_mining: 0.00,
                    cosmos_mining: 0.00,
                    dogecoin: 0.00,
                    binince_coin: 0.00,
                    referal_balance: 0.00
                }
            }
        },

        include: {
            wallet_balance: true
        }
    });
}

function addUploadedFile(files) {
    return prisma.uploads.create({
        data: files
    });
}

function addDeposit(data) {
    return prisma.deposit.create({
        data: data
    });
}

function findUserById(id) {
    return prisma.user.findUnique({
        where: {
            id,
        },
    });
}

function findDepositById(payerid) {
    return prisma.deposit.findMany({
        where: {
            payerid,
        },
    });
}

function findSingleDepositById(id) {
    return prisma.deposit.findUnique({
        where: {
            id,
        },
    });
}

function findTradersById(id) {
    return prisma.traders.findUnique({
        where: {
            id,
        },
    });
}

function findWithdrawalById(id) {
    return prisma.withdrawal.findUnique({
        where: {
            id,
        },
    });
}

module.exports = {
    findUserByEmail,
    findUserById,
    addUploadedFile,
    findWithdrawalById,
    findTradersById,
    findDepositById,
    addDeposit,
    findSingleDepositById,
    createUserByEmailAndPassword
};