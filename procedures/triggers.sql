DELIMITER $$

-- 1. Prevent overlapping appointments for a doctor
CREATE TRIGGER trg_prevent_double_booking
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
  DECLARE cnt INT;
  SELECT COUNT(*) INTO cnt
  FROM Appointments
  WHERE doctor_id=NEW.doctor_id
    AND status IN ('Pending','Confirmed')
    AND ABS(TIMESTAMPDIFF(MINUTE, appointment_datetime, NEW.appointment_datetime)) < NEW.duration_minutes;
  IF cnt > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Doctor already has an appointment at this time';
  END IF;
END$$

-- 2. Auto-cancel appointment if patient is admitted
CREATE TRIGGER trg_cancel_if_admitted
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
  DECLARE adm_count INT;
  SELECT COUNT(*) INTO adm_count FROM Admissions WHERE patient_id=NEW.patient_id AND status='Admitted';
  IF adm_count > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot book appointment for admitted patient';
  END IF;
END$$

-- 3. Reduce medicine stock on pharmacy sale
CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON Pharmacy_Sales
FOR EACH ROW
BEGIN
  UPDATE Medicines
  SET stock = stock - NEW.quantity
  WHERE medicine_id = NEW.medicine_id;
END$$

-- 4. Alert if medicine stock goes below threshold (10 units)
CREATE TRIGGER trg_low_stock_alert
AFTER UPDATE ON Medicines
FOR EACH ROW
BEGIN
  IF NEW.stock < 10 THEN
    INSERT INTO Restock_Alerts (medicine_id, current_stock, threshold)
    VALUES (NEW.medicine_id, NEW.stock, 10);
  END IF;
END$$

-- 5. Auto-update appointment status to 'Completed' after billing
CREATE TRIGGER trg_complete_after_bill
AFTER INSERT ON Billing
FOR EACH ROW
BEGIN
  UPDATE Appointments
  SET status='Completed'
  WHERE appointment_id=NEW.appointment_id;
END$$

-- 6. Update available_beds when admitting a patient
CREATE TRIGGER trg_update_beds_on_admit
AFTER INSERT ON Admissions
FOR EACH ROW
BEGIN
  UPDATE Wards
  SET available_beds = available_beds - 1
  WHERE ward_id = NEW.ward_id;
END$$

-- 7. Update available_beds when discharging a patient
CREATE TRIGGER trg_update_beds_on_discharge
AFTER UPDATE ON Admissions
FOR EACH ROW
BEGIN
  IF OLD.status='Admitted' AND NEW.status='Discharged' THEN
    UPDATE Wards
    SET available_beds = available_beds + 1
    WHERE ward_id = NEW.ward_id;
  END IF;
END$$

-- 8. Auto-assign default role as 'Patient' if user inserted without role
CREATE TRIGGER trg_default_role
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
  IF NEW.role IS NULL THEN
    SET NEW.role = 'Patient';
  END IF;
END$$

-- 9. Prevent negative billing amount
CREATE TRIGGER trg_no_negative_bill
BEFORE INSERT ON Billing
FOR EACH ROW
BEGIN
  IF NEW.total_amount < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Billing amount cannot be negative';
  END IF;
END$$

-- 10. Audit log for patient history changes
CREATE TABLE IF NOT EXISTS Medical_History_Audit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  history_id INT,
  patient_id INT,
  action VARCHAR(50),
  changed_on DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER trg_history_audit
AFTER UPDATE ON Medical_History
FOR EACH ROW
BEGIN
  INSERT INTO Medical_History_Audit (history_id, patient_id, action)
  VALUES (OLD.history_id, OLD.patient_id, 'Updated');
END$$

DELIMITER ;
