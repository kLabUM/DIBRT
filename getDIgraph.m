function [DI_opt, total_time] = get_DIgraph(data)
% This function takes in a 'data' matrix that needs to be handled
% by a fitting function.  The output is a cell array, where 'DI_opt{Y}.par'
% is the parent set of Y. 
%
% 'data' should be m by n, where 'm' is the number of processes and 'n' is
% the number of time-steps

% Author: Chris Quinn, Tue, 05/06/2014, UIUC 
% Update: Yao Hu, Fri, 05/09/2014, UIUC

tstart = tic;
m = size(data,1);
n = size(data,2);

%'Tmark': coefficient
Tmark = 1; 
 


%% initialize DI
DI_opt = cell(m,1);

for Y = 1:m
    %The weight on the complete graph (to be fed to MWDST) of
    %I(X-->Y) where X is a set of processes including b
    DI_opt{Y}.par = []; %the set of parents that correspond to the maximal value
    DI_opt{Y}.val = []; %Yao: directed information    
end

for Y = 1  %1:m 
    j = 1;
    for X = 1:m
        if X~=Y          
            %now get DI  I(X --> Y||all else)  
            temp_par = 1:m;
            
            %remove the columns indexed by Y and X 
            temp_par([Y, X]) = [];
            
            %get mean error variance for full model
            sigma_est_full = datafit(data',Y,[X temp_par], Tmark);
            
            %get mean error variance for partial model
            temp_par(temp_par == X) = [];
            sigma_est_part = datafit(data',Y,temp_par, Tmark);
            
            
            % DI_val = 1/2*log(sigma_est_part/sigma_est_full);
            % edited by Yao
            DI_par(j) = X;
            DI_val(j) = 1/2*abs(log(sigma_est_part/sigma_est_full));
            
            % print_DI_value(Y,X,temp_par,DI_val);
            fprintf('%i -> %i : %i\n', X, Y, DI_val(j));
            %decide to add if it is above the MDL threshold (used to avoid overfitting)            
            MDL = Tmark*1/2*log2(n)/n;  % MDL = [m - (m-1)]* Tmark*1/2*log2(n)/n;
            
            if DI_val(j) <= MDL
                fprintf('\t below threshold %f \n',MDL);
            else
                DI_opt{Y}.par = [DI_opt{Y}.par X];
                % add by Yao
                DI_opt{Y}.val = [DI_opt{Y}.val DI_val(j)];
            end
            j = j + 1;
        end
    end
    
    fprintf('\n\n\t%i:',Y);
    [NDI_val, I_val] = sort(DI_val, 'descend');
    
    fprintf('\nDI in descending order:')
    for i = 1 : length(I_val)
        fprintf('%i,', DI_par(I_val(i)))
    end
    
    for i = 1:numel(DI_opt{Y}.par)
        fprintf('\npar: %i, val: %i', DI_opt{Y}.par(i), DI_opt{Y}.val(i))
    end
    
    fprintf('\n\n');

end

total_time = toc(tstart);

end




