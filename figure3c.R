# EU Pediatric Antibiotic Reduction Analysis
# Analysis of bacterial lysates impact on recurrent respiratory tract infections (RRTIs)
# Author: Maja Cieslik
# Date: June 2025
# Copyright (c) 2025 Maja Cieslik
# Licensed under the GNU General Public License v3.0 (GPL-3.0). See LICENSE file for details.

library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)
library(cowplot)    
col_vibrant <- list(
  bar   = "#C97BA5",  
  error = "#8F4E75"    
)

data <- data.frame(
  adoption_rate      = factor(c("25%", "50%", "75%", "100%"),
                              levels = c("25%", "50%", "75%", "100%")),
  beta_lactams       = c(2284512, 4569025, 6853538, 9138050),
  macrolides         = c(647278,  1294557, 1941836, 2589114),
  other_antibiotics  = c(875730,  1751460, 2627189, 3502919),
  lower_ci           = c(2244433, 4488866, 6733300,  8977733),
  upper_ci           = c(5370608, 10741216,16111825, 21482433),
  total              = c(3807520, 7615042, 11422563, 15230083)
)

# totals in millions + percentage reduction --------------------------------
data <- data %>%
  mutate(
    total_m    = total      / 1e6,
    lower_ci_m = lower_ci   / 1e6,
    upper_ci_m = upper_ci   / 1e6,
    pct_reduc  = total / 36792673 * 100        # denominator = total courses in population
  )

# plotting

p_core <- ggplot(data, aes(y = adoption_rate, x = total_m)) +
  geom_col(fill = col_vibrant$bar, width = 0.6) +                                   # vibrant bars
  geom_errorbarh(aes(xmin = lower_ci_m, xmax = upper_ci_m),                         # CI whiskers
                 height = 0.25, size = 0.7, colour = col_vibrant$error) +
#  geom_text(aes(x = upper_ci_m + 1, label = sprintf("%.1f%%", pct_reduc)),           # % labels
#          hjust = 0, vjust = 0.5, size = 4, colour = col_vibrant$error) +
  scale_x_continuous(
    name   = "Antibiotic Courses Avoided (millions, with 95% CI)",
    limits = c(0, 25), breaks = seq(0, 25, 5), expand = c(0, 0)
  ) +
  scale_y_discrete(name = "Bacterial Lysates Adoption Rate") +
  labs(
    title    = "Antibiotic Courses Avoided",
    subtitle = "with 95% confidence intervals",
    caption  = "Based on mean difference of -1.90 courses per child (95% CI: -1.12 to -2.68)\nPopulation size: 8.02 milion children with recurrent RTIs in the EU"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title        = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle     = element_text(hjust = 0),
    plot.caption      = element_text(hjust = 1),
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank()
  )

print(p_core)
