-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 17 Nov 2022 pada 10.12
-- Versi server: 10.4.22-MariaDB
-- Versi PHP: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `web_supermarket`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang`
--

CREATE TABLE `barang` (
  `kdBarang` char(8) NOT NULL,
  `idKategori` int(11) NOT NULL,
  `namaBarang` varchar(64) NOT NULL,
  `harga` int(11) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `barang`
--

INSERT INTO `barang` (`kdBarang`, `idKategori`, `namaBarang`, `harga`, `stok`) VALUES
('B2200001', 11, 'Ram Laptop 1GB mix vendor ddr3', 75000, 10),
('B2200002', 13, 'Ram Laptop 1GB mix vendor ddr2', 50000, 8),
('B2200003', 12, 'Processor Intel Pentium Dual Core E2160', 120000, 1),
('B2200004', 14, 'Perdana Happy 6GB+Tiktok 14GB+Bonus Bulanan 3GB', 22000, 7),
('B2200005', 19, 'Voucher Wifi 12 Jam', 3000, 80),
('B2200006', 19, 'Voucher Wifi 1 Hari', 5000, 89),
('B2200007', 19, 'Voucher Wifi 3 Hari', 13000, 8),
('B2200008', 19, 'Voucher Wifi 7 hari', 27000, 9),
('B2200009', 20, 'Instal Laptop Windows 7', 50000, 100),
('B2200010', 20, 'Instal Laptop Windows 8', 75000, 100),
('B2200011', 20, 'Instal Laptop Windows 10', 100000, 100),
('B2200012', 20, 'Instal Laptop Windows 11', 100000, 100),
('B2200013', 21, 'Jasa setting Mikrotik', 200000, 100);

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `idKategori` int(11) NOT NULL,
  `namaKategori` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `kategori`
--

INSERT INTO `kategori` (`idKategori`, `namaKategori`) VALUES
(11, 'Ram Laptop ddr3'),
(12, 'Processor Komputer'),
(13, 'Ram Laptop ddr2'),
(14, 'Kartu Perdana Tri'),
(19, 'Voucher Wifi'),
(20, 'Instal Laptop'),
(21, 'Mikrotik');

-- --------------------------------------------------------

--
-- Struktur dari tabel `keranjang`
--

CREATE TABLE `keranjang` (
  `noItem` int(11) NOT NULL,
  `kdBarang` char(10) NOT NULL,
  `idUser` char(4) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Trigger `keranjang`
--
DELIMITER $$
CREATE TRIGGER `kurangi_stok` AFTER INSERT ON `keranjang` FOR EACH ROW UPDATE barang SET stok = stok - NEW.qty WHERE barang.kdBarang = NEW.kdBarang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `reset_stok` BEFORE DELETE ON `keranjang` FOR EACH ROW UPDATE barang SET stok = stok + OLD.qty WHERE barang.kdBarang = OLD.kdBarang
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `idTransaksi` char(10) NOT NULL,
  `tanggal` date NOT NULL,
  `idUser` char(4) NOT NULL,
  `namaPelanggan` varchar(64) NOT NULL,
  `alamatPelanggan` varchar(128) NOT NULL,
  `totalHarga` int(11) NOT NULL,
  `uangBayar` int(11) NOT NULL,
  `kembalian` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi_detail`
--

CREATE TABLE `transaksi_detail` (
  `idTransaksi` char(10) NOT NULL,
  `kdBarang` char(8) NOT NULL,
  `qty` int(11) NOT NULL,
  `subtotal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `idUser` char(4) NOT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(128) NOT NULL,
  `level` enum('administrator','petugas','kepala toko') NOT NULL,
  `nama` varchar(64) NOT NULL,
  `noTelp` varchar(20) NOT NULL,
  `foto` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`idUser`, `username`, `password`, `level`, `nama`, `noTelp`, `foto`) VALUES
('U001', 'warungit', '$2y$10$uZe/tmJqt7eH.gjOX3E/Fu9Ic6.kup3FT01E8F.bqAxfU8YmpJoCm', 'administrator', 'Mohamad Farhan Bula', '089602665624', '1a2f693a89a7a03283022b5c25889378.png');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`kdBarang`),
  ADD KEY `idKategori` (`idKategori`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`idKategori`);

--
-- Indeks untuk tabel `keranjang`
--
ALTER TABLE `keranjang`
  ADD PRIMARY KEY (`noItem`),
  ADD KEY `kdBarang` (`kdBarang`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`idTransaksi`),
  ADD KEY `idUser` (`idUser`);

--
-- Indeks untuk tabel `transaksi_detail`
--
ALTER TABLE `transaksi_detail`
  ADD KEY `idTransaksi` (`idTransaksi`),
  ADD KEY `kdBarang` (`kdBarang`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`idUser`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `idKategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `barang_ibfk_1` FOREIGN KEY (`idKategori`) REFERENCES `kategori` (`idKategori`);

--
-- Ketidakleluasaan untuk tabel `keranjang`
--
ALTER TABLE `keranjang`
  ADD CONSTRAINT `keranjang_ibfk_1` FOREIGN KEY (`kdBarang`) REFERENCES `barang` (`kdBarang`);

--
-- Ketidakleluasaan untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`);

--
-- Ketidakleluasaan untuk tabel `transaksi_detail`
--
ALTER TABLE `transaksi_detail`
  ADD CONSTRAINT `transaksi_detail_ibfk_2` FOREIGN KEY (`kdBarang`) REFERENCES `barang` (`kdBarang`),
  ADD CONSTRAINT `transaksi_detail_ibfk_3` FOREIGN KEY (`idTransaksi`) REFERENCES `transaksi` (`idTransaksi`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
