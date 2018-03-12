
    If I allow for non rat cells, I will need to omit the laminar features!
    It is possibly easier to just install the shiny app with the software for computing the stuff on a random swc installed

- Check for cell quality. Does it have basic characteristics of it? 
- Could I include neuroSTR headers in an R package? That would not be too hard to achieved. 
- It could be called NeuroSTR+. It could have all the things together. 


- Module 1: NeuroSTR + for computing the features. 
    - Checking of reconstruction and computing of features. 
- Module 2: the model of interneurons. Previously trained model. 
    - Trained model learned from data. This will be an object, some kind of a model with its parameters set. Or will call for re-learning each time? It could be saved on disc or simply in the package as data, and then re-called whenever I needed this data to re-appear. 
    - Thus, I need to provide this final model. This final model need not be part of the package. But it can be, for transparency. 
- Module 3:
    - Model training. The comparison and performance of multiple models. 
- Module 4 (optional): 
    - Make a shiny interface 

