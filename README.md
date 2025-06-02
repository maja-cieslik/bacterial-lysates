# EU Pediatric Antibiotic Reduction Prediction Modelling

## Overview

This repository contains the computational methodology and reproducible analysis for the scientific article: "**Efficacy of Bacterial Lysates in Reducing Antibiotic Use for Recurrent Respiratory Tract Infections in Children: A Systematic Review, Meta-Analysis, and Predictive Modelling Study**".

The analysis estimates the potential reduction in antibiotic usage among European Union pediatric populations through the implementation of bacterial lysates as preventive treatment for recurrent respiratory tract infections (RTIs).

## Repository Contents

### Scripts

- **`data collection.R`** - Main R script containing all calculations and statistical analysis
    - Population-based calculations for EU pediatric RRTI prevalence
    - Impact scenarios for different adoption rates (25%, 50%, 75%, 100%)
    - Confidence interval analysis (95% CI)
    - Sensitivity analysis for varying RRTI prevalence rates
    - Automated export of results to CSV files

### Generated Data Files

The R script generates the following CSV files:

- `antibiotic_reduction_scenarios.csv` - Impact scenarios by adoption rate
- `confidence_interval_analysis.csv` - Statistical confidence intervals
- `treatment_distribution.csv` - Baseline treatment distribution data

### Visualizations

- **`figure3a`** - Confidence interval analysis across adoption scenarios
- **`figure3b`** - Breakdown of avoided antibiotic courses by drug class (macrolides vs beta-lactams)
- **`figure3c`** - Impact of different adoption rates on antibiotic courses avoided

## Methodology

### Data Sources

- **EU Population Data**: Eurostat pediatric population statistics (80,158,328 children under 18)
- **RRTI Prevalence**: Literature-based estimate of 10% (Peeters et al., 2021; Toivonen et al., 2016)
- **Treatment Patterns**: Distribution of antibiotic courses in children with RRTIs (Toivonen et al., 2016)
- **Efficacy Data**: Meta-analysis mean difference of -1.90 antibiotic courses (95% CI: -2.68 to -1.12)
- **Antibiotic Classes**: Distribution from Italian cohort study (Principi et al., 2003)

### Key Assumptions

- 10% prevalence of recurrent RTIs in EU pediatric population
- Treatment distribution: 7% (0 courses), 19% (1-2 courses), 25% (3-4 courses), 49% (5+ courses)
- Median 7 antibiotic courses for children receiving 5+ treatments
- Antibiotic class distribution: 68.3% macrolides, 22.3% beta-lactams

### Statistical Analysis

The analysis employs population-based modeling to estimate:

- Total annual antibiotic courses in the target population (36.8 million)
- Potential reductions under different adoption scenarios
- Confidence intervals reflecting clinical trial uncertainty
- Sensitivity analysis for varying prevalence assumptions

## Key Findings

|Adoption Rate|Courses Avoided|Percentage Reduction|95% CI Range|
|---|---|---|---|
|25%|3,807,520|10.3%|6.1% - 14.6%|
|50%|7,615,042|20.7%|12.2% - 29.2%|
|75%|11,422,563|31.0%|18.3% - 43.8%|
|100%|15,230,083|41.4%|24.4% - 58.4%|

## Usage

### Prerequisites

```r
# Required R packages
install.packages(c("dplyr", "knitr", "kableExtra"))
```

### Running the Analysis

```r
# Clone the repository
git clone https://github.com/maja-cieslik/bacterial-lysates

# Set working directory
setwd("eu-pediatric-antibiotic-analysis")

# Run the main analysis
source("antibiotic_reduction_analysis.R")
```

The script will:

1. Display formatted results in the console
2. Generate CSV files with detailed results
3. Create summary statistics and confidence intervals

### Reproducibility

All calculations are fully reproducible using the provided R script. The analysis follows best practices for scientific computing:

- Clear documentation of data sources and assumptions
- Structured, commented code
- Version-controlled methodology
- Exported intermediate results for validation

## Citation

If you use this analysis or code in your research, please cite:

