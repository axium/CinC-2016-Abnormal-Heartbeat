%% Generate .mat Files from training-a,b,c,d,e,f.
% X = Data Matrix with Each Column is an Audio Signal.
% Y = Labels => {-1,0,+1} for { Normal , Unsure , AbNormal}.
% L = Length of the Audio Signal in each Column.
% Fs = Sampling Frequency of each Audio File.

clc;clear all;close all;
%% TRAINING-A:
AudioFiles = dir('training-a\*.wav');
load('Y_a.mat');
oldFolder = cd( 'training-a');
X = [];
L = [];
Fs = [];

[x, fs] = audioread(AudioFiles(1).name);
X = [X , x];
L = [L , length(x)];
Fs = [Fs , fs];

for i=2:length(AudioFiles)
    [x, fs] = audioread(AudioFiles(i).name);
    l = size(x,1);
    S = size(X,1);
    if  l >= S
        X = [X; zeros(l-S , size(X,2))];
    elseif  l<S            
        x = [x ; zeros(abs(S-l) , 1)];
    end
    X = [X , x];
    L = [L , l];
    Fs = [Fs , fs];
end

cd(oldFolder);
save('HeartData_Training_A.mat' , 'X', 'L', 'Fs', 'Y');
clear all;

%% TRAINING-B:
AudioFiles = dir('training-b\*.wav');
load('Y_b.mat');
oldFolder = cd( 'training-b');
X = [];
L = [];
Fs = [];

[x, fs] = audioread(AudioFiles(1).name);
X = [X , x];
L = [L , length(x)];
Fs = [Fs , fs];

for i=2:length(AudioFiles)
    [x, fs] = audioread(AudioFiles(i).name);
    l = size(x,1);
    S = size(X,1);
    if  l >= S
        X = [X; zeros(l-S , size(X,2))];
    elseif  l<S            
        x = [x ; zeros(abs(S-l) , 1)];
    end
    X = [X , x];
    L = [L , l];
    Fs = [Fs , fs];
end

cd(oldFolder);
save('HeartData_Training_B.mat' , 'X', 'L', 'Fs', 'Y');
clear all;

%% TRAINING-C:
AudioFiles = dir('training-c\*.wav');
load('Y_c.mat');
oldFolder = cd( 'training-c');
X = [];
L = [];
Fs = [];

[x, fs] = audioread(AudioFiles(1).name);
X = [X , x];
L = [L , length(x)];
Fs = [Fs , fs];

for i=2:length(AudioFiles)
    [x, fs] = audioread(AudioFiles(i).name);
    l = size(x,1);
    S = size(X,1);
    if  l >= S
        X = [X; zeros(l-S , size(X,2))];
    elseif  l<S            
        x = [x ; zeros(abs(S-l) , 1)];
    end
    X = [X , x];
    L = [L , l];
    Fs = [Fs , fs];
end

cd(oldFolder);
save('HeartData_Training_C.mat' , 'X', 'L', 'Fs', 'Y');
clear all;

%% TRAINING-D:
AudioFiles = dir('training-d\*.wav');
load('Y_d.mat');
oldFolder = cd( 'training-d');
X = [];
L = [];
Fs = [];

[x, fs] = audioread(AudioFiles(1).name);
X = [X , x];
L = [L , length(x)];
Fs = [Fs , fs];

for i=2:length(AudioFiles)
    [x, fs] = audioread(AudioFiles(i).name);
    l = size(x,1);
    S = size(X,1);
    if  l >= S
        X = [X; zeros(l-S , size(X,2))];
    elseif  l<S            
        x = [x ; zeros(abs(S-l) , 1)];
    end
    X = [X , x];
    L = [L , l];
    Fs = [Fs , fs];
end

cd(oldFolder);
save('HeartData_Training_D.mat' , 'X', 'L', 'Fs', 'Y');
clear all;

%% TRAINING-E:
AudioFiles = dir('training-e\*.wav');
load('Y_e.mat');
oldFolder = cd( 'training-e');
X = [];
L = [];
Fs = [];

[x, fs] = audioread(AudioFiles(1).name);
X = [X , x];
L = [L , length(x)];
Fs = [Fs , fs];

for i=2:length(AudioFiles)
    [x, fs] = audioread(AudioFiles(i).name);
    l = size(x,1);
    S = size(X,1);
    if  l >= S
        X = [X; zeros(l-S , size(X,2))];
    elseif  l<S            
        x = [x ; zeros(abs(S-l) , 1)];
    end
    X = [X , x];
    L = [L , l];
    Fs = [Fs , fs];
end

cd(oldFolder);
save('HeartData_Training_E.mat' , 'X', 'L', 'Fs', 'Y');
clear all;

%% TRAINING-F:
AudioFiles = dir('training-f\*.wav');
load('Y_f.mat');
oldFolder = cd( 'training-f');
X = [];
L = [];
Fs = [];

[x, fs] = audioread(AudioFiles(1).name);
X = [X , x];
L = [L , length(x)];
Fs = [Fs , fs];

for i=2:length(AudioFiles)
    [x, fs] = audioread(AudioFiles(i).name);
    l = size(x,1);
    S = size(X,1);
    if  l >= S
        X = [X; zeros(l-S , size(X,2))];
    elseif  l<S            
        x = [x ; zeros(abs(S-l) , 1)];
    end
    X = [X , x];
    L = [L , l];
    Fs = [Fs , fs];
end

cd(oldFolder);
save('HeartData_Training_F.mat' , 'X', 'L', 'Fs', 'Y');
clear all;
