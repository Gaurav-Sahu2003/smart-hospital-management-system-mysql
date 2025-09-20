-- 1. Appointment lookup by doctor + datetime
CREATE INDEX idx_doctor_datetime ON Appointments(doctor_id, appointment_datetime);

-- 2. Appointment lookup by patient
CREATE INDEX idx_patient_appointments ON Appointments(patient_id);

-- 3. Medicines by expiry date
CREATE INDEX idx_medicine_expiry ON Medicines(expiry_date);

-- 4. Pharmacy sales by medicine
CREATE INDEX idx_pharmacy_sales_medicine ON Pharmacy_Sales(medicine_id);

-- 5. Billing by patient
CREATE INDEX idx_billing_patient ON Billing(patient_id);

-- 6. Insurance lookup by policy number
CREATE INDEX idx_insurance_policy ON Insurance(policy_number);

-- 7. Lab tests by patient
CREATE INDEX idx_patient_tests ON Patient_Tests(patient_id);

-- 8. Wards by type
CREATE INDEX idx_wards_type ON Wards(type);

-- 9. Medical history by patient + disease
CREATE INDEX idx_medical_history_disease ON Medical_History(patient_id, disease);

-- 10. Admissions by status (fast active patients lookup)
CREATE INDEX idx_admissions_status ON Admissions(status);
