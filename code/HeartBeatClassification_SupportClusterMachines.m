clc;clear all;close all;
%% Loading PhysioNet Feature Matrix 
    %  {-1 , 0 ,1} => { Normal, Unsure, Abnormal}
    load('PhysioNet_FeatureMatrix.mat');

%% FEATURE NORMALIZATION

    mean_Perc = mean(Perc,2);
    std_Perc = std( Perc, 0, 2);

    Perc_Normalized = bsxfun(@minus, Perc, mean_Perc);
    Perc_Normalized = bsxfun(@rdivide, Perc_Normalized, std_Perc);

    mean_CepsL = mean(CepsL, 2);
    std_CepsL = std( CepsL, 0, 2);

    CepsL_Normalized = bsxfun(@minus, CepsL, mean_CepsL);
    CepsL_Normalized = bsxfun(@rdivide, CepsL_Normalized, std_CepsL);


    s1 = sum(std( Perc, 0, 2));
    s2 = sum(std( CepsL, 0, 2));
    PercCepsL = [Perc_Normalized/s1 ; CepsL_Normalized/s2];

    DATA_PercCepsL = [ PercCepsL ; Y]';

    %Randominisg Feature MATRIX : DATA_PercCepsL
    L = size(DATA_PercCepsL,1);
    DATA_PercCepsL = DATA_PercCepsL(randperm(L,L),:);
    DATA_PercCepsL = DATA_PercCepsL(randperm(L,L),:);
    DATA_PercCepsL = DATA_PercCepsL(randperm(L,L),:);




%% CLUSTERING THE NEGATIVE MAJORITY CLASS INTO N = 5 CLUSTERS.
    N = 5;
    DATA = DATA_PercCepsL(:,1:end-1)';
    TARGET = DATA_PercCepsL(:,end);

    DATA_NEG = DATA(:, find(TARGET == -1)');
    DATA_POS = DATA(:, find(TARGET ==  1));
    TARGET_POS = ones( 1, size( DATA_POS,2));

    Cluster_idx = kmeans( DATA_NEG' , N);

    % CLUSTER NO. 1
    DATA_NEG_CLUSTER1 = DATA_NEG(: , find(Cluster_idx ==1));
    TARGET_CLUSTER1 = -1 * ones( 1, size(DATA_NEG_CLUSTER1,2));
    TRAINING_DATA1 = [DATA_NEG_CLUSTER1 , DATA_POS]; 
    TARGET_DATA1 =   [ TARGET_CLUSTER1 , TARGET_POS];

    % CLUSTER NO. 2
    DATA_NEG_CLUSTER2 = DATA_NEG(: , find(Cluster_idx ==2));
    TARGET_CLUSTER2 = -1 * ones( 1, size(DATA_NEG_CLUSTER2,2));
    TRAINING_DATA2 = [DATA_NEG_CLUSTER2 , DATA_POS]; 
    TARGET_DATA2 =   [ TARGET_CLUSTER2 , TARGET_POS];

    % CLUSTER NO. 3
    DATA_NEG_CLUSTER3 = DATA_NEG(: , find(Cluster_idx ==3));
    TARGET_CLUSTER3 = -1 * ones( 1, size(DATA_NEG_CLUSTER3,2));
    TRAINING_DATA3 = [DATA_NEG_CLUSTER3 , DATA_POS]; 
    TARGET_DATA3 =   [ TARGET_CLUSTER3 , TARGET_POS];

%     % CLUSTER NO. 4
%     DATA_NEG_CLUSTER4 = DATA_NEG(: , find(Cluster_idx ==4));
%     TARGET_CLUSTER4 = -1 * ones( 1, size(DATA_NEG_CLUSTER4,2));
%     TRAINING_DATA4 = [DATA_NEG_CLUSTER4 , DATA_POS]; 
%     TARGET_DATA4 =   [ TARGET_CLUSTER4 , TARGET_POS];
%     
%     % CLUSTER NO. 5
%     DATA_NEG_CLUSTER5 = DATA_NEG(: , find(Cluster_idx ==5));
%     TARGET_CLUSTER5 = -1 * ones(1,  size(DATA_NEG_CLUSTER5,2));
%     TRAINING_DATA5 = [DATA_NEG_CLUSTER5 , DATA_POS]; 
%     TARGET_DATA5 =   [ TARGET_CLUSTER5 , TARGET_POS];





%% TRAINING ENSEMBLE OF SUPPORT VECTOR MACHINE CLASSIFIERS.
    C = 10000;
    L = 60;
    SVMModel_1 = fitcsvm(TRAINING_DATA1', TARGET_DATA1','Standardize',...
        true,'KernelFunction','RBF','KernelScale',L, 'BoxConstraint' , C );
    SVMModel_2 = fitcsvm(TRAINING_DATA2', TARGET_DATA2','Standardize',...
        true,'KernelFunction','RBF','KernelScale',L, 'BoxConstraint' , C );
    SVMModel_3 = fitcsvm(TRAINING_DATA3', TARGET_DATA3','Standardize',...
        true,'KernelFunction','RBF','KernelScale',L, 'BoxConstraint' , C );
    %SVMModel_4 = fitcsvm(TRAINING_DATA4', TARGET_DATA4','Standardize',...
    %   true,'KernelFunction','RBF','KernelScale',L, 'BoxConstraint' , C );
    %SVMModel_5 = fitcsvm(TRAINING_DATA5', TARGET_DATA5','Standardize',...
    %   true,'KernelFunction','RBF','KernelScale',L, 'BoxConstraint' , C );

    % TRAINING ACCURACY OF ENSEMBLE OF SVMs.
    Target_Predicted1 = predict( SVMModel_1 , DATA')';
    Target_Predicted2 = predict( SVMModel_2 , DATA')';
    Target_Predicted3 = predict( SVMModel_3 , DATA')';
    %Target_Predicted4 = predict( SVMModel_4 , DATA')';
    %Target_Predicted5 = predict( SVMModel_5 , DATA')';

    Target_Predicted = [Target_Predicted1 ; Target_Predicted2 ; ...
        Target_Predicted3];% ; Target_Predicted4]; Target_Predicted5];
    Target_Predicted = sum( Target_Predicted == 1 , 1);
    Target_Predicted = ( Target_Predicted > 2 ) + 0;
    Target_Predicted( Target_Predicted == 0) = -1;

    TrainingError = 1/2* abs(DATA_PercCepsL(:,end) - Target_Predicted');
    TrainingError = sum(TrainingError)/ length(TrainingError);
    TrainingAccuracy = (1 - TrainingError)*100;

    T = DATA_PercCepsL(:,end)' ;
    L = Target_Predicted;
    T = (T==1);
    L = (L==1);
    [~,~,~,per] = confusion( T , L);
    CONFUSION_MATRIX_TRAINING = [ per(1,3) , per(1,2) ; per(2,2) , per(2,3)]


    