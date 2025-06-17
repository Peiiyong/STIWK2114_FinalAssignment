-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 17, 2025 at 11:05 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wtms_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_submissions`
--

CREATE TABLE `tbl_submissions` (
  `id` int(11) NOT NULL,
  `work_id` int(11) NOT NULL,
  `worker_id` int(11) NOT NULL,
  `submission_text` text NOT NULL,
  `submitted_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_submissions`
--

INSERT INTO `tbl_submissions` (`id`, `work_id`, `worker_id`, `submission_text`, `submitted_at`) VALUES
(1, 11, 1, 'Sensors in zone A calibrated successfully.', '2025-06-17 00:00:00'),
(2, 16, 1, 'Safety protocols updated in training manual.', '2025-06-17 00:00:00'),
(3, 21, 1, 'Old files archived into storage unit.', '2025-06-17 00:00:00'),
(4, 12, 2, 'All air filters replaced in ventilation.', '2025-06-17 00:00:00'),
(5, 17, 2, 'Patch v2.1 applied to all production PCs.', '2025-06-17 00:00:00'),
(6, 13, 3, 'Full system backup completed successfully.', '2025-06-17 00:00:00'),
(7, 18, 3, 'Fire drill completed with full attendance.', '2025-06-17 00:00:00'),
(8, 14, 4, 'Fire extinguishers checked and up to date.', '2025-06-17 00:00:00'),
(9, 19, 4, 'Lighting system inspected and faulty bulbs replaced.', '2025-06-17 00:00:00'),
(10, 24, 4, 'System diagnostics run without errors.', '2025-06-17 00:00:00'),
(11, 5, 5, 'SOP for packaging unit finalized and shared.', '2025-06-17 00:00:00'),
(12, 10, 5, 'Performance report completed and submitted.', '2025-06-17 00:00:00'),
(13, 29, 5, 'Audit checklist drafted and uploaded.', '2025-06-17 00:00:00'),
(14, 23, 3, 'DONE FOR REVIEW CONTRACTS..', '2025-06-17 16:41:44');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_works`
--

