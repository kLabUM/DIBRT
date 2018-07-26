% Compare CSO measured and simulated 
% author: Yao Hu, 05/09/2018, U-M

clc; clear; close all;

nodes_relevant = {'1:2,8,6'};

formatin = 'dd-mmm-yyyy';

for i = 1 : length(nodes_relevant)
    % save the data into the file
    relv_nodes = strsplit(nodes_relevant{i}, ':');
    node = relv_nodes{1};
    inflow_file = 'test_data.csv';
    fileID = fopen(inflow_file);
    formatSpec = strcat(repmat(' %f', 1, 13));
    old_inflow_data = textscan(fileID, formatSpec, 'Delimiter', ',');
    fclose(fileID);
  
    new_inflow_data = cell2mat(old_inflow_data); 
    
    % modelled value
    simData = new_inflow_data(:, 2);
     
    % children node
    cNode = 1;
    % parent node
    pNode = [];
    
    relv = strsplit(relv_nodes{2}, ',');
        
    for j = 1 : length(relv)
        pNode = [pNode, str2num(relv{j})];
    end
    
    pData = new_inflow_data(:, pNode);
    cData = new_inflow_data(:, cNode);
    
    simData = simData(~isnan(cData), :);
    pData = pData(~isnan(cData), :);
    cData = cData(~isnan(cData));
    
    trlen = ceil(length(pData)*0.6);
    
    if ~isempty(trlen)
        
        rng(5); % for reproducibility
        
        % 5-fold cross-validation
        XData = pData(1:trlen, :);
        YData = cData(1:trlen, :);
       
        brt = RegressionTree.template('MinLeaf', 3);
        % 200 ensemble models and learn rate is 0.01
        mdl = fitensemble(XData, YData, 'LSBoost', 200, brt, 'LearnRate', 0.01);
        predicted = predict(mdl, pData);
          
    end
    
   
    figure      
    plot(cData, '-b', 'LineWidth', 2.0);
    hold on
    plot(simData, '-k', 'LineWidth', 2.0);
    hold on
    plot(predicted, '-r', 'LineWidth', 2.0);
end



