# 🎓 Predicting First‑Year GPA with Linear Regression (R + tidyverse)

## Why this matters
Universities want to spot risk early and target support. This project builds a **predictive model** of **first‑year GPA** from pre‑admission and academic variables (e.g., HS GPA, SAT, sex). It demonstrates **machine learning with linear regression** using a transparent, business‑friendly workflow.

## What this shows (skills)
- Predictive modeling (linear regression treated as ML)
- Honest evaluation (train/test split + 5‑fold CV)
- Model diagnostics (multicollinearity, residual checks)
- Executive‑ready visuals (actual vs. predicted)

## Data
- `school.csv` (not included here): one row per student  
  **Key fields:**  
  - `fy_gpa` *(target)* — first‑year GPA  
  - `hs_gpa` — high‑school GPA  
  - `sat_v`, `sat_m` — SAT Verbal/Math (or `sat_sum`)  
  - `sex` — categorical  
  - + optional profile fields

> If your dataset uses different column names, update the `select()` and formulas in the script.

## Method (plain English)
1. Clean and type‑check inputs (drop NAs, factor `sex`)
2. Split into **train (80%)** and **test (20%)**
3. Fit models:  
   - **Baseline:** `fy_gpa ~ hs_gpa`  
   - **Full:** `fy_gpa ~ hs_gpa + sat_v + sat_m + sex`  
   - *(Optional)* Interaction: `hs_gpa * sex`
4. Check **VIF** to avoid redundancy (SAT sum vs. components)
5. 5‑fold cross‑validate on training set; report mean RMSE/R²
6. Score on test set; plot **Actual vs Predicted**
7. Summarize results in business terms

## Results (example)
- **Full model** improves accuracy over the HS‑only baseline
- Visuals show tight clustering around the 45° line (good calibration)
- Coefficients are interpretable and align with domain intuition

## Files
- `gpa_linear_regression.R` — full analysis (tidyverse)
- `outputs/` *(optional)* — predictions and metrics (CSV/PNG)

## How to run
```r
install.packages(c("tidyverse","rsample","broom","yardstick","GGally","car","modelr","glue"))
source("gpa_linear_regression.R")
```

## Talking points for stakeholders
- **Actionable:** model prioritizes early signals (HS GPA + SAT) to guide advising
- **Transparent:** coefficients are interpretable (why a prediction is high/low)
- **Practical:** can be refreshed as new cohorts arrive; extendable to classification (retention)
