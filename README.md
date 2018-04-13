<!-- README.md is generated from README.Rmd. Please edit that file -->
gabaclassifier
==============

The goal of gabaclassifier is to ...

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
## basic example code
```

Installing
==========

It is straightforward from Github. `gabaclassifier` requires `neuroimm`, `neurostrr` to be installed from Github. - DEPENDS ON PKG neurostrplus and neurostr. - Intstall those via github

``` r
devtool::install_github()
devtool::install_github()
```

It has only been tested on Ubuntu 16.04.

Issues
======

-   **pkg descrption**
-   **Maybe also include the training functions here, also the trainig dataset, with the list of used cells.**
-   check package docs
-   **apply theta\_complement? maybe it could change the results a lot!!** does it just apply to torque?
-   Update description
-   Poner detalles sobre el modelo y su accuracy
-   Add morphology validation and checks. Filters for not suitable.
-   Anadir neuronas de ejemplo
-   Anadir vignette con ejemplos de uso

TOdo neurostr
=============

-   NeuroSTR: the expanded path bug
-   CORREGIR EL NOMBRE DE LA NEURON EN NEUROSTRCPP. En la fila de NEUROSTRCPP.
    --------------------------------------------------------------------------

    title: "GABAergic interneurons classifier" author: "Bojan Mihaljevic" date: "2018-04-12" output: rmarkdown::html\_vignette vignette: &gt; % % % ---

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

Usage
=====

Cells are classified with the `classify_interneuron` function. The inputs are

-   A path to a SWC reconstruction of a neuron morphology
-   The layer containing that cell

The model has only been trained with layer L2/3 to layer L6 interneurons and thus interneurons from those layers are allowed as input to `classify_interneuron`.

``` r
# show error Try with l1. 
```

The output is one of the following type labels:

``` r
# do this code inlune 
```

Chandelier, Martinotti, ... It is simple to use. **With function and abbrevs**

Details
=======

gabaclassifier will classify any neuronal recontruction that passes basic reconstruction quality checks That is, considered the most likely out of those. The layer information corresponds to male rat ... somatosensory cortex. It is important that the morphology is of sufficient quality, as `gabaclassifier` performs only basic checks. Not all morphologies are valid and basic checks are performed. If it is not indeed an interneuron, and so on. Checks: has axon and dendrites, attached to soma, length &gt; 3000 and so on. Both at training and clasification.

It will provide a classification for any output that passes that. So, if you pass a pyramidal neuron, it will slitt output a classification. Also, since it was trained with specific rat cells (see below), it might not be very correct with others.

Model
=====

The model is forest (**citation**) trained on **650** interneurons. The cells were L23 to L6...interneurons from the Markam laboratory. The ids of the cells are provided in ... The accuracy is 72%. **Show the confusion matrix.**
