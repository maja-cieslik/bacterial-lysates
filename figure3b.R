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
col_lancet <- c(
  "Beta-lactams"      = "#E8CBDD",  
  "Macrolides"        = "#DEE1E9",  
  "Other Antibiotics" = "#F1E0D9"   
)
data <- data.frame(
  adoption_rate = factor(c("25%", "50%", "75%", "100%"), 
                         levels = c("25%", "50%", "75%", "100%")),
  beta_lactams      = c(2284512, 4569025, 6853538, 9138050),
  macrolides        = c(647278, 1294557, 1941836, 2589114),
  other_antibiotics = c(875730, 1751460, 2627189, 3502919),
  lower_ci          = c(2244433, 4488866, 6733300, 8977733),
  upper_ci          = c(5370608, 10741216, 16111825, 21482433),
  total             = c(3807520, 7615042, 11422563, 15230083)
)
# Long format & factor order (unchanged) ----------------------------------
data_long <- data %>% 
  pivot_longer(
    cols      = c(beta_lactams, macrolides, other_antibiotics),
    names_to  = "antibiotic_class",
    values_to = "courses_avoided"
  ) %>% 
  mutate(
    antibiotic_class = factor(
      antibiotic_class,
      levels = c("other_antibiotics", "macrolides", "beta_lactams"),   # reversed for stacking order
      labels = c("Other Antibiotics", "Macrolides", "Beta-lactams")
    )
  )
# Millions formatter ------------------------------------------------------
format_in_millions <- function(x) {
  paste0(format(round(x / 1e6, 1), nsmall = 1), "M")
}
# Create annotation data for totals ---------------------------------------
annotation_data <- data %>%
  select(adoption_rate, total) %>%
  mutate(
    total_label = format_in_millions(total),
    # Position labels slightly above the bars
    y_position = total + (total * 0.05)  # 5% above the total height
  )
# Plot --------------------------------------------------------------------
ggplot(data_long,
       aes(x = adoption_rate, y = courses_avoided, fill = antibiotic_class)) +
  geom_bar(
    stat     = "identity",
    position = "stack",
    width    = 0.7,
    colour   = "grey60",   # thin outline to keep the pastels legible
    linewidth = 0.2
  ) +
  # Add total value labels above each bar
  geom_text(
    data = annotation_data,
    aes(x = adoption_rate, y = y_position, label = total_label),
    inherit.aes = FALSE,  # Don't inherit aesthetics from main plot
    vjust = 0,           # Align text bottom to the y position
    hjust = 0.5,         # Center horizontally
    size = 3.5,          # Text size
    fontface = "bold",   # Make text bold
    colour = "black"     # Text color
  ) +
  scale_fill_manual(values = col_lancet) +      # Lancet colours
  guides(fill = guide_legend(reverse = TRUE)) +  # Reverse legend order
  scale_y_continuous(
    labels = format_in_millions,
    expand = expansion(mult = c(0, 0.15))  # Increased top expansion to accommodate labels
  ) +
  labs(
    title    = "Antibiotic Courses Avoided by Class and Adoption Rate",
    subtitle = "Absolute number of courses showing scaling impact with increased adoption",
    x        = "Bacterial Lysates Adoption Rate",
    y        = "Antibiotic Courses Avoided (millions)",
    fill     = "Antibiotic Class",
    caption  = "Total target population: 8.02 million children\nMean difference per child: -1.90 courses (95% CI: -1.12 to -2.68)"
  ) +
  theme_minimal() +
  theme(
    plot.title        = element_text(face = "bold", size = 14),
    plot.subtitle     = element_text(size = 11, colour = "gray30"),
    plot.caption      = element_text(hjust = 0, size = 9),
    legend.position   = "bottom",
    legend.title      = element_text(face = "bold"),
    axis.title        = element_text(face = "bold"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank()
  )