-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 24, 2019 at 03:06 PM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `movie_ticket_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `bID` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `inDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `uID` int(11) NOT NULL,
  `sID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `mID` int(11) NOT NULL,
  `movieName` varchar(30) NOT NULL,
  `isActive` tinyint(1) NOT NULL,
  `inDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `uID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`mID`, `movieName`, `isActive`, `inDate`, `uID`) VALUES
(1, 'aaaaaaa', 1, '2019-08-24 02:47:58', 4),
(4, 'dabang 3', 1, '2019-08-24 11:31:25', 4),
(5, 'old town', 0, '2019-08-24 11:33:57', 4);

-- --------------------------------------------------------

--
-- Table structure for table `shows`
--

CREATE TABLE `shows` (
  `sID` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `duration` int(11) NOT NULL,
  `seats` int(11) NOT NULL,
  `inDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `uID` int(11) NOT NULL,
  `mID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `uID` int(11) NOT NULL,
  `userName` varbinary(30) NOT NULL,
  `email` varbinary(50) NOT NULL,
  `password` varbinary(70) NOT NULL,
  `fullName` varchar(30) NOT NULL,
  `isAdmin` tinyint(1) NOT NULL,
  `regDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`uID`, `userName`, `email`, `password`, `fullName`, `isAdmin`, `regDate`) VALUES
(4, 0x73726a6e, 0x73726a6e40676d61696c2e636f6d, 0x30313163393435663330636532636261666334353266333938343066303235363933333339633432, 'srjn pkwn', 1, '2019-08-21 16:22:58'),
(8, 0x31313131, 0x3131313132323232, 0x30313163393435663330636532636261666334353266333938343066303235363933333339633432, '1111 2222', 0, '2019-08-24 01:55:40'),
(9, 0x616161, 0x616161, 0x37653234306465373466623165643038666130386433383036336636613661393134363261383135, 'aaa', 0, '2019-08-24 11:54:57'),
(10, 0x626262, 0x626262424242, 0x35636231333832383464343331616264366130353361353636323565633038386266623838393132, 'bbb', 0, '2019-08-24 11:55:52'),
(11, 0x73726a6e313030, 0x737039383631353840676d61696c2e636f6d, 0x30313163393435663330636532636261666334353266333938343066303235363933333339633432, 'srjn pkwn', 0, '2019-08-24 12:34:09'),
(12, 0x73726a6e313131, 0x73726a6e31303040676d61696c2e636f6d, 0x30313163393435663330636532636261666334353266333938343066303235363933333339633432, '?????? ?????', 0, '2019-08-24 12:36:38');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`bID`),
  ADD KEY `uID` (`uID`),
  ADD KEY `bookings_ibfk_2` (`sID`);

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`mID`),
  ADD UNIQUE KEY `movieName` (`movieName`),
  ADD KEY `uID` (`uID`);

--
-- Indexes for table `shows`
--
ALTER TABLE `shows`
  ADD PRIMARY KEY (`sID`),
  ADD KEY `shows_ibfk_2` (`mID`),
  ADD KEY `uID` (`uID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`uID`),
  ADD UNIQUE KEY `userName` (`userName`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `bID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `mID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `shows`
--
ALTER TABLE `shows`
  MODIFY `sID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `uID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`uID`) REFERENCES `users` (`uID`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`sID`) REFERENCES `shows` (`sID`) ON DELETE CASCADE;

--
-- Constraints for table `movies`
--
ALTER TABLE `movies`
  ADD CONSTRAINT `movies_ibfk_1` FOREIGN KEY (`uID`) REFERENCES `users` (`uID`);

--
-- Constraints for table `shows`
--
ALTER TABLE `shows`
  ADD CONSTRAINT `shows_ibfk_2` FOREIGN KEY (`mID`) REFERENCES `movies` (`mID`) ON DELETE CASCADE,
  ADD CONSTRAINT `shows_ibfk_3` FOREIGN KEY (`uID`) REFERENCES `users` (`uID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
