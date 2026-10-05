%% STEP 10 - Upper Band Optimization
%
% Project:
% Design and Fabrication of a Dual-Band
% Microstrip Patch Antenna for 2.4/5 GHz
%
% MATLAB R2024b
%
% Purpose:
% Optimize the E-notch to obtain a resonance
% near 5 GHz while monitoring the 2.4 GHz band.

clc;
clear;
close all;

%% ========================================================
% 1. TARGET FREQUENCIES
% =========================================================

f1 = 2.4e9;
f2 = 5.0e9;

Z0 = 50;

%% ========================================================
% 2. MATERIAL PARAMETERS
% =========================================================

er = 4.3;

h = 1.6e-3;

tanDelta = 0.02;

%% ========================================================
% 3. ANTENNA DIMENSIONS
% =========================================================

% Use the optimized values from Step 9 here.
%
% If Step 9 produced different values, replace these two
% numbers with your Step 9 results.

patchLength = 29.7e-3;

feedPosition = -7e-3;

patchWidth = 37.9e-3;

groundLength = 50e-3;

groundWidth = 50e-3;

%% ========================================================
% 4. FR-4 SUBSTRATE
% =========================================================

substrate = dielectric;

substrate.Name = "FR4";

substrate.EpsilonR = er;

substrate.LossTangent = tanDelta;

substrate.Thickness = h;

%% ========================================================
% 5. NOTCH PARAMETERS
% =========================================================

% Main E-notch length sweep

notchLengths = (7:0.5:13)*1e-3;

% Keep notch width fixed initially.

notchWidth = 1e-3;

% Center arm parameters

centerArmNotchLength = 2.8e-3;

centerArmNotchWidth = 6.2e-3;

%% ========================================================
% 6. FREQUENCY RANGE
% =========================================================

frequency = linspace(4.2e9,5.8e9,161);

%% ========================================================
% 7. RESULT ARRAYS
% =========================================================

resonantFrequency = zeros(size(notchLengths));

minimumS11 = zeros(size(notchLengths));

S11_2p4 = zeros(size(notchLengths));

S11_5 = zeros(size(notchLengths));

%% ========================================================
% 8. START OPTIMIZATION
% =========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 10 - 5 GHz NOTCH OPTIMIZATION\n");
fprintf("====================================================\n");

fprintf("Target upper frequency : %.2f GHz\n",f2/1e9);

fprintf("Patch length           : %.3f mm\n", ...
    patchLength*1000);

fprintf("Feed position          : %.3f mm\n", ...
    feedPosition*1000);

fprintf("\n");

%% ========================================================
% 9. OPTIMIZATION LOOP
% =========================================================

for k = 1:length(notchLengths)

    %% Create E-notched antenna

    ant = patchMicrostripEnotch;

    %% Patch

    ant.Length = patchLength;

    ant.Width = patchWidth;

    ant.Height = h;

    %% E-notch

    ant.NotchLength = notchLengths(k);

    ant.NotchWidth = notchWidth;

    ant.CenterArmNotchLength = centerArmNotchLength;

    ant.CenterArmNotchWidth = centerArmNotchWidth;

    %% Substrate

    ant.Substrate = substrate;

    %% Ground

    ant.GroundPlaneLength = groundLength;

    ant.GroundPlaneWidth = groundWidth;

    %% Feed

    ant.FeedOffset = [feedPosition 0];

    %% Calculate impedance

    Z = impedance(ant,frequency);

    %% Calculate S11

    Gamma = (Z-Z0)./(Z+Z0);

    S11 = 20*log10(abs(Gamma));

    %% Find upper resonance

    [minimumS11(k),index] = min(S11);

    resonantFrequency(k) = frequency(index);

    %% Calculate S11 at 2.4 GHz

    Z24 = impedance(ant,f1);

    Gamma24 = (Z24-Z0)/(Z24+Z0);

    S11_2p4(k) = 20*log10(abs(Gamma24));

    %% Calculate S11 at 5 GHz

    Z5 = impedance(ant,f2);

    Gamma5 = (Z5-Z0)/(Z5+Z0);

    S11_5(k) = 20*log10(abs(Gamma5));

    %% Display result

    fprintf( ...
        "Notch = %6.2f mm | Resonance = %.4f GHz | S11@2.4 = %7.2f dB | S11@5 = %7.2f dB\n", ...
        notchLengths(k)*1000, ...
        resonantFrequency(k)/1e9, ...
        S11_2p4(k), ...
        S11_5(k));

end

%% ========================================================
% 10. FIND NOTCH CLOSEST TO 5 GHz
% =========================================================

frequencyError = abs(resonantFrequency-f2);

[~,bestIndex] = min(frequencyError);

bestNotchLength = notchLengths(bestIndex);

%% ========================================================
% 11. DISPLAY BEST NOTCH
% =========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("BEST NOTCH LENGTH FOR 5 GHz\n");
fprintf("====================================================\n");

fprintf("Best notch length : %.3f mm\n", ...
    bestNotchLength*1000);

fprintf("Resonant frequency: %.4f GHz\n", ...
    resonantFrequency(bestIndex)/1e9);

fprintf("Minimum S11       : %.3f dB\n", ...
    minimumS11(bestIndex));

fprintf("S11 at 2.4 GHz   : %.3f dB\n", ...
    S11_2p4(bestIndex));

fprintf("S11 at 5 GHz     : %.3f dB\n", ...
    S11_5(bestIndex));

