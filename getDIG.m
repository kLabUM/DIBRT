% Get Directed Information Graph
% author: Yao Hu, 05/09/2018, U-M

clc; clear; close all;
         
% save the data into the file
disp('Flow:');
inflow_file = 'test_data.csv';
inflow_data = load(inflow_file);

% get the graph structure 
[DI_opt, total_time] = getDIgraph(inflow_data');
