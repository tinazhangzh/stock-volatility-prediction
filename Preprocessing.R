```{r}
# Load necessary libraries
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(caret)
library(lmtest)

# Read the cleaned dataset (replace with relative path if used in GitHub repo)
stock_data <- read_csv("data/updated_data.csv")

# Remove rows with missing Log_Ret values
stock_data <- stock_data %>% 
  filter(!is.na(Log_Ret))

# Convert Date column to Date format
stock_data$Date <- as.Date(stock_data$Date)

# Display summary statistics
head(stock_data)
summary(stock_data)
```

```{r}
# Plot log returns over time for a selected stock (e.g., AAL)
ggplot(data = stock_data %>% filter(StockID == 'AAL'), aes(x = Date, y = Log_Ret)) +
  geom_line() +
  labs(title = "Logarithmic Returns over Time for Stock AAL",
       x = "Date",
       y = "Log Return")
```

## Linear Regression Model

```{r}
set.seed(565)

# Split the dataset into training (80%) and test (20%) sets
index <- createDataPartition(stock_data$Log_Ret, p = 0.8, list = FALSE)
train_data <- stock_data[index, ]
test_data <- stock_data[-index, ]

# Fit linear regression model to predict Log_Ret using all features
model <- lm(Log_Ret ~ ., data = train_data %>% select(-Date))

# Evaluate model performance on test data
predictions <- predict(model, newdata = test_data)
rmse <- sqrt(mean((predictions - test_data$Log_Ret)^2))
rmse
```

```{r}
# Plot actual vs. predicted log returns
ggplot(data = NULL, aes(x = test_data$Log_Ret, y = predictions)) +
  geom_point(alpha = 0.4) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Actual vs. Predicted Log Returns",
       x = "Actual",
       y = "Predicted")
