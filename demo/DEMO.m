clc; clear all; close all;
load('SVMModel.mat');

Trunc = 0.1;
AudioFiles = dir('*.wav');
for i = 1:length(AudioFiles)
    
    [y,Fs] = audioread(AudioFiles(i).name);
    y = y(Trunc*Fs : length(y)-Trunc*Fs);
    y_smooth =  HeartBeatSmooth(y,Fs);    
    [Perc, CepsL] = FeatureExtract(y_smooth, Fs);

    Perc_Normalized = bsxfun(@minus, Perc, mean_Perc);
    Perc_Normalized = bsxfun(@rdivide, Perc_Normalized, std_Perc);
    

    CepsL_Normalized = bsxfun(@minus, CepsL, mean_CepsL);
    CepsL_Normalized = bsxfun(@rdivide, CepsL_Normalized, std_CepsL);

    Predict = [Perc_Normalized; CepsL_Normalized];

    Target_Predicted  = EnsembleSVM_PREDICT( Predict, SVMModel_1, SVMModel_2, SVMModel_3);
    fprintf('PREDICTED CLASS OF %s = %d\n' , AudioFiles(i).name , Target_Predicted);
end