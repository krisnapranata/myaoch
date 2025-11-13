-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 08, 2025 at 04:02 AM
-- Server version: 10.11.13-MariaDB-0ubuntu0.24.04.1
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `myaoch`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add ai dataset history', 7, 'add_aidatasethistory'),
(26, 'Can change ai dataset history', 7, 'change_aidatasethistory'),
(27, 'Can delete ai dataset history', 7, 'delete_aidatasethistory'),
(28, 'Can view ai dataset history', 7, 'view_aidatasethistory'),
(29, 'Can add app user', 8, 'add_appuser'),
(30, 'Can change app user', 8, 'change_appuser'),
(31, 'Can delete app user', 8, 'delete_appuser'),
(32, 'Can view app user', 8, 'view_appuser'),
(33, 'Can add peralatan', 9, 'add_peralatan'),
(34, 'Can change peralatan', 9, 'change_peralatan'),
(35, 'Can delete peralatan', 9, 'delete_peralatan'),
(36, 'Can view peralatan', 9, 'view_peralatan'),
(37, 'Can add setting ai model', 10, 'add_settingaimodel'),
(38, 'Can change setting ai model', 10, 'change_settingaimodel'),
(39, 'Can delete setting ai model', 10, 'delete_settingaimodel'),
(40, 'Can view setting ai model', 10, 'view_settingaimodel'),
(41, 'Can add unit', 11, 'add_unit'),
(42, 'Can change unit', 11, 'change_unit'),
(43, 'Can delete unit', 11, 'delete_unit'),
(44, 'Can view unit', 11, 'view_unit'),
(45, 'Can add log aktivitas', 12, 'add_logaktivitas'),
(46, 'Can change log aktivitas', 12, 'change_logaktivitas'),
(47, 'Can delete log aktivitas', 12, 'delete_logaktivitas'),
(48, 'Can view log aktivitas', 12, 'view_logaktivitas'),
(49, 'Can add nilai kesiapan', 13, 'add_nilaikesiapan'),
(50, 'Can change nilai kesiapan', 13, 'change_nilaikesiapan'),
(51, 'Can delete nilai kesiapan', 13, 'delete_nilaikesiapan'),
(52, 'Can view nilai kesiapan', 13, 'view_nilaikesiapan'),
(53, 'Can add notifikasi', 14, 'add_notifikasi'),
(54, 'Can change notifikasi', 14, 'change_notifikasi'),
(55, 'Can delete notifikasi', 14, 'delete_notifikasi'),
(56, 'Can view notifikasi', 14, 'view_notifikasi'),
(57, 'Can add file upload', 15, 'add_fileupload'),
(58, 'Can change file upload', 15, 'change_fileupload'),
(59, 'Can delete file upload', 15, 'delete_fileupload'),
(60, 'Can view file upload', 15, 'view_fileupload'),
(61, 'Can add riwayat peralatan', 16, 'add_riwayatperalatan'),
(62, 'Can change riwayat peralatan', 16, 'change_riwayatperalatan'),
(63, 'Can delete riwayat peralatan', 16, 'delete_riwayatperalatan'),
(64, 'Can view riwayat peralatan', 16, 'view_riwayatperalatan'),
(65, 'Can add laporan', 17, 'add_laporan'),
(66, 'Can change laporan', 17, 'change_laporan'),
(67, 'Can delete laporan', 17, 'delete_laporan'),
(68, 'Can view laporan', 17, 'view_laporan'),
(69, 'Can add ai analitik', 18, 'add_aianalitik'),
(70, 'Can change ai analitik', 18, 'change_aianalitik'),
(71, 'Can delete ai analitik', 18, 'delete_aianalitik'),
(72, 'Can view ai analitik', 18, 'view_aianalitik'),
(73, 'Can add verifikasi', 19, 'add_verifikasi'),
(74, 'Can change verifikasi', 19, 'change_verifikasi'),
(75, 'Can delete verifikasi', 19, 'delete_verifikasi'),
(76, 'Can view verifikasi', 19, 'view_verifikasi'),
(77, 'Can add energy setting', 20, 'add_energysetting'),
(78, 'Can change energy setting', 20, 'change_energysetting'),
(79, 'Can delete energy setting', 20, 'delete_energysetting'),
(80, 'Can view energy setting', 20, 'view_energysetting'),
(81, 'Can add konsumsi energi', 21, 'add_konsumsienergi'),
(82, 'Can change konsumsi energi', 21, 'change_konsumsienergi'),
(83, 'Can delete konsumsi energi', 21, 'delete_konsumsienergi'),
(84, 'Can view konsumsi energi', 21, 'view_konsumsienergi');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$1000000$7JhP4pVnjPAfVwS7qusPzu$TuMFXhgZrgM3/SWAT9x5XxrQVfAaMXdx5nmlXVcY7cg=', '2025-11-07 00:09:01.463611', 1, 'admin', '', '', 'krisna.pranata@gmail.com', 1, 1, '2025-10-29 12:56:20.112931'),
(2, 'pbkdf2_sha256$1000000$3J18ukSEYjWctmKCslh0LT$+nFwNI7CcC4kG/37JhwZJhXpulic/N558Fq7EIdpvIw=', '2025-11-03 08:11:38.968785', 0, 'atnos', 'ATNOS', 'ELBAN', 'krisna.pranata@gmail.com', 1, 1, '2025-11-03 07:58:18.000000');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_user_user_permissions`
--

INSERT INTO `auth_user_user_permissions` (`id`, `user_id`, `permission_id`) VALUES
(1, 2, 33),
(2, 2, 34),
(3, 2, 35),
(4, 2, 36),
(5, 2, 41),
(6, 2, 42),
(7, 2, 43),
(8, 2, 44),
(9, 2, 48),
(10, 2, 49),
(11, 2, 50),
(12, 2, 51),
(13, 2, 52),
(14, 2, 61),
(15, 2, 62),
(16, 2, 63),
(17, 2, 64),
(18, 2, 65),
(19, 2, 68);

-- --------------------------------------------------------

--
-- Table structure for table `core_aianalitik`
--

CREATE TABLE `core_aianalitik` (
  `id` bigint(20) NOT NULL,
  `periode` date NOT NULL,
  `hasil_prediksi` varchar(150) DEFAULT NULL,
  `faktor_penyebab` longtext DEFAULT NULL,
  `saran_tindakan` longtext DEFAULT NULL,
  `confidence_score` decimal(5,2) DEFAULT NULL,
  `dibuat_otomatis` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `unit_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `core_aidatasethistory`
--

