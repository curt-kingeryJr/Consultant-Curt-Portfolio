# Load necessary libraries
library(tidyverse)
library(broom)

# Load dataset
# Replace with the actual path or method to load your dataset
df <- read_csv("student_data.csv")

# View first few rows
head(df)

# Exploratory Data Analysis
glimpse(df)
summary(df)

# Check for missing values
colSums(is.na(df))

# Basic visualization: GPA vs Study Hours
ggplot(df, aes(x = StudyHours, y = GPA)) +
  geom_point(color = "blue", alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(title = "GPA vs Study Hours",
       x = "Study Hours per Week",
       y = "Freshman GPA")

# Fit linear regression model
model <- lm(GPA ~ StudyHours + AttendanceRate + HighSchoolGPA, data = df)

# Model summary
summary(model)

# Tidy model output
tidy(model)

# Confidence intervals
confint(model)

# Visualize residuals
df$residuals <- resid(model)
ggplot(df, aes(x = residuals)) +
  geom_histogram(binwidth = 0.1, fill = "skyblue", color = "black") +
  labs(title = "Residuals Distribution",
       x = "Residuals",
       y = "Frequency")

# Predict GPA for new data
new_data <- data.frame(
  StudyHours = c(10, 15, 20),
  AttendanceRate = c(0.9, 0.95, 0.85),
  HighSchoolGPA = c(3.5, 3.8, 3.2)
)

predictions <- predict(model, newdata = new_data, interval = "confidence")
predictions

# Save model
saveRDS(model, file = "linear_regression_model.rds")
