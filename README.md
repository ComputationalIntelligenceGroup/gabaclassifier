# WHAT 

- gabaquantify. includes gaba check.  
- gabaclassify 
- documentation of the process  
- layer cannot be optional because it is in the models already!! nothing is optional. 

# notes:

# var names identical for modelling to be possible
  # **fun** <- 'list_branch_usable_measures'
  # not relevant. extra columns do no harm.

# Issues
- **Quitar metadata de aqui, tb por el asunto de licencia**
- NeuroSTR: the expanded path bug

### CORREGIR EL NOMBRE DE LA NEURON EN NEUROSTRCPP. En la fila de NEUROSTRCPP.
### check: compute_prob_translaminair
# about a 1000 cells at neuromorpho. use them!!!
  computed at /code/bbp-data/json/neurostr-current2
# meta is actually not needed for prediction. maybe i will remove it.
# licence of blue brain data??? write to epfl people.
# licence: gpl because of rcpp? 

- copy code form neurostrrr to neuroimm: e.g., neurostrr::extend_xyz
- one thing is client, another thing is my extravariables. or add that to neurostr. 

# todo: check: no columns missing wrt to the dataset model was trained with. maybe can access it through model object.

# TODO uncomment above in format_variables
  
- Check for cell quality. Does it have basic characteristics of it? 
- Could I include neuroSTR headers in an R package? That would not be too hard to achieved. 
- It could be called NeuroSTR+. It could have all the things together.  

- Module 1: NeuroSTR + for computing the features. 
    - Checking of reconstruction and computing of features. 
    - Even if I have NeuroSTR in the headers, users will need to have headers in order to compile the package. It won't work, unless I somehow do it with BH and with RcppEigen. Otherwise, it won't work so easily. 
    - It might work that way, only that I might need to change the headers to use RcppEigen instead of Eigen and such 
    - However, Filesystem and Program options seem to be binaries. That is a problem for Rcpp headers, right?
    - I could have a subset of NeuroSTR in my project. 
    - An alternative is to make an rcpp wrapper for neurostr, but it would still require installing boost libraries.  
    - Uses C++14. A guide  by Sergio on this? 
    - Quizas puedo pedir ayuda a Mario con esto?
    - Filesystem is also included as a header library there

    - Maybe I do not need cmake to compile neurostr for my own need 
    - I can make a shiny interface but will not deploy it online. 

    Plan: 
    - Make the function to upload and classify a neuron, given a path 
    - Then compute that neurons features 
    - Then finally call neurostr to get that done. 
    - Basically, when this is cleaned, I could re-organize bmc paper code 
    - Si veo que no puedo, pedire ayuda de Mario.  


    - Calling neuroSTR:
        - Having the enormous SWC file is probably not pragmatic. I need a single function entry point for a neuron to compute its features. That function will then call NeuroSTR in some way.  
        - But maybe I do not need the installables of NeuroSTR if I call it for a single SWC. But yeah, the code is called for a single SWC. And it produces a json. But it would be easier to just skip the installable and just get functions directly. Would be much better. 

    - calling neurostr binary requires installing it. also adding my own custom code from the binaries.
    - get weight, height, etc, per feature. get a json or a vector per neuron. then have to summarize them by arbor. that is done in my own code.
    - so, basically, i could get the neurostrr output in some format, json or a list of whatever, and then format it with my own code. 
    - i think it reads json as a single row in a data set 
    - neurostr add some additional information to the code. I could add this into neurostr. 
        - basically, neurostr is the hard code 
        - the neurostr is my r code working on the binaries and input from neurostr 

    - Module 2: the model of interneurons. Previously trained model. 
    - Trained model learned from data. This will be an object, some kind of a model with its parameters set. Or will call for re-learning each time? It could be saved on disc or simply in the package as data, and then re-called whenever I needed this data to re-appear. 
    - Thus, I need to provide this final model. This final model need not be part of the package. But it can be, for transparency. 

- Module 3:
    - Model training. The comparison and performance of multiple models. 

- Module 4 (optional): 
    - Make a shiny interface 



