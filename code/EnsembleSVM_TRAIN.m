%% FUNCTION TO TRAIN ENSEMBLE SVM ON COMPLETE DATA.
% INPUTS:  1. DATA   => DATA POINTS AS COLUMNS.
%          2. TARGET => Column Vector of Binary Labels i.e. {-1,+1}
%          3. C      => Box Constraint
%          4. L      => Kernel Scale
%          5. kFold  => kFold for Validation
% OUTPUTS: 1. SVMModel_1
%          2. SVMModel_2
%          3. SVMModel_3


function [SVMModel_1, SVMModel_2, SVMModel_3] = ...
            EnsembleSVM_TRAIN( DATA, TARGET, Kernel, C, L, Standardisation)
    
 
        DATA_NEG = DATA(:, find(TARGET == -1));
        DATA_POS = DATA(:, find(TARGET ==  1));
        TARGET_POS = ones( 1, size( DATA_POS,2));

        No_Of_Partitions = 3;
        Partition = floor(size(DATA_NEG,2)/No_Of_Partitions);
        
        % kFold TRAINING DATA 1
        DATA_NEG1 = DATA_NEG(: , 1:Partition);
        TARGET_NEG1 = -1 * ones( 1, size( DATA_NEG1,2));
        TRAINING_DATA1 = [ DATA_NEG1 , DATA_POS ] ;
        TARGET_DATA1 =  [ TARGET_NEG1 , TARGET_POS];

        % kFold TRAINING DATA 2
        DATA_NEG2 = DATA_NEG(: , Partition+1:2*Partition);
        TARGET_NEG2 = -1 * ones( 1, size( DATA_NEG2,2));
        TRAINING_DATA2 = [ DATA_NEG2 , DATA_POS ] ;
        TARGET_DATA2 =  [ TARGET_NEG2 , TARGET_POS];

        % kFold TRAINING DATA 3
        DATA_NEG3 = DATA_NEG(: , 2*Partition+1:end);
        TARGET_NEG3 = -1 * ones( 1, size( DATA_NEG3,2));
        TRAINING_DATA3 = [ DATA_NEG3 , DATA_POS ] ;
        TARGET_DATA3 =  [ TARGET_NEG3 , TARGET_POS];
        

        % Training Ensemble of SVM
         SVMModel_1 = fitcsvm(TRAINING_DATA1', TARGET_DATA1','Standardize',...
            Standardisation(1,:),'KernelFunction',Kernel(1,:),'KernelScale',L(1), 'BoxConstraint' , C(1) );
        SVMModel_2 = fitcsvm(TRAINING_DATA2', TARGET_DATA2','Standardize',...
            Standardisation(2,:),'KernelFunction',Kernel(2,:),'KernelScale',L(2), 'BoxConstraint' , C(2) );
        SVMModel_3 = fitcsvm(TRAINING_DATA3', TARGET_DATA3','Standardize',...
            Standardisation(3,:),'KernelFunction',Kernel(3,:),'KernelScale',L(3), 'BoxConstraint' , C(3) );
       
        

    
    
end
