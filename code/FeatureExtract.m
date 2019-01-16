function [Perc, CepsL] = FeatureExtract(y_smooth , Fs)
%% BASED ON RESEARCH PAPER: 'Content-Based Audio Classification and Retrieval by Support Vector Machines'
%              By: Guodong Guo and Stan Z. Li ...IEEE TRANSACTIONS ON NEURAL NETWORKS, VOL. 14, NO. 1, JANUARY 2003
% Frame is of 256 Samples. i.e 64ms. with 25% overlap i.e. 64Samples=>16ms
% 50ms => Min. Split Time. => FrameSize=200
    L = length(y_smooth);
    FrameSize = 256;%256; % Keep it Even. But do IT FOR ODD. PREFFERED
    OverLap = 0.25 * FrameSize;%64;
    Frames = buffer( y_smooth, FrameSize, OverLap);
    HammingWindow = hamming(FrameSize);
    Frames = bsxfun(@times, Frames,HammingWindow);


%% Silent_Frames & Silent_Ratio Feature: Detecting Silent Frames using Energy
    Threshold = 0.085;
    EnergyOfFrames = sum( abs(Frames).^2 , 1);
    Silent_Frames = zeros(1,size(EnergyOfFrames,2));
    Silent_Frames( EnergyOfFrames < Threshold) = 1;
    Silent_Ratio = sum( Silent_Frames) / size(EnergyOfFrames,2);
%% LogTotalSpectrumPower Feature: Total Spectrum Power.
    Fourier_Frames = fftshift(fft(Frames,[],1));
    L =  size(Fourier_Frames,1);
    f_frame = -L/2:1:(L-1)/2; % Row Vector of freq. corresponding to Columns in Fourier_Frames.
    f_frame = f_frame * Fs/(L-1);
    TotalSpectrumPower = 1/2 * sum( abs(Fourier_Frames).^2, 1);
    LogTotalSpectrumPower = log(TotalSpectrumPower);

%% Feature: Subband Powers.
    Fourier_Frames_PosFreq = Fourier_Frames(end/2+1:end , :);
    f_frame_PosFreq = f_frame(end/2+1:end); % Row Vector of freq. corresponding to Columns in Fourier_Frames_PosFreq.
    %Fourier_Frames_PosFreq_Truncated = 
    f0 = size(Fourier_Frames_PosFreq,1);
    Fourier_Frames_1stBand = Fourier_Frames_PosFreq(1:f0/8, :);
    Fourier_Frames_2ndBand = Fourier_Frames_PosFreq(f0/8+1:f0/4,:);
    Fourier_Frames_3rdBand = Fourier_Frames_PosFreq(f0/4+1:f0/2,:);
    Fourier_Frames_4thBand = Fourier_Frames_PosFreq(f0/2+1:f0,:);

    log_Fourier_Frames_1stBand = log(sum(abs(Fourier_Frames_1stBand).^2, 1));
    log_Fourier_Frames_2ndBand = log(sum(abs(Fourier_Frames_2ndBand).^2, 1));
    log_Fourier_Frames_3rdBand = log(sum(abs(Fourier_Frames_3rdBand).^2, 1));
    log_Fourier_Frames_4thBand = log(sum(abs(Fourier_Frames_4thBand).^2, 1));
