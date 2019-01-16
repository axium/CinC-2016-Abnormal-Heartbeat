clc;clear all;close all;
%% Loading PhysioNet Feature Matrix 
    %  {-1 , 0 ,1} => { Normal, Unsure, Abnormal}
    load('PhysioNet_FeatureMatrix.mat');

%% DIVIDING DATA INTO TRAINING AND TESTING
    
    TestDataSize = 0;
    
    L = size(Perc,2);
    for i = 1:50
        ReOrder = randperm(L,L);
        Perc = Perc( : , ReOrder);
        CepsL = CepsL( : , ReOrder);
        Y = Y( : , ReOrder);
    end
    
    Perc_Testing  =  Perc(: , end-TestDataSize+1:end);
    CepsL_Testing =  CepsL(: , end-TestDataSize+1:end);
    Y_Testing     =  Y(: , end-TestDataSize+1:end);
    
    
    Perc = Perc(: , 1: end-TestDataSize);
    CepsL = CepsL(:, 1: end-TestDataSize);
    Y = Y( 1: end - TestDataSize);
    
%% NORMALIZING
    mean_Perc = mean(Perc,2);
    std_Perc = std( Perc, 0, 2);

    mean_CepsL = mean(CepsL, 2);
    std_CepsL = std( CepsL, 0, 2);
    
    Perc_Normalized = bsxfun(@minus, Perc, mean_Perc);
    Perc_Normalized = bsxfun(@rdivide, Perc_Normalized, std_Perc);

    
    CepsL_Normalized = bsxfun(@minus, CepsL, mean_CepsL);
    CepsL_Normalized = bsxfun(@rdivide, CepsL_Normalized, std_CepsL);


    s1 = 1;%sum(std( Perc_Normalized, 0, 2));
    s2 = 1;%sum(std( CepsL_Normalized, 0, 2));
    
    PercCepsL = [Perc_Normalized/s1 ; CepsL_Normalized/s2];
    
%% SMOTE UPSAMLPING OF MINORITY CLASS
    [PercCepsL , Y] = SMOTE( PercCepsL' , Y');
    PercCepsL = PercCepsL';
    DATA_PercCepsL = [ PercCepsL ; Y']';

    %Randominisg Feature MATRIX : DATA_PercCepsL
    L = size(DATA_PercCepsL,1);
    for i = 1: 20
        DATA_PercCepsL = DATA_PercCepsL(randperm(L,L),:);
    end

  %Max_Normalize =  max(DATA_PercCepsL(:,1:end-1),[], 1);
  %DATA_PercCepsL(:,1:end-1) = bsxfun( @rdivide, DATA_PercCepsL(:,1:end-1) , Max_Normalize);

%% TRAINING AND VALIDATION OF ENSEMBLE SVM.
%  TRAINING DATA =  DATA
%  TRAINING LABELS = TARGET
%  WORKS OK FOR DATA SIZE = 3218. CHECK FOR ANY ELSE.


DATA = DATA_PercCepsL(:,   1:end-1)';
TARGET = DATA_PercCepsL(: , end);

kFold = 10;
% BEST RESULT C = 100,L = 7.01 FOR 3 SVM CLASSIFIERS. RESULT = 90 TP & 75 => STANDARDISATION ON TN
% BEST RESUKT C=100, L =7.01 LINEAR KERNEL => 80 TP and 80 FN ACCURACY STANDARDISATION ON
C = 100;
Kernel = 'RBF';
L = 3.04;
Standardisation= 'on';

%SVMModel = fitcsvm(DATA, TARGET,'Standardize',...
%           Standardisation,'KernelFunction',Kernel,'KernelScale',L, 'BoxConstraint' , C );
       
%% TRAINING THE SELECTED MODEL ON ALL THE DATA.

SVMModel = fitcsvm(DATA', TARGET,'Standardize',...
           Standardisation,'KernelFunction',Kernel,'KernelScale',L, 'BoxConstraint' , C );
 



%% TESTING THE ACCURACY OF TRAINED MODEL
% 
%     Perc_Normalized = bsxfun(@minus, Perc_Testing, mean_Perc);
%     Perc_Normalized = bsxfun(@rdivide, Perc_Normalized, std_Perc);
% 
%     CepsL_Normalized = bsxfun(@minus, CepsL_Testing, mean_CepsL);
%     CepsL_Normalized = bsxfun(@rdivide, CepsL_Normalized, std_CepsL);
%  
%     PercCepsL = [Perc_Normalized/s1 ; CepsL_Normalized/s2];
% 
%     DATA_PercCepsL = [ PercCepsL ; Y_Testing]';    
% 
%     
% %   ENSEMBLE SVM PREDICTION ON TEST DATA
%     DATA = DATA_PercCepsL(:, 1:end-1)';
%     TARGET = DATA_PercCepsL(:, end);
% 
%     
%     Target_Predicted =  predict( SVMModel, DATA')';
%     TestingError = 1/2* abs(TARGET - Target_Predicted');
%     TestingError = sum(TestingError)/ length(TestingError);
%     TestingAccuracy = (1 - TestingError)*100;
% 
%     T = TARGET' ;
%     L = Target_Predicted;
%     T = (T==1);
%     L = (L==1);
%     plotconfusion(T,L)
% 