CREATE TABLE `core_aidatasethistory` (
  `id` bigint(20) NOT NULL,
  `tanggal` date NOT NULL,
  `jumlah_data` int(11) DEFAULT NULL,
  `sumber_data` varchar(100) DEFAULT NULL,
  `versi_model` varchar(20) DEFAULT NULL,
  `akurasi_model` decimal(5,2) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `core_appuser`
--

CREATE TABLE `core_appuser` (
  `id` bigint(20) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(128) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `role` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `unit_id` bigint(20) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `core_appuser`
--

INSERT INTO `core_appuser` (`id`, `username`, `password`, `nama_lengkap`, `role`, `email`, `is_active`, `created_at`, `unit_id`, `updated_at`) VALUES
(1, 'operator1', 'pbkdf2_sha256$216000$dummy$hashdummy123', 'Operator Electrical', 'Operator', NULL, 1, '2025-10-29 13:11:56.791675', 1, '2025-11-05 00:33:56.384968'),
(2, 'spv1', 'pbkdf2_sha256$216000$dummy$hashdummy123', 'Supervisor Electrical', 'SPV', NULL, 1, '2025-10-29 13:11:56.795634', 1, '2025-11-05 00:33:56.384968'),
(3, 'aoch1', 'pbkdf2_sha256$216000$dummy$hashdummy123', 'AOCH Terminal', 'AOCH', NULL, 1, '2025-10-29 13:11:56.799698', 4, '2025-11-05 00:33:56.384968'),
(4, 'gm1', 'pbkdf2_sha256$216000$dummy$hashdummy123', 'General Manager Bandara', 'GM', NULL, 1, '2025-10-29 13:11:56.803335', NULL, '2025-11-05 00:33:56.384968'),
(5, 'krisna', '12345', 'Krisna Pranata', 'Operator', 'krisna.pranata@gmail.com', 1, '2025-11-01 04:00:29.000000', 6, '2025-11-05 00:33:56.384968');

-- --------------------------------------------------------

--
-- Table structure for table `core_energysetting`
--

CREATE TABLE `core_energysetting` (
  `id` bigint(20) NOT NULL,
  `nama_bandara` varchar(100) NOT NULL,
  `faktor_kali_kwh` decimal(10,2) NOT NULL,
  `harga_lwbp` decimal(12,2) NOT NULL,
  `harga_wbp` decimal(12,2) NOT NULL,
  `batas_pemakaian_harian` decimal(12,2) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `core_energysetting`
--

INSERT INTO `core_energysetting` (`id`, `nama_bandara`, `faktor_kali_kwh`, `harga_lwbp`, `harga_wbp`, `batas_pemakaian_harian`, `updated_at`) VALUES
(1, 'BIZAM', 8000.00, 1035.78, 1553.67, 30000.00, '2025-11-07 02:54:17.730137');

-- --------------------------------------------------------

--
-- Table structure for table `core_fileupload`
--

CREATE TABLE `core_fileupload` (
  `id` bigint(20) NOT NULL,
  `nama_file` varchar(255) NOT NULL,
  `path_file` varchar(255) NOT NULL,
  `jenis_file` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `uploaded_by_id` bigint(20) DEFAULT NULL,
  `kesiapan_id` bigint(20) DEFAULT NULL,
  `peralatan_id` bigint(20) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `core_konsumsienergi`
--

CREATE TABLE `core_konsumsienergi` (
  `id` bigint(20) NOT NULL,
  `tanggal` date NOT NULL,
  `stand_awal_lwbp` decimal(12,2) NOT NULL,
  `stand_akhir_lwbp` decimal(12,2) NOT NULL,
  `stand_awal_wbp` decimal(12,2) NOT NULL,
  `stand_akhir_wbp` decimal(12,2) NOT NULL,
  `pemakaian_lwbp` decimal(12,2) NOT NULL,
  `pemakaian_wbp` decimal(12,2) NOT NULL,
  `total_pemakaian_energi` decimal(12,2) NOT NULL,
  `biaya_lwbp` decimal(15,2) NOT NULL,
  `biaya_wbp` decimal(15,2) NOT NULL,
  `total_biaya` decimal(15,2) NOT NULL,
  `selisih_pemakaian_biaya` decimal(15,2) NOT NULL,
  `deviasi_pemakaian_persen` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `core_konsumsienergi`
--

INSERT INTO `core_konsumsienergi` (`id`, `tanggal`, `stand_awal_lwbp`, `stand_akhir_lwbp`, `stand_awal_wbp`, `stand_akhir_wbp`, `pemakaian_lwbp`, `pemakaian_wbp`, `total_pemakaian_energi`, `biaya_lwbp`, `biaya_wbp`, `total_biaya`, `selisih_pemakaian_biaya`, `deviasi_pemakaian_persen`) VALUES
(1, '2025-11-01', 7945.40, 7948.81, 1407.20, 1407.62, 27280.00, 3360.00, 30640.00, 28256078.40, 5220331.20, 33476409.60, 0.00, 0.00),
(3, '2025-11-02', 7948.81, 7952.05, 1407.62, 1408.15, 25920.00, 4240.00, 30160.00, 26847417.60, 6587560.80, 33434978.40, -41431.20, -0.12),
(4, '2025-11-03', 7952.05, 7955.26, 1408.15, 1408.61, 25680.00, 3680.00, 29360.00, 26598830.40, 5717505.60, 32316336.00, -1118642.40, -3.35),
(5, '2025-11-04', 7955.26, 7958.46, 1408.61, 1409.03, 25600.00, 3360.00, 28960.00, 26515968.00, 5220331.20, 31736299.20, -580036.80, -1.79),
(6, '2025-11-05', 7958.46, 7961.47, 1409.03, 1409.40, 24080.00, 2960.00, 27040.00, 24941582.40, 4598863.20, 29540445.60, -2195853.60, -6.92),
(7, '2025-11-06', 7945.40, 7948.81, 1407.20, 1407.62, 27280.00, 3360.00, 30640.00, 28256078.40, 5220331.20, 33476409.60, 3935964.00, 13.32),
(8, '2025-11-07', 7948.81, 7952.05, 1407.62, 1408.15, 25920.00, 4240.00, 30160.00, 26847417.60, 6587560.80, 33434978.40, -41431.20, -0.12),
(9, '2025-11-08', 7955.26, 7958.46, 1408.61, 1409.03, 25600.00, 3360.00, 28960.00, 26515968.00, 5220331.20, 31736299.20, -1698679.20, -5.08);

-- --------------------------------------------------------

--
-- Table structure for table `core_laporan`
--

CREATE TABLE `core_laporan` (
  `id` bigint(20) NOT NULL,
  `periode` varchar(10) NOT NULL,
  `tanggal_awal` date NOT NULL,
  `tanggal_akhir` date NOT NULL,
  `rata_kesiapan` decimal(5,2) DEFAULT NULL,
  `distribusi_kategori` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`distribusi_kategori`)),
  `catatan` longtext DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `dibuat_oleh_id` bigint(20) DEFAULT NULL,
  `unit_id` bigint(20) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `core_laporan`
--

INSERT INTO `core_laporan` (`id`, `periode`, `tanggal_awal`, `tanggal_akhir`, `rata_kesiapan`, `distribusi_kategori`, `catatan`, `created_at`, `dibuat_oleh_id`, `unit_id`, `updated_at`) VALUES
(1, 'Harian', '2025-10-22', '2025-10-29', 87.30, '{\"Normal/Serviceable\": 4, \"Normal/Unserviceable\": 1, \"Not Normal/Serviceable\": 0, \"Not Normal/Unserviceable\": 0}', NULL, '2025-10-29 13:11:56.866723', 2, 1, '2025-11-05 00:33:56.462185');

-- --------------------------------------------------------

--
-- Table structure for table `core_logaktivitas`
--

CREATE TABLE `core_logaktivitas` (
  `id` bigint(20) NOT NULL,
  `aksi` varchar(150) NOT NULL,
  `tabel_terkait` varchar(50) DEFAULT NULL,
  `id_referensi` int(11) DEFAULT NULL,
  `deskripsi` longtext DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `core_nilaikesiapan`
--

CREATE TABLE `core_nilaikesiapan` (
  `id` bigint(20) NOT NULL,
  `tanggal` date NOT NULL,
  `nilai` decimal(5,2) NOT NULL,
  `kategori_kesiapan` varchar(50) DEFAULT NULL,
  `keterangan` longtext DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `butuh_verif_gm` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_input_id` bigint(20) DEFAULT NULL,
  `peralatan_id` bigint(20) NOT NULL,
  `jumlah_alat_normal` int(10) UNSIGNED NOT NULL CHECK (`jumlah_alat_normal` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `core_nilaikesiapan`
--

INSERT INTO `core_nilaikesiapan` (`id`, `tanggal`, `nilai`, `kategori_kesiapan`, `keterangan`, `status`, `butuh_verif_gm`, `created_at`, `updated_at`, `user_input_id`, `peralatan_id`, `jumlah_alat_normal`) VALUES
(1, '2025-10-29', 56.11, 'Normal / Unserviceable', 'Input otomatis tanggal 2025-10-29', 'Final', 0, '2025-10-29 13:11:56.820884', '2025-10-29 13:11:56.821410', 3, 1, 0),
(2, '2025-10-28', 95.49, 'Normal / Serviceable', 'Input otomatis tanggal 2025-10-28', 'Final', 0, '2025-10-29 13:11:56.823681', '2025-10-29 13:11:56.824111', 3, 1, 0),
(3, '2025-10-27', 32.90, 'Not Normal / Serviceable', 'Input otomatis tanggal 2025-10-27', 'Diverifikasi SPV', 0, '2025-10-29 13:11:56.826061', '2025-10-29 13:11:56.826447', 1, 1, 0),
(4, '2025-10-26', 36.73, 'Not Normal / Serviceable', 'Input otomatis tanggal 2025-10-26', 'Final', 0, '2025-10-29 13:11:56.828321', '2025-10-29 13:11:56.828677', 2, 1, 0),
(5, '2025-10-25', 53.31, 'Normal / Unserviceable', 'Input otomatis tanggal 2025-10-25', 'Final', 0, '2025-10-29 13:11:56.830505', '2025-10-29 13:11:56.830820', 1, 1, 0),
(6, '2025-10-29', 95.09, 'Normal / Serviceable', 'Input otomatis tanggal 2025-10-29', 'Diverifikasi SPV', 0, '2025-10-29 13:11:56.832358', '2025-10-29 13:11:56.832677', 1, 2, 0),
(7, '2025-10-28', 36.82, 'Not Normal / Serviceable', 'Input otomatis tanggal 2025-10-28', 'Diverifikasi SPV', 0, '2025-10-29 13:11:56.834427', '2025-10-29 13:11:56.834685', 3, 2, 0),
(8, '2025-10-27', 62.16, 'Normal / Unserviceable', 'Input otomatis tanggal 2025-10-27', 'Final', 0, '2025-10-29 13:11:56.836435', '2025-10-29 13:11:56.836685', 1, 2, 0),
(9, '2025-10-26', 44.84, 'Not Normal / Serviceable', 'Input otomatis tanggal 2025-10-26', 'Diverifikasi SPV', 0, '2025-10-29 13:11:56.838327', '2025-10-29 13:11:56.838783', 3, 2, 0),
(10, '2025-10-25', 44.46, 'Not Normal / Serviceable', 'Input otomatis tanggal 2025-10-25', 'Diverifikasi AOCH', 0, '2025-10-29 13:11:56.840703', '2025-10-29 13:11:56.841067', 1, 2, 0),
(11, '2025-10-29', 97.17, 'Normal / Serviceable', 'Input otomatis tanggal 2025-10-29', 'Diverifikasi AOCH', 0, '2025-10-29 13:11:56.842952', '2025-10-29 13:11:56.843346', 1, 3, 0),
(12, '2025-10-28', 46.06, 'Not Normal / Serviceable', 'Input otomatis tanggal 2025-10-28', 'Draft', 0, '2025-10-29 13:11:56.845360', '2025-10-29 13:11:56.845706', 1, 3, 0),
(13, '2025-10-27', 71.76, 'Normal / Unserviceable', 'Input otomatis tanggal 2025-10-27', 'Diverifikasi AOCH', 0, '2025-10-29 13:11:56.847340', '2025-10-29 13:11:56.847641', 3, 3, 0),
(14, '2025-10-26', 81.84, 'Normal / Serviceable', 'Input otomatis tanggal 2025-10-26', 'Diverifikasi SPV', 0, '2025-10-29 13:11:56.849207', '2025-10-29 13:11:56.849455', 3, 3, 0),
(15, '2025-10-25', 50.45, 'Normal / Unserviceable', 'Input otomatis tanggal 2025-10-25', 'Final', 0, '2025-10-29 13:11:56.851145', '2025-10-29 13:11:56.851424', 4, 3, 0),
(16, '2025-10-29', 48.41, 'Not Normal / Serviceable', 'Input otomatis tanggal 2025-10-29', 'Final', 0, '2025-10-29 13:11:56.853077', '2025-10-29 13:11:56.853322', 3, 4, 0),
(17, '2025-10-28', 46.54, 'Not Normal / Serviceable', 'Input otomatis tanggal 2025-10-28', 'Diverifikasi AOCH', 0, '2025-10-29 13:11:56.854840', '2025-10-29 13:11:56.855151', 1, 4, 0),
(18, '2025-10-27', 33.42, 'Not Normal / Serviceable', 'Input otomatis tanggal 2025-10-27', 'Draft', 0, '2025-10-29 13:11:56.856783', '2025-10-29 13:11:56.857054', 3, 4, 0),
(19, '2025-10-26', 75.72, 'Normal / Serviceable', 'Input otomatis tanggal 2025-10-26', 'Diverifikasi SPV', 0, '2025-10-29 13:11:56.858760', '2025-10-29 13:11:56.859017', 1, 4, 0),
(20, '2025-10-25', 64.25, 'Normal / Unserviceable', 'Input otomatis tanggal 2025-10-25', 'Diverifikasi AOCH', 0, '2025-10-29 13:11:56.860701', '2025-10-29 13:11:56.860946', 4, 4, 0),
(21, '2025-10-29', 90.00, 'Normal / Serviceable', 'Normal', 'Draft', 0, '2025-10-29 15:43:35.000000', '2025-10-29 15:44:17.263247', 1, 5, 0),
(22, '2025-11-01', 45.00, 'Not Normal / Serviceable', 'Perlu Service', 'Draft', 0, '2025-11-01 03:58:45.000000', '2025-11-01 04:00:59.624359', 5, 6, 0),
(23, '2025-11-01', 35.00, 'Not Normal / Serviceable', 'Service', 'Draft', 0, '2025-11-01 04:01:51.000000', '2025-11-01 04:02:28.448037', 1, 1, 0),
(24, '2025-11-01', 25.00, 'Not Normal / Unserviceable', 'Service', 'Draft', 0, '2025-11-01 04:02:47.000000', '2025-11-01 04:03:06.720303', 1, 2, 0),
(25, '2025-11-01', 10.00, 'Not Normal / Unserviceable', 'service', 'Draft', 0, '2025-11-01 04:03:25.000000', '2025-11-01 04:03:49.102739', 1, 3, 0),
(26, '2025-11-01', 20.00, 'Not Normal / Unserviceable', 'Ser', 'Draft', 0, '2025-11-01 04:04:51.000000', '2025-11-01 04:05:07.696601', 5, 5, 0),
(27, '2025-11-01', 90.00, 'Normal / Serviceable', 'normal', 'Draft', 0, '2025-11-01 05:26:43.000000', '2025-11-01 05:27:10.106840', 1, 4, 0),
(28, '2025-11-01', 100.00, 'Normal / Serviceable', 'Normal', 'Draft', 0, '2025-11-01 05:29:07.000000', '2025-11-01 05:29:37.574952', 1, 1, 0),
(29, '2025-11-01', 100.00, 'Normal / Serviceable', 'Normal', 'Draft', 0, '2025-11-01 05:30:01.000000', '2025-11-01 05:30:17.682227', 5, 5, 0),
(30, '2025-11-01', 100.00, 'Normal / Serviceable', 'Normal', 'Draft', 0, '2025-11-01 05:30:35.000000', '2025-11-01 05:32:47.970035', 5, 7, 0),
(31, '2025-11-01', 100.00, 'Normal / Serviceable', 'Normal', 'Draft', 0, '2025-11-01 09:05:18.000000', '2025-11-01 09:05:41.678208', 1, 2, 0),
(32, '2025-11-01', 100.00, 'Normal / Serviceable', 'Normal', 'Draft', 0, '2025-11-01 09:06:01.000000', '2025-11-01 09:06:22.237716', 1, 2, 0),
(33, '2025-11-01', 75.00, 'Normal / Unserviceable', 'normal', 'Draft', 0, '2025-11-01 12:55:41.000000', '2025-11-01 12:56:37.004169', 1, 8, 0),
(34, '2025-11-02', 80.00, 'Normal / Serviceable', 'Normal', 'Draft', 0, '2025-11-02 05:12:32.000000', '2025-11-02 05:12:51.787271', 5, 6, 0),
(37, '2025-11-03', 90.00, 'Normal / Serviceable', 'Normal', 'Draft', 0, '2025-11-03 00:38:54.000000', '2025-11-03 00:39:15.063741', 5, 5, 0),
(38, '2025-11-03', 20.00, 'Not Normal / Unserviceable', 'ser', 'Draft', 0, '2025-11-03 00:39:20.000000', '2025-11-03 00:39:38.363830', 1, 1, 0),
(39, '2025-11-03', 70.00, 'Normal / Unserviceable', 'lknsd', 'Draft', 0, '2025-11-03 00:54:58.000000', '2025-11-03 08:12:55.102383', 1, 2, 7),
(40, '2025-11-03', 100.00, 'Normal / Serviceable', 'as', 'Diverifikasi SPV', 0, '2025-11-03 00:56:13.000000', '2025-11-03 16:14:03.810067', 1, 3, 5),
(43, '2025-11-03', 100.00, 'Normal / Serviceable', 'oasajk', 'Draft', 0, '2025-11-03 16:11:33.000000', '2025-11-03 16:12:25.682014', 1, 4, 20),
(44, '2025-11-04', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-04 02:13:24.000000', '2025-11-04 02:17:09.537955', NULL, 5, 1),
(45, '2025-11-04', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-04 02:13:42.000000', '2025-11-04 02:13:56.347830', NULL, 6, 1),
(46, '2025-11-04', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-04 02:13:58.000000', '2025-11-04 02:14:08.121126', 1, 1, 1),
(47, '2025-11-04', 50.00, 'Not Normal / Serviceable', '', 'Draft', 0, '2025-11-04 02:14:09.000000', '2025-11-04 02:14:22.925716', 1, 2, 5),
(48, '2025-11-04', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-04 02:14:29.000000', '2025-11-04 02:38:29.737966', NULL, 4, 20),
(49, '2025-11-04', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-04 02:14:46.000000', '2025-11-04 02:14:56.828446', NULL, 10, 1),
(50, '2025-11-04', 0.00, 'Not Normal / Unserviceable', '', 'Draft', 0, '2025-11-04 02:15:00.000000', '2025-11-04 02:15:13.370755', NULL, 7, 0),
(51, '2025-11-04', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-04 02:15:35.000000', '2025-11-04 02:15:47.591230', NULL, 8, 1),
(52, '2025-11-04', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-04 02:15:53.000000', '2025-11-04 02:40:02.537151', NULL, 9, 1),
(60, '2025-11-05', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-05 05:23:41.902250', '2025-11-05 05:23:41.902278', NULL, 1, 1),
(61, '2025-11-05', 75.00, 'Normal / Unserviceable', '', 'Draft', 0, '2025-11-05 05:24:17.792325', '2025-11-05 05:26:14.088301', NULL, 4, 15),
(62, '2025-11-05', 50.00, 'Not Normal / Serviceable', '', 'Draft', 0, '2025-11-05 05:26:47.979220', '2025-11-05 05:26:47.979256', NULL, 6, 25),
(64, '2025-11-05', 0.00, 'Not Normal / Unserviceable', '', 'Draft', 0, '2025-11-05 05:28:00.937223', '2025-11-05 07:18:38.934772', NULL, 9, 0),
(65, '2025-11-05', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-05 07:20:11.837664', '2025-11-05 07:20:11.837681', NULL, 8, 1),
(66, '2025-11-06', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-05 23:40:05.115383', '2025-11-05 23:40:05.115459', NULL, 1, 1),
(67, '2025-11-06', 75.00, 'Normal / Unserviceable', '', 'Draft', 0, '2025-11-05 23:40:46.874317', '2025-11-05 23:40:46.874390', NULL, 4, 15),
(68, '2025-11-06', 80.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-05 23:41:47.909510', '2025-11-06 01:42:24.231891', NULL, 6, 40),
(69, '2025-11-06', 0.00, 'Not Normal / Unserviceable', '', 'Draft', 0, '2025-11-05 23:42:21.553907', '2025-11-05 23:42:21.553972', NULL, 7, 0),
(70, '2025-11-06', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-05 23:42:34.287498', '2025-11-05 23:42:34.287568', NULL, 8, 1),
(71, '2025-11-06', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-05 23:43:15.246905', '2025-11-06 01:27:54.738964', NULL, 9, 1),
(72, '2025-11-06', 50.00, 'Not Normal / Serviceable', '', 'Draft', 0, '2025-11-06 01:28:51.567943', '2025-11-06 01:28:51.567990', NULL, 2, 5),
(74, '2025-11-07', 100.00, 'Normal / Serviceable', '', 'Draft', 0, '2025-11-07 00:09:21.722467', '2025-11-07 00:09:21.722496', NULL, 1, 1),
(75, '2025-11-07', 60.00, 'Normal / Unserviceable', '', 'Draft', 0, '2025-11-07 00:10:08.336402', '2025-11-07 00:10:23.956507', NULL, 3, 3),
(76, '2025-11-07', 40.00, 'Not Normal / Serviceable', '', 'Draft', 0, '2025-11-07 00:10:50.360373', '2025-11-07 01:19:55.324868', NULL, 6, 20),
(77, '2025-11-07', 0.00, 'Not Normal / Unserviceable', '', 'Draft', 0, '2025-11-07 00:11:03.107844', '2025-11-07 00:11:03.107892', NULL, 7, 0),
(78, '2025-11-08', 100.00, 'Normal / Serviceable', 'jnas', 'Draft', 0, '2025-11-07 22:40:38.503931', '2025-11-07 22:40:38.503966', 1, 1, 1),
(79, '2025-11-08', 60.00, 'Normal / Unserviceable', 'lnasljnsal', 'Draft', 0, '2025-11-07 22:41:00.957012', '2025-11-07 22:41:00.957047', 1, 3, 3),
(80, '2025-11-08', 75.00, 'Normal / Unserviceable', 'ljnas', 'Draft', 0, '2025-11-07 22:41:36.104155', '2025-11-07 22:41:36.104180', 1, 4, 15),
(81, '2025-11-08', 100.00, 'Normal / Serviceable', 'kmask', 'Draft', 0, '2025-11-07 22:41:52.734555', '2025-11-07 22:41:52.734619', NULL, 5, 1),
(82, '2025-11-08', 100.00, 'Normal / Serviceable', 'knans', 'Draft', 0, '2025-11-07 22:42:11.597823', '2025-11-07 22:42:11.597849', NULL, 7, 1),
(83, '2025-11-08', 30.00, 'Not Normal / Serviceable', 'ojnas', 'Draft', 0, '2025-11-07 22:42:37.814235', '2025-11-07 22:42:37.814282', NULL, 11, 3),
(84, '2025-11-08', 50.00, 'Not Normal / Serviceable', 'lkask', 'Draft', 0, '2025-11-07 22:43:00.743977', '2025-11-07 22:43:00.744000', NULL, 12, 10),
(85, '2025-11-08', 75.00, 'Normal / Unserviceable', 'knask', 'Draft', 0, '2025-11-07 22:43:39.577015', '2025-11-07 22:43:39.577050', NULL, 13, 15);

-- --------------------------------------------------------

--
-- Table structure for table `core_notifikasi`
--

CREATE TABLE `core_notifikasi` (
  `id` bigint(20) NOT NULL,
  `judul` varchar(150) NOT NULL,
  `pesan` longtext NOT NULL,
  `jenis` varchar(30) NOT NULL,
  `status_baca` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `core_peralatan`
--

CREATE TABLE `core_peralatan` (
  `id` bigint(20) NOT NULL,
  `nama_peralatan` varchar(150) NOT NULL,
  `kode_peralatan` varchar(30) NOT NULL,
  `kategori` varchar(20) DEFAULT NULL,
  `merk` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `tahun_pengadaan` int(11) DEFAULT NULL,
  `status_operasional` varchar(20) NOT NULL,
  `keterangan` longtext DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `unit_id` bigint(20) NOT NULL,
  `jumlah_alat` int(10) UNSIGNED NOT NULL CHECK (`jumlah_alat` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `core_peralatan`
--

INSERT INTO `core_peralatan` (`id`, `nama_peralatan`, `kode_peralatan`, `kategori`, `merk`, `model`, `tahun_pengadaan`, `status_operasional`, `keterangan`, `is_active`, `unit_id`, `jumlah_alat`) VALUES
(1, 'Genset Utama', 'GEN001', 'Power', 'Caterpillar', 'X200', 2018, 'Normal', NULL, 1, 1, 1),
(2, 'Runway Light', 'RL001', 'Prioritas', 'Philips', 'Airfield-XL', 2019, 'Normal', '', 1, 1, 10),
(3, 'Conveyor Belt', 'CVB001', 'Prioritas', 'Siemens', 'MTR100', 2020, 'Normal', '', 1, 2, 5),
(4, 'Pushback Tractor', 'PBT001', 'Prioritas', 'Toyota', 'GSP-12', 2017, 'Normal', 'Normal', 1, 3, 20),
(5, 'X-Ray Bagasi', 'xraybag1234567', 'Keamanan', 'Fiscan', '09u90u2', 2020, 'Normal', 'Operasi', 1, 6, 1),
(6, 'CCTV', 'cctv0123', NULL, 'Bosch', 'Bosch12345', 2019, 'Normal', 'Operasi Normal', 1, 6, 50),
(7, 'Drone', 'dron123', 'Keamanan', 'Bosch', 'Bosch12345', 2019, 'Normal', 'Normal', 1, 7, 1),
(8, 'Dron 1', 'drn1', 'Keamanan', 'Fiscan', 'drn1', 2018, 'Normal', 'tes', 1, 7, 1),
(9, 'Dron 2', 'drn2', 'Keamanan', 'Bosch', 'drn2', 2019, 'Normal', 'normal', 1, 7, 1),
(10, 'GSE 2', 'gse2', 'Keamanan', 'oknsod', 'ijisod', 2019, 'Normal', 'onosdn', 1, 3, 1),
(11, 'AOCC 1', 'aocc1', 'Prioritas', 'ljnsa', 'knd', 2019, 'Normal', 'lndd', 1, 4, 10),
(12, 'Gedung', 'gd', 'Prioritas', 'onsd', 'pkmek', 2019, 'Normal', 'nsakn', 1, 5, 20),
(13, 'ALAT UNIT A', 'ala', 'Prioritas', 'oaso', 'i', 2019, 'Normal', 'ijai', 1, 9, 20);

-- --------------------------------------------------------

--
-- Table structure for table `core_riwayatperalatan`
--

CREATE TABLE `core_riwayatperalatan` (
  `id` bigint(20) NOT NULL,
  `jenis_riwayat` varchar(20) NOT NULL,
  `tanggal_mulai` date DEFAULT NULL,
  `tanggal_selesai` date DEFAULT NULL,
  `deskripsi` longtext DEFAULT NULL,
  `hasil` longtext DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `dibuat_oleh_id` bigint(20) DEFAULT NULL,
  `peralatan_id` bigint(20) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `core_settingaimodel`
--

CREATE TABLE `core_settingaimodel` (
  `id` bigint(20) NOT NULL,
  `nama_model` varchar(100) NOT NULL,
  `versi` varchar(20) NOT NULL,
  `akurasi` decimal(5,2) NOT NULL,
  `path_model` varchar(255) NOT NULL,
  `deskripsi` longtext DEFAULT NULL,
  `created_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `core_unit`
--

CREATE TABLE `core_unit` (
  `id` bigint(20) NOT NULL,
  `nama_unit` varchar(100) NOT NULL,
  `kode_unit` varchar(10) DEFAULT NULL,
  `lokasi` varchar(100) DEFAULT NULL,
  `keterangan` longtext DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `core_unit`
--

INSERT INTO `core_unit` (`id`, `nama_unit`, `kode_unit`, `lokasi`, `keterangan`, `is_active`) VALUES
(1, 'Electrical', 'ELC', 'Terminal 1', NULL, 1),
(2, 'Mechanical', 'MEC', 'Terminal 3', NULL, 1),
(3, 'GSE', 'GSE', 'Terminal 2', NULL, 1),
(4, 'AOCC', 'AOC', 'Terminal 2', NULL, 1),
(5, 'Facility', 'FMG', 'Terminal 3', '', 1),
(6, 'ATNOS', 'ATN', 'Terminal', 'Airport Technology', 1),
(7, 'AMC', 'amc123', 'Bandara', 'AMC', 1),
(9, 'UNIT A', 'unit1', 'Bandara', 'jbsdbds', 1);

-- --------------------------------------------------------

--
-- Table structure for table `core_verifikasi`
--

CREATE TABLE `core_verifikasi` (
  `id` bigint(20) NOT NULL,
  `verifikasi_level` varchar(10) NOT NULL,
  `status_verifikasi` varchar(10) NOT NULL,
  `catatan` longtext DEFAULT NULL,
  `tanggal_verifikasi` datetime(6) NOT NULL,
  `kesiapan_id` bigint(20) NOT NULL,
  `requested_by_id` bigint(20) DEFAULT NULL,
  `verifikator_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `core_verifikasi`
--

INSERT INTO `core_verifikasi` (`id`, `verifikasi_level`, `status_verifikasi`, `catatan`, `tanggal_verifikasi`, `kesiapan_id`, `requested_by_id`, `verifikator_id`) VALUES
(1, 'AOCH', 'Approved', 'Sudah diverifikasi otomatis (seeding)', '2025-10-29 13:11:56.864764', 20, NULL, 3),
(2, 'SPV', 'Approved', 'yes', '2025-11-01 04:07:01.000000', 26, 5, 2);

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2025-10-29 15:40:09.961981', '6', 'ATNOS', 1, '[{\"added\": {}}]', 11, 1),
(2, '2025-10-29 15:40:51.076867', '6', 'ATNOS', 2, '[{\"changed\": {\"fields\": [\"Lokasi\"]}}]', 11, 1),
(3, '2025-10-29 15:42:40.379165', '5', 'X-Ray Bagasi (ATNOS)', 1, '[{\"added\": {}}]', 9, 1),
(4, '2025-10-29 15:44:17.267975', '21', 'X-Ray Bagasi (90%)', 1, '[{\"added\": {}}]', 13, 1),
(5, '2025-11-01 03:59:42.555035', '6', 'CCTV (ATNOS)', 1, '[{\"added\": {}}]', 9, 1),
(6, '2025-11-01 04:00:53.111821', '5', 'Krisna Pranata (Operator)', 1, '[{\"added\": {}}]', 8, 1),
(7, '2025-11-01 04:00:59.628500', '22', 'CCTV (45%)', 1, '[{\"added\": {}}]', 13, 1),
(8, '2025-11-01 04:02:28.449245', '23', 'Genset Utama (35%)', 1, '[{\"added\": {}}]', 13, 1),
(9, '2025-11-01 04:03:06.721582', '24', 'Runway Light (25%)', 1, '[{\"added\": {}}]', 13, 1),
(10, '2025-11-01 04:03:49.104043', '25', 'Conveyor Belt (10%)', 1, '[{\"added\": {}}]', 13, 1),
(11, '2025-11-01 04:05:07.697839', '26', 'X-Ray Bagasi (20%)', 1, '[{\"added\": {}}]', 13, 1),
(12, '2025-11-01 04:07:32.228182', '2', 'X-Ray Bagasi - SPV (Approved)', 1, '[{\"added\": {}}]', 19, 1),
(13, '2025-11-01 05:27:10.112446', '27', 'Pushback Tractor (90%)', 1, '[{\"added\": {}}]', 13, 1),
(14, '2025-11-01 05:29:37.576103', '28', 'Genset Utama (100%)', 1, '[{\"added\": {}}]', 13, 1),
(15, '2025-11-01 05:30:17.683185', '29', 'X-Ray Bagasi (100%)', 1, '[{\"added\": {}}]', 13, 1),
(16, '2025-11-01 05:30:56.230418', '7', 'AMC', 1, '[{\"added\": {}}]', 11, 1),
(17, '2025-11-01 05:32:22.793329', '7', 'Drone (AMC)', 1, '[{\"added\": {}}]', 9, 1),
(18, '2025-11-01 05:32:47.970930', '30', 'Drone (100%)', 1, '[{\"added\": {}}]', 13, 1),
(19, '2025-11-01 09:05:41.684129', '31', 'Runway Light (100%)', 1, '[{\"added\": {}}]', 13, 1),
(20, '2025-11-01 09:06:22.238611', '32', 'Runway Light (100%)', 1, '[{\"added\": {}}]', 13, 1),
(21, '2025-11-01 12:56:16.579578', '8', 'Dron 1 (AMC)', 1, '[{\"added\": {}}]', 9, 1),
(22, '2025-11-01 12:56:37.020610', '33', 'Dron 1 (75%)', 1, '[{\"added\": {}}]', 13, 1),
(23, '2025-11-01 13:56:44.031345', '9', 'Dron 2 (AMC)', 1, '[{\"added\": {}}]', 9, 1),
(24, '2025-11-02 05:12:51.801816', '34', 'CCTV (80%)', 1, '[{\"added\": {}}]', 13, 1),
(25, '2025-11-03 00:07:28.280824', '35', 'X-Ray Bagasi (75%)', 1, '[{\"added\": {}}]', 13, 1),
(26, '2025-11-03 00:08:16.132454', '36', 'Genset Utama (100%)', 1, '[{\"added\": {}}]', 13, 1),
(27, '2025-11-03 00:19:31.430704', '36', 'Genset Utama (100.00%)', 3, '', 13, 1),
(28, '2025-11-03 00:19:31.430770', '35', 'X-Ray Bagasi (75.00%)', 3, '', 13, 1),
(29, '2025-11-03 00:39:15.065591', '37', 'X-Ray Bagasi (90%)', 1, '[{\"added\": {}}]', 13, 1),
(30, '2025-11-03 00:39:38.365095', '38', 'Genset Utama (20%)', 1, '[{\"added\": {}}]', 13, 1),
(31, '2025-11-03 00:55:43.577972', '39', 'Runway Light (20%)', 1, '[{\"added\": {}}]', 13, 1),
(32, '2025-11-03 00:56:26.086810', '40', 'Conveyor Belt (20%)', 1, '[{\"added\": {}}]', 13, 1),
(33, '2025-11-03 00:59:08.100866', '41', 'Pushback Tractor (75%)', 1, '[{\"added\": {}}]', 13, 1),
(34, '2025-11-03 01:15:07.656083', '10', 'GSE 2 (GSE)', 1, '[{\"added\": {}}]', 9, 1),
(35, '2025-11-03 01:15:33.181528', '42', 'GSE 2 (100%)', 1, '[{\"added\": {}}]', 13, 1),
(36, '2025-11-03 02:28:39.996495', '42', 'GSE 2 (100.00%)', 3, '', 13, 1),
(37, '2025-11-03 02:29:02.474309', '41', 'Pushback Tractor (75.00%)', 3, '', 13, 1),
(38, '2025-11-03 02:30:15.355821', '8', 'Facilities', 1, '[{\"added\": {}}]', 11, 1),
(39, '2025-11-03 02:31:01.244007', '8', 'Facilities', 3, '', 11, 1),
(40, '2025-11-03 07:52:45.203360', '3', 'Conveyor Belt (Mechanical)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat\", \"Kategori\"]}}]', 9, 1),
(41, '2025-11-03 07:54:15.330970', '40', 'Conveyor Belt (60.0%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\"]}}]', 13, 1),
(42, '2025-11-03 07:58:19.184222', '2', 'atnos', 1, '[{\"added\": {}}]', 4, 1),
(43, '2025-11-03 08:01:44.789497', '2', 'atnos', 2, '[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\", \"Staff status\", \"User permissions\", \"Last login\"]}}]', 4, 1),
(44, '2025-11-03 08:04:48.828205', '40', 'Conveyor Belt (40.0%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\"]}}]', 13, 2),
(45, '2025-11-03 08:12:34.534678', '2', 'Runway Light (Electrical)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat\", \"Kategori\"]}}]', 9, 2),
(46, '2025-11-03 08:12:55.103890', '39', 'Runway Light (70.0%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\"]}}]', 13, 2),
(47, '2025-11-03 08:38:31.217439', '40', 'Conveyor Belt (40.0%)', 2, '[{\"changed\": {\"fields\": [\"Status\"]}}]', 13, 1),
(48, '2025-11-03 15:24:25.414643', '4', 'Pushback Tractor (GSE)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat\", \"Kategori\", \"Keterangan\"]}}]', 9, 1),
(49, '2025-11-03 16:12:25.686499', '43', 'Pushback Tractor (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(50, '2025-11-03 16:14:03.811984', '40', 'Conveyor Belt (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(51, '2025-11-04 02:13:38.697481', '44', 'X-Ray Bagasi (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(52, '2025-11-04 02:13:56.349594', '45', 'CCTV (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(53, '2025-11-04 02:14:08.122481', '46', 'Genset Utama (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(54, '2025-11-04 02:14:22.927905', '47', 'Runway Light (50.00%)', 1, '[{\"added\": {}}]', 13, 1),
(55, '2025-11-04 02:14:43.493774', '48', 'Pushback Tractor (25.00%)', 1, '[{\"added\": {}}]', 13, 1),
(56, '2025-11-04 02:14:56.830327', '49', 'GSE 2 (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(57, '2025-11-04 02:15:13.372349', '50', 'Drone (0.00%)', 1, '[{\"added\": {}}]', 13, 1),
(58, '2025-11-04 02:15:47.592230', '51', 'Dron 1 (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(59, '2025-11-04 02:16:03.151394', '52', 'Dron 2 (0.00%)', 1, '[{\"added\": {}}]', 13, 1),
(60, '2025-11-04 02:16:41.331532', '44', 'X-Ray Bagasi (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(61, '2025-11-04 02:17:09.538771', '44', 'X-Ray Bagasi (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(62, '2025-11-04 02:38:29.739232', '48', 'Pushback Tractor (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(63, '2025-11-04 02:38:59.217188', '52', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(64, '2025-11-04 02:39:15.793570', '52', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(65, '2025-11-04 02:40:02.538311', '52', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(66, '2025-11-04 23:53:16.038182', '53', 'Genset Utama (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(67, '2025-11-05 00:00:10.039619', '54', 'Genset Utama (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(68, '2025-11-05 02:37:20.170864', '55', 'Conveyor Belt (60.00%)', 1, '[{\"added\": {}}]', 13, 1),
(69, '2025-11-05 02:39:42.309051', '56', 'Pushback Tractor (5.00%)', 1, '[{\"added\": {}}]', 13, 1),
(70, '2025-11-05 02:40:44.928111', '57', 'X-Ray Bagasi (0.00%)', 1, '[{\"added\": {}}]', 13, 1),
(71, '2025-11-05 02:41:54.816447', '58', 'Drone (0.00%)', 1, '[{\"added\": {}}]', 13, 1),
(72, '2025-11-05 02:43:00.214641', '58', 'Drone (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(73, '2025-11-05 03:08:22.993149', '58', 'Drone (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(74, '2025-11-05 03:08:42.313282', '58', 'Drone (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(75, '2025-11-05 03:10:19.696093', '6', 'CCTV (ATNOS)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat\", \"Kategori\"]}}]', 9, 1),
(76, '2025-11-05 03:12:03.842137', '59', 'CCTV (90.00%)', 1, '[{\"added\": {}}]', 13, 1),
(77, '2025-11-05 03:12:36.877857', '59', 'CCTV (50.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(78, '2025-11-05 03:12:51.648610', '59', 'CCTV (80.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(79, '2025-11-05 03:14:00.646692', '59', 'CCTV (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(80, '2025-11-05 03:14:19.962961', '59', 'CCTV (4.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(81, '2025-11-05 03:14:35.328920', '59', 'CCTV (50.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(82, '2025-11-05 04:04:25.476061', '56', 'Pushback Tractor (50.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(83, '2025-11-05 04:04:58.139516', '56', 'Pushback Tractor (10.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(84, '2025-11-05 04:05:33.153749', '56', 'Pushback Tractor (25.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(85, '2025-11-05 04:06:14.283461', '56', 'Pushback Tractor (5.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(86, '2025-11-05 05:07:35.458676', '55', 'Conveyor Belt (20.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(87, '2025-11-05 05:08:11.512511', '55', 'Conveyor Belt (60.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(88, '2025-11-05 05:08:26.790178', '54', 'Genset Utama (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(89, '2025-11-05 05:09:22.943224', '54', 'Genset Utama (0.00%)', 3, '', 13, 1),
(90, '2025-11-05 05:11:31.445178', '58', 'Drone (100.00%)', 3, '', 13, 1),
(91, '2025-11-05 05:11:41.907866', '59', 'CCTV (50.00%)', 3, '', 13, 1),
(92, '2025-11-05 05:11:41.907924', '57', 'X-Ray Bagasi (0.00%)', 3, '', 13, 1),
(93, '2025-11-05 05:11:41.907957', '56', 'Pushback Tractor (5.00%)', 3, '', 13, 1),
(94, '2025-11-05 05:11:41.907987', '55', 'Conveyor Belt (60.00%)', 3, '', 13, 1),
(95, '2025-11-05 05:23:41.903429', '60', 'Genset Utama (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(96, '2025-11-05 05:24:17.793068', '61', 'Pushback Tractor (90.00%)', 1, '[{\"added\": {}}]', 13, 1),
(97, '2025-11-05 05:24:27.925990', '61', 'Pushback Tractor (50.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(98, '2025-11-05 05:26:14.089803', '61', 'Pushback Tractor (75.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(99, '2025-11-05 05:26:47.980493', '62', 'CCTV (50.00%)', 1, '[{\"added\": {}}]', 13, 1),
(100, '2025-11-05 05:27:23.934423', '63', 'GSE 2 (0.00%)', 1, '[{\"added\": {}}]', 13, 1),
(101, '2025-11-05 05:27:41.633507', '63', 'GSE 2 (0.00%)', 3, '', 13, 1),
(102, '2025-11-05 05:28:00.938578', '64', 'Dron 2 (0.00%)', 1, '[{\"added\": {}}]', 13, 1),
(103, '2025-11-05 05:33:59.963963', '64', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(104, '2025-11-05 05:39:03.536996', '64', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(105, '2025-11-05 05:44:52.752625', '64', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(106, '2025-11-05 05:45:05.337470', '64', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(107, '2025-11-05 05:50:50.441716', '64', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(108, '2025-11-05 05:51:14.753858', '64', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(109, '2025-11-05 05:51:41.669166', '64', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(110, '2025-11-05 05:51:54.175398', '64', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(111, '2025-11-05 06:27:43.200819', '64', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(112, '2025-11-05 06:28:03.127939', '64', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(113, '2025-11-05 06:43:37.258447', '64', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(114, '2025-11-05 07:04:31.068030', '64', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(115, '2025-11-05 07:04:58.307276', '64', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(116, '2025-11-05 07:18:38.936393', '64', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(117, '2025-11-05 07:20:11.838384', '65', 'Dron 1 (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(118, '2025-11-05 23:40:05.118773', '66', 'Genset Utama (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(119, '2025-11-05 23:40:46.877498', '67', 'Pushback Tractor (75.00%)', 1, '[{\"added\": {}}]', 13, 1),
(120, '2025-11-05 23:41:47.911635', '68', 'CCTV (50.00%)', 1, '[{\"added\": {}}]', 13, 1),
(121, '2025-11-05 23:42:21.556029', '69', 'Drone (0.00%)', 1, '[{\"added\": {}}]', 13, 1),
(122, '2025-11-05 23:42:34.290069', '70', 'Dron 1 (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(123, '2025-11-05 23:43:15.249407', '71', 'Dron 2 (0.00%)', 1, '[{\"added\": {}}]', 13, 1),
(124, '2025-11-06 00:11:17.050879', '71', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(125, '2025-11-06 00:11:29.769030', '71', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(126, '2025-11-06 01:26:58.068641', '71', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(127, '2025-11-06 01:27:32.211702', '71', 'Dron 2 (0.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(128, '2025-11-06 01:27:54.741155', '71', 'Dron 2 (100.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(129, '2025-11-06 01:28:51.569666', '72', 'Runway Light (50.00%)', 1, '[{\"added\": {}}]', 13, 1),
(130, '2025-11-06 01:38:34.930626', '73', 'CCTV (90.00%)', 1, '[{\"added\": {}}]', 13, 1),
(131, '2025-11-06 01:41:56.136636', '73', 'CCTV (90.00%)', 3, '', 13, 1),
(132, '2025-11-06 01:42:24.233815', '68', 'CCTV (80.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(133, '2025-11-07 00:09:21.723527', '74', 'Genset Utama (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(134, '2025-11-07 00:10:08.336996', '75', 'Conveyor Belt (80.00%)', 1, '[{\"added\": {}}]', 13, 1),
(135, '2025-11-07 00:10:23.957402', '75', 'Conveyor Belt (60.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(136, '2025-11-07 00:10:50.361639', '76', 'CCTV (50.00%)', 1, '[{\"added\": {}}]', 13, 1),
(137, '2025-11-07 00:11:03.109566', '77', 'Drone (0.00%)', 1, '[{\"added\": {}}]', 13, 1),
(138, '2025-11-07 01:19:55.326268', '76', 'CCTV (40.00%)', 2, '[{\"changed\": {\"fields\": [\"Jumlah alat normal\", \"Nilai\"]}}]', 13, 1),
(139, '2025-11-07 02:54:17.730761', '1', 'Konfigurasi Energi BIZAM', 1, '[{\"added\": {}}]', 20, 1),
(140, '2025-11-07 02:55:46.838255', '1', '2025-11-07 – 33476409.600000 (Deviasi 0.00%)', 1, '[{\"added\": {}}]', 21, 1),
(141, '2025-11-07 02:57:03.251888', '1', '2025-11-06 – 33476409.600000 (Deviasi 0.00%)', 2, '[{\"changed\": {\"fields\": [\"Tanggal\"]}}]', 21, 1),
(142, '2025-11-07 02:57:30.306077', '1', '2025-11-06 – 33476409.600000 (Deviasi 0.00%)', 2, '[]', 21, 1),
(143, '2025-11-07 02:58:17.115464', '2', '2025-11-07 – 593066870968.800000 (Deviasi 1771496.41%)', 1, '[{\"added\": {}}]', 21, 1),
(144, '2025-11-07 03:10:02.710899', '2', 'KonsumsiEnergi object (2)', 3, '', 21, 1),
(145, '2025-11-07 03:10:44.091352', '3', 'KonsumsiEnergi object (3)', 1, '[{\"added\": {}}]', 21, 1),
(146, '2025-11-07 03:53:26.383059', '3', 'KonsumsiEnergi object (3)', 2, '[{\"changed\": {\"fields\": [\"Stand awal lwbp\", \"Pemakaian lwbp\", \"Total pemakaian energi\", \"Biaya lwbp\", \"Total biaya\", \"Selisih pemakaian biaya\", \"Deviasi pemakaian persen\"]}}]', 21, 1),
(147, '2025-11-07 03:55:56.339121', '3', 'KonsumsiEnergi object (3)', 2, '[{\"changed\": {\"fields\": [\"Stand awal lwbp\", \"Pemakaian lwbp\", \"Total pemakaian energi\", \"Biaya lwbp\", \"Total biaya\", \"Selisih pemakaian biaya\", \"Deviasi pemakaian persen\"]}}]', 21, 1),
(148, '2025-11-07 05:29:49.536643', '3', 'KonsumsiEnergi object (3)', 2, '[{\"changed\": {\"fields\": [\"Stand awal lwbp\", \"Stand awal wbp\", \"Pemakaian lwbp\", \"Pemakaian wbp\", \"Total pemakaian energi\", \"Biaya lwbp\", \"Biaya wbp\", \"Total biaya\", \"Selisih pemakaian biaya\", \"Deviasi pemakaian persen\"]}}]', 21, 1),
(149, '2025-11-07 05:40:10.725071', '1', 'KonsumsiEnergi object (1)', 2, '[{\"changed\": {\"fields\": [\"Tanggal\", \"Selisih pemakaian biaya\"]}}]', 21, 1),
(150, '2025-11-07 05:42:52.851577', '3', 'KonsumsiEnergi object (3)', 2, '[{\"changed\": {\"fields\": [\"Tanggal\", \"Selisih pemakaian biaya\", \"Deviasi pemakaian persen\"]}}]', 21, 1),
(151, '2025-11-07 05:44:30.213826', '3', 'KonsumsiEnergi object (3)', 2, '[{\"changed\": {\"fields\": [\"Stand awal lwbp\", \"Stand awal wbp\", \"Pemakaian lwbp\", \"Pemakaian wbp\", \"Total pemakaian energi\", \"Biaya lwbp\", \"Biaya wbp\", \"Total biaya\", \"Selisih pemakaian biaya\", \"Deviasi pemakaian persen\"]}}]', 21, 1),
(152, '2025-11-07 05:45:09.465709', '1', 'KonsumsiEnergi object (1)', 2, '[{\"changed\": {\"fields\": [\"Selisih pemakaian biaya\"]}}]', 21, 1),
(153, '2025-11-07 05:45:44.089377', '3', 'KonsumsiEnergi object (3)', 2, '[{\"changed\": {\"fields\": [\"Stand awal wbp\", \"Pemakaian wbp\", \"Total pemakaian energi\", \"Biaya wbp\", \"Total biaya\", \"Selisih pemakaian biaya\", \"Deviasi pemakaian persen\"]}}]', 21, 1),
(154, '2025-11-07 05:46:38.506124', '4', 'KonsumsiEnergi object (4)', 1, '[{\"added\": {}}]', 21, 1),
(155, '2025-11-07 05:48:02.207013', '5', 'KonsumsiEnergi object (5)', 1, '[{\"added\": {}}]', 21, 1),
(156, '2025-11-07 09:26:04.349328', '6', 'KonsumsiEnergi object (6)', 1, '[{\"added\": {}}]', 21, 1),
(157, '2025-11-07 09:26:47.083777', '6', 'KonsumsiEnergi object (6)', 2, '[{\"changed\": {\"fields\": [\"Tanggal\", \"Selisih pemakaian biaya\"]}}]', 21, 1),
(158, '2025-11-07 09:28:10.737715', '7', 'KonsumsiEnergi object (7)', 1, '[{\"added\": {}}]', 21, 1),
(159, '2025-11-07 09:29:09.390761', '8', 'KonsumsiEnergi object (8)', 1, '[{\"added\": {}}]', 21, 1),
(160, '2025-11-07 22:27:18.645032', '9', 'KonsumsiEnergi object (9)', 1, '[{\"added\": {}}]', 21, 1),
(161, '2025-11-07 22:28:09.805385', '9', 'KonsumsiEnergi object (9)', 2, '[{\"changed\": {\"fields\": [\"Stand akhir lwbp\", \"Pemakaian lwbp\", \"Total pemakaian energi\", \"Biaya lwbp\", \"Total biaya\", \"Selisih pemakaian biaya\", \"Deviasi pemakaian persen\"]}}]', 21, 1),
(162, '2025-11-07 22:38:29.320765', '11', 'AOCC 1 (AOCC)', 1, '[{\"added\": {}}]', 9, 1),
(163, '2025-11-07 22:39:00.316632', '12', 'Gedung (Facility Management)', 1, '[{\"added\": {}}]', 9, 1),
(164, '2025-11-07 22:39:43.907826', '9', 'UNIT A', 1, '[{\"added\": {}}]', 11, 1),
(165, '2025-11-07 22:40:11.077267', '13', 'ALAT UNIT A (UNIT A)', 1, '[{\"added\": {}}]', 9, 1),
(166, '2025-11-07 22:40:38.505156', '78', 'Genset Utama (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(167, '2025-11-07 22:41:00.958231', '79', 'Conveyor Belt (60.00%)', 1, '[{\"added\": {}}]', 13, 1),
(168, '2025-11-07 22:41:36.104992', '80', 'Pushback Tractor (75.00%)', 1, '[{\"added\": {}}]', 13, 1),
(169, '2025-11-07 22:41:52.736236', '81', 'X-Ray Bagasi (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(170, '2025-11-07 22:42:11.598653', '82', 'Drone (100.00%)', 1, '[{\"added\": {}}]', 13, 1),
(171, '2025-11-07 22:42:37.815375', '83', 'AOCC 1 (30.00%)', 1, '[{\"added\": {}}]', 13, 1),
(172, '2025-11-07 22:43:00.744651', '84', 'Gedung (50.00%)', 1, '[{\"added\": {}}]', 13, 1),
(173, '2025-11-07 22:43:39.578207', '85', 'ALAT UNIT A (75.00%)', 1, '[{\"added\": {}}]', 13, 1),
(174, '2025-11-07 22:44:04.990645', '5', 'Facility', 2, '[{\"changed\": {\"fields\": [\"Nama unit\"]}}]', 11, 1);

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(18, 'core', 'aianalitik'),
(7, 'core', 'aidatasethistory'),
(8, 'core', 'appuser'),
(20, 'core', 'energysetting'),
(15, 'core', 'fileupload'),
(21, 'core', 'konsumsienergi'),
(17, 'core', 'laporan'),
(12, 'core', 'logaktivitas'),
(13, 'core', 'nilaikesiapan'),
(14, 'core', 'notifikasi'),
(9, 'core', 'peralatan'),
(16, 'core', 'riwayatperalatan'),
(10, 'core', 'settingaimodel'),
(11, 'core', 'unit'),
(19, 'core', 'verifikasi'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-10-29 12:55:46.583750'),
(2, 'auth', '0001_initial', '2025-10-29 12:55:46.968437'),
(3, 'admin', '0001_initial', '2025-10-29 12:55:47.066167'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-10-29 12:55:47.089263'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-10-29 12:55:47.101110'),
(6, 'contenttypes', '0002_remove_content_type_name', '2025-10-29 12:55:47.153040'),
(7, 'auth', '0002_alter_permission_name_max_length', '2025-10-29 12:55:47.178494'),
(8, 'auth', '0003_alter_user_email_max_length', '2025-10-29 12:55:47.199886'),
(9, 'auth', '0004_alter_user_username_opts', '2025-10-29 12:55:47.223999'),
(10, 'auth', '0005_alter_user_last_login_null', '2025-10-29 12:55:47.258862'),
(11, 'auth', '0006_require_contenttypes_0002', '2025-10-29 12:55:47.260353'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2025-10-29 12:55:47.267278'),
(13, 'auth', '0008_alter_user_username_max_length', '2025-10-29 12:55:47.288883'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2025-10-29 12:55:47.309194'),
(15, 'auth', '0010_alter_group_name_max_length', '2025-10-29 12:55:47.331134'),
(16, 'auth', '0011_update_proxy_permissions', '2025-10-29 12:55:47.338697'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2025-10-29 12:55:47.360667'),
(18, 'core', '0001_initial', '2025-10-29 12:55:47.987802'),
(19, 'sessions', '0001_initial', '2025-10-29 12:55:48.027567'),
(20, 'core', '0002_nilaikesiapan_jumlah_alat_normal_and_more', '2025-11-03 04:50:52.004082'),
(21, 'core', '0003_alter_nilaikesiapan_jumlah_alat_normal', '2025-11-03 07:46:11.077122'),
(22, 'core', '0004_alter_peralatan_kategori', '2025-11-03 07:52:04.561000'),
(23, 'core', '0005_alter_nilaikesiapan_tanggal', '2025-11-04 23:59:02.412785'),
(24, 'core', '0006_appuser_updated_at_fileupload_updated_at_and_more', '2025-11-05 00:33:56.658390'),
(25, 'core', '0007_energysetting_konsumsienergi', '2025-11-07 02:52:02.996373');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0vn9t3c1imxx8564b7vha1k5w5c6brrk', 'eyJhcHB1c2VyX2lkIjo1fQ:1vHU8u:oyc1Nx2UAmdMnK84fs4RIYxZrmK0YiloW_dwIlCx1BQ', '2025-11-21 21:37:12.734744'),
('30tnakk5lz15hwmbnp2hsbzuqtip3wni', 'eyJhcHB1c2VyX2lkIjo1fQ:1vHVDb:gpOgimsDBDq8TiAu-S8FC_nkvdN7PSz3vDZfDtJw2p0', '2025-11-21 22:46:07.448804'),
('43oo1fg6lx7ssorhkd2jvwenrxmku4tn', 'eyJhcHB1c2VyX2lkIjo1fQ:1vGnZY:4eWod4mh_0GaHbEgzdAZ5DB4x8d4U27_hsj8F1FlGiw', '2025-11-20 00:09:52.217469'),
('7elwstk2iaojt4a8fdsv7sdvpkmjtzbx', '.eJxVjMsOwiAUBf-FtSFcnsWl-34DubykaqAp7cr479qkMel2Zs55E5znrafFTZFc1YU43Nbi_oQAOTGP4ZnqLuID673R0Oq6TJ7uCT1sp2OL6XU72tNBwV5-axM0MBBZZwPKZwDPtGYomErMciltVhjQDjYyaRV4HLIMYHTkQmWDnHy-SqY8Ew:1vGosY:ZHVFAM0bVXgBWutMA9aqYL9rSLxuHWzrweJDHxv2oJI', '2025-11-20 01:33:34.174339'),
('92nqr4w8j4h1tf3hcb9bj2b1ow5icov9', '.eJxVjssKwjAURP8lawm5eTYu3fsN4eZlqpKUpl2J_24LRXQ7Z-YwL-JwXYpbe5rdGMmZADn9Zh7DI9UdxDvWW6Oh1WUePd0r9KCdXltMz8vR_RMU7GVbm6CBgcg6G1A-A3imNUPBVGKWS2mzwoB2sJFJq8DjkGUAoyMXKhvkmxSn6XtTvT8ezTwT:1vGRm7:wfm5bsqVUhsICIm6ue5el0tBmYUMx7pvDfkuoCYaUJk', '2025-11-19 00:53:23.287005'),
('9qpbbzbnxhr5k1alf4gj27so28yo71bq', 'eyJhcHB1c2VyX2lkIjo1fQ:1vGoSY:mQGe3i8KhND8MM2zuFyrjdDBHv9mml1HRMi3OxgZf6A', '2025-11-20 01:06:42.855655'),
('awu21nmrqryqmpie8zzrha6psx2smd5h', '.eJxVjDsOwjAQBe_iGlm7_saU9JzBWv9wANlSnFSIu0OkFNC-mXkv5mlbq99GXvyc2JkhO_1ugeIjtx2kO7Vb57G3dZkD3xV-0MGvPeXn5XD_DiqN-q1tNAgoiykWdSiIAYwBkqAzOKGUK5oiucklUE5joKmoiNYkIXWxJNj7A74rNwg:1vE5jQ:HOMR2grqOBeS-e1T6UIisSdoM8nqg1Cb3Mmv8PJnM1U', '2025-11-12 12:56:52.715344'),
('cadjpy87vcxmjgb9dy3p6kzxxx20izp7', 'eyJhcHB1c2VyX2lkIjo1fQ:1vHWu6:bgkja6UNnlZe8YtYjww3AiZk7igL2QY98R6cMGxV9vU', '2025-11-22 00:34:06.036727'),
('enuilv7svgvipmn33z8h85y1jbp4w2qy', 'eyJhcHB1c2VyX2lkIjo1fQ:1vFrvh:HSzPbEopZCjOXgaE5VhtCzEixe3gQi-XF-HTYprqW_Y', '2025-11-17 10:36:53.621059'),
('hn97nik26zbkwf8th9wl84r75we4zs0c', '.eJxVjMsOwiAUBf-FtSFcnsWl-34DubykaqAp7cr479qkMel2Zs55E5znrafFTZFc1YU43Nbi_oQAOTGP4ZnqLuID673R0Oq6TJ7uCT1sp2OL6XU72tNBwV5-axM0MBBZZwPKZwDPtGYomErMciltVhjQDjYyaRV4HLIMYHTkQmWDnHy-SqY8Ew:1vFwDb:sjAjzWEIP9U4Zjh8UtcXG3nYw4oLGYKioJR8fU6ysCs', '2025-11-17 15:11:39.936637'),
('lh9jxzd63daby9aj17p6ytdjqqlxn6nd', 'eyJhcHB1c2VyX2lkIjo1fQ:1vGoSU:Bft_nyKUGPHYOyVPyXjcdPkKL_-rpkC9nUt4EZywoxE', '2025-11-20 01:06:38.247432'),
('llexago8gn6ist8x94pvbxz6axjoba0b', '.eJxVjMsOwiAUBf-FtSFcnsWl-34DubykaqAp7cr479qkMel2Zs55E5znrafFTZFc1YU43Nbi_oQAOTGP4ZnqLuID673R0Oq6TJ7uCT1sp2OL6XU72tNBwV5-axM0MBBZZwPKZwDPtGYomErMciltVhjQDjYyaRV4HLIMYHTkQmWDnHy-SqY8Ew:1vHA2H:3V7w3V1_3vB7wPyP6GWUmMZue0gAbzariZi0W3E6src', '2025-11-21 00:09:01.465229'),
('qe90kqq0pxbyvs2q5ypeof4vpqrdhhhd', 'eyJhcHB1c2VyX2lkIjo1fQ:1vHVq1:OGzJ1zTD1XhW0BteXEZhb2raCCvlieHZlaRhrFxQlMI', '2025-11-21 23:25:49.603851'),
('shpcfrb22z0knnmz2evhk67n149fojw0', 'eyJhcHB1c2VyX2lkIjo1fQ:1vHUBQ:aQgvezFDHz1e_tnztyc09XyIVZICDc5e6HfadkfsBeM', '2025-11-21 21:39:48.688118'),
('wh0qf3h3gszvj8ed1nb6hba05gq94sux', 'eyJhcHB1c2VyX2lkIjo1fQ:1vHWAV:ql52ja5Pxu2kLm8DlJs7QDBJ59yr-OiYNmwa2G1OcwI', '2025-11-21 23:46:59.094545'),
('xl4kop1nlyl6pt2fzd6vpl6bf9xz1jan', 'eyJhcHB1c2VyX2lkIjo1fQ:1vGoeU:Bb8o-e2rAdA6kAqVmhLTflU6ep3joIHaoxBtAjbhFo4', '2025-11-20 01:19:02.465041'),
('zcfpe74dggvt2ronq4be5q9jtvhzsqpk', 'eyJhcHB1c2VyX2lkIjo1fQ:1vHTxz:8ZVKe6zPSoHu-lUctFCkfROTlkVg1639yFaEzeBJpy4', '2025-11-21 21:25:55.659836');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `core_aianalitik`
--
ALTER TABLE `core_aianalitik`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_aianalitik_unit_id_0dba632c_fk_core_unit_id` (`unit_id`);

--
-- Indexes for table `core_aidatasethistory`
--
ALTER TABLE `core_aidatasethistory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `core_appuser`
--
ALTER TABLE `core_appuser`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `core_appuser_unit_id_29debb08_fk_core_unit_id` (`unit_id`);

--
-- Indexes for table `core_energysetting`
--
ALTER TABLE `core_energysetting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `core_fileupload`
--
ALTER TABLE `core_fileupload`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_fileupload_uploaded_by_id_e979a3b0_fk_core_appuser_id` (`uploaded_by_id`),
  ADD KEY `core_fileupload_kesiapan_id_9c6dc044_fk_core_nilaikesiapan_id` (`kesiapan_id`),
  ADD KEY `core_fileupload_peralatan_id_a82c74e4_fk_core_peralatan_id` (`peralatan_id`);

--
-- Indexes for table `core_konsumsienergi`
--
ALTER TABLE `core_konsumsienergi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `core_laporan`
--
ALTER TABLE `core_laporan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_laporan_dibuat_oleh_id_52f1cd14_fk_core_appuser_id` (`dibuat_oleh_id`),
  ADD KEY `core_laporan_unit_id_43644c2a_fk_core_unit_id` (`unit_id`);

--
-- Indexes for table `core_logaktivitas`
--
ALTER TABLE `core_logaktivitas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_logaktivitas_user_id_7fb5280f_fk_core_appuser_id` (`user_id`);

--
-- Indexes for table `core_nilaikesiapan`
--
ALTER TABLE `core_nilaikesiapan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_nilaikesiapan_user_input_id_6ddcf53d_fk_core_appuser_id` (`user_input_id`),
  ADD KEY `core_nilaikesiapan_peralatan_id_3cfc85a1_fk_core_peralatan_id` (`peralatan_id`);

--
-- Indexes for table `core_notifikasi`
--
ALTER TABLE `core_notifikasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_notifikasi_user_id_b43d7c16_fk_core_appuser_id` (`user_id`);

--
-- Indexes for table `core_peralatan`
--
ALTER TABLE `core_peralatan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode_peralatan` (`kode_peralatan`),
  ADD KEY `core_peralatan_unit_id_143b703e_fk_core_unit_id` (`unit_id`);

--
-- Indexes for table `core_riwayatperalatan`
--
ALTER TABLE `core_riwayatperalatan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_riwayatperalatan_dibuat_oleh_id_3fb0f4c9_fk_core_appuser_id` (`dibuat_oleh_id`),
  ADD KEY `core_riwayatperalatan_peralatan_id_9ef01fd8_fk_core_peralatan_id` (`peralatan_id`);

--
-- Indexes for table `core_settingaimodel`
--
ALTER TABLE `core_settingaimodel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `core_unit`
--
ALTER TABLE `core_unit`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode_unit` (`kode_unit`);

--
-- Indexes for table `core_verifikasi`
--
ALTER TABLE `core_verifikasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_verifikasi_kesiapan_id_d53e5724_fk_core_nilaikesiapan_id` (`kesiapan_id`),
  ADD KEY `core_verifikasi_requested_by_id_d5dfd573_fk_core_appuser_id` (`requested_by_id`),
  ADD KEY `core_verifikasi_verifikator_id_e9e3b1de_fk_core_appuser_id` (`verifikator_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `core_aianalitik`
--
ALTER TABLE `core_aianalitik`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `core_aidatasethistory`
--
ALTER TABLE `core_aidatasethistory`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `core_appuser`
--
ALTER TABLE `core_appuser`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `core_energysetting`
--
ALTER TABLE `core_energysetting`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `core_fileupload`
--
ALTER TABLE `core_fileupload`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `core_konsumsienergi`
--
ALTER TABLE `core_konsumsienergi`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `core_laporan`
--
ALTER TABLE `core_laporan`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `core_logaktivitas`
--
ALTER TABLE `core_logaktivitas`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `core_nilaikesiapan`
--
ALTER TABLE `core_nilaikesiapan`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT for table `core_notifikasi`
--
ALTER TABLE `core_notifikasi`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `core_peralatan`
--
ALTER TABLE `core_peralatan`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `core_riwayatperalatan`
--
ALTER TABLE `core_riwayatperalatan`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `core_settingaimodel`
--
ALTER TABLE `core_settingaimodel`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `core_unit`
--
ALTER TABLE `core_unit`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `core_verifikasi`
--
ALTER TABLE `core_verifikasi`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=175;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `core_aianalitik`
--
ALTER TABLE `core_aianalitik`
  ADD CONSTRAINT `core_aianalitik_unit_id_0dba632c_fk_core_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `core_unit` (`id`);

--
-- Constraints for table `core_appuser`
--
ALTER TABLE `core_appuser`
  ADD CONSTRAINT `core_appuser_unit_id_29debb08_fk_core_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `core_unit` (`id`);

--
-- Constraints for table `core_fileupload`
--
ALTER TABLE `core_fileupload`
  ADD CONSTRAINT `core_fileupload_kesiapan_id_9c6dc044_fk_core_nilaikesiapan_id` FOREIGN KEY (`kesiapan_id`) REFERENCES `core_nilaikesiapan` (`id`),
  ADD CONSTRAINT `core_fileupload_peralatan_id_a82c74e4_fk_core_peralatan_id` FOREIGN KEY (`peralatan_id`) REFERENCES `core_peralatan` (`id`),
  ADD CONSTRAINT `core_fileupload_uploaded_by_id_e979a3b0_fk_core_appuser_id` FOREIGN KEY (`uploaded_by_id`) REFERENCES `core_appuser` (`id`);

--
-- Constraints for table `core_laporan`
--
ALTER TABLE `core_laporan`
  ADD CONSTRAINT `core_laporan_dibuat_oleh_id_52f1cd14_fk_core_appuser_id` FOREIGN KEY (`dibuat_oleh_id`) REFERENCES `core_appuser` (`id`),
  ADD CONSTRAINT `core_laporan_unit_id_43644c2a_fk_core_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `core_unit` (`id`);

--
-- Constraints for table `core_logaktivitas`
--
ALTER TABLE `core_logaktivitas`
  ADD CONSTRAINT `core_logaktivitas_user_id_7fb5280f_fk_core_appuser_id` FOREIGN KEY (`user_id`) REFERENCES `core_appuser` (`id`);

--
-- Constraints for table `core_nilaikesiapan`
--
ALTER TABLE `core_nilaikesiapan`
  ADD CONSTRAINT `core_nilaikesiapan_peralatan_id_3cfc85a1_fk_core_peralatan_id` FOREIGN KEY (`peralatan_id`) REFERENCES `core_peralatan` (`id`),
  ADD CONSTRAINT `core_nilaikesiapan_user_input_id_6ddcf53d_fk_core_appuser_id` FOREIGN KEY (`user_input_id`) REFERENCES `core_appuser` (`id`);

--
-- Constraints for table `core_notifikasi`
--
ALTER TABLE `core_notifikasi`
  ADD CONSTRAINT `core_notifikasi_user_id_b43d7c16_fk_core_appuser_id` FOREIGN KEY (`user_id`) REFERENCES `core_appuser` (`id`);

--
-- Constraints for table `core_peralatan`
--
ALTER TABLE `core_peralatan`
  ADD CONSTRAINT `core_peralatan_unit_id_143b703e_fk_core_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `core_unit` (`id`);

--
-- Constraints for table `core_riwayatperalatan`
--
ALTER TABLE `core_riwayatperalatan`
  ADD CONSTRAINT `core_riwayatperalatan_dibuat_oleh_id_3fb0f4c9_fk_core_appuser_id` FOREIGN KEY (`dibuat_oleh_id`) REFERENCES `core_appuser` (`id`),
  ADD CONSTRAINT `core_riwayatperalatan_peralatan_id_9ef01fd8_fk_core_peralatan_id` FOREIGN KEY (`peralatan_id`) REFERENCES `core_peralatan` (`id`);

--
-- Constraints for table `core_verifikasi`
--
ALTER TABLE `core_verifikasi`
  ADD CONSTRAINT `core_verifikasi_kesiapan_id_d53e5724_fk_core_nilaikesiapan_id` FOREIGN KEY (`kesiapan_id`) REFERENCES `core_nilaikesiapan` (`id`),
  ADD CONSTRAINT `core_verifikasi_requested_by_id_d5dfd573_fk_core_appuser_id` FOREIGN KEY (`requested_by_id`) REFERENCES `core_appuser` (`id`),
  ADD CONSTRAINT `core_verifikasi_verifikator_id_e9e3b1de_fk_core_appuser_id` FOREIGN KEY (`verifikator_id`) REFERENCES `core_appuser` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
