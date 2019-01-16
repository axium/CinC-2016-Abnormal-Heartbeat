function y_smooth = HeartBeatSmooth(y,Fs)
%% BASED ON THE RESEARCH PAPER: A Robust Heart Sound Segmentation and Classification Algorithm using Wavelet Decomposition and Spectrogram
%                   By:  Peter J. Bentley


%% SIGNAL PROPERTIES
    L = length(y);
    Ts = 1/Fs;
    t = (0:L-1)*Ts;
    %plot(t,y)

%% WAVELET TRANSFORM TO REMOVE DETAILS : USING 4TH LEVEL DAUBECHIES 6 FILTER.
    [c,l] = wavedec(y,4,'db6');
    [cd1,cd2,cd3,cd4] = detcoef(c,l,[1 2 3 4]);
    cA4 = appcoef(c,l,'db6',4);
    c_new = c;
    c_new(length(cA4)+1 : length(cd1)+length(cd2)+length(cd3)+length(cd4)) = 0;
    y_rec = waverec( c_new,l,'db6');
    y_rec = y_rec/max(y_rec);
    %hold on
    %figure
    %plot(y_rec);
    %plot(t,y_rec,'b');
%% FILTERING RECONSTRUCTED SOUND SIGNAL AT 195 Hz.
    f = (0:L-1)*Fs/L;
    cutOff = 195; % 195Hz
    f_normalized = 2*cutOff/Fs;
    [b,a]= butter(6,f_normalized,'low');
    y_filtered = filter(b,a ,y_rec);
    y_filtered = y_filtered/max(y_filtered);
    %plot( t, y_filtered,'r');
    %figure
    %plot( y_filtered);
%% SMOOTHING THE FILTERED SIGNAL
    y_smooth = fastsmooth( y_filtered,5,2);
    y_smooth = y_smooth / max(y_smooth);
    %figure
    %plot(y_smooth)
    %plot(t,y_smooth,'c');

end