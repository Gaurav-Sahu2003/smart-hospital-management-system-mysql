USE shms;

-- Insert Users (10)
INSERT INTO Users (name, email, password_hash, role)
VALUES
('Ramesh Gupta', 'ramesh.gupta@example.com', 'pass123', 'Admin'),
('Anjali Sharma', 'anjali.sharma@example.com', 'pass123', 'Doctor'),
('Dr. Arvind Singh', 'arvind.singh@example.com', 'pass123', 'Doctor'),
('Sneha Patel', 'sneha.patel@example.com', 'pass123', 'Nurse'),
('Amit Kumar', 'amit.kumar@example.com', 'pass123', 'Receptionist'),
('Neha Yadav', 'neha.yadav@example.com', 'pass123', 'Patient'),
('Pooja Das', 'pooja.das@example.com', 'pass123', 'Patient'),
('Rahul Jain', 'rahul.jain@example.com', 'pass123', 'Patient'),
('Sunita Mehra', 'sunita.mehra@example.com', 'pass123', 'Nurse'),
('Mohit Verma', 'mohit.verma@example.com', 'pass123', 'Patient');

-- Insert Doctors (10)
INSERT INTO Doctors (name, specialization, phone, email)
VALUES
('Dr. Arvind Singh', 'Cardiologist', '9876500001', 'arvind.singh@hospital.com'),
('Dr. Meena Patel', 'Neurologist', '9876500002', 'meena.patel@hospital.com'),
('Dr. Karan Malhotra', 'Orthopedic', '9876500003', 'karan.malhotra@hospital.com'),
('Dr. Priya Desai', 'Dermatologist', '9876500004', 'priya.desai@hospital.com'),
('Dr. Ajay Rathi', 'Pediatrician', '9876500005', 'ajay.rathi@hospital.com'),
('Dr. Sneha Iyer', 'Gynecologist', '9876500006', 'sneha.iyer@hospital.com'),
('Dr. Rohit Tiwari', 'Oncologist', '9876500007', 'rohit.tiwari@hospital.com'),
('Dr. Kavita Joshi', 'ENT', '9876500008', 'kavita.joshi@hospital.com'),
('Dr. Nitin Arora', 'Psychiatrist', '9876500009', 'nitin.arora@hospital.com'),
('Dr. Vandana Nair', 'General Physician', '9876500010', 'vandana.nair@hospital.com');

-- Insert Patients (10)
INSERT INTO Patients (name, dob, gender, phone, address)
VALUES
('Amit Kumar', '1990-05-12', 'Male', '900000001', 'Raipur, CG'),
('Sneha Gupta', '1995-09-23', 'Female', '900000002', 'Bilaspur, CG'),
('Rajesh Verma', '1988-02-14', 'Male', '900000003', 'Durg, CG'),
('Pooja Sharma', '1993-07-11', 'Female', '900000004', 'Korba, CG'),
('Neeraj Yadav', '1998-01-19', 'Male', '900000005', 'Ambikapur, CG'),
('Divya Sahu', '1994-03-05', 'Female', '900000006', 'Dhamtari, CG'),
('Manish Tiwari', '1992-06-17', 'Male', '900000007', 'Jagdalpur, CG'),
('Ritika Jain', '1999-10-22', 'Female', '900000008', 'Kawardha, CG'),
('Harsh Vardhan', '1987-12-30', 'Male', '900000009', 'Raigarh, CG'),
('Komal Sen', '1996-04-09', 'Female', '900000010', 'Mahasamund, CG');

-- Insert Staff (10)
INSERT INTO Staff (name, position, phone, email)
VALUES
('Ravi Sharma', 'Receptionist', '911100001', 'ravi.sharma@hospital.com'),
('Seema Verma', 'Nurse', '911100002', 'seema.verma@hospital.com'),
('Anil Yadav', 'Pharmacist', '911100003', 'anil.yadav@hospital.com'),
('Sunita Rani', 'Lab Technician', '911100004', 'sunita.rani@hospital.com'),
('Mukesh Kumar', 'Cleaner', '911100005', 'mukesh.kumar@hospital.com'),
('Neha Gupta', 'Receptionist', '911100006', 'neha.gupta@hospital.com'),
('Rajiv Singh', 'Nurse', '911100007', 'rajiv.singh@hospital.com'),
('Poonam Devi', 'Ward Incharge', '911100008', 'poonam.devi@hospital.com'),
('Sanjay Joshi', 'Lab Technician', '911100009', 'sanjay.joshi@hospital.com'),
('Kiran Das', 'Security', '911100010', 'kiran.das@hospital.com');

-- Insert Appointments (10)
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status)
VALUES
(1, 1, '2025-09-22 10:00:00', 'Scheduled'),
(2, 2, '2025-09-22 11:00:00', 'Scheduled'),
(3, 3, '2025-09-23 09:30:00', 'Scheduled'),
(4, 4, '2025-09-23 10:30:00', 'Scheduled'),
(5, 5, '2025-09-24 14:00:00', 'Scheduled'),
(6, 6, '2025-09-24 15:00:00', 'Scheduled'),
(7, 7, '2025-09-25 16:00:00', 'Scheduled'),
(8, 8, '2025-09-25 17:00:00', 'Scheduled'),
(9, 9, '2025-09-26 09:00:00', 'Scheduled'),
(10, 10, '2025-09-26 10:00:00', 'Scheduled');

-- Insert Billing (10)
INSERT INTO Billing (patient_id, amount, status)
VALUES
(1, 5000, 'Paid'),
(2, 1200, 'Unpaid'),
(3, 2300, 'Paid'),
(4, 750, 'Paid'),
(5, 999, 'Unpaid'),
(6, 4500, 'Paid'),
(7, 3000, 'Paid'),
(8, 1500, 'Unpaid'),
(9, 2100, 'Paid'),
(10, 1800, 'Paid');
