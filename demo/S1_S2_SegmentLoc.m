function  [Loc, S1_Loc, S2_Loc, y_envelope] = S1_S2_SegmentLoc(y_smooth , Fs)
%% %% BASED ON THE RESEARCH PAPER: A Robust Heart Sound Segmentation and Classification Algorithm using Wavelet Decomposition and Spectrogram
%                   By:  Peter J. Bentley
 
%% FINDING PEAKS
    L = length(y_smooth);
    Ts = 1/Fs;
    t = (0:L-1)*Ts;
    y_smooth_sq = y_smooth.^2;
    y_smooth_sq = y_smooth_sq / max(y_smooth_sq);
    %plot(t,y_smooth_sq,'k');
    
%% FINDING PEAKS USING ENVELOPE
    [ y_envelope,yi_Low] =envelope( y_smooth, 0.05*Fs, 'peak');
    %hold on
    y_envelope = y_envelope / max(y_envelope);
    %plot( t,y_envelope);
    [~,Loc] = findpeaks( y_envelope , 'MinPeakHeight' ,0.1,'MinPeakDistance', 0.1*Fs ); % 50ms = 0.05s => 0.05/Ts .

%     for i = 2: length(Loc)
%         if ( t(Loc(i)) - t(Loc(i-1)) <= 0.05 )
%             Loc(i) = Loc(i-1);
%         end
%     end
%     scatter(Loc*Ts, y_envelope(Loc) , 'x');

%% Identifying S1 and S2
    S1_S2 = diff( t(Loc)); % Time btw alternate peaks.
    M1 = mean( S1_S2(1:2:end));
    M2 = mean( S1_S2(2:2:end));

    if( M1<M2)
        S1_Loc = Loc(1:2:end);
        S2_Loc = Loc(2:2:end);
    else
        S1_Loc = Loc(2:2:end);
        S2_Loc = Loc(1:2:end);
    end
     %scatter(S1_Loc*Ts, y_envelope(S1_Loc) ,'rx');
     %scatter(S2_Loc*Ts, y_envelope(S2_Loc) ,'bx');
end