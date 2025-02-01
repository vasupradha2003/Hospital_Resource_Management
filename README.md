# Hospital Management System - MySQL

## Overview
This project represents a simple Hospital Management System using MySQL that enables the management of doctors, patients, appointments, billing, beds, and medical inventory. It utilizes various SQL techniques such as JOINs, Views, Common Table Expressions (CTEs), Triggers, Stored Procedures, and CASE Statements to streamline data management processes.

## Features

### 1. Doctor Management
- **Doctors Table**: Stores information about doctors, including their name, specialization, contact details, and email.
- **Appointments**: Links doctors to patient appointments, including appointment date and status (Scheduled, Completed, Cancelled).

### 2. Patient Management
- **Patients Table**: Stores patient information, such as name, age, gender, address, and contact details.
- **Appointments**: Manages patient appointments and their statuses.
- **Billing**: Tracks patient billing, payment status, and amounts due.

### 3. Bed Management
- **Beds Table**: Keeps track of available and occupied beds in different wards, updating the status as patients are admitted or discharged.

### 4. Medical Inventory Management
- **Medical Inventory Table**: Tracks medicines, their stock levels, and expiration dates.

### 5. Stored Procedures & Triggers
- **Stored Procedure**: Adds new appointments while checking for doctor availability on the given date.
- **Trigger**: Automatically updates bed status to 'Available' when a patient's appointment is marked as 'Completed'.

### 6. Advanced SQL Queries
- **Doctor Appointment Summary**: View doctors along with their appointment count.
- **Available Beds**: Lists all available beds.
- **Patients With Pending Bills**: Displays patients who haven’t paid their bills yet.
- **Expiring Medicines**: Identifies medicines that are about to expire soon.
- **Patients Who Have Visited More Than Once**: Lists patients who have visited the hospital multiple times.
- **Patients Who Spent Over ₹5000**: Uses CTEs to list patients who have spent over ₹5000 on medical bills.
- **Categorizing Patients by Billing Amount**: Uses a CASE statement to categorize patients based on the amount of their medical bills.

## SQL Structures

- **Tables**: 
  - Doctors
  - Patients
  - Appointments
  - Beds
  - Medical_Inventory
  - Billing

- **Views**: 
  - Low Stock Medicine
  - Doctor Appointment Summary

- **CTEs**: 
  - Patient Billing
  - Doctor Appointments

- **Stored Procedure**: 
  - Add Appointment

- **Trigger**: 
  - Update Bed Status on Appointment Completion

## Installation

### 1. Set up MySQL:
Install MySQL and set up a new database named `HospitalDB`.

### 2. Create the Database and Tables:
Run the provided SQL script to create the tables and insert sample data.
### 3. SQL queries
 You can execute the SQL queries provided in the script To get various reports, manage data, and interact with the system.
