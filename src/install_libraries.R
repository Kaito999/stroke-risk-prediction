libraries <- c(
  "caret", "ROCR", "pROC", "patchwork", "rsample",
  "tidymodels", "gtsummary", "tidyverse", "corrplot",
  "ggcorrplot", "ggplot2", "patchwork", "timeDate",
  "modeldata", "vip", "MLmetrics", "imbalance",
  "gridExtra", "AICcmodavg"
)

for (lib in libraries) {
  if (!requireNamespace(lib, quietly = TRUE)) {
    install.packages(lib, dependencies = TRUE)
  }
}

cat("Libraries installed successfully.\n")

lapply(libraries, library, character.only = TRUE)
