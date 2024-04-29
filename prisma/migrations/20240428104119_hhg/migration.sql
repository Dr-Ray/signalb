-- CreateTable
CREATE TABLE `User` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fullname` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `phone` VARCHAR(191) NULL,
    `password` VARCHAR(191) NOT NULL,
    `currency` VARCHAR(191) NULL,
    `country` VARCHAR(191) NULL,
    `state` VARCHAR(191) NULL,
    `city` VARCHAR(191) NULL,
    `emailverpin` INTEGER NOT NULL,
    `tradingplan` VARCHAR(191) NOT NULL DEFAULT 'Premium account Plan',
    `profilephoto` VARCHAR(191) NOT NULL DEFAULT 'human.png',
    `idfront` VARCHAR(191) NULL,
    `idback` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Traders` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `image` VARCHAR(191) NOT NULL,
    `total_wins` INTEGER NOT NULL,
    `trades` INTEGER NOT NULL,
    `followers` INTEGER NOT NULL,
    `total_losses` INTEGER NOT NULL,
    `win_percent` DECIMAL(65, 30) NOT NULL,
    `profit_share` INTEGER NOT NULL,
    `createdAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RefreshToken` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `hashid` VARCHAR(191) NOT NULL,
    `hashedToken` VARCHAR(191) NOT NULL,
    `userId` INTEGER NOT NULL,
    `revoked` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `RefreshToken_hashid_key`(`hashid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Deposit` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `paytype` VARCHAR(191) NOT NULL,
    `status` VARCHAR(191) NOT NULL,
    `amount` DECIMAL(65, 30) NOT NULL,
    `payerid` INTEGER NOT NULL,
    `payproof` VARCHAR(191) NOT NULL,
    `addresspaidt` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Referal` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `refered_id` INTEGER NOT NULL,
    `referer` INTEGER NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Withdrawal` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `from_wallet` VARCHAR(191) NOT NULL,
    `amount` VARCHAR(191) NOT NULL,
    `to_wallet` VARCHAR(191) NOT NULL,
    `currency` VARCHAR(191) NOT NULL,
    `withdrawer_id` INTEGER NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Wallet_balance` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `trading_profit` INTEGER NOT NULL,
    `trading_deposit` INTEGER NOT NULL,
    `btc_mining` DECIMAL(65, 30) NOT NULL,
    `eth_mining` DECIMAL(65, 30) NOT NULL,
    `cosmos_mining` DECIMAL(65, 30) NOT NULL,
    `dogecoin` DECIMAL(65, 30) NOT NULL,
    `binince_coin` DECIMAL(65, 30) NOT NULL,
    `referal_balance` INTEGER NOT NULL,
    `owner_id` INTEGER NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Wallet_balance_owner_id_key`(`owner_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CopyTraders` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `trader_id` INTEGER NOT NULL,
    `copier_id` INTEGER NOT NULL,
    `accepted` BOOLEAN NOT NULL,
    `Date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `CopyTraders_trader_id_key`(`trader_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Mining` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `mining_rig` VARCHAR(191) NOT NULL,
    `start` BOOLEAN NOT NULL,
    `stop` BOOLEAN NOT NULL,
    `coin` VARCHAR(191) NOT NULL,
    `balance` DECIMAL(65, 30) NOT NULL,
    `stopAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `status` VARCHAR(191) NOT NULL,
    `owner_id` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `RefreshToken` ADD CONSTRAINT `RefreshToken_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Deposit` ADD CONSTRAINT `Deposit_payerid_fkey` FOREIGN KEY (`payerid`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Referal` ADD CONSTRAINT `Referal_referer_fkey` FOREIGN KEY (`referer`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Withdrawal` ADD CONSTRAINT `Withdrawal_withdrawer_id_fkey` FOREIGN KEY (`withdrawer_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Wallet_balance` ADD CONSTRAINT `Wallet_balance_owner_id_fkey` FOREIGN KEY (`owner_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CopyTraders` ADD CONSTRAINT `CopyTraders_trader_id_fkey` FOREIGN KEY (`trader_id`) REFERENCES `Traders`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CopyTraders` ADD CONSTRAINT `CopyTraders_copier_id_fkey` FOREIGN KEY (`copier_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Mining` ADD CONSTRAINT `Mining_owner_id_fkey` FOREIGN KEY (`owner_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
