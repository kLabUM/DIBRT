A data-driven approach using Directed Information and Boosted Regression Trees. By Yao Hu,
Don Scavia and Branko Kerkez. 2018-05-09

1. Open and run the getDIG.m: select the processes that have causal influence on the 
target process. A sample dataset, test_data is prepared for the test.
1.1. The getDIG.m calls two Matlab files in sequence: getDIgraph.m and datafit.m. For the 
detailed description of the files, please refer to the code comments.

2. Once the influential processes are selected, open the getRegression.m and put their indices 
in the variable, nodes_relevant in dictionary format. For example, when nodes_relevant = {'1:2,8,6'},
1 indicates the target process, and 2, 8 and 6 indicate the indices of the influential processes.
2.1 The amount of data for training and validation can be adjusted via the variable, trlen. In our case,
we used 60/40 split.
2.2 Three parameters can be adjusted to avoid overfitting, 'MinLeaf', 'LSBoost' and 'LearnRate'. 
For the details and usage of the parameters, please refer to the relevant Matlab document.
    
