# importing the necessary libraries - R version [4.3.2]

library(caret)
library(ROCR)
library(pROC)
library(patchwork)
library(rsample)
library(tidymodels)
library(gtsummary)
library(tidyverse)
library(corrplot)
library(ggcorrplot)
library(ggplot2)
library(patchwork)
library(timeDate)
library(modeldata)
library(vip)
library(MLmetrics)
library(imbalance)
library(gridExtra)
library(AICcmodavg)


#------------------------ 1. Preparing the data-set ----------------------------

# 1.1 importing stroke data-set ------------------------------------------------

location <- "./data/stroke-data.csv"
stroke_data <- read.csv(location)


# 1.2 filtering and clearing the dataset ---------------------------------------

process_stroke_data <- function(data) {
  # filter out rows with unknown BMI, smoking status or gender
  data <- data %>% 
    filter(bmi != "N/A", smoking_status != "Unknown", gender != "Other")
  
  # re-code variables
  data <- data %>%
    mutate_at(vars(gender, hypertension, heart_disease, ever_married, work_type, 
                   Residence_type, smoking_status, stroke), as.factor) %>%
    mutate_at(vars(bmi), as.double)
  
  # drop unnecessary level for gender
  data$gender <- data$gender %>% 
    droplevels(exclude = "Other")
  
  # drop unusable variable id
  data <- subset(data, select = -id)
  
  return(data)
}

stroke_data <- process_stroke_data(stroke_data)


# --------------------- 2. Exploratory data analysis ---------------------------

summary(stroke_data)

# 2.1 density plots ------------------------------------------------------------

ggplot(stroke_data, aes(x = age, fill = stroke)) +
  geom_density(alpha = 0.8) +
  labs(
    y = "Density",
    x = "Age",
    title = "Age-Stroke Distribution",
    fill = "Stroke"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() +
  xlim(0, 100) + 
  theme(plot.title = element_text(hjust = 0.5))

ggplot(stroke_data, aes(x = avg_glucose_level, fill = stroke)) +
  geom_density(alpha = 0.8) +
  labs(
    y = "Density",
    x = "Average glucose level",
    title = "Glucose-Stroke Distribution",
    fill = "Stroke"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() +
  xlim(0, 300) + 
  theme(plot.title = element_text(hjust = 0.5))


ggplot(stroke_data, aes(x = bmi, fill = stroke)) +
  geom_density(alpha = 0.8) +
  labs(
    y = "Density",
    x = "BMI",
    title = "BMI-Stroke Distribution",
    fill = "Stroke"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))


# 2.2 bar plots ----------------------------------------------------------------

calculate_percentage <- function(data, group_var, count_var) {
  percentages <- data %>%
    group_by(across({{group_var}}), {{count_var}}) %>%
    summarise(count = n(), .groups = "drop") %>%
    group_by(across({{group_var}}), .groups = "drop") %>%
    mutate(percentage = count / sum(count) * 100)
  
  return(percentages)
}

hypertension_percentages <- calculate_percentage(stroke_data, hypertension, stroke)

# plot for hypertension vs. stroke distribution with percentages
ggplot(hypertension_percentages, aes(x = hypertension, y = percentage, fill = stroke)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(percentage), "%")), position = 
              position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    y = "Percentage of Patients",
    x = "Hypertension",
    title = "Distribution of Stroke by Hypertension"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5))

heart_disease_percentages <- calculate_percentage(stroke_data, heart_disease, stroke)

# plot for heart disease vs. stroke distribution with percentages
ggplot(heart_disease_percentages, aes(x = heart_disease, y = percentage, fill = stroke)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(percentage), "%")), 
            position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    y = "Percentage of Patients",
    x = "Heart Disease",
    title = "Distribution of Stroke by Heart Disease"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5))


marriage_percentages <- calculate_percentage(stroke_data, ever_married, stroke)

# Plotting marriage vs. stroke distribution with percentages
ggplot(marriage_percentages, aes(x = ever_married, y = percentage, fill = stroke)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(percentage), "%")), 
            position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    y = "Percentage of Patients",
    x = "Marital Status",
    title = "Distribution of Stroke by Marital Status"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5))

residence_percentages <- calculate_percentage(stroke_data, Residence_type, stroke)

# Plotting residence vs. stroke distribution with percentages
ggplot(residence_percentages, aes(x = Residence_type, y = percentage, fill = stroke)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(percentage), "%")), 
            position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    y = "Percentage of Patients",
    x = "Residence Type",
    title = "Distribution of Stroke by Residence Type"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5))


smoking_percentages <- calculate_percentage(stroke_data, smoking_status, stroke)

# Plotting smoking status vs. stroke distribution with percentages
ggplot(smoking_percentages, aes(x = smoking_status, y = percentage, fill = stroke)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(percentage), "%")), 
            position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    y = "Percentage of Patients",
    x = "Smoking Status",
    title = "Distribution of Stroke by Smoking Status"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5))

work_percentages <- calculate_percentage(stroke_data, work_type, stroke)

# Plotting work type vs. stroke distribution with percentages
ggplot(work_percentages, aes(x = work_type, y = percentage, fill = stroke)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(percentage), "%")), 
            position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    y = "Percentage of Patients",
    x = "Work Type",
    title = "Distribution of Stroke by Work Type"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5))


# bar chart of patients with and without stroke
ggplot(data = stroke_data, aes(x = stroke, fill = stroke)) +
  geom_bar() +
  geom_text(
    stat = "count",
    aes(label = scales::percent(after_stat(count/sum(count))), vjust = -0.5)
  ) +
  labs(
    y = "Number of Patients",
    x = "Stroke",
    title = "Percentage of Patients with and Without Strokes"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

gender_percentages <- calculate_percentage(stroke_data, gender, stroke)

# Plotting gender vs. stroke distribution with percentages
ggplot(gender_percentages, aes(x = gender, y = percentage, fill = stroke)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(percentage), "%")), 
            position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    y = "Percentage of Patients",
    x = "Gender",
    title = "Distribution of Stroke by Gender"
  ) +
  scale_fill_manual(values = c("#003f5c", "#ff6361")) +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5))


# 2.3 corrplot for all clinical features of dataset ----------------------------

numeric_df <- as.data.frame(lapply(stroke_data, as.numeric))
correlation_matrix <- cor(numeric_df)
ggcorrplot(correlation_matrix, 
           type = "lower", 
           lab = TRUE, 
           lab_size = 3, 
           outline.color = "white", 
           colors = c("blue", "white", "red")) + 
  xlab("Variables") +
  ylab("Variables") +
  ggtitle("Correlation Plot of Features") + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +  
  theme(plot.title = element_text(hjust = 0.5))


# ------------------------------ 3. Modeling -----------------------------------

# 3.1 balancing the dataset ----------------------------------------------------

imbalanceRatio(as.data.frame(stroke_data), classAttr = "stroke")

stroke_test <- stroke_data %>%
  mutate(
    stroke = as.character(stroke),
    across(where(is.factor), as.numeric),
    stroke = factor(stroke)
  )

stroke_oversampled <- oversample(
  as.data.frame(stroke_test), 
  classAttr = "stroke", 
  ratio = 1, method = "MWMOTE")

head(stroke_oversampled)

stroke_oversampled %>%
  group_by(stroke) %>%
  summarize(n = n()) %>%
  mutate(prop = round(n / sum(n), 2))

stroke_data <- stroke_oversampled


# splitting dataset into training and testing subsets for model train

df <- stroke_data %>% mutate_if(is.ordered, factor, ordered = F)

stroke_split <- initial_split(df, prop = .7, strata = 'stroke')
stroke_train <- training(stroke_split)
stroke_test <- testing(stroke_split)

# training to models first with all features, the second with the one most 
# relevant to stroke

set.seed(42)
cv_stroke_model1 <- train(stroke ~ .,
                          data = stroke_train,
                          method = 'glm',
                          family = 'binomial',
                          trControl = trainControl(method = 'cv', number = 10)
)

set.seed(42)
cv_stroke_model2 <- train(stroke ~
                            age + 
                            hypertension +
                            heart_disease +
                            avg_glucose_level +
                            smoking_status,
                          data = stroke_train,
                          method = 'glm',
                          family = 'binomial',
                          trControl = trainControl(method = 'cv', number = 10)
)

vip(cv_stroke_model1, num_features = 10)


model_list <- list(model1 = cv_stroke_model1$finalModel,
                   model2 = cv_stroke_model2$finalModel)

aic_table <- aictab(model_list)

print(aic_table)

predictions <- predict(cv_stroke_model1, stroke_train)


conf_matrix_model <- confusionMatrix(
  data = relevel(predictions, ref = '1'),
  reference = relevel(stroke_train$stroke, ref = '1')
)

print(conf_matrix_model)

predictions_test_model1 <- predict(cv_stroke_model1, newdata = stroke_train, type = "prob")

predictions_test_model2 <- predict(cv_stroke_model2, newdata = stroke_train, type = "prob")

roc_test_model1 <- roc(as.numeric(stroke_train$stroke) - 1, predictions_test_model1[, 1])
roc_test_model2 <- roc(as.numeric(stroke_train$stroke) - 1, predictions_test_model2[, 1])

plot(roc_test_model1, col = "blue", main = "ROC Curves", lwd = 1)
lines(roc_test_model2, col = "red", lwd = 1)

legend("bottomright", legend = c("glm_model_1", "glm_model_2"), col = c("blue", "red"), lwd = 2)

# xgboost model

xgbGrid <- expand.grid(
  nrounds = 3500,
  max_depth = 7,
  eta = 0.01,
  gamma = 0.01,
  colsample_bytree = 0.75,
  min_child_weight = 0,
  subsample = 0.5
)

xgbControl <- trainControl(
  method = "cv",
  number = 5
)

xgb_model <- train(
  stroke ~ .,
  data = stroke_train,
  method = "xgbTree",
  tuneLength = 3,
  tuneGrid = xgbGrid,
  trControl = xgbControl
)

xgb_model

x_test <- stroke_test %>% select(-stroke)

xbg_pred <- predict(xgb_model, newdata = x_test) 

confusionMatrix(xbg_pred, factor(stroke_test[["stroke"]]), positive = "1")

