
CREATE DATABASE hospital_db;
USE hospital_db;

CREATE TABLE rooms (
    room_id VARCHAR(10) PRIMARY KEY,
    room_type VARCHAR(30),
    floor INT,
    equipment_type VARCHAR(50),
    capacity INT,
    last_maintenance_date DATE,
    is_available VARCHAR(3)
);

CREATE TABLE patients (
    patient_id VARCHAR(20) PRIMARY KEY,
    patient_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    city VARCHAR(50),
    patient_type VARCHAR(20),
    preferred_time_slot VARCHAR(20),
    registration_date DATE
);

CREATE TABLE doctors (
    doctor_id VARCHAR(10) PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialty VARCHAR(50),
    hire_date DATE,
    rating DECIMAL(3, 2),
    employment_type VARCHAR(20),
    is_active VARCHAR(3)
);

-- Step 3: Create dependent tables with foreign keys

CREATE TABLE appointments (
    appointment_id VARCHAR(20) PRIMARY KEY,
    patient_id VARCHAR(20),
    appointment_date DATE,
    doctor_id VARCHAR(10),
    service_type VARCHAR(30),
    priority VARCHAR(10),
    estimated_cost DECIMAL(10, 2),
    booking_channel VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE treatments (
    treatment_id VARCHAR(20) PRIMARY KEY,
    appointment_id VARCHAR(20),
    doctor_id VARCHAR(10),
    room_id VARCHAR(10),
    actual_treatment_date DATE,
    status VARCHAR(20),
    treatment_attempt INT,
    treatment_duration_min INT,
    waiting_time_min INT,
    treatment_cost DECIMAL(10, 2),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- 1.4 Analytical Thinking from the ER Diagram

-- 1. Patients who have booked multiple appointments
-- patients.patient_id
-- patients.patient_name
-- appointments.appointment_id
-- appointments.patient_id
-- Explanation:
-- The patient_id connects a patient with their appointments. By counting appointment_id for each patient_id, management can find patients who booked more than one appointment.


-- 2. Appointments requiring more than one treatment attempt
-- treatment_id
-- appointment_id
-- treatment_attempt
-- Explanation:
-- The treatment_attempt column tells us how many attempts were required for a treatment. If treatment_attempt > 1, the appointment required multiple treatment attempts.

-- 3 Compare General, Corporate, and Insurance patients based on appointment activity
-- patient_id
-- patient_type
-- appointment_id
-- patient_id
-- Explanation:
-- patient_type identifies whether the patient is General, Corporate, or Insurance. The appointments table shows their appointment activity.


-- 4. Compare service types based on treatment duration and waiting time
-- appointment_id
-- service_type
-- appointment_id
-- treatment_duration_min
-- waiting_time_min
-- Explanation:
-- The service_type is stored in appointments, while treatment duration and waiting time are stored in treatments


-- 5.Identify doctors who handled treatments and examine their ratings
-- doctor_id
-- doctor_name
-- rating
-- doctor_id
-- treatment_id
-- Explanation:
-- The treatments table tells us which doctor handled the treatment.
 -- The doctors table contains the doctor's rating.
 
 -- 6. Understand whether room/equipment types are used for different service types
-- From appointments:
-- appointment_id
-- service_type
-- From treatments:
-- appointment_id
-- room_id
-- From rooms:
-- room_id
-- room_type
-- equipment_type

-- Explanation:
-- We need to connect the appointment to its treatment and then connect the treatment to the room.

-- 7. Compare treatment performance across cities
-- From patients:
-- patient_id
-- city
-- From appointments:
-- appointment_id
-- patient_id
-- From treatments:
-- appointment_id
-- Explanation:
-- The city is stored in the patients table, while treatment performance information is in treatments.
 
 -- 8. Investigate whether higher-priority appointments have longer waiting times or different outcomes
-- From appointments:
-- appointment_id
-- priority
-- From treatments:
-- appointment_id
-- waiting_time_min
-- Explanation:
-- The priority field tells us whether the appointment is Routine, Urgent, Emergency, etc.

-- 9. Understand whether treatment outcomes differ across service types
-- From appointments:
-- appointment_id
-- service_type
-- From treatments:
-- appointment_id
-- Explanation:
-- service_type tells us what service the patient booked, while status tells us the treatment outcome/status.

-- 10. Connect each patient to their appointments and treatment outcomes
-- patients
-- patient_id
-- patient_name
-- patient_type
-- city

-- appointments
-- appointment_id
-- patient_id
-- service_type
-- priority
      
-- treatments
-- treatment_id
-- appointment_id
-- Explanation:
-- This is a three-table relationship.

-- Sprint 3: Basic Analysis / Data Exploration

-- 1. What is the total number of patients?
select count(*) as total_patients
from patients;
-- 2. What is the total number of appointments?
select count(*) as total_appointments
from appointments;
-- 3. What is the total number of treatment records?
select count(*) as total_treatments
from treatments;
-- 4. What are the different medical service types?
select distinct service_type
from appointments;
-- 5. How many doctors are currently active?
SELECT COUNT(*) AS active_doctors
FROM doctors
WHERE is_active = 'Yes';
-- 6. What are the different room types?
SELECT room_type, COUNT(*) AS total_rooms
FROM rooms
GROUP BY room_type;
-- 7. What is the total estimated appointment value?
SELECT SUM(estimated_cost) AS total_estimated_value
FROM appointments;
-- 8. What is the average treatment duration?
SELECT AVG(treatment_duration_min) AS average_treatment_duration
FROM treatments;
-- Sprint 4: Objective-Based Analysis
-- 4.1 Understand Patient and Appointment Demand

-- Compare appointment volume across cities
SELECT 
    p.city,
    COUNT(a.appointment_id) AS appointment_volume
FROM patients p
LEFT JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.city
ORDER BY appointment_volume DESC;

-- ● Compare appointments across service types and priorities.
SELECT 
    service_type,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY service_type
ORDER BY total_appointments DESC;

-- ● Examine appointment volume over time.
SELECT appointment_date, COUNT(*) AS appointment_count
FROM appointments
GROUP BY appointment_date
ORDER BY appointment_date DESC ;

-- Compare Estimated Appointment Value Across Patient Types
SELECT 
    p.patient_type,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(a.estimated_cost) AS total_estimated_value,
    AVG(a.estimated_cost) AS average_estimated_value
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_type
ORDER BY total_estimated_value DESC;

-- Examine Booking Channels and Their Contribution to Demand
SELECT booking_channel,
       COUNT(*) AS total_appointments
FROM appointments
GROUP BY booking_channel
ORDER BY total_appointments DESC;

-- 4.2 
-- Compare patients by number of appointments
SELECT 
    p.patient_id,
    p.patient_name,
    COUNT(a.appointment_id) AS total_appointments
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name
ORDER BY total_appointments DESC;

-- Identify patients with higher cumulative estimated appointment value
SELECT 
    p.patient_id,
    p.patient_name,
    SUM(a.estimated_cost) AS total_estimated_value
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name
ORDER BY total_estimated_value DESC;

-- Compare patient activity across cities
SELECT 
    p.city,
    COUNT(DISTINCT p.patient_id) AS total_patients,
    COUNT(a.appointment_id) AS total_appointments
FROM patients p
LEFT JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.city
ORDER BY total_appointments DESC;
-- Compare General, Corporate, and Insurance patients
SELECT 
    p.patient_type,
    COUNT(DISTINCT p.patient_id) AS total_patients,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(a.estimated_cost) AS total_estimated_cost
FROM patients p
LEFT JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_type
ORDER BY total_estimated_cost DESC;
-- Examine patient booking patterns over time
SELECT 
    DATE_FORMAT(appointment_date, '%Y-%m') AS appointment_month,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
ORDER BY appointment_month;

-- 4.3
-- Compare Treatment Outcomes Across Cities
SELECT p.city,
       t.status,
       COUNT(*) AS treatment_count
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
JOIN treatments t
    ON a.appointment_id = t.appointment_id
GROUP BY p.city, t.status
ORDER BY p.city, treatment_count DESC;
-- Examine Treatment Duration and Waiting Time
SELECT 
    AVG(treatment_duration_min) AS avg_treatment_duration,
    AVG(waiting_time_min) AS avg_waiting_time,
    MIN(treatment_duration_min) AS min_treatment_duration,
    MAX(treatment_duration_min) AS max_treatment_duration
FROM treatments;
-- Compare Completed, Cancelled, No-Show, Rescheduled and In Progress Outcomes
SELECT status,
       COUNT(*) AS treatment_count
FROM treatments
GROUP BY status
ORDER BY treatment_count DESC;
-- Identify Areas with Higher Treatment Activity
SELECT p.city,
       COUNT(t.treatment_id) AS total_treatments
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
JOIN treatments t
    ON a.appointment_id = t.appointment_id
GROUP BY p.city
ORDER BY total_treatments DESC;
-- Identify Cities with Poorer Treatment Outcomes
SELECT p.city,
       COUNT(*) AS poor_outcome_count
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
JOIN treatments t
    ON a.appointment_id = t.appointment_id
WHERE t.status IN ('Cancelled', 'No-Show')
GROUP BY p.city
ORDER BY poor_outcome_count DESC;
-- Treatment Outcomes Over Time
SELECT 
    DATE_FORMAT(actual_treatment_date, '%Y-%m') AS treatment_month,
    status,
    COUNT(treatment_id) AS treatment_count
FROM treatments
GROUP BY DATE_FORMAT(actual_treatment_date, '%Y-%m'), status
ORDER BY treatment_month, status;

-- 4.4  
-- Compare the number of treatments handled by doctors
SELECT d.doctor_id,
       d.doctor_name,
       COUNT(t.treatment_id) AS total_treatments
FROM doctors d
JOIN treatments t
ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY total_treatments DESC;
-- Compare doctor performance across treatment outcomes
SELECT d.doctor_name,
       t.status,
       COUNT(t.treatment_id) AS treatment_count
FROM doctors d
JOIN treatments t
ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_name, t.status
ORDER BY d.doctor_name, treatment_count DESC;
-- Examine treatment duration across doctors
-- Examine treatment duration across doctors
SELECT d.doctor_name,
       COUNT(t.treatment_id) AS total_treatments,
       ROUND(AVG(t.treatment_duration_min), 2) AS avg_treatment_duration,
       MIN(t.treatment_duration_min) AS min_duration,
       MAX(t.treatment_duration_min) AS max_duration
FROM doctors d
JOIN treatments t
ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY avg_treatment_duration DESC;
-- Compare room usage across room types and equipment types
SELECT r.room_type,
       r.equipment_type,
       COUNT(t.treatment_id) AS total_treatments
FROM rooms r
JOIN treatments t
ON r.room_id = t.room_id
GROUP BY r.room_type, r.equipment_type
ORDER BY total_treatments DESC;
-- Evaluate treatment performance across rooms
SELECT r.room_id,
       r.room_type,
       r.equipment_type,
       COUNT(t.treatment_id) AS total_treatments,
       ROUND(AVG(t.treatment_duration_min), 2) AS avg_duration,
       ROUND(AVG(t.waiting_time_min), 2) AS avg_waiting_time,
       ROUND(AVG(t.treatment_cost), 2) AS avg_treatment_cost
FROM rooms r
JOIN treatments t
ON r.room_id = t.room_id
GROUP BY r.room_id, r.room_type, r.equipment_type
ORDER BY total_treatments DESC;

-- 4.5
-- Identify appointments requiring multiple treatment attempts
SELECT appointment_id,
       MAX(treatment_attempt) AS total_attempts
FROM treatments
GROUP BY appointment_id
HAVING MAX(treatment_attempt) > 1
ORDER BY total_attempts DESC;
-- Find common treatment problem statuses and patterns
SELECT status,
       COUNT(*) AS total_treatments
FROM treatments
GROUP BY status
ORDER BY total_treatments DESC;
-- Compare waiting time for appointments with multiple attempts
SELECT 
    CASE
        WHEN t.treatment_attempt > 1 THEN 'Multiple Attempts'
        ELSE 'Single Attempt'
    END AS attempt_type,
    COUNT(*) AS total_treatments,
    AVG(t.waiting_time_min) AS average_waiting_time
FROM treatments t
GROUP BY
    CASE
        WHEN t.treatment_attempt > 1 THEN 'Multiple Attempts'
        ELSE 'Single Attempt'
    END;
    -- Identify cities with more cancellations, no-shows, or rescheduling
    SELECT 
    p.city,
    t.status,
    COUNT(*) AS total_cases
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
JOIN treatments t
    ON a.appointment_id = t.appointment_id
WHERE LOWER(t.status) IN ('cancelled', 'no-show', 'rescheduled')
GROUP BY p.city, t.status
ORDER BY total_cases DESC;
-- Identify service types with more cancellations, no-shows, or rescheduling
SELECT 
    a.service_type,
    t.status,
    COUNT(*) AS total_cases
FROM appointments a
JOIN treatments t
    ON a.appointment_id = t.appointment_id
WHERE LOWER(t.status) IN ('cancelled', 'no-show', 'rescheduled')
GROUP BY a.service_type, t.status
ORDER BY total_cases DESC;


