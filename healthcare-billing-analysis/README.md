# 🏥 Healthcare Billing Analysis (Excel + Power Query)

## 📌 Overview
This project demonstrates my ability to clean, transform, and analyze healthcare billing data using **Excel’s Power Query**. I engineered **Length of Stay (LOS)**, performed **categorical rollups** (gender, insurer, hospital, issue type), and ran **time‑series views** for anomaly detection. The dataset was intentionally simplified (nearly uniform distributions), and I document the implications while showcasing a professional, repeatable workflow.

---

## ⚙️ Key Skills Demonstrated
- **Power Query (M) for repeatable data prep**: type coercion, calculated columns, parameterized logic.
- **Feature engineering**: **LOS = Departure Date − Arrival Date** (in days).
- **Categorical analysis**: Group By to compute **sum / average / median / count** by gender, insurer, hospital, and issue type.
- **Time‑series analysis**: Billing totals by month; optional gender split to check for divergence.
- **Analyst judgment**: Clear call‑out that the dataset lacked realistic variance; communicated limits and next best steps.

---

## 🧭 What’s in this folder
- `README.md` (this file) — recruiter‑friendly overview of the project.
- `query.m` — Power Query (M) script reflecting the core transformations and grouped analyses.

> If you open this in Excel or Power BI, paste the `query.m` contents into **Power Query** (Data → Get Data → Launch Power Query Editor → **New Source** or **Advanced Editor**).

---

## 🧪 Summary of Workflow
1) **Ingest & clean** (set types, trim text, normalize dates).  
2) **Engineer LOS** = `Duration.Days(Departure - Arrival)`.  
3) **Group By views** to compute **Sum / Avg / Median / Count** for:
   - Gender
   - Insurer
   - Hospital
   - Issue Type
4) **Time series** (monthly) for total billing; optional **gender split**.  
5) **Interpretation**: No meaningful differences or anomalies due to highly uniform data generation.

---

## 📣 Recruiter Takeaway
Even with a “sterile” dataset, this project shows I can:
- Build **clean, auditable** data pipelines in Power Query
- Create **analysis‑ready** features and views for stakeholders
- Use **structured EDA** to confirm or refute patterns (and communicate limits clearly)

This is the same disciplined approach I bring to real‑world healthcare and operational analytics.
