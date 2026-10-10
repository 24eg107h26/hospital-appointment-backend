CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

CREATE TABLE IF NOT EXISTS users (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      password VARCHAR(255) NOT NULL,
      phone VARCHAR(15),
      role ENUM('ADMIN', 'DOCTOR', 'PATIENT') NOT NULL
);

CREATE TABLE IF NOT EXISTS doctors (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      user_id BIGINT NOT NULL UNIQUE,
      specialization VARCHAR(100) NOT NULL,
      qualification VARCHAR(100),
      experience_years INT,
      consultation_fee DECIMAL(10, 2),
      room_number VARCHAR(20),
      active BOOLEAN DEFAULT TRUE,
      CONSTRAINT fk_doctors_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS patients (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      user_id BIGINT NOT NULL UNIQUE,
      age INT,
      gender VARCHAR(10),
      address VARCHAR(255),
      CONSTRAINT fk_patients_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS schedules (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      doctor_id BIGINT NOT NULL,
      day_of_week ENUM('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY') NOT NULL,
      start_time TIME NOT NULL,
      end_time TIME NOT NULL,
      max_tokens_per_day INT NOT NULL,
      CONSTRAINT fk_schedules_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
      CONSTRAINT uq_doctor_day UNIQUE (doctor_id, day_of_week)
);

CREATE TABLE IF NOT EXISTS appointments (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      patient_id BIGINT NOT NULL,
      doctor_id BIGINT NOT NULL,
      appointment_date DATE NOT NULL,
      token_number INT NOT NULL,
      status ENUM('BOOKED', 'WAITING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'BOOKED',
      reason VARCHAR(255),
      created_at DATETIME NOT NULL,
      CONSTRAINT fk_appointments_patient FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
      CONSTRAINT fk_appointments_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
      CONSTRAINT uq_doctor_date_token UNIQUE (doctor_id, appointment_date, token_number)
);
