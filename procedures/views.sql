-- 1. Daily revenue report
CREATE VIEW vw_daily_revenue AS
SELECT DATE(created_at) AS date, SUM(total_amount - discount) AS total_revenue
FROM Billing WHERE payment_status='Paid'
GROUP BY DATE(created_at);

-- 2. Top prescribed medicines
CREATE VIEW vw_top_medicines AS
SELECT m.name, SUM(ps.quantity) AS total_sold
FROM Pharmacy_Sales ps JOIN Medicines m ON ps.medicine_id=m.medicine_id
GROUP BY m.medicine_id ORDER BY total_sold DESC;

-- 3. Doctor workload (appointments per doctor per day)
CREATE VIEW vw_doctor_workload AS
SELECT doctor_id, DATE(appointment_datetime) AS date, COUNT(*) AS appointments
FROM Appointments GROUP BY doctor_id, DATE(appointment_datetime);

-- 4. Active patients in hospital
CREATE VIEW vw_active_patients AS
SELECT a.admission_id, p.name, w.name AS ward_name, a.admission_date
FROM Admissions a
JOIN Patients p ON a.patient_id=p.patient_id
JOIN Wards w ON a.ward_id=w.ward_id
WHERE a.status='Admitted';

-- 5. Expiring medicines soon
CREATE VIEW vw_expiring_medicines AS
SELECT name, expiry_date, stock
FROM Medicines
WHERE expiry_date < (CURDATE() + INTERVAL 30 DAY);

-- 6. Unpaid bills
CREATE VIEW vw_unpaid_bills AS
SELECT b.bill_id, p.name, b.total_amount, b.discount, b.created_at
FROM Billing b JOIN Patients p ON b.patient_id=p.patient_id
WHERE b.payment_status='Pending';

-- 7. Patient medical history overview
CREATE VIEW vw_patient_history AS
SELECT p.name, mh.disease, mh.diagnosis_date, mh.treatment, d.name AS doctor
FROM Medical_History mh
JOIN Patients p ON mh.patient_id=p.patient_id
JOIN Doctors d ON mh.doctor_id=d.doctor_id;

-- 8. Doctor specializations count
CREATE VIEW vw_doctor_specializations AS
SELECT specialization, COUNT(*) AS doctors_count
FROM Doctors GROUP BY specialization;

-- 9. Lab test statistics
CREATE VIEW vw_lab_test_stats AS
SELECT lt.name AS test_name, COUNT(pt.test_record_id) AS times_taken
FROM Lab_Tests lt
LEFT JOIN Patient_Tests pt ON lt.test_id=pt.test_id
GROUP BY lt.test_id;

-- 10. Ward occupancy percentage
CREATE VIEW vw_ward_occupancy AS
SELECT w.name, w.capacity, w.available_beds,
ROUND(((w.capacity - w.available_beds)/w.capacity)*100,2) AS occupancy_percent
FROM Wards w;
