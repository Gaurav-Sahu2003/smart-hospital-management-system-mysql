-- 0. create database and use it
CREATE DATABASE IF NOT EXISTS shms;
USE shms;

-- Optional: set sql_mode for stricter behavior
SET sql_mode = 'STRICT_ALL_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';


-- 1. Users (roles: Admin, Doctor, Nurse, Receptionist, Patient)
CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL, -- store hashed password
  role ENUM('Admin','Doctor','Nurse','Receptionist','Patient') NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Patients
CREATE TABLE Patients (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNIQUE, -- optional link to Users (if patient has login)
  name VARCHAR(150) NOT NULL,
  dob DATE,
  gender ENUM('Male','Female','Other'),
  contact VARCHAR(30),
  address TEXT,
  blood_group VARCHAR(5),
  emergency_contact VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- 3. Doctors
CREATE TABLE Doctors (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNIQUE, -- link to Users (optional)
  name VARCHAR(150) NOT NULL,
  specialization VARCHAR(150),
  contact VARCHAR(30),
  available_hours VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- 4. Staff
CREATE TABLE Staff (
  staff_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  role VARCHAR(100),
  shift VARCHAR(50),
  contact VARCHAR(30),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 5. Appointments
CREATE TABLE Appointments (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  appointment_datetime DATETIME NOT NULL,
  duration_minutes INT DEFAULT 30,
  status ENUM('Pending','Confirmed','Completed','Cancelled') DEFAULT 'Pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE
);

-- 6. Billing
CREATE TABLE Billing (
  bill_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  appointment_id INT,
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  discount DECIMAL(12,2) DEFAULT 0.00,
  payment_status ENUM('Pending','Paid','Failed') DEFAULT 'Pending',
  payment_mode ENUM('Cash','Card','UPI','Insurance','Other') DEFAULT 'Cash',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
  FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- 7. Insurance
CREATE TABLE Insurance (
  insurance_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  provider VARCHAR(150),
  policy_number VARCHAR(100),
  coverage_amount DECIMAL(12,2) DEFAULT 0.00,
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 8. Medicines / Inventory
CREATE TABLE Medicines (
  medicine_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  brand VARCHAR(150),
  expiry_date DATE,
  stock INT DEFAULT 0,
  price DECIMAL(10,2) DEFAULT 0.00,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 9. Pharmacy_Sales
CREATE TABLE Pharmacy_Sales (
  sale_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  medicine_id INT NOT NULL,
  quantity INT NOT NULL,
  sale_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  total_price DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
  FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);

-- 10. Restock Alerts
CREATE TABLE Restock_Alerts (
  alert_id INT AUTO_INCREMENT PRIMARY KEY,
  medicine_id INT NOT NULL,
  current_stock INT NOT NULL,
  threshold INT NOT NULL,
  alert_generated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  resolved BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);

-- 11. Lab Tests & Patient Tests
CREATE TABLE Lab_Tests (
  test_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  cost DECIMAL(10,2) DEFAULT 0.00,
  normal_range VARCHAR(100)
);

CREATE TABLE Patient_Tests (
  test_record_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  test_id INT NOT NULL,
  result TEXT,
  test_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  doctor_id INT,
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
  FOREIGN KEY (test_id) REFERENCES Lab_Tests(test_id),
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 12. Wards & Admissions
CREATE TABLE Wards (
  ward_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150),
  type ENUM('ICU','General','Private','Semi-Private') DEFAULT 'General',
  capacity INT DEFAULT 0,
  available_beds INT DEFAULT 0
);

CREATE TABLE Admissions (
  admission_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  ward_id INT,
  admission_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  discharge_date DATETIME,
  status ENUM('Admitted','Discharged') DEFAULT 'Admitted',
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
  FOREIGN KEY (ward_id) REFERENCES Wards(ward_id)
);

-- 13. Medical History
CREATE TABLE Medical_History (
  history_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  disease VARCHAR(255),
  diagnosis_date DATE,
  treatment TEXT,
  doctor_id INT,
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
