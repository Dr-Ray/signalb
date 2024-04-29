-- AlterTable
ALTER TABLE `deposit` ADD COLUMN `paymethod` VARCHAR(191) NOT NULL DEFAULT 'Crypto',
    MODIFY `status` VARCHAR(191) NOT NULL DEFAULT 'Pending',
    MODIFY `payproof` INTEGER NULL;

-- AlterTable
ALTER TABLE `uploads` ADD COLUMN `tableRef` INTEGER NULL;
