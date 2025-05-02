## README: repo "interesting_flowers" 

## Data and scripts assosiated with "The evolutionary dynamics of plant mating systems: how bias for studying ‘interesting’ plant reproductive systems could backfire" 

### Paper

The paper assosiated with this dataset is: 

Elena M Meyer, Laura F Galloway, Andrew J Eckert, The evolutionary dynamics of plant mating systems: how bias for studying ‘interesting’ plant reproductive systems could backfire, Annals of Botany, 2025;, mcaf031, [https://doi.org/10.1093/aob/mcaf031](url)

### Description of the project

We conducted a literature review to review and synthesize efforts to quantify mating systems across angiosperms. This data allowed us to examine patterns of potential bias in the existing data based on factors such as family or sexual system, as well as how the data available on plant mating systems has changed over time. Broadly, we revisited the question of the underlying distribution of selfing and the adequacy of our existing data to unravel the complex dynamics of plant mating system evolution. 

#### Files and variable

**Description:** This repository contains:

* A folder named “WFO_Data” with three .xlsx files: 1) “PlantsWFOdatabasepart1.xlsx”, “PlantsWFOdatabasepart2.xlsx”, and “PlantsWFOdatabasepart2.xlsx”. These are datasets originating from World Flora Online which go with the R package “U.Taxonstrand” (Zhang et al. 2022). 
* An annotated R script titled “Analysis_MatingSyst.R” was used to analyze the input data. 
* “Input_Data_MS.xlsx”, which is an Excel workbook with three tabs: 1) “Notes + metadata”, 2) “Data 2017-2022”, and 3) “Data from large reviews.” Here, missing values are encoded as “NA”.  Variables (column names) are described in Tab 1. 
* “Output_Data_MS.csv”, which is the finished output produced by the R script. Here, missing values are encoded as “na”. 

### Code/software

The script attached (“Analysis_MatingSyst.R”) was written using: 

* RStudio 2023.06.2+561 “Mountain Hydrangea” Release (de44a3118f7963972e24a78b7a1ad48b4be8a217, 2023-08-25) for macOS
* R version 4.3.0 (2023-04-21) “Already Tomorrow” 

The following packages were used:

* readxl - Wickham H, Bryan J (2025). *readxl: Read Excel Files*. R package version 1.4.5, https://github.com/tidyverse/readxl, [https://readxl.tidyverse.org](https://readxl.tidyverse.org/).
* devtools - Wickham H, Hester J, Chang W, Bryan J (2022). devtools: Tools to Make Developing R Packages Easier. https://devtools.r-lib.org/, https://github.com/r-lib/devtools.
* dplyr - Wickham H, François R, Henry L, Müller K, Vaughan D (2023). *dplyr: A Grammar of Data Manipulation*. R package version 1.1.4, https://github.com/tidyverse/dplyr, [https://dplyr.tidyverse.org](https://dplyr.tidyverse.org/).
* U.Taxonstand - Zhang, J. & Qian, H. (2023). U.Taxonstand: An R package for standardizing scientific names of plants and animals. Plant Diversity, 45(1): 1-5. DOI: [10.1016/j.pld.2022.09.001](https://doi.org/10.1016/j.pld.2022.09.001)

### Access information

Other publicly accessible locations of the data: Data Dryad (under review, link forthcoming). 

