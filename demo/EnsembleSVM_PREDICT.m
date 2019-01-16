%% FUNCTION TO PREDICT ENSEMBLE SVM CLASSIFIER OUTPUT
%
% INPUTS:  1. DATA   => DATA POINTS AS COLUMNS.
%          2. SVMModel_1 
%          3. SVMModel_2      
%          4. SVMModel_3      
%          
% OUTPUTS: 1. Target_Predicted Labels

function Target_Predicted  = EnsembleSVM_PREDICT( DATA, SVMModel_1, SVMModel_2,...
                       SVMModel_3)

    Target_Predicted1 = predict( SVMModel_1 , DATA')';
    Target_Predicted2 = predict( SVMModel_2 , DATA')';
    Target_Predicted3 = predict( SVMModel_3 , DATA')';
    
    Target_Predicted = [Target_Predicted1 ; Target_Predicted2 ; ...
        Target_Predicted3];

    Target_Predicted = sum( Target_Predicted == 1 , 1);
    Target_Predicted = ( Target_Predicted > 1 ) + 0;
    Target_Predicted( Target_Predicted == 0) = -1;
    
end