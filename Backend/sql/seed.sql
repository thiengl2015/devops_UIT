-- CLMS Seed Data for MySQL
-- Run: mysql -u root -p clms_db < sql/seed.sql

USE clms_db;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE password_reset_tokens;
TRUNCATE TABLE refresh_tokens;
TRUNCATE TABLE incident_tickets;
TRUNCATE TABLE reservations;
TRUNCATE TABLE workstations;
TRUNCATE TABLE lab_rooms;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;

-- Seed Users (passwords are bcrypt hashed - "Admin@1234" and "Test@1234")
INSERT INTO users (username, email, password, full_name, phone, role, status, is_verified, failed_login_attempts) VALUES
('admin', 'admin@clms.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Nguyen Van Admin', '0912345001', 'system_admin', 'active', TRUE, 0),
('staff1', 'staff1@clms.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tran Thi Staff', '0912345002', 'lab_staff', 'active', TRUE, 0),
('staff2', 'staff2@clms.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Le Van Staff', '0912345003', 'lab_staff', 'active', TRUE, 0),
('staff3', 'staff3@clms.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Pham Thi Staff', '0912345004', 'lab_staff', 'active', TRUE, 0),
('staff4', 'staff4@clms.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Hoang Van Staff', '0912345005', 'lab_staff', 'active', TRUE, 0),
('user1', 'user1@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Nguyen Thi Student', '0901234001', 'customer', 'active', TRUE, 0),
('user2', 'user2@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tran Van Student', '0901234002', 'customer', 'active', TRUE, 0),
('user3', 'user3@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Le Thi Student', '0901234003', 'customer', 'active', TRUE, 0),
('user4', 'user4@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Pham Van Student', '0901234004', 'customer', 'active', TRUE, 0),
('user5', 'user5@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Hoang Thi Student', '0901234005', 'customer', 'active', TRUE, 0),
('user6', 'user6@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dang Van Student', '0901234006', 'customer', 'active', TRUE, 0),
('user7', 'user7@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bui Thi Student', '0901234007', 'customer', 'active', TRUE, 0),
('user8', 'user8@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Do Van Student', '0901234008', 'customer', 'active', TRUE, 0),
('user9', 'user9@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Vu Thi Student', '0901234009', 'customer', 'active', TRUE, 0),
('user10', 'user10@student.edu.vn', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ngo Van Student', '0901234010', 'customer', 'active', TRUE, 0);

-- Seed Lab Rooms
INSERT INTO lab_rooms (room_code, name, location, capacity, description, status) VALUES
('LAB-A101', 'Lab Room A - Floor 1', 'Building A, Floor 1', 40, 'Main lab for Basic Programming', 'active'),
('LAB-A102', 'Lab Room B - Floor 1', 'Building A, Floor 1', 30, 'Lab for Database course', 'active'),
('LAB-B201', 'Lab Room C - Floor 2', 'Building B, Floor 2', 35, 'Lab for Computer Networking', 'active'),
('LAB-B202', 'Lab Room D - Floor 2', 'Building B, Floor 2', 40, 'Lab for Operating Systems', 'active'),
('LAB-C301', 'Lab Room E - Floor 3', 'Building C, Floor 3', 50, 'Large lab for final exams', 'active'),
('LAB-D401', 'Lab Room F - Floor 4', 'Building D, Floor 4', 25, 'Lab for graduate students', 'active'),
('LAB-E501', 'Lab Room G - Floor 5', 'Building E, Floor 5', 30, 'Lab for Artificial Intelligence', 'maintenance');

-- Seed Workstations (5 per room)
INSERT INTO workstations (lab_room_id, station_code, ip_address, mac_address, cpu, ram_gb, gpu, os, state) VALUES
-- LAB-A101
(1, 'A101-PC01', '192.168.1.1', '00:1B:44:11:3A:B1', 'Intel Core i5-12400', 16, 'Intel UHD 730', 'Windows 11 Pro', 'available'),
(1, 'A101-PC02', '192.168.1.2', '00:1B:44:11:3A:B2', 'Intel Core i5-12400', 16, 'Intel UHD 730', 'Windows 11 Pro', 'available'),
(1, 'A101-PC03', '192.168.1.3', '00:1B:44:11:3A:B3', 'Intel Core i5-12400', 16, 'Intel UHD 730', 'Windows 11 Pro', 'available'),
(1, 'A101-PC04', '192.168.1.4', '00:1B:44:11:3A:B4', 'Intel Core i5-12400', 16, 'Intel UHD 730', 'Windows 11 Pro', 'maintenance'),
(1, 'A101-PC05', '192.168.1.5', '00:1B:44:11:3A:B5', 'Intel Core i5-12400', 16, 'Intel UHD 730', 'Windows 11 Pro', 'available'),
-- LAB-A102
(2, 'A102-PC01', '192.168.1.11', '00:1B:44:11:3A:C1', 'AMD Ryzen 5 5600X', 16, 'AMD Radeon RX 550', 'Windows 11 Pro', 'available'),
(2, 'A102-PC02', '192.168.1.12', '00:1B:44:11:3A:C2', 'AMD Ryzen 5 5600X', 16, 'AMD Radeon RX 550', 'Windows 11 Pro', 'available'),
(2, 'A102-PC03', '192.168.1.13', '00:1B:44:11:3A:C3', 'AMD Ryzen 5 5600X', 16, 'AMD Radeon RX 550', 'Windows 11 Pro', 'available'),
(2, 'A102-PC04', '192.168.1.14', '00:1B:44:11:3A:C4', 'AMD Ryzen 5 5600X', 16, 'AMD Radeon RX 550', 'Windows 11 Pro', 'reserved'),
(2, 'A102-PC05', '192.168.1.15', '00:1B:44:11:3A:C5', 'AMD Ryzen 5 5600X', 16, 'AMD Radeon RX 550', 'Windows 11 Pro', 'available'),
-- LAB-B201
(3, 'B201-PC01', '192.168.2.1', '00:1B:44:11:3A:D1', 'Intel Core i7-12700', 32, 'NVIDIA GTX 1650', 'Ubuntu 22.04 LTS', 'available'),
(3, 'B201-PC02', '192.168.2.2', '00:1B:44:11:3A:D2', 'Intel Core i7-12700', 32, 'NVIDIA GTX 1650', 'Ubuntu 22.04 LTS', 'available'),
(3, 'B201-PC03', '192.168.2.3', '00:1B:44:11:3A:D3', 'Intel Core i7-12700', 32, 'NVIDIA GTX 1650', 'Ubuntu 22.04 LTS', 'available'),
(3, 'B201-PC04', '192.168.2.4', '00:1B:44:11:3A:D4', 'Intel Core i7-12700', 32, 'NVIDIA GTX 1650', 'Ubuntu 22.04 LTS', 'available'),
(3, 'B201-PC05', '192.168.2.5', '00:1B:44:11:3A:D5', 'Intel Core i7-12700', 32, 'NVIDIA GTX 1650', 'Ubuntu 22.04 LTS', 'maintenance'),
-- LAB-B202
(4, 'B202-PC01', '192.168.2.11', '00:1B:44:11:3A:E1', 'AMD Ryzen 7 5800X', 32, 'NVIDIA RTX 3060', 'Windows 11 Pro', 'available'),
(4, 'B202-PC02', '192.168.2.12', '00:1B:44:11:3A:E2', 'AMD Ryzen 7 5800X', 32, 'NVIDIA RTX 3060', 'Windows 11 Pro', 'available'),
(4, 'B202-PC03', '192.168.2.13', '00:1B:44:11:3A:E3', 'AMD Ryzen 7 5800X', 32, 'NVIDIA RTX 3060', 'Windows 11 Pro', 'available'),
(4, 'B202-PC04', '192.168.2.14', '00:1B:44:11:3A:E4', 'AMD Ryzen 7 5800X', 32, 'NVIDIA RTX 3060', 'Windows 11 Pro', 'available'),
(4, 'B202-PC05', '192.168.2.15', '00:1B:44:11:3A:E5', 'AMD Ryzen 7 5800X', 32, 'NVIDIA RTX 3060', 'Windows 11 Pro', 'reserved'),
-- LAB-C301
(5, 'C301-PC01', '192.168.3.1', '00:1B:44:11:3A:F1', 'Intel Core i9-12900', 64, 'NVIDIA RTX 3080', 'Windows 11 Pro', 'available'),
(5, 'C301-PC02', '192.168.3.2', '00:1B:44:11:3A:F2', 'Intel Core i9-12900', 64, 'NVIDIA RTX 3080', 'Windows 11 Pro', 'available'),
(5, 'C301-PC03', '192.168.3.3', '00:1B:44:11:3A:F3', 'Intel Core i9-12900', 64, 'NVIDIA RTX 3080', 'Windows 11 Pro', 'available'),
(5, 'C301-PC04', '192.168.3.4', '00:1B:44:11:3A:F4', 'Intel Core i9-12900', 64, 'NVIDIA RTX 3080', 'Windows 11 Pro', 'available'),
(5, 'C301-PC05', '192.168.3.5', '00:1B:44:11:3A:F5', 'Intel Core i9-12900', 64, 'NVIDIA RTX 3080', 'Windows 11 Pro', 'available'),
-- LAB-D401
(6, 'D401-PC01', '192.168.4.1', '00:1B:44:11:3A:G1', 'AMD Ryzen 9 5950X', 64, 'NVIDIA RTX 3090', 'Ubuntu 22.04 LTS', 'available'),
(6, 'D401-PC02', '192.168.4.2', '00:1B:44:11:3A:G2', 'AMD Ryzen 9 5950X', 64, 'NVIDIA RTX 3090', 'Ubuntu 22.04 LTS', 'available'),
(6, 'D401-PC03', '192.168.4.3', '00:1B:44:11:3A:G3', 'AMD Ryzen 9 5950X', 64, 'NVIDIA RTX 3090', 'Ubuntu 22.04 LTS', 'available'),
(6, 'D401-PC04', '192.168.4.4', '00:1B:44:11:3A:G4', 'AMD Ryzen 9 5950X', 64, 'NVIDIA RTX 3090', 'Ubuntu 22.04 LTS', 'available'),
(6, 'D401-PC05', '192.168.4.5', '00:1B:44:11:3A:G5', 'AMD Ryzen 9 5950X', 64, 'NVIDIA RTX 3090', 'Ubuntu 22.04 LTS', 'available'),
-- LAB-E501
(7, 'E501-PC01', '192.168.5.1', '00:1B:44:11:3A:H1', 'Intel Core i7-12700K', 32, 'NVIDIA RTX 3070', 'Windows 11 Pro', 'available'),
(7, 'E501-PC02', '192.168.5.2', '00:1B:44:11:3A:H2', 'Intel Core i7-12700K', 32, 'NVIDIA RTX 3070', 'Windows 11 Pro', 'available'),
(7, 'E501-PC03', '192.168.5.3', '00:1B:44:11:3A:H3', 'Intel Core i7-12700K', 32, 'NVIDIA RTX 3070', 'Windows 11 Pro', 'available'),
(7, 'E501-PC04', '192.168.5.4', '00:1B:44:11:3A:H4', 'Intel Core i7-12700K', 32, 'NVIDIA RTX 3070', 'Windows 11 Pro', 'available'),
(7, 'E501-PC05', '192.168.5.5', '00:1B:44:11:3A:H5', 'Intel Core i7-12700K', 32, 'NVIDIA RTX 3070', 'Windows 11 Pro', 'available');

-- Seed Reservations
INSERT INTO reservations (user_id, resource_type, lab_room_id, workstation_id, start_time, end_time, purpose, expected_users, status, processed_by, processed_at) VALUES
(6, 'lab_room', 1, NULL, '2026-05-25 08:00:00', '2026-05-25 10:00:00', 'Learn Python Programming', 30, 'approved', 2, '2026-05-24 10:00:00'),
(7, 'lab_room', 2, NULL, '2026-05-25 13:00:00', '2026-05-25 15:00:00', 'Database Practice', 25, 'approved', 2, '2026-05-24 11:00:00'),
(8, 'workstation', NULL, 11, '2026-05-26 09:00:00', '2026-05-26 12:00:00', 'Project Work', 1, 'pending', NULL, NULL),
(9, 'lab_room', 3, NULL, '2026-05-27 14:00:00', '2026-05-27 16:00:00', 'Networking Final Exam', 35, 'approved', 3, '2026-05-24 15:00:00'),
(10, 'workstation', NULL, 21, '2026-05-28 08:00:00', '2026-05-28 11:00:00', 'AI Practice', 1, 'pending', NULL, NULL),
(6, 'lab_room', 4, NULL, '2026-05-29 10:00:00', '2026-05-29 12:00:00', 'Operating Systems Class', 30, 'rejected', 2, '2026-05-24 16:00:00'),
(11, 'lab_room', 5, NULL, '2026-05-30 08:00:00', '2026-05-30 11:00:00', 'Final Exam', 50, 'pending', NULL, NULL),
(12, 'workstation', NULL, 16, '2026-05-25 15:00:00', '2026-05-25 17:00:00', 'Educational Gaming', 1, 'approved', 4, '2026-05-24 14:00:00');

-- Seed Incident Tickets
INSERT INTO incident_tickets (reporter_id, workstation_id, lab_room_id, category, description, status, assigned_to, resolution_note) VALUES
(6, 4, 1, 'hardware', 'Computer fails to boot, unusual noise from cooling fan', 'open', NULL, NULL),
(7, 11, 2, 'software', 'Visual Studio Code keeps crashing', 'under_review', 2, 'Checking software version'),
(8, NULL, 3, 'network', 'Cannot connect to internet in LAB-B201', 'resolved', 3, 'Fixed by resetting network switch'),
(9, 25, 4, 'hardware', 'Keyboard not working properly', 'closed', 2, 'Replaced with new keyboard'),
(10, NULL, 1, 'os', 'Windows blue screen after update', 'open', NULL, NULL);
