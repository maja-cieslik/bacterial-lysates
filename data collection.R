# EU Pediatric Antibiotic Reduction Analysis
# Analysis of bacterial lysates impact on recurrent respiratory tract infections (RRTIs)
# Author: Maja Cieslik
# Date: June 2025
# Copyright (c) 2025 Maja Cieslik
# Licensed under the MIT License. See LICENSE file for details.

library(dplyr)
library(knitr)
library(kableExtra)

# ==============================================================================
# DATA COLLECTION AND PARAMETERS
# ==============================================================================

# Population data
eu_pediatric_population <- 80158328  # Total children under 18 in EU (Eurostat)

# Prevalence of recurrent RTIs
rrti_prevalence <- 0.10  # 10% assumption based on literature (Peeters et al., 2021; Toivonen et al., 2016)

# Distribution of antibiotic treatments in children with RRTIs (Toivonen et al., 2016)
treatment_distribution <- data.frame(
  treatments = c("0", "1-2", "3-4", "5+"),
  percentage = c(0.07, 0.19, 0.25, 0.49),
  courses_midpoint = c(0, 1.5, 3.5, 7)  # Using median 7 for 5+ category (Principi et al., 2003)
)

# Treatment efficacy from meta-analysis
mean_difference <- -1.90  # Mean reduction in antibiotic courses
ci_lower <- -1.12         # 95% CI lower bound
ci_upper <- -2.68         # 95% CI upper bound

# Antibiotic class distribution (Principi et al., 2003)
macrolides_pct <- 0.683   # 68.3%
beta_lactams_pct <- 0.223 # 22.3%

cat("=== EU PEDIATRIC ANTIBIOTIC REDUCTION ANALYSIS ===\n\n")

# ==============================================================================
# BASIC CALCULATIONS
# ==============================================================================

cat("1. POPULATION AND BASELINE CALCULATIONS\n")
cat("==========================================\n")

# Calculate target population
children_with_rrti <- round(eu_pediatric_population * rrti_prevalence)
cat(sprintf("Total EU pediatric population: %s children\n", format(eu_pediatric_population, big.mark = ",")))
cat(sprintf("Children with recurrent RTIs (%.0f%%): %s children\n", 
            rrti_prevalence * 100, format(children_with_rrti, big.mark = ",")))

# Calculate weighted average courses per child
treatment_distribution$children_count <- round(children_with_rrti * treatment_distribution$percentage)
treatment_distribution$total_courses <- treatment_distribution$children_count * treatment_distribution$courses_midpoint

weighted_avg_courses <- sum(treatment_distribution$percentage * treatment_distribution$courses_midpoint)
total_annual_courses <- sum(treatment_distribution$total_courses)

cat("\nTreatment Distribution:\n")
print(kable(treatment_distribution, 
            col.names = c("Treatments", "Percentage", "Courses (midpoint)", "Children Count", "Total Courses"),
            format.args = list(big.mark = ","),
            digits = 2))

cat(sprintf("\nWeighted average courses per child: %.2f\n", weighted_avg_courses))
cat(sprintf("Total annual antibiotic courses: %s\n", format(total_annual_courses, big.mark = ",")))

# ==============================================================================
# IMPACT SCENARIOS BY ADOPTION RATE
# ==============================================================================

cat("\n\n2. IMPACT SCENARIOS BY ADOPTION RATE\n")
cat("=====================================\n")

# Define adoption rates
adoption_rates <- c(0.25, 0.50, 0.75, 1.00)

# Function to calculate impact for given adoption rate and mean difference
calculate_impact <- function(adoption_rate, mean_diff) {
  children_treated <- round(children_with_rrti * adoption_rate)
  children_standard <- children_with_rrti - children_treated
  
  courses_reduced <- round(children_treated * abs(mean_diff))
  percentage_reduction <- (courses_reduced / total_annual_courses) * 100
  
  macrolides_avoided <- round(courses_reduced * macrolides_pct)
  beta_lactams_avoided <- round(courses_reduced * beta_lactams_pct)
  
  return(list(
    adoption_rate = adoption_rate,
    children_treated = children_treated,
    children_standard = children_standard,
    courses_reduced = courses_reduced,
    percentage_reduction = percentage_reduction,
    macrolides_avoided = macrolides_avoided,
    beta_lactams_avoided = beta_lactams_avoided
  ))
}

# Calculate scenarios for point estimate
scenarios <- lapply(adoption_rates, function(rate) calculate_impact(rate, mean_difference))
names(scenarios) <- paste0(adoption_rates * 100, "%")

# Create results table
results_table <- data.frame(
  adoption_rate = paste0(adoption_rates * 100, "%"),
  children_treated = sapply(scenarios, function(x) x$children_treated),
  courses_reduced = sapply(scenarios, function(x) x$courses_reduced),
  percentage_reduction = sapply(scenarios, function(x) x$percentage_reduction),
  macrolides_avoided = sapply(scenarios, function(x) x$macrolides_avoided),
  beta_lactams_avoided = sapply(scenarios, function(x) x$beta_lactams_avoided)
)

