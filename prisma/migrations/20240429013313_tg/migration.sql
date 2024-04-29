/*
  Warnings:

  - You are about to alter the column `payproof` on the `deposit` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Int`.

*/
-- AlterTable
ALTER TABLE `deposit` MODIFY `payproof` INTEGER NOT NULL;

-- CreateTable
CREATE TABLE `Uploads` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `filename` VARCHAR(191) NOT NULL,
    `uploader_id` INTEGER NOT NULL,
    `filepath` VARCHAR(191) NOT NULL,
    `uploadDesc` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Uploads` ADD CONSTRAINT `Uploads_uploader_id_fkey` FOREIGN KEY (`uploader_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