fprintf("====================================================\n");

%% ========================================================
% 12. PLOT RESONANCE VS NOTCH LENGTH
% =========================================================

figure;

plot(notchLengths*1000,...
     resonantFrequency/1e9,...
     'o-','LineWidth',1.5);

hold on;

yline(5.0,'--');

grid on;

xlabel("Notch Length (mm)");

ylabel("Upper Resonant Frequency (GHz)");

title("Upper Resonance vs E-Notch Length");

hold off;

%% ========================================================
% 13. PLOT S11 AT 5 GHz
% =========================================================

figure;

plot(notchLengths*1000,...
     S11_5,...
     'o-','LineWidth',1.5);

hold on;

yline(-10,'--');

grid on;

xlabel("Notch Length (mm)");

ylabel("S_{11} at 5 GHz (dB)");

title("5 GHz Matching vs Notch Length");

hold off;

%% ========================================================
% 14. CREATE OPTIMIZED ANTENNA
% =========================================================

optimizedAntenna = patchMicrostripEnotch;

optimizedAntenna.Length = patchLength;

optimizedAntenna.Width = patchWidth;

optimizedAntenna.Height = h;

optimizedAntenna.NotchLength = bestNotchLength;

optimizedAntenna.NotchWidth = notchWidth;

optimizedAntenna.CenterArmNotchLength = ...
    centerArmNotchLength;

optimizedAntenna.CenterArmNotchWidth = ...
    centerArmNotchWidth;

optimizedAntenna.Substrate = substrate;

optimizedAntenna.GroundPlaneLength = groundLength;

optimizedAntenna.GroundPlaneWidth = groundWidth;

optimizedAntenna.FeedOffset = [feedPosition 0];

%% ========================================================
% 15. DISPLAY OPTIMIZED ANTENNA
% =========================================================

figure;

show(optimizedAntenna);

title("5 GHz Optimized E-Notched Patch");

%% ========================================================
% 16. FULL DUAL-BAND FREQUENCY SWEEP
% =========================================================

frequencyFull = linspace(1.8e9,6.0e9,301);

Zfull = impedance(optimizedAntenna,frequencyFull);

GammaFull = (Zfull-Z0)./(Zfull+Z0);

S11Full = 20*log10(abs(GammaFull));

VSWRFull = (1+abs(GammaFull))./(1-abs(GammaFull));

%% ========================================================
% 17. FULL S11 PLOT
% =========================================================

figure;

plot(frequencyFull/1e9,...
     S11Full,...
     'LineWidth',1.5);

hold on;

yline(-10,'--');

xline(2.4,'--');

xline(5.0,'--');

grid on;

xlabel("Frequency (GHz)");

ylabel("S_{11} (dB)");

title("Dual-Band S_{11} After 5 GHz Optimization");

xlim([1.8 6]);

ylim([-40 5]);

hold off;

%% ========================================================
% 18. FULL VSWR PLOT
% =========================================================

figure;

plot(frequencyFull/1e9,...
     VSWRFull,...
     'LineWidth',1.5);

hold on;

yline(2,'--');

xline(2.4,'--');

xline(5.0,'--');

grid on;

xlabel("Frequency (GHz)");

ylabel("VSWR");

title("Dual-Band VSWR");

xlim([1.8 6]);

ylim([1 10]);

hold off;

%% ========================================================
% 19. FINAL 2.4 GHz RESULT
% =========================================================

[~,index24] = min(abs(frequencyFull-f1));

fprintf("\n");
fprintf("====================================================\n");
fprintf("FINAL 2.4 GHz RESULT\n");
fprintf("====================================================\n");

fprintf("Frequency : %.4f GHz\n", ...
    frequencyFull(index24)/1e9);

fprintf("S11       : %.3f dB\n", ...
    S11Full(index24));

fprintf("VSWR      : %.3f\n", ...
    VSWRFull(index24));

%% ========================================================
% 20. FINAL 5 GHz RESULT
% =========================================================

[~,index5] = min(abs(frequencyFull-f2));

fprintf("\n");
fprintf("====================================================\n");
fprintf("FINAL 5 GHz RESULT\n");
fprintf("====================================================\n");

fprintf("Frequency : %.4f GHz\n", ...
    frequencyFull(index5)/1e9);

fprintf("S11       : %.3f dB\n", ...
    S11Full(index5));

fprintf("VSWR      : %.3f\n", ...
    VSWRFull(index5));

%% ========================================================
% 21. FINAL SUMMARY
% =========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 10 COMPLETE\n");
fprintf("====================================================\n");

fprintf("Patch length      : %.3f mm\n", ...
    patchLength*1000);

fprintf("Patch width       : %.3f mm\n", ...
    patchWidth*1000);

fprintf("Feed position     : %.3f mm\n", ...
    feedPosition*1000);

fprintf("Optimized notch   : %.3f mm\n", ...
    bestNotchLength*1000);

fprintf("\n");

fprintf("2.4 GHz S11       : %.3f dB\n", ...
    S11Full(index24));

fprintf("2.4 GHz VSWR      : %.3f\n", ...
    VSWRFull(index24));

fprintf("\n");

fprintf("5 GHz S11         : %.3f dB\n", ...
    S11Full(index5));

fprintf("5 GHz VSWR        : %.3f\n", ...
    VSWRFull(index5));

fprintf("====================================================\n");