cat("Point Estimate Results (Mean Difference = -1.90):\n")
print(kable(results_table,
            col.names = c("Adoption Rate", "Children Treated", "Courses Reduced", 
                          "% Reduction", "Macrolides Avoided", "Beta-lactams Avoided"),
            format.args = list(big.mark = ","),
            digits = 1))

# ==============================================================================
# CONFIDENCE INTERVAL ANALYSIS
# ==============================================================================

cat("\n\n3. CONFIDENCE INTERVAL ANALYSIS\n")
cat("================================\n")

# Calculate confidence intervals for all adoption rates
ci_results <- data.frame(
  adoption_rate = paste0(adoption_rates * 100, "%"),
  point_estimate = sapply(adoption_rates, function(rate) calculate_impact(rate, mean_difference)$courses_reduced),
  lower_bound = sapply(adoption_rates, function(rate) calculate_impact(rate, ci_lower)$courses_reduced),
  upper_bound = sapply(adoption_rates, function(rate) calculate_impact(rate, ci_upper)$courses_reduced),
  point_pct = sapply(adoption_rates, function(rate) calculate_impact(rate, mean_difference)$percentage_reduction),
  lower_pct = sapply(adoption_rates, function(rate) calculate_impact(rate, ci_lower)$percentage_reduction),
  upper_pct = sapply(adoption_rates, function(rate) calculate_impact(rate, ci_upper)$percentage_reduction)
)

cat("Confidence Interval Analysis (95% CI):\n")
print(kable(ci_results,
            col.names = c("Adoption Rate", 
                          "Point Est. (Courses)", "Lower Bound", "Upper Bound",
                          "Point Est. (%)", "Lower Bound (%)", "Upper Bound (%)"),
            format.args = list(big.mark = ","),
            digits = 1))

# ==============================================================================
# SUMMARY STATISTICS
# ==============================================================================

cat("\n\n4. SUMMARY STATISTICS\n")
cat("=====================\n")

cat(sprintf("Base Case (100%% adoption):\n"))
cat(sprintf("- Maximum courses avoided: %s (%.1f%% reduction)\n", 
            format(scenarios[["100%"]]$courses_reduced, big.mark = ","),
            scenarios[["100%"]]$percentage_reduction))

cat(sprintf("\nConfidence Interval Range (100%% adoption):\n"))
cat(sprintf("- Conservative estimate: %s courses (%.1f%% reduction)\n",
            format(ci_results$lower_bound[4], big.mark = ","), ci_results$lower_pct[4]))
cat(sprintf("- Optimistic estimate: %s courses (%.1f%% reduction)\n",
            format(ci_results$upper_bound[4], big.mark = ","), ci_results$upper_pct[4]))

cat(sprintf("\nAntibiotic Class Impact (50%% adoption scenario):\n"))
cat(sprintf("- Macrolides avoided: %s courses\n", 
            format(scenarios[["50%"]]$macrolides_avoided, big.mark = ",")))
cat(sprintf("- Beta-lactams avoided: %s courses\n", 
            format(scenarios[["50%"]]$beta_lactams_avoided, big.mark = ",")))

# ==============================================================================
# SENSITIVITY ANALYSIS
# ==============================================================================

cat("\n\n5. SENSITIVITY ANALYSIS\n")
cat("=======================\n")

# Test different prevalence rates
prevalence_rates <- c(0.06, 0.10, 0.20)  # 6%, 10%, 20% based on literature
sensitivity_results <- data.frame(
  prevalence = paste0(prevalence_rates * 100, "%"),
  target_population = prevalence_rates * eu_pediatric_population,
  courses_50pct_adoption = sapply(prevalence_rates, function(p) {
    target_pop <- p * eu_pediatric_population
    treated <- target_pop * 0.5
    return(round(treated * abs(mean_difference)))
  })
)

cat("Sensitivity to RRTI Prevalence (50% adoption rate):\n")
print(kable(sensitivity_results,
            col.names = c("RRTI Prevalence", "Target Population", "Courses Avoided"),
            format.args = list(big.mark = ","),
            digits = 0))

# ==============================================================================
# EXPORT RESULTS
# ==============================================================================

cat("\n\n6. EXPORTING RESULTS\n")
cat("====================\n")

# Save key results to CSV files for further analysis
write.csv(results_table, "antibiotic_reduction_scenarios.csv", row.names = FALSE)
write.csv(ci_results, "confidence_interval_analysis.csv", row.names = FALSE)
write.csv(treatment_distribution, "treatment_distribution.csv", row.names = FALSE)

cat("Results exported to CSV files:\n")
cat("- antibiotic_reduction_scenarios.csv\n")
cat("- confidence_interval_analysis.csv\n")
cat("- treatment_distribution.csv\n")

cat("\n=== ANALYSIS COMPLETE ===\n")