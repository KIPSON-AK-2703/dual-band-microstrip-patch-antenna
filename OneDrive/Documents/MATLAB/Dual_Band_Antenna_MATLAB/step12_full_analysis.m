%% STEP 12 - Full Performance Analysis
%
% Dual-Band Microstrip Patch Antenna
% Target: 2.4 GHz and 5 GHz
%
% MATLAB R2024b

clc;
clear;
close all;

%% ========================================================
% 1. TARGET FREQUENCIES
% ========================================================

f1 = 2.4e9;
f2 = 5.0e9;

Z0 = 50;

%% ========================================================
% 2. MATERIAL
% ========================================================

er = 4.3;
h = 1.6e-3;
tanDelta = 0.02;

%% ========================================================
% 3. ANTENNA PARAMETERS
% ========================================================

patchLength = 29.7e-3;
patchWidth  = 37.9e-3;

groundLength = 50e-3;
groundWidth = 50e-3;

%% ========================================================
% IMPORTANT
% ========================================================
%
% Replace these values with the actual BEST values
% obtained from STEP 11.
%
% Example only:
%
% bestNotchLength = 9e-3;
% bestFeedPosition = -5e-3;
%
% DO NOT use these example values as your final design.
%

bestNotchLength = 9e-3;
bestFeedPosition = -5e-3;

%% ========================================================
% 4. FR-4
% ========================================================

substrate = dielectric;

substrate.Name = "FR4";

substrate.EpsilonR = er;

substrate.LossTangent = tanDelta;

substrate.Thickness = h;

%% ========================================================
% 5. CREATE OPTIMIZED ANTENNA
% ========================================================

ant = patchMicrostripEnotch;

ant.Length = patchLength;

ant.Width = patchWidth;

ant.Height = h;

ant.NotchLength = bestNotchLength;

ant.NotchWidth = 1e-3;

ant.CenterArmNotchLength = 2.8e-3;

ant.CenterArmNotchWidth = 6.2e-3;

ant.Substrate = substrate;

ant.GroundPlaneLength = groundLength;

ant.GroundPlaneWidth = groundWidth;

ant.FeedOffset = [bestFeedPosition 0];

%% ========================================================
% 6. DISPLAY ANTENNA
% ========================================================

figure;

show(ant);

title("Optimized Dual-Band Antenna");

%% ========================================================
% 7. FREQUENCY SWEEP
% ========================================================

frequency = linspace(1.8e9,6e9,401);

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 12 - FULL PERFORMANCE ANALYSIS\n");
fprintf("====================================================\n");

fprintf("Frequency range : %.2f - %.2f GHz\n", ...
    frequency(1)/1e9, ...
    frequency(end)/1e9);

fprintf("Number of points: %d\n",length(frequency));

fprintf("\nCalculating impedance...\n");

Z = impedance(ant,frequency);

fprintf("Impedance calculation completed.\n");

%% ========================================================
% 8. S11
% ========================================================

Gamma = (Z-Z0)./(Z+Z0);

S11 = 20*log10(abs(Gamma));

%% ========================================================
% 9. VSWR
% ========================================================

VSWR = (1+abs(Gamma))./(1-abs(Gamma));

%% ========================================================
% 10. S11 PLOT
% ========================================================

figure;

plot(frequency/1e9,S11,...
    "LineWidth",1.5);

hold on;

yline(-10,"--");

xline(2.4,"--");

xline(5.0,"--");

grid on;

xlabel("Frequency (GHz)");

ylabel("S_{11} (dB)");

title("Final S_{11}");

xlim([1.8 6]);

ylim([-40 5]);

hold off;

%% ========================================================
% 11. FIND RESONANCES
% ========================================================

[pks,locs] = findpeaks(-S11);

fprintf("\n");
fprintf("====================================================\n");
fprintf("RESONANCES\n");
fprintf("====================================================\n");

for k = 1:length(locs)

    fprintf("Resonance %d : %.4f GHz | S11 = %.3f dB\n", ...
        k, ...
        frequency(locs(k))/1e9, ...
        S11(locs(k)));

end

%% ========================================================
% 12. RESULT AT 2.4 GHz
% ========================================================

[~,index24] = min(abs(frequency-f1));

Z24 = Z(index24);

fprintf("\n");
fprintf("====================================================\n");
fprintf("2.4 GHz PERFORMANCE\n");
fprintf("====================================================\n");

fprintf("Frequency  : %.4f GHz\n", ...
    frequency(index24)/1e9);

fprintf("S11        : %.3f dB\n", ...
    S11(index24));

fprintf("Resistance : %.3f Ohm\n", ...
    real(Z24));

fprintf("Reactance  : %.3f Ohm\n", ...
    imag(Z24));

fprintf("VSWR       : %.3f\n", ...
    VSWR(index24));

