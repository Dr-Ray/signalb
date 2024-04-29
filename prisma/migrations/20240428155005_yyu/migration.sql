/*
  Warnings:

  - You are about to alter the column `trading_profit` on the `wallet_balance` table. The data in that column could be lost. The data in that column will be cast from `Int` to `Decimal(65,30)`.
  - You are about to alter the column `trading_deposit` on the `wallet_balance` table. The data in that column could be lost. The data in that column will be cast from `Int` to `Decimal(65,30)`.
  - You are about to alter the column `referal_balance` on the `wallet_balance` table. The data in that column could be lost. The data in that column will be cast from `Int` to `Decimal(65,30)`.

*/
-- AlterTable
ALTER TABLE `wallet_balance` MODIFY `trading_profit` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    MODIFY `trading_deposit` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    MODIFY `btc_mining` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    MODIFY `eth_mining` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    MODIFY `cosmos_mining` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    MODIFY `dogecoin` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    MODIFY `binince_coin` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    MODIFY `referal_balance` DECIMAL(65, 30) NOT NULL DEFAULT 0.00;
