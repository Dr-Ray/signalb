/*
  Warnings:

  - You are about to drop the column `binince_coin` on the `user` table. All the data in the column will be lost.
  - You are about to drop the column `btc_mining` on the `user` table. All the data in the column will be lost.
  - You are about to drop the column `cosmos_mining` on the `user` table. All the data in the column will be lost.
  - You are about to drop the column `dogecoin` on the `user` table. All the data in the column will be lost.
  - You are about to drop the column `eth_mining` on the `user` table. All the data in the column will be lost.
  - You are about to drop the column `referal_balance` on the `user` table. All the data in the column will be lost.
  - You are about to drop the column `trading_deposit` on the `user` table. All the data in the column will be lost.
  - You are about to drop the column `trading_profit` on the `user` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `user` DROP COLUMN `binince_coin`,
    DROP COLUMN `btc_mining`,
    DROP COLUMN `cosmos_mining`,
    DROP COLUMN `dogecoin`,
    DROP COLUMN `eth_mining`,
    DROP COLUMN `referal_balance`,
    DROP COLUMN `trading_deposit`,
    DROP COLUMN `trading_profit`;

-- CreateTable
CREATE TABLE `Wallet_balance` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `trading_profit` INTEGER NOT NULL,
    `trading_deposit` INTEGER NOT NULL,
    `btc_mining` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
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

-- AddForeignKey
ALTER TABLE `Wallet_balance` ADD CONSTRAINT `Wallet_balance_owner_id_fkey` FOREIGN KEY (`owner_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