CREATE TABLE `tbl_works` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `assigned_to` int(11) NOT NULL,
  `date_assigned` date NOT NULL,
  `due_date` date NOT NULL,
  `status` varchar(20) DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_works`
--

INSERT INTO `tbl_works` (`id`, `title`, `description`, `assigned_to`, `date_assigned`, `due_date`, `status`) VALUES
(1, 'Prepare Material A', 'Prepare raw material A for assembly.', 1, '2025-05-25', '2025-05-28', 'overdue'),
(2, 'Inspect Machine X', 'Conduct inspection for machine X.', 2, '2025-05-25', '2025-05-29', 'overdue'),
(3, 'Clean Area B', 'Deep clean work area B before audit.', 3, '2025-05-25', '2025-05-30', 'overdue'),
(4, 'Test Circuit Board', 'Perform unit test for circuit batch 4.', 4, '2025-05-25', '2025-05-28', 'pending'),
(5, 'Document Process', 'Write SOP for packaging unit.', 5, '2025-05-25', '2025-05-29', 'submitted'),
(6, 'Paint Booth Check', 'Routine check on painting booth.', 1, '2025-05-25', '2025-05-30', 'overdue'),
(7, 'Label Inventory', 'Label all boxes in section C.', 2, '2025-05-25', '2025-05-28', 'overdue'),
(8, 'Update Database', 'Update inventory in MySQL system.', 3, '2025-05-25', '2025-05-29', 'overdue'),
(9, 'Maintain Equipment', 'Oil and tune cutting machine.', 4, '2025-05-25', '2025-05-30', 'pending'),
(10, 'Prepare Report', 'Prepare monthly performance report.', 5, '2025-05-25', '2025-05-30', 'submitted'),
(11, 'Calibrate Sensors', 'Calibrate all temperature sensors in zone A.', 1, '2025-06-17', '2025-07-03', 'submitted'),
(12, 'Replace Filters', 'Change air filters in ventilation system.', 2, '2025-06-17', '2025-07-05', 'submitted'),
(13, 'Backup Database', 'Perform full system backup.', 3, '2025-06-17', '2025-07-03', 'submitted'),
(14, 'Inspect Fire Ext.', 'Check fire extinguishers for safety.', 4, '2025-06-17', '2025-07-06', 'submitted'),
(15, 'Reorganize Tools', 'Sort and label tools in workshop.', 5, '2025-06-17', '2025-07-07', 'pending'),
(16, 'Training Manual', 'Update safety protocols.', 1, '2025-06-17', '2025-07-09', 'submitted'),
(17, 'Install Software Patch', 'Apply latest patch to production PCs.', 2, '2025-06-17', '2025-07-08', 'submitted'),
(18, 'Conduct Fire Drill', 'Schedule and execute quarterly fire drill.', 3, '2025-06-17', '2025-07-09', 'submitted'),
(19, 'Check Lighting', 'Replace faulty bulbs in office.', 4, '2025-06-17', '2025-07-10', 'submitted'),
(20, 'Refill First Aid Kits', 'Ensure all kits are fully stocked.', 5, '2025-06-17', '2025-07-11', 'pending'),
(21, 'Archive Old Files', 'Move files older than 2 years to archive.', 1, '2025-06-17', '2025-08-02', 'submitted'),
(22, 'Polish Floor', 'Buff and polish the main hallway floor.', 2, '2025-06-17', '2025-08-03', 'pending'),
(23, 'Review Contracts', 'Check vendor contract dates.', 3, '2025-06-17', '2025-08-07', 'submitted'),
(24, 'System Diagnostics', 'Run diagnostics on all servers.', 4, '2025-06-17', '2025-08-04', 'submitted'),
(25, 'Verify Inventory', 'Manual count for warehouse A inventory.', 5, '2025-06-17', '2025-08-06', 'pending'),
(26, 'Update HR Records', 'Add new employee data to the system.', 1, '2025-06-17', '2025-08-07', 'pending'),
(27, 'Service Air Conditioner', 'Clean and service AC units in floor 2.', 2, '2025-06-17', '2025-08-09', 'pending'),
(28, 'Check Security Cameras', 'Ensure all cameras are online and recording.', 3, '2025-06-17', '2025-08-08', 'pending'),
(29, 'Audit Checklist', 'Prepare checklist for audit.', 4, '2025-06-17', '2025-08-10', 'submitted');

-- --------------------------------------------------------

--
-- Table structure for table `workers`
--

CREATE TABLE `workers` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `workers`
--

INSERT INTO `workers` (`id`, `full_name`, `email`, `password`, `phone`, `address`) VALUES
(1, 'Kim Tae Hyung', 'vante@example.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '01112301230', 'No. 1 Jalan Ampang'),
(2, 'Jeon Jung Kook', 'kookie@example.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '012901901', 'No. 2 Jalan Kuching'),
(3, 'Tan Pei Yong', 'jemins2001@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0110291689', 'No. 3 Jalan Klang'),
(4, 'Kim Seok Jin', 'jinn12@example.com', '7b52009b64fd0a2a49e6d8a939753077792b0554', '0161204120', 'No. 4 Jalan Genting'),
(5, 'Park Ji Min', 'jm.park@example.com', '7b52009b64fd0a2a49e6d8a939753077792b0554', '0181013101', 'No. 5 Jalan Imbi');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_submissions`
--
ALTER TABLE `tbl_submissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_works`
--
ALTER TABLE `tbl_works`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `workers`
--
ALTER TABLE `workers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_submissions`
--
ALTER TABLE `tbl_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `tbl_works`
--
ALTER TABLE `tbl_works`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `workers`
--
ALTER TABLE `workers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
