%% FUNCTION TO EVALUATE PERFORMANCE OF ENSEMBLE SVM
% INPUTS:  1. DATA   => DATA POINTS AS COLUMNS.
%          2. TARGET => Column Vector of Binary Labels i.e. {-1,+1}
%          3. C      => Box Constraint
%          4. L      => Kernel Scale
%          5. kFold  => kFold for Validation
%
% OUTPUTS: 1. kFold Validation Accuracy
%          2. kFold Confusion Matrix
%          3. SVMModel_1
%          4. SVMModel_2
%          5. SVMModel_3

function [ VALIDATION_ACCURACY, CONFUSION_MATRIX_VALIDATION , SVMModel_1, SVMModel_2, SVMModel_3] = ...
            EnsembleSVM_kFold_VALID( DATA , TARGET ,kFold, Kernel, C, L, Standardisation)
    
    FoldSize = floor(size(DATA,2)/kFold);
    VALIDATION_ACCURACY = [];
    CONFUSION_MATRIX_VALIDATION = [];
    
    per_sum = zeros(2,2);
    
    for i = 0: kFold-1
        if( i == kFold-1)
            idx_Validation = [i*FoldSize+1 , size(DATA,2)];

        else
            idx_Validation = [i*FoldSize+1 , i*FoldSize + FoldSize];
        end

        ValidationData_kFold   = DATA(:, idx_Validation(1)  :  idx_Validation(2) );
        ValidationTarget_kFold =    TARGET( idx_Validation(1)  :  idx_Validation(2) );

        TrainingData_kFold     = [ DATA(:, 1: idx_Validation(1)-1) , DATA(:, idx_Validation(2)+1:end) ];
        TraingingTarget_kFold  =    [ TARGET(  1: idx_Validation(1)-1) ; TARGET(idx_Validation(2)+1:end ) ];


        DATA_NEG = TrainingData_kFold(:, find(TraingingTarget_kFold == -1));
        DATA_POS = TrainingData_kFold(:, find(TraingingTarget_kFold ==  1));
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
       
        

        % Prediction on Validation Set. 
        Target_Predicted1 = predict( SVMModel_1 , ValidationData_kFold')';
        Target_Predicted2 = predict( SVMModel_2 , ValidationData_kFold')';
        Target_Predicted3 = predict( SVMModel_3 , ValidationData_kFold')';
        % Calculate Validation Accuracy.
        Target_Predicted = [Target_Predicted1 ; Target_Predicted2 ; ...
                     Target_Predicted3];%; Target_Predicted4];
        Target_Predicted = sum( Target_Predicted == 1 , 1);
        Target_Predicted = ( Target_Predicted > 1 ) + 0;
        Target_Predicted( Target_Predicted == 0) = -1;

        Error = 1/2* abs(ValidationTarget_kFold - Target_Predicted');
        Error = sum(Error)/ length(Error);
        Accuracy = (1 - Error)*100;
        VALIDATION_ACCURACY = [ VALIDATION_ACCURACY , Accuracy ];
        
        % Calculating Confusion Matrix.
        T = ValidationTarget_kFold' ;
        U = Target_Predicted;
        T = (T==1);
        U = (U==1);
        [conf , order] = confusionmat(T,U);
        
        
        plotconfusion(T,U);
        per_sum  = per_sum + conf;
    end

    VALIDATION_ACCURACY = mean( VALIDATION_ACCURACY);
    CONFUSION_MATRIX_VALIDATION = [per_sum(1,1) , per_sum(1,2) ; per_sum(2,1) , per_sum(2,2)]/kFold;
    CONFUSION_MATRIX_VALIDATION = per_sum' / kFold;
    
    
    
end
