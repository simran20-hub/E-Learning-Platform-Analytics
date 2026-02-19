drop database if exists ELearning_platform;
create database ELearning_platform;
use ELearning_platform;

CREATE TABLE student_table (
    student_id VARCHAR(10) PRIMARY KEY,
    student_name VARCHAR(75) NOT NULL,
    age INT NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    contact VARCHAR(15) NOT NULL UNIQUE,
    email_id VARCHAR(50) NOT NULL UNIQUE,
    state VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE NOT NULL,
    active_status ENUM('Active', 'Inactive', 'Suspended') NOT NULL,
    CONSTRAINT chk_student_age CHECK (age > 0 AND age < 120)
) ENGINE=InnoDB;

CREATE INDEX idx_student_status ON student_table(active_status);
CREATE INDEX idx_student_signup ON student_table(signup_date);

CREATE TABLE instructor_table (
    instructor_id VARCHAR(10) PRIMARY KEY,
    instructor_name VARCHAR(75) NOT NULL,
    join_date DATE NOT NULL,
    email_id VARCHAR(50) NOT NULL UNIQUE,
    country VARCHAR(50),
    active_status ENUM('Active', 'Inactive', 'On Hold') NOT NULL
) ENGINE=InnoDB;

CREATE INDEX idx_instructor_status ON instructor_table(active_status);
CREATE INDEX idx_instructor_join ON instructor_table(join_date);

CREATE TABLE category_table (
    category_id VARCHAR(10) PRIMARY KEY,
    category_name VARCHAR(75) NOT NULL,
    parent_category_id VARCHAR(10) DEFAULT NULL,
    CONSTRAINT fk_parent_category 
        FOREIGN KEY (parent_category_id) 
        REFERENCES category_table(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_parent_category ON category_table(parent_category_id);

CREATE TABLE course_table (
    course_id VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(75) NOT NULL,
    instructor_id VARCHAR(10) NOT NULL,
    category_id VARCHAR(10) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    creation_date DATE NOT NULL,
    status ENUM('active', 'inactive', 'removed') NOT NULL,
    CONSTRAINT chk_course_price CHECK (price >= 0),
    
    CONSTRAINT fk_course_instructor 
        FOREIGN KEY (instructor_id) 
        REFERENCES instructor_table(instructor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_course_category 
        FOREIGN KEY (category_id) 
        REFERENCES category_table(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_course_instructor ON course_table(instructor_id);
CREATE INDEX idx_course_category ON course_table(category_id);
CREATE INDEX idx_course_status ON course_table(status);
CREATE INDEX idx_course_creation ON course_table(creation_date);

CREATE TABLE enrollment_table (
    enrollment_id VARCHAR(10) PRIMARY KEY,
    student_id VARCHAR(10) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    enrollment_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    discount DECIMAL(5,2) NOT NULL DEFAULT 0,
    final_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_enrollment_discount CHECK (discount >= 0 AND discount <= 100),
    CONSTRAINT chk_enrollment_price CHECK (final_price >= 0),
    CONSTRAINT fk_enrollment_student 
        FOREIGN KEY (student_id) 
        REFERENCES student_table(student_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_enrollment_course 
        FOREIGN KEY (course_id) 
        REFERENCES course_table(course_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_enrollment_student ON enrollment_table(student_id);
CREATE INDEX idx_enrollment_course ON enrollment_table(course_id);
CREATE INDEX idx_enrollment_timestamp ON enrollment_table(enrollment_timestamp);

CREATE TABLE payment_table (
    payment_id VARCHAR(10) PRIMARY KEY,
    enrollment_id VARCHAR(10) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount_paid DECIMAL(10,2) NOT NULL,
    status ENUM('Success', 'Failed') NOT NULL,
    CONSTRAINT chk_payment_amount CHECK (amount_paid >= 0),
    CONSTRAINT fk_payment_enrollment 
        FOREIGN KEY (enrollment_id) 
        REFERENCES enrollment_table(enrollment_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_payment_enrollment ON payment_table(enrollment_id);
CREATE INDEX idx_payment_date ON payment_table(payment_date);
CREATE INDEX idx_payment_status ON payment_table(status);