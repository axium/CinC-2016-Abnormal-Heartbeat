clc;clear all; close all;
%% Concatenating all Feature Matrices.
%  Labels =>  {-1 , 0 ,1} => { Normal, Unsure, Abnormal}
%  Output => Perc, CepsL, Y 
%  Y = Row Vector of Labels.
PERC = [];
CEPSL =[];
LABEL = [];
load 'Training_A_PercCepsL_FeatureMatrix.mat';
    PERC = [ PERC , Perc];
    CEPSL = [CEPSL , CepsL];
    LABEL = [ LABEL ; Y];
load 'Training_B_PercCepsL_FeatureMatrix.mat';
    PERC = [ PERC , Perc];
    CEPSL = [CEPSL , CepsL];
    LABEL = [ LABEL ; Y];
load 'Training_C_PercCepsL_FeatureMatrix.mat';
    PERC = [ PERC , Perc];
    CEPSL = [CEPSL , CepsL];
    LABEL = [ LABEL ; Y];
load 'Training_D_PercCepsL_FeatureMatrix.mat';
    PERC = [ PERC , Perc];
    CEPSL = [CEPSL , CepsL];
    LABEL = [ LABEL ; Y];
load 'Training_E_PercCepsL_FeatureMatrix.mat';
    PERC = [ PERC , Perc];
    CEPSL = [CEPSL , CepsL];
    LABEL = [ LABEL ; Y];
load 'Training_F_PercCepsL_FeatureMatrix.mat';
    PERC = [ PERC , Perc];
    CEPSL = [CEPSL , CepsL];
    LABEL = [ LABEL ; Y];

    
clear Perc CepsL Y;
Perc = PERC;
CepsL = CEPSL;
Y = LABEL;
clear PERC CEPSL LABEL;
Y = Y';
[row, col] = find( CepsL == -Inf);
CepsL(: , col) = [];
Perc(: , col) = [];
Y( : , col ) = [];

save( 'PhysioNet_FeatureMatrix.mat' , 'Perc', 'CepsL', 'Y');