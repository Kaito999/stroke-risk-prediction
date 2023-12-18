# Stroke Risk Prediction Project

This repository contains the code and documentation for a educational research project on stroke risk prediction. The project investigates the escalating incidence of strokes, leveraging a Kaggle-sourced dataset with 11 clinical features.

## Introduction
As of [current date], stroke is the second leading cause of death globally. This project aims to enhance our understanding of stroke risk factors and develop predictive models for early intervention and prevention.

## Materials & Methods
The project utilizes a Kaggle-sourced dataset with 11 clinical features. The dataset undergoes data preprocessing, exploratory data analysis, and the development of logistic regression and XGBoost models.

- Exploratory Data Analysis (EDA)
  The EDA process involves visualization tools such as R and ggplot2 to analyze stroke events across demographic and lifestyle factors. Unexpected findings, such as the relationship between glucose levels and strokes, are explored.
- Imbalanced Data Handling
  Acknowledging imbalanced data, the project addresses this bias through oversampling using the MWMOTE technique.
- Logistic Regression and Variable Importance
  Logistic regression models are developed, and Variable Importance in Projection (VIP) analysis is employed to identify key factors influencing stroke occurrence.
- AIC Analysis
  The project compares two logistic regression models using the Akaike Information Criterion (AIC) for model selection.
- Performance Assessment
  Performance evaluation includes confusion matrices, ROC curves, and other metrics for both logistic regression and XGBoost models.

### Project Structure
- `code/`: Contains the code for data preprocessing, model development, and evaluation.
- `data/`: Contains the Kaggle-sourced dataset.
- `visualizations/`: Includes visualizations generated during the exploratory data analysis.

### Requirements
- R (version X.X.X)
- Required R packages (list them)

### Setup
1. Clone the repository: `git clone [repository-url]`
2. Navigate to the project directory: `cd stroke-risk-prediction`

### Usage
1. Run data preprocessing scripts: `Rscript code/preprocess_data.R`
2. Execute exploratory data analysis: `Rscript code/eda.R`
3. Train logistic regression model: `Rscript code/train_logistic_regression.R`
4. Evaluate model performance: `Rscript code/evaluate_models.R`

### Contributing
Feel free to contribute to this project by forking the repository and creating a pull request. For major changes, please open an issue to discuss potential updates.

### License
This project is licensed under the [License Name] - see the [LICENSE.md](LICENSE.md) file for details.
