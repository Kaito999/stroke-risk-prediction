# Stroke Risk Prediction

Stroke is the second leading cause of death globally. This repository contains the code and documentation for a educational research project on stroke risk prediction. The project investigates the escalating incidence of strokes, leveraging a Kaggle-sourced dataset with 11 clinical features.

## Materials & Methods
The dataset undergoes data preprocessing, exploratory data analysis, and the development of logistic regression and XGBoost models.

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

## Project Structure
- `src/`: Contains the script for data preprocessing, model development, and evaluation.
- `data/`: Contains the Kaggle-sourced dataset.
- `plots/`: Includes visualizations generated during the exploratory data analysis.
- `report/`: Contains the presentation and the scientific paper of the project.

## Requirements
- [RStudio](https://posit.co/download/rstudio-desktop/)
- R [version 4.3.2](https://cran.r-project.org/bin/windows/base/)
- Required libraries:
```
source("./src/install_libraries.R")
```

## Setup
1. Clone the repository: `git clone [repository-url]`
2. Navigate to the project directory: `cd stroke-risk-prediction`

## Usage
1. Open the project: `stroke-risk-prediction/stroke-risk-prediction.Rproj`
2. Access the code: `src/stroke_risk_prediction.R`
3. Execute step by step the code inside script

## License
This project is licensed under the [License Name] - see the [LICENSE.md](LICENSE.md) file for details.
