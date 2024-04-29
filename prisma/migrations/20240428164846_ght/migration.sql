/*
  Warnings:

  - You are about to drop the `wallet_balance` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `wallet_balance` DROP FOREIGN KEY `Wallet_balance_owner_id_fkey`;

-- AlterTable
ALTER TABLE `user` ADD COLUMN `binince_coin` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    ADD COLUMN `btc_mining` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    ADD COLUMN `cosmos_mining` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    ADD COLUMN `dogecoin` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    ADD COLUMN `eth_mining` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    ADD COLUMN `referal_balance` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    ADD COLUMN `trading_deposit` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    ADD COLUMN `trading_profit` DECIMAL(65, 30) NOT NULL DEFAULT 0.00;

-- DropTable
DROP TABLE `wallet_balance`;
