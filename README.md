<!-- README.md is generated from README.Rmd. Please edit that file -->
Issues
======

-   **pkg descrption**
-   **Maybe also include the training functions here, also the trainig dataset, with the list of used cells.**
-   **apply theta\_complement? maybe it could change the results a lot!!** does it just apply to torque?
-   Poner detalles sobre el modelo y su accuracy

Overview
========

`gabaclassifier` classifies a given neuronal morphology into one of **eight** types, such as Chandelier or Martinotti. The following classifies cell C030502A as a nest basket cell.

``` r
library(gabaclassifier) 
file <- system.file('extdata', 'C030502A.swc', package = 'gabaclassifier')
classify_interneuron(file = file, layer  = '23')
#>   1 
#> NBC 
#> Levels: BTC ChC DBC LBC MC NBC SBC
```

The mapping from the abbreviated output to the full type name is

``` r
# full_class_name('NBC')
```

names. have it somewhere for sure.

The output is one of the following type labels:

``` r
# do this code inlune 
```

Chandelier, Martinotti, ... It is simple to use. **With function and abbrevs**

Installing
==========

`gabaclassifier` requires `neurostr` and `neurostrplus` to be installed. The following installs all three packages (install the `devtools` package with `install.package('devtools')` if you don't have it):

``` r
# install.package('devtools')
devtools::install_github("neurostr")
devtools::install_github("neurostrplus")
devtools::install_github("gabaclassifier") 
```

These packages have only been tested on Ubuntu 16.04.

Usage
=====

Cells are classified with the `classify_interneuron` function. The inputs are

-   A path to a SWC reconstruction of a neuron morphology
-   The layer containing the cell's soma

The path must be fully expanded, that is `/home/user/neuron.swc` while work while `~/neuron.swc` will not.

The model has been trained with layer L2/3 to layer L6 interneurons and thus only interneurons from those layers are allowed as input to `classify_interneuron`.

``` r
classify_interneuron(file = file, layer  = '1')
#> The following checks have failed:
#>          name  pass
#> 3 Layer 2/3-6 FALSE
#> NULL
```

A cell will be classified as long as it

1.  An L2/3, L4, L5, or L6 cell
2.  Passes basics morphology quality such as It will not classify if some problems with morphology.

<!-- -->

    #>   short                long
    #> 1   BTC       Bitufted cell
    #> 2   ChC     Chandelier cell
    #> 3   DBC Double bouquet cell
    #> 4   LBC   Large basket cell
    #> 5    MC     Martinotti cell
    #> 6   NBC    Nest basket cell
    #> 7   SBC   Small basket cell

Checks:
- has axon and dendrites, - attached to soma, - length &gt; 3000 and so on. Both at training and clasification.

Details
=======

gabaclassifier will classify any neuronal recontruction that passes the above criteria, assigning it into one of the mentioned classes. Since it was trained with male rat ... somatosensory cortex (see below), passing other species, area etc. interneurons may result in poorer prediction.

Model
=====

The model is random forest (**citation**) trained on **650** interneurons. The cells were L23 to L6...interneurons from the Markam laboratory. These were male ... The ids of the cells are provided in ... while laminar metadata is available in .

The 10-fold cross-validated accuracy of the model is XX%. The best predicted types are ChC, .. while types such as BTC and abv are herder to detec: **Show the confusion matrix.**