```
[Author Names] ([Year]). Efficacy of Bacterial Lysates in Reducing Antibiotic Use for Recurrent Respiratory Tract Infections in Children: A Systematic Review, Meta-Analysis, and Predictive Modelling Study. 
[Journal Name], [Volume(Issue)], [Page Range]. DOI: [DOI]

Code and data available at: https://github.com/maja-cieslik/bacterial-lysates
```

## License

This work is licensed under the GNU General Public License v3.0 (GPL-3.0). See the [LICENSE](https://claude.ai/chat/LICENSE) file for details.

### GPL-3.0 License Summary

- **Freedom to use**: You can use this code for any purpose
- **Freedom to study**: Source code is available and documented
- **Freedom to modify**: You can adapt the code for your needs
- **Freedom to distribute**: You can share the original or modified versions
- **Copyleft provision**: Derivative works must also be licensed under GPL-3.0

## Contributing

We welcome contributions to improve the analysis methodology or extend the research scope. Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add new analysis feature'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Create a Pull Request

## Contact

For questions about the methodology or code implementation, please:

- Open an issue in this repository
- Contact the corresponding author: [wojciech.feleszko@wum.edu.pl]

## Acknowledgments

- European Union Eurostat for pediatric population statistics
- R Core Team and package maintainers for statistical computing tools (dplyr, knitr, kableExtra)

### Research Data Sources

We acknowledge the following research groups whose published studies provided the clinical data foundation for this analysis:

**RRTI Prevalence and Treatment Patterns:**

- Peeters, D., Verhulst, P., Vaessen-Verberne, A., van den Tweel, X., Noordzij, J. & Driessen, G. (2021). Low Prevalence of Severe Underlying Pathology in Children With Recurrent Respiratory Tract Infections. _The Pediatric Infectious Disease Journal_, 40(11), e424-e426. doi: 10.1097/INF.0000000000003256
- Toivonen, L., Karppinen, S., Schuez-Havupalo, L., Teros-Jaakkola, T., Vuononvirta, J., Mertsola, J., He, Q., Waris, M., & Peltola, V. (2016). Burden of recurrent respiratory tract infections in children: A prospective cohort study. _Pediatric Infectious Disease Journal_, 35(12), e362–e369. [https://doi.org/10.1097/INF.0000000000001304](https://doi.org/10.1097/INF.0000000000001304)

**Clinical Context and Treatment Distribution:**

- de Martino, M., & Ballotti, S. (2007). The child with recurrent respiratory infections: Normal or not? _Pediatric Allergy and Immunology_, 18(SUPPL. 18), 13–18. [https://doi.org/10.1111/j.1399-3038.2007.00625.x](https://doi.org/10.1111/j.1399-3038.2007.00625.x)
- Chiappini, E., Santamaria, F., Marseglia, G. L., Marchisio, P., Galli, L., Cutrera, R., de Martino, M., Antonini, S., Becherucci, P., Biasci, P., Bortone, B., Bottero, S., Caldarelli, V., Cardinale, F., Gattinara, G. C., Ciarcià, M., Ciofi, D., D'Elios, S., di Mauro, G., … Villani, A. (2021). Prevention of recurrent respiratory infections: Inter-society Consensus. _Italian Journal of Pediatrics_, 47(1). [https://doi.org/10.1186/s13052-021-01150-0](https://doi.org/10.1186/s13052-021-01150-0)

**Antibiotic Usage Patterns:**

- Principi, N., Esposito, S., Cavagna, R., Bosis, S., Droghetti, R., Faelli, N., Tosi, S., Begliatti, E., Amato, G., Armenio, L., Chetrì, L., Bernardi, F., Corsini, I., Berni Canani, M., Boner, A., Cohen, A., de Mattia, D., Schettini, F., Paone, F., … Azzari, C. (2003). Recurrent respiratory tract infections in pediatric age: A population-based survey of the therapeutic role of macrolides. _Journal of Chemotherapy_, 15(1), 53–59. [https://doi.org/10.1179/joc.2003.15.1.53](https://doi.org/10.1179/joc.2003.15.1.53)