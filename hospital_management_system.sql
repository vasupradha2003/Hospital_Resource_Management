CREATE DATABASE HospitalDB;
USE HospitalDB;

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100),
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE
);
INSERT INTO Doctors (Name, Specialization, Phone, Email) VALUES
('Dr. Rajesh Kumar', 'Cardiologist', '9876543210', 'rajesh@hospital.com'),
('Dr. Neha Sharma', 'Neurologist', '9876543211', 'neha@hospital.com'),
('Dr. Arvind Patel', 'Orthopedic', '9876543212', 'arvind@hospital.com'),
('Dr. Priya Desai', 'Dermatologist', '9876543213', 'priya@hospital.com'),
('Dr. Sanjay Mehta', 'Pediatrician', '9876543214', 'sanjay@hospital.com'),
('Dr. Sunita Rao', 'Gynecologist', '9876543215', 'sunita@hospital.com');

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Age INT,
    Gender ENUM('Male', 'Female', 'Other'),
    Address VARCHAR(255),
    Phone VARCHAR(15) UNIQUE
);
INSERT INTO Patients (Name, Age, Gender, Address, Phone) VALUES
('Amit Verma', 45, 'Male', 'Delhi', '9876500011'),
('Sneha Kapoor', 30, 'Female', 'Mumbai', '9876500012'),
('Vikram Singh', 55, 'Male', 'Chennai', '9876500013'),
('Ritu Sharma', 25, 'Female', 'Bangalore', '9876500014'),
('Anjali Menon', 60, 'Female', 'Kolkata', '9876500015'),
('Ramesh Tiwari', 35, 'Male', 'Pune', '9876500016'),
('Pooja Iyer', 42, 'Female', 'Hyderabad', '9876500017'),
('Gautam Joshi', 50, 'Male', 'Jaipur', '9876500018');

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Status ENUM('Scheduled', 'Completed', 'Cancelled'),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ON DELETE CASCADE
);

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status) VALUES
(1, 1, '2025-02-15', 'Scheduled'),
(2, 2, '2025-02-16', 'Completed'),
(3, 3, '2025-02-17', 'Scheduled'),
(4, 4, '2025-02-18', 'Scheduled'),
(5, 5, '2025-02-19', 'Cancelled'),
(6, 6, '2025-02-20', 'Completed'),
(7, 1, '2025-02-21', 'Scheduled'),
(8, 3, '2025-02-22', 'Scheduled');


CREATE TABLE Beds (
    BedID INT PRIMARY KEY AUTO_INCREMENT,
    Ward VARCHAR(50),
    Status ENUM('Available', 'Occupied') DEFAULT 'Available',
    PatientID INT UNIQUE NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE SET NULL
);

INSERT INTO Beds (Ward, Status, PatientID) VALUES
('General', 'Occupied', 1),
('ICU', 'Available', NULL),
('General', 'Occupied', 2),
('ICU', 'Occupied', 3),
('Pediatric', 'Available', NULL),
('Maternity', 'Occupied', 5),
('Surgical', 'Occupied', 6),
('General', 'Available', NULL);

CREATE TABLE Medical_Inventory (
    MedicineID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Stock INT DEFAULT 0,
    ExpiryDate DATE
);
INSERT INTO Medical_Inventory (Name, Stock, ExpiryDate) VALUES
('Paracetamol', 200, '2025-12-31'),
('Antibiotics', 150, '2025-08-15'),
('Painkillers', 100, '2025-09-10'),
('Cough Syrup', 80, '2025-07-05'),
('Insulin', 50, '2025-11-20'),
('Vitamin Tablets', 300, '2026-01-30'),
('Blood Pressure Medication', 120, '2025-10-15'),
('Cholesterol Control', 90, '2025-09-25');

CREATE TABLE Billing (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    Amount DECIMAL(10,2),
    PaymentStatus ENUM('Pending', 'Paid'),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE
);
INSERT INTO Billing (PatientID, Amount, PaymentStatus) VALUES
(1, 5000, 'Pending'),
(2, 3000, 'Paid'),
(3, 7000, 'Pending'),
(4, 4500, 'Paid'),
(5, 6000, 'Pending'),
(6, 2500, 'Paid'),
(7, 10000, 'Pending'),
(8, 3200, 'Paid');

# 1. **🔹 Find Doctors and Their Appointments**
SELECT d.Name AS Doctor, d.Specialization, COUNT(a.AppointmentID) AS Total_Appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID;

# 2.  **🔹 Find Available Beds**
SELECT BedID, Ward FROM Beds WHERE Status = 'Available';

#3. **🔹 List Patients Who Haven’t Paid Their Bills**
SELECT p.Name, p.Phone, b.Amount
FROM Patients p
JOIN Billing b ON p.PatientID = b.PatientID
WHERE b.PaymentStatus = 'Pending';

#4. **🔹 Check Medicines Expiring Soon**
SELECT Name, Stock, ExpiryDate
FROM Medical_Inventory
WHERE ExpiryDate < CURDATE() + INTERVAL 30 DAY;

#5. ** List Patients Who Have Visited More Than Once **
SELECT p.Name, COUNT(a.AppointmentID) AS Visit_Count
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID
HAVING COUNT(a.AppointmentID) > 1;

# 6. ** View: Doctor Appointment Summary **
#A view to simplify retrieving doctors and their appointment counts.
CREATE VIEW Doctor_Appointment_Summary AS
SELECT d.DoctorID, d.Name AS Doctor, d.Specialization, COUNT(a.AppointmentID) AS Total_Appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID;
select * from Doctor_Appointment_Summary;

#7.  CTE: Patients Who Have Spent More Than ₹5000
#Using Common Table Expressions (CTEs) to list patients who have total bills exceeding ₹5000.
WITH Patient_Billing AS (
    SELECT p.PatientID, p.Name, SUM(b.Amount) AS Total_Spent
    FROM Patients p
    JOIN Billing b ON p.PatientID = b.PatientID
    GROUP BY p.PatientID
)
SELECT * FROM Patient_Billing WHERE Total_Spent > 5000;

#8. CASE Statement: Categorize Patients Based on Billing Amount
#Classifying patients into categories (Low, Medium, High) based on their bill amount.
SELECT p.Name, b.Amount,
    CASE 
        WHEN b.Amount < 2000 THEN 'Low'
        WHEN b.Amount BETWEEN 2000 AND 5000 THEN 'Medium'
        ELSE 'High'
    END AS Billing_Category
FROM Patients p
JOIN Billing b ON p.PatientID = b.PatientID;

# 9. Stored Procedure: Add a New Appointment
#A stored procedure to insert an appointment while automatically checking doctor availability.
DELIMITER $$

CREATE PROCEDURE AddAppointment (
    IN patient_id INT,
    IN doctor_id INT,
    IN app_date DATE
)
BEGIN
    DECLARE doctor_busy INT;

    -- Check if the doctor is available on the given date
    SELECT COUNT(*) INTO doctor_busy 
    FROM Appointments 
    WHERE DoctorID = doctor_id AND AppointmentDate = app_date;
    
    IF doctor_busy = 0 THEN
        INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status)
        VALUES (patient_id, doctor_id, app_date, 'Scheduled');
        SELECT 'Appointment Scheduled Successfully' AS Message;
    ELSE
        SELECT 'Doctor Not Available on this Date' AS Message;
    END IF;
END $$
DELIMITER ;
CALL AddAppointment(1, 2, '2025-02-18');


# 10. Trigger: Update Bed Status When a Patient is Discharged
# A trigger that updates bed status to 'Available' when a patient's appointment is completed.
DELIMITER $$
CREATE TRIGGER UpdateBedStatus
AFTER UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Completed' THEN
        UPDATE Beds
        SET Status = 'Available', PatientID = NULL
        WHERE PatientID = NEW.PatientID;
    END IF;
END $$

DELIMITER ;
SELECT * FROM Beds WHERE Status = 'Available';

# 11. View: List of Medicines Below a Stock Threshold
# A view to monitor medicines running low.
CREATE VIEW Low_Stock_Medicine AS
SELECT Name, Stock
FROM Medical_Inventory
WHERE Stock < 150;

#Use the View
SELECT * FROM Low_Stock_Medicine;

#12. CTE: Find Doctors Who Have No Appointments
# Using CTE to find doctors with no patients assigned.
WITH Doctor_Appointments AS (
    SELECT d.DoctorID, d.Name, COUNT(a.AppointmentID) AS Total_Appointments
    FROM Doctors d
    LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
    GROUP BY d.DoctorID
)
SELECT * FROM Doctor_Appointments WHERE Total_Appointments = 1;

#13. CASE Statement: Identify Patients Who Are Due for Follow-Up
#Using CASE to identify if a patient needs a follow-up appointment.

SELECT p.Name, p.PatientID, a.AppointmentDate,
    CASE 
        WHEN a.Status = 'Completed' AND a.AppointmentDate < CURDATE() - INTERVAL 30 DAY 
        THEN 'Follow-Up Required'
        ELSE 'No Follow-Up Needed'
    END AS Follow_Up_Status
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID;
