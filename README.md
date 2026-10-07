# 🏥 Hospital Management System

A robust, backend-driven relational database project and management application designed to handle hospital operations, including patient demand, treatment tracking, doctor scheduling, and resource utilization.

---

## 📌 Project Overview

Managing hospital workflows efficiently is critical for patient care and resource allocation. This project models a comprehensive healthcare database system using **MySQL**, supported by an interactive backend and frontend integration (via FastAPI and Streamlit) to streamline appointment booking, patient records, and doctor scheduling.

### Key Modules
- **Patient & Appointment Management:** Track patient demographics, intake records, and appointment schedules.
- **Doctor & Staff Scheduling:** Manage doctor availability, specialties, and department allocations.
- **Treatment & Performance Analytics:** Monitor medical treatments, service performance metrics, and operational efficiency.
- **Resource Utilization:** Analyze hospital resource allocation and demand trends.

---

## 🛠️ Tech Stack & Tools

- **Database Management:** MySQL, MySQL Workbench
- **Backend Framework:** FastAPI / Python
- **Frontend / UI:** Streamlit
- **Version Control:** Git & GitHub

---

## 📁 Repository Structure

```text
├── database/
│   └── schema.sql                  # Database schema creation and table definitions
│   └── sample_data.sql             # Initial dummy data for testing
├── backend/
│   └── main.py                     # FastAPI application endpoints and database connection
├── frontend/
│   └── app.py                      # Streamlit interactive user interface
├── README.md                       # Project documentation
└── requirements.txt                # Python dependencies