%% ========================================================
% 13. RESULT AT 5 GHz
% ========================================================

[~,index5] = min(abs(frequency-f2));

Z5 = Z(index5);

fprintf("\n");
fprintf("====================================================\n");
fprintf("5 GHz PERFORMANCE\n");
fprintf("====================================================\n");

fprintf("Frequency  : %.4f GHz\n", ...
    frequency(index5)/1e9);

fprintf("S11        : %.3f dB\n", ...
    S11(index5));

fprintf("Resistance : %.3f Ohm\n", ...
    real(Z5));

fprintf("Reactance  : %.3f Ohm\n", ...
    imag(Z5));

fprintf("VSWR       : %.3f\n", ...
    VSWR(index5));

%% ========================================================
% 14. IMPEDANCE PLOT
% ========================================================

figure;

plot(frequency/1e9,real(Z),...
    "LineWidth",1.5);

hold on;

plot(frequency/1e9,imag(Z),...
    "LineWidth",1.5);

grid on;

xlabel("Frequency (GHz)");

ylabel("Impedance (Ohm)");

title("Input Impedance");

legend("Resistance","Reactance");

xline(2.4,"--");

xline(5.0,"--");

yline(0,"--");

xlim([1.8 6]);

hold off;

%% ========================================================
% 15. VSWR PLOT
% ========================================================

figure;

plot(frequency/1e9,VSWR,...
    "LineWidth",1.5);

hold on;

yline(2,"--");

xline(2.4,"--");

xline(5.0,"--");

grid on;

xlabel("Frequency (GHz)");

ylabel("VSWR");

title("Final VSWR");

xlim([1.8 6]);

ylim([1 10]);

hold off;

%% ========================================================
% 16. -10 dB BANDWIDTH
% ========================================================

below10 = S11 <= -10;

%% Find continuous regions

d = diff([false below10 false]);

startIndex = find(d == 1);

endIndex = find(d == -1)-1;

fprintf("\n");
fprintf("====================================================\n");
fprintf("-10 dB BANDWIDTHS\n");
fprintf("====================================================\n");

if isempty(startIndex)

    fprintf("No -10 dB bandwidth found.\n");

else

    for k = 1:length(startIndex)

        fLow = frequency(startIndex(k));

        fHigh = frequency(endIndex(k));

        BW = fHigh-fLow;

        fCenter = (fLow+fHigh)/2;

        fprintf("\nBand %d\n",k);

        fprintf("Lower frequency : %.4f GHz\n", ...
            fLow/1e9);

        fprintf("Upper frequency : %.4f GHz\n", ...
            fHigh/1e9);

        fprintf("Center frequency: %.4f GHz\n", ...
            fCenter/1e9);

        fprintf("Bandwidth       : %.2f MHz\n", ...
            BW/1e6);

        fprintf("Fractional BW   : %.2f %%\n", ...
            (BW/fCenter)*100);

    end

end

%% ========================================================
% 17. RADIATION PATTERN - 2.4 GHz
% ========================================================

fprintf("\n");
fprintf("Calculating 2.4 GHz radiation pattern...\n");

figure;

pattern(ant,f1);

title("Radiation Pattern at 2.4 GHz");

%% ========================================================
% 18. RADIATION PATTERN - 5 GHz
% ========================================================

fprintf("Calculating 5 GHz radiation pattern...\n");

figure;

pattern(ant,f2);

title("Radiation Pattern at 5 GHz");

%% ========================================================
% 19. GAIN - 2.4 GHz
% ========================================================

figure;

pattern(ant,f1,...
    "Type","gain");

title("Gain Pattern at 2.4 GHz");

%% ========================================================
% 20. GAIN - 5 GHz
% ========================================================

figure;

pattern(ant,f2,...
    "Type","gain");

title("Gain Pattern at 5 GHz");

%% ========================================================
% 21. FINAL SUMMARY
% ========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 12 FINAL SUMMARY\n");
fprintf("====================================================\n");

fprintf("Patch length       : %.3f mm\n",patchLength*1000);

fprintf("Patch width        : %.3f mm\n",patchWidth*1000);

fprintf("Notch length       : %.3f mm\n",bestNotchLength*1000);

fprintf("Feed position      : %.3f mm\n",bestFeedPosition*1000);

fprintf("\n");

fprintf("2.4 GHz S11        : %.3f dB\n",S11(index24));

fprintf("2.4 GHz VSWR       : %.3f\n",VSWR(index24));

fprintf("\n");

fprintf("5 GHz S11          : %.3f dB\n",S11(index5));

fprintf("5 GHz VSWR         : %.3f\n",VSWR(index5));

fprintf("\n");

fprintf("====================================================\n");
fprintf("STEP 12 COMPLETED\n");
fprintf("====================================================\n");