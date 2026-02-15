# Data Model Explanation

## Business Context

This project models an online learning marketplace where students enroll in courses created by instructors. The platform generates revenue through successful course purchases and aims to optimize instructor performance, course portfolio, pricing, and student engagement.

The data model is designed to support business intelligence and analytical reporting rather than transactional system operations.

---

## Modeling Objective

The objective of this data model is to build a scalable and structured analytical foundation that enables:

* Revenue and financial analysis.
* Instructor performance monitoring.
* Course portfolio optimization.
* Student engagement and behavioral insights.

The schema is designed to balance normalization and analytical usability.

---

## Modeling Approach

The design follows a star-schema inspired approach, where:

* Fact tables capture transactional business events.
* Dimension tables store descriptive and contextual attributes.

This structure improves query performance and simplifies analytical reporting.

---

## Fact Tables

### 1. Enrollments

The enrollments table captures student purchase behavior and represents the commercial intent of course acquisition.

This table enables:

* Revenue and conversion analysis.
* Course demand tracking.
* Student activity monitoring.

### 2. Payments

The payments table captures financial transactions linked to enrollments.

Payments are modeled separately to support:

* Multiple payment attempts.
* Installment-based transactions.
* Failed payments.
* Refund tracking.
* Accurate revenue recognition.

This separation reflects real-world financial system design.

---

## Dimension Tables

### Students

Stores demographic and behavioral attributes that enable segmentation and engagement analysis.

### Instructors

Supports performance evaluation, productivity tracking, and retention strategies.

### Courses

Represents the product layer of the platform and enables analysis of portfolio performance.

### Categories

A hierarchical self-referencing structure is used to support both categories and subcategories, enabling domain-level insights and scalability.

---

## Relationship Design

The model maintains referential integrity through structured relationships:

* A student can enroll in multiple courses.
* A course can have many students.
* This many-to-many relationship is handled using the enrollments table.
* Each enrollment can have multiple payments, allowing flexibility in financial tracking.

---

## Key Design Decisions

### Separation of Commercial and Financial Events

Enrollment captures intent, while payments capture actual financial movement. This allows flexibility for refunds, failed transactions, and future payment models.

### Avoidance of Derived Metrics

Metrics such as total revenue, total students, and instructor contribution are calculated dynamically using SQL. This avoids redundancy and ensures data consistency.

### Hierarchical Category Structure

A self-referencing category design supports scalability and flexible domain expansion.

### Controlled Normalization

The schema minimizes redundancy while maintaining analytical usability and query efficiency.

---

## Constraints and Data Integrity

To ensure data quality and consistency, the following constraints are implemented:

* Primary keys to maintain uniqueness.
* Foreign keys to enforce relationships.
* NOT NULL constraints for critical attributes.
* CHECK constraints for valid payment states.
* Logical time sequence validation between events.

---

## Scalability and Future Extensions

The model can be extended by integrating:

* Course reviews and ratings.
* Marketing and campaign tracking.
* Subscription-based pricing.
* Automated ETL and real-time analytics.
* Advanced behavioral and personalization analytics.

This design simulates a real-world analytical data system that supports scalable and data-driven decision-making.
