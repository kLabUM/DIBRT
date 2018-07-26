function modelvar = datafit(dataT, Y, par, Tmark)
% dataT: 'n' by 'm' matrix, 'n' is the number of time-steps, where 'm' is
% the number of processes;
% Y : the index in {1, .., m} of process looking at, 
% par : a vector of indices of parents we are considering, and 
% Tmark : the Markov order (can ignore it for now)
% Author: Yao Hu, 05/09/2018, U-M

xaxis = dataT(:, par);
yaxis = dataT(:, Y);
%% Train a Regression Tree 
rng(5); % for reproducibility

[m, n] = size(yaxis);
% tree-depth 4
t = RegressionTree.template('MinLeaf',4);
% 500 ensemble models and learn rate is 0.01
mdl = fitensemble(xaxis(1:m,:),yaxis(1:m,:),'LSBoost',500,t,'LearnRate',0.01);
modelvar = loss(mdl,xaxis(1:m,:),yaxis(1:m),'mode','ensemble');

end