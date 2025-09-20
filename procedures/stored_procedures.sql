DELIMITER $$

-- 1. Book Appointment
CREATE PROCEDURE sp_book_appointment (
  IN p_patient_id INT, IN p_doctor_id INT, IN p_datetime DATETIME, IN p_duration INT
)
BEGIN
  INSERT INTO Appointments (patient_id, doctor_id, appointment_datetime, duration_minutes, status)
  VALUES (p_patient_id, p_doctor_id, p_datetime, p_duration, 'Confirmed');
END$$

-- 2. Cancel Appointment
CREATE PROCEDURE sp_cancel_appointment (IN p_appointment_id INT)
BEGIN
  UPDATE Appointments SET status='Cancelled' WHERE appointment_id=p_appointment_id;
END$$

-- 3. Complete Appointment
CREATE PROCEDURE sp_complete_appointment (IN p_appointment_id INT)
BEGIN
  UPDATE Appointments SET status='Completed' WHERE appointment_id=p_appointment_id;
END$$

-- 4. Create Bill
CREATE PROCEDURE sp_create_bill (
  IN p_patient_id INT, IN p_appointment_id INT, IN p_amount DECIMAL(12,2), IN p_discount DECIMAL(12,2)
)
BEGIN
  INSERT INTO Billing (patient_id, appointment_id, total_amount, discount, payment_status)
  VALUES (p_patient_id, p_appointment_id, p_amount, p_discount, 'Pending');
END$$

-- 5. Pay Bill
CREATE PROCEDURE sp_pay_bill (IN p_bill_id INT, IN p_mode VARCHAR(20))
BEGIN
  UPDATE Billing SET payment_status='Paid', payment_mode=p_mode WHERE bill_id=p_bill_id;
END$$

-- 6. Add New Medicine
CREATE PROCEDURE sp_add_medicine (
  IN p_name VARCHAR(150), IN p_brand VARCHAR(150), IN p_expiry DATE, IN p_stock INT, IN p_price DECIMAL(10,2)
)
BEGIN
  INSERT INTO Medicines (name, brand, expiry_date, stock, price)
  VALUES (p_name, p_brand, p_expiry, p_stock, p_price);
END$$

-- 7. Record Pharmacy Sale
CREATE PROCEDURE sp_record_sale (IN p_patient_id INT, IN p_medicine_id INT, IN p_qty INT)
BEGIN
  DECLARE med_price DECIMAL(10,2);
  SELECT price INTO med_price FROM Medicines WHERE medicine_id=p_medicine_id;
  INSERT INTO Pharmacy_Sales (patient_id, medicine_id, quantity, total_price)
  VALUES (p_patient_id, p_medicine_id, p_qty, med_price*p_qty);
  UPDATE Medicines SET stock=stock - p_qty WHERE medicine_id=p_medicine_id;
END$$

-- 8. Admit Patient
CREATE PROCEDURE sp_admit_patient (IN p_patient_id INT, IN p_ward_id INT)
BEGIN
  INSERT INTO Admissions (patient_id, ward_id, status) VALUES (p_patient_id, p_ward_id, 'Admitted');
  UPDATE Wards SET available_beds=available_beds-1 WHERE ward_id=p_ward_id;
END$$

-- 9. Discharge Patient
CREATE PROCEDURE sp_discharge_patient (IN p_admission_id INT)
BEGIN
  DECLARE wardId INT;
  SELECT ward_id INTO wardId FROM Admissions WHERE admission_id=p_admission_id;
  UPDATE Admissions SET status='Discharged', discharge_date=NOW() WHERE admission_id=p_admission_id;
  UPDATE Wards SET available_beds=available_beds+1 WHERE ward_id=wardId;
END$$

-- 10. Add Medical History
CREATE PROCEDURE sp_add_medical_history (
  IN p_patient_id INT, IN p_disease VARCHAR(255), IN p_date DATE, IN p_treatment TEXT, IN p_doctor_id INT
)
BEGIN
  INSERT INTO Medical_History (patient_id, disease, diagnosis_date, treatment, doctor_id)
  VALUES (p_patient_id, p_disease, p_date, p_treatment, p_doctor_id);
END$$

DELIMITER ;
