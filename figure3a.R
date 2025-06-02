# EU Pediatric Antibiotic Reduction Analysis
# Analysis of bacterial lysates impact on recurrent respiratory tract infections (RRTIs)
# Author: Maja Cieslik
# Date: June 2025
# Copyright (c) 2025 Maja Cieslik
# Licensed under the MIT License. See LICENSE file for details.

library(ggplot2)
library(scales)
library(dplyr)

col_lancet <- list(
  ribbon = "#E8CBDD",  # medium mauve  (still Lancet-style)
  line   = "#C97BA5"   # deeper vibrant pink for contrast
)

# Meta-analysis parameters -------------------------------------------------
md_point <- -1.90            # mean difference in courses
md_lower <- -1.12            # 95 % CI lower bound
md_upper <- -2.68            # 95 % CI upper bound
target_population <- 8015833 # children with recurrent RTIs

# Data frame over 0–100 % adoption ----------------------------------------
fig1C_df <- data.frame(adopt_pct = 0:100) %>% 
  mutate(
    adoptn_frac = adopt_pct / 100,
    point = abs(md_point) * target_population * adoptn_frac,
    lower = abs(md_lower) * target_population * adoptn_frac,
    upper = abs(md_upper) * target_population * adoptn_frac
  )

# Custom formatter for millions scale ------------------------------------
millions_formatter <- function(x) {
  paste0(x / 1e6, "M")
}

# Plot --------------------------------------------------------------------
ggplot(fig1C_df, aes(adopt_pct, point)) +
  geom_ribbon(
    aes(ymin = lower, ymax = upper),
    fill  = col_lancet$ribbon,
    alpha = 0.45                         # richer ribbon
  ) +
  geom_line(
    colour    = col_lancet$line,
    linewidth = 1.2                      # slightly bolder line
  ) +
  scale_x_continuous(breaks = seq(0, 100, 25)) +
  scale_y_continuous(
    labels = millions_formatter,
    breaks = seq(0, 20000000, 5000000)  # Breaks at 0, 5M, 10M, 15M, 20M
  ) +
  labs(
    x = "Bacterial Lysates Adoption Rate (%)",
    y = "Antibiotic courses avoided annually (millions)",
    title = "Sensitivity analysis across the full adoption range",
    caption = "Shaded band = 95% confidence interval"
  ) +
  theme_bw() +
  theme(
    plot.title       = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )