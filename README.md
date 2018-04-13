<!-- README.md is generated from README.Rmd. Please edit that file -->
Overview
========

`gabaclassifier` classifies a given neuronal morphology into one of eight types (see below), such as Chandelier or Martinotti.

For example, it classifies cell C030502A as a nest basket cell.

``` r
library(gabaclassifier) 
file <- system.file('extdata', 'C030502A.swc', package = 'gabaclassifier')
classify_interneuron(file = file, layer  = '23')
#>   1 
#> NBC 
#> Levels: BTC ChC DBC LBC MC NBC SBC
```

The output is short code for the type name. The codes for the eight types are:

| short | long                |
|:------|:--------------------|
| BTC   | Bitufted cell       |
| ChC   | Chandelier cell     |
| DBC   | Double bouquet cell |
| LBC   | Large basket cell   |
| MC    | Martinotti cell     |
| NBC   | Nest basket cell    |
| SBC   | Small basket cell   |

Installing
==========

`gabaclassifier` requires `neurostr` and `neurostrplus` to be installed. The following installs all three packages (install the `devtools` package with `install.package('devtools')` if you don't have it):

``` r
# install.package('devtools')
devtools::install_github("ComputationalIntelligenceGroup/neurostrr")
devtools::install_github("ComputationalIntelligenceGroup/neurostrplus")
devtools::install_github("ComputationalIntelligenceGroup/gabaclassifier") 
```

These packages have only been tested on Ubuntu 16.04.

Usage
=====

Cells are classified with the `classify_interneuron` function. The inputs are

-   A path to a SWC reconstruction of a neuron morphology
-   The layer containing the cell's soma

The path must be fully expanded, that is `/home/user/neuron.swc` will work while `~/neuron.swc` will not.

The model has been trained with layer L2/3 to layer L6 interneurons and thus only interneurons from those layers are allowed as input to `classify_interneuron`.

``` r
classify_interneuron(file = file, layer  = '1')
#> The following checks have failed:
#>          name  pass
#> 3 Layer 2/3-6 FALSE
#> NULL
```

`gabaclassifier` will only classify a morphology reconstruction that passes the following quality checks:

-   Has both axon and dendrites
-   The axon is not interrupted
-   Has a soma
-   Nerites are attached to soma
-   Axonal length &gt; 3000 micrometers

So, it will not classify the following cell:

``` r
file <- system.file('extdata', 'C170501A2.swc', package = 'gabaclassifier')
classify_interneuron(file = file, layer  = '4')
#> The following checks have failed:
#>                     name  pass
#> 4 Has axon and dendrites FALSE
#> 5            Single axon FALSE
#> 6    Axon > 3000 microns FALSE
#> NULL
```

The underlying model has been trained and tested with rat somatosensory cortex interneurons (see below). Classifying interneurons from other species, brain area etc. may be less reliable.

Model
=====

The classification is based on a model trained in a supervised fashion. The model is a random forest with 2000 trees trained on 503 cells with 74 morphometrics for each. The morphometrics were computed with the `neuorstrplus` and `neurostr` packages. All cells are hind-limb somatosensory cortex interneurons from two-week-old male Wistar rats reconcstructed by the Markam laboratory. The ids of the cells are available with `gabaclassifier:::cell_ids`. The cells are from layers L2/3, L4, L5, or L6 cell and fullfill the above-listed morphology quality criteria.

The 10-fold cross-validated accuracy of the model is 0.7015649. The types with highest sensitivity are Martinotti, Large basket, and nest basket. The model in unable to recognizes bitufted cells.

|     |  BTC|  ChC|  DBC|  LBC|   MC|  NBC|  SBC|  sensitivity|
|-----|----:|----:|----:|----:|----:|----:|----:|------------:|
| BTC |    5|    0|    1|   17|    8|    4|    1|        0.139|
| ChC |    0|   11|    0|    1|    0|    0|    6|        0.611|
| DBC |    0|    1|   22|    4|    5|    0|    0|        0.688|
| LBC |    3|    0|    1|  118|   12|   19|    4|        0.752|
| MC  |    1|    0|    0|   15|  100|    1|    1|        0.847|
| NBC |    0|    0|    0|   22|    0|   65|    4|        0.714|
| SBC |    0|    1|    1|    7|    3|    4|   35|        0.686|