%% fc Feature: Brightnesss i.e Frequency Centroid => Centre Frequency
    fc = 1/2*bsxfun(@times, abs(f_frame'), abs(Fourier_Frames).^2);
    fc = sum(fc,1) ./ TotalSpectrumPower;


%% B Feature: Bandwidth
    f_frame_rep = repmat(f_frame' , 1,length(fc));
    fminusfc = bsxfun(@minus, f_frame_rep, fc);
    fminusfc_Sq = fminusfc.^2;
    B_numerator = sum( fminusfc_Sq .* abs(Fourier_Frames).^2 , 1);
    B = (B_numerator ./ TotalSpectrumPower).^(1/2);

%% Feature: Pitch Frequency


%% CepCoeff Feature: Mel-Frequency Cepstral Coefficients 
    Fourier_Frames = fftshift(fft(Frames,400,1)); % 400=> Positive freq. 400/2 = 200 Point FFT because 200Hz FreqLimit.
    L =  size(Fourier_Frames,1);
    f_frame = -L/2:1:(L-1)/2; % Row Vector of freq. corresponding to Columns in Fourier_Frames.
    f_frame = f_frame * Fs/(L-1);
    Fourier_Frames_PosFreq = Fourier_Frames(end/2+1:end , :);
    FreqLimit = [0 , 200]; %[0 , Fs/2] => No need of using Fs because filtered at 195Hz.
    K = 19; % No. of Filter Banks
    MelFreqLimit = 1125*log( 1 + FreqLimit/700);
    MelScaleFilterInterval = (MelFreqLimit(2) - MelFreqLimit(1))/(K+1); % for K filter banks, we need K+1 intervals.
    MelScaleFilterInterval = MelFreqLimit(1):MelScaleFilterInterval:MelFreqLimit(2);
    FreqScaleFilterInterval = 700*(exp(MelScaleFilterInterval/1125)-1);
    FreqScaleFilterInterval = round( FreqScaleFilterInterval);
    %Triangular_Filter_Bank = zeros(size(Fourier_Frames_PosFreq));
    Triangular_Filter_Bank = [];
    for i = 2: K+1
        tmp = [];
        tmp = [tmp ; zeros( FreqScaleFilterInterval(i-1) ,1)];
        tmp = [tmp ; triang( FreqScaleFilterInterval(i+1) - FreqScaleFilterInterval(i-1))];
        tmp = [tmp ; zeros( FreqScaleFilterInterval(end) - FreqScaleFilterInterval(i+1),1)];
        Triangular_Filter_Bank = [Triangular_Filter_Bank ,tmp];
    end
    % Triangular_Filter_Bank_DownSampled = [];
    % 
    % DecimationRatio = 1; % Converting Size from 400 to 200.
    % l = size(Fourier_Frames_PosFreq,2);
    % Fourier_Frames_PosFreq_Extended = [Fourier_Frames_PosFreq ;zeros(71,l)];  % Extending Size from 128 to 200 by padding zeros at either end.
    % for i = 1: size(Triangular_Filter_Bank,2)
    %    Triangular_Filter_Bank_DownSampled = [Triangular_Filter_Bank_DownSampled , decimate(Triangular_Filter_Bank(:,i), DecimationRatio)];
    % end

    CepCoeff = [];
    for i = 1: size(Fourier_Frames_PosFreq,2)
       CepCoeffOfFrame_i = bsxfun(@times, Triangular_Filter_Bank , abs(Fourier_Frames_PosFreq(:,i)).^2);
       CepCoeffOfFrame_i = sum( CepCoeffOfFrame_i , 1)';
       CepCoeff = [ CepCoeff, CepCoeffOfFrame_i];
    end
    CepCoeff = log( CepCoeff);
    CepCoeff = dct(CepCoeff);
%% Perc: Formation of Feature Vector
    % Mean of Perc. Features
    idx = find( Silent_Frames == 0);
    mean_LogTotalSpectrumPower =  mean( LogTotalSpectrumPower(idx));
    mean_Fourier_Frames_1stBand = mean(log_Fourier_Frames_1stBand(idx));
    mean_Fourier_Frames_2ndBand = mean(log_Fourier_Frames_2ndBand(idx));
    mean_Fourier_Frames_3rdBand = mean(log_Fourier_Frames_3rdBand(idx));
    mean_Fourier_Frames_4thBand = mean(log_Fourier_Frames_4thBand(idx));
    mean_fc = mean(fc(idx));
    mean_B = mean(fc(idx));

    % Std of Perc. Features
    std_LogTotalSpectrumPower =  std( LogTotalSpectrumPower(idx));
    std_Fourier_Frames_1stBand = std(log_Fourier_Frames_1stBand(idx));
    std_Fourier_Frames_2ndBand = std(log_Fourier_Frames_2ndBand(idx));
    std_Fourier_Frames_3rdBand = std(log_Fourier_Frames_3rdBand(idx));
    std_Fourier_Frames_4thBand = std(log_Fourier_Frames_4thBand(idx));
    std_fc = std(fc(idx));
    std_B = std(B(idx));

    Perc = [ mean_LogTotalSpectrumPower;
             mean_Fourier_Frames_1stBand;
             mean_Fourier_Frames_2ndBand;
             mean_Fourier_Frames_3rdBand;
             mean_Fourier_Frames_4thBand;
             mean_fc;
             mean_B;
             std_LogTotalSpectrumPower;
             std_Fourier_Frames_1stBand;
             std_Fourier_Frames_2ndBand;
             std_Fourier_Frames_3rdBand;
             std_Fourier_Frames_4thBand;
             std_fc;
             std_B;
             Silent_Ratio
            ];

%% CepsL : Formation of Feature Vector
    mean_CepsL = mean( CepCoeff , 2);
    std_CepsL = std( CepCoeff,[],2);

    CepsL = [mean_CepsL; 
             std_CepsL
            ];