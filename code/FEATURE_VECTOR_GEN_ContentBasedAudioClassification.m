clc;clear all;close all;
Trunc = 0.1; % .1 * Fs = 400  msec to be Truncated From Either Side of Audio Signal.
%% Feature Generation For Training A.
load 'Data Set\HeartData_Training_A.mat';
% X = X1;
% clear X1;
Perc = [];
CepsL = [];
for i = 1 : size(X,2)
    y = X(1:L(i) , i);        
    y = y(Trunc*Fs(i) : length(y)-Trunc*Fs(i));
    subplot(1,2,1)
    plot(y);
    y_smooth =  HeartBeatSmooth(y,Fs(i));   
    subplot(1,2,2)
    plot(y_smooth);
    [Perc_i, CepsL_i] = FeatureExtract(y_smooth, Fs(i));
    Perc = [ Perc , Perc_i];
    CepsL = [CepsL , CepsL_i];
end
save ('Training_A_PercCepsL_FeatureMatrix.mat' , 'Perc', 'CepsL' ,'Y');
clear Perc Perc_i CepsL CepsL_i i Fs L  y X Y y_smooth


%% Feature Generation For Training B.
load 'Data Set\HeartData_Training_B.mat';
Perc = [];
CepsL = [];
for i = 1 : size(X,2)
    y = X(1:L(i) , i);        
    y = y(Trunc*Fs(i) : length(y)-Trunc*Fs(i));
    y_smooth =  HeartBeatSmooth(y,Fs(i));    
    [Perc_i, CepsL_i] = FeatureExtract(y_smooth, Fs(i));
    Perc = [ Perc , Perc_i];
    CepsL = [CepsL , CepsL_i];
end
save ('Training_B_PercCepsL_FeatureMatrix.mat' , 'Perc', 'CepsL' ,'Y');
clear Perc Perc_i CepsL CepsL_i i Fs L  y X Y y_smooth


%% Feature Generation For Training C.
load 'Data Set\HeartData_Training_C.mat';
Perc = [];
CepsL = [];
for i = 1 : size(X,2)
    y = X(1:L(i) , i);        
    y = y(Trunc*Fs(i) : length(y)-Trunc*Fs(i));
    y_smooth =  HeartBeatSmooth(y,Fs(i));    
    [Perc_i, CepsL_i] = FeatureExtract(y_smooth, Fs(i));
    Perc = [ Perc , Perc_i];
    CepsL = [CepsL , CepsL_i];
end
save ('Training_C_PercCepsL_FeatureMatrix.mat' , 'Perc', 'CepsL' ,'Y');
clear Perc Perc_i CepsL CepsL_i i Fs L  y X Y y_smooth

%% Feature Generation For Training D.
load 'Data Set\HeartData_Training_D.mat';
Perc = [];
CepsL = [];
for i = 1 : size(X,2)
    y = X(1:L(i) , i);        
    y = y(Trunc*Fs(i) : length(y)-Trunc*Fs(i));
    y_smooth =  HeartBeatSmooth(y,Fs(i));    
    [Perc_i, CepsL_i] = FeatureExtract(y_smooth, Fs(i));
    Perc = [ Perc , Perc_i];
    CepsL = [CepsL , CepsL_i];
end
save ('Training_D_PercCepsL_FeatureMatrix.mat' , 'Perc', 'CepsL' ,'Y');
clear Perc Perc_i CepsL CepsL_i i Fs L  y X Y y_smooth

%% Feature Generation For Training E.
load 'Data Set\HeartData_Training_E1.mat';
X = X1;
Y1 = Y;
clear X1;
Perc = [];
CepsL = [];
for i = 1 : size(X,2)
    y = X(1:L(i) , i);        
    y = y(Trunc*Fs(i) : length(y)-Trunc*Fs(i));
    y_smooth =  HeartBeatSmooth(y,Fs(i));    
    [Perc_i, CepsL_i] = FeatureExtract(y_smooth, Fs(i));
    Perc = [ Perc , Perc_i];
    CepsL = [CepsL , CepsL_i];
end

load 'Data Set\HeartData_Training_E2.mat';
X = X2;
Y2 = Y;
clear X2;
for i = 1 : size(X,2)
    y = X(1:L(i) , i);        
    y = y(Trunc*Fs(i) : length(y)-Trunc*Fs(i));
    y_smooth =  HeartBeatSmooth(y,Fs(i));    
    [Perc_i, CepsL_i] = FeatureExtract(y_smooth, Fs(i));
    Perc = [ Perc , Perc_i];
    CepsL = [CepsL , CepsL_i];
end
Y = [Y1;Y2];
save ('Training_E_PercCepsL_FeatureMatrix.mat' , 'Perc', 'CepsL' ,'Y');
clear Perc Perc_i CepsL CepsL_i i Fs L  y X Y y_smooth

%% Feature Generation For Training F.
load 'Data Set\HeartData_Training_F.mat';
Perc = [];
CepsL = [];
for i = 1 : size(X,2)
    y = X(1:L(i) , i);        
    y = y(Trunc*Fs(i) : length(y)-Trunc*Fs(i));
    y_smooth =  HeartBeatSmooth(y,Fs(i));    
    [Perc_i, CepsL_i] = FeatureExtract(y_smooth, Fs(i));
    Perc = [ Perc , Perc_i];
    CepsL = [CepsL , CepsL_i];
end
save ('Training_F_PercCepsL_FeatureMatrix.mat' , 'Perc', 'CepsL' ,'Y');
clear Perc Perc_i CepsL CepsL_i i Fs L  y X Y y_smooth