%% STEP 9 - 2.4 GHz Feed Optimization
%
% Project:
% Design and Fabrication of a Dual-Band
% Microstrip Patch Antenna for 2.4/5 GHz
%
% MATLAB R2024b

clc;
clear;
close all;

%% ========================================================
% 1. TARGET AND MATERIAL PARAMETERS
% ========================================================

fTarget = 2.4e9;

er = 4.3;
h = 1.6e-3;
tanDelta = 0.02;

Z0 = 50;

%% ========================================================
% 2. INITIAL ANTENNA DIMENSIONS
% ========================================================

W = 37.9e-3;
L_initial = 29.7e-3;

groundWidth = 50e-3;
groundLength = 50e-3;

%% ========================================================
% 3. CREATE FR-4
% ========================================================

substrate = dielectric;

substrate.Name = "FR4";
substrate.EpsilonR = er;
substrate.LossTangent = tanDelta;
substrate.Thickness = h;

%% ========================================================
% 4. FREQUENCY RANGE FOR LOWER BAND
% ========================================================

frequency = linspace(2.0e9,2.8e9,81);

%% ========================================================
% 5. PATCH LENGTH SEARCH
% ========================================================

lengthValues = (28:0.5:33)*1e-3;

resonantFrequency = zeros(size(lengthValues));

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 9A - PATCH LENGTH SEARCH\n");
fprintf("====================================================\n");

for k = 1:length(lengthValues)

    ant = patchMicrostripEnotch;

    ant.Length = lengthValues(k);
    ant.Width = W;
    ant.Height = h;

    ant.Substrate = substrate;

    ant.GroundPlaneLength = groundLength;
    ant.GroundPlaneWidth = groundWidth;

    Z = impedance(ant,frequency);

    Gamma = (Z-Z0)./(Z+Z0);

    S11 = 20*log10(abs(Gamma));

    [~,index] = min(S11);

    resonantFrequency(k) = frequency(index);

    fprintf("Length = %6.2f mm | Resonance = %.4f GHz\n", ...
        lengthValues(k)*1000, ...
        resonantFrequency(k)/1e9);

end

%% ========================================================
% 6. SELECT PATCH LENGTH CLOSEST TO 2.4 GHz
% ========================================================

frequencyError = abs(resonantFrequency-fTarget);

[~,bestLengthIndex] = min(frequencyError);

optimizedLength = lengthValues(bestLengthIndex);

fprintf("\n");
fprintf("====================================================\n");
fprintf("SELECTED PATCH LENGTH\n");
fprintf("====================================================\n");

fprintf("Initial length   : %.3f mm\n",L_initial*1000);

fprintf("Optimized length : %.3f mm\n", ...
    optimizedLength*1000);

fprintf("Estimated resonance : %.4f GHz\n", ...
    resonantFrequency(bestLengthIndex)/1e9);

%% ========================================================
% 7. FEED POSITION SEARCH
% ========================================================

% Keep feed safely inside the patch.

feedPositions = -12e-3:0.5e-3:12e-3;

S11_feed = zeros(size(feedPositions));

Z_feed = complex(zeros(size(feedPositions)));

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 9B - FEED POSITION OPTIMIZATION\n");
fprintf("====================================================\n");

for k = 1:length(feedPositions)

    ant = patchMicrostripEnotch;

    ant.Length = optimizedLength;
    ant.Width = W;
    ant.Height = h;

    ant.Substrate = substrate;

    ant.GroundPlaneLength = groundLength;
    ant.GroundPlaneWidth = groundWidth;

    ant.FeedOffset = [feedPositions(k) 0];

    Ztemp = impedance(ant,fTarget);

    Z_feed(k) = Ztemp;

    Gamma = (Ztemp-Z0)/(Ztemp+Z0);

    S11_feed(k) = 20*log10(abs(Gamma));

    fprintf("Feed = %7.2f mm | Z = %8.2f %+.2fj Ohm | S11 = %7.2f dB\n", ...
        feedPositions(k)*1000, ...
        real(Ztemp), ...
        imag(Ztemp), ...
        S11_feed(k));

end

%% ========================================================
% 8. FIND BEST FEED
% ========================================================

[minS11,bestFeedIndex] = min(S11_feed);

bestFeedPosition = feedPositions(bestFeedIndex);

bestZ = Z_feed(bestFeedIndex);

bestGamma = (bestZ-Z0)/(bestZ+Z0);

bestVSWR = (1+abs(bestGamma))/(1-abs(bestGamma));

%% ========================================================
% 9. DISPLAY BEST FEED
% ========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("BEST 2.4 GHz FEED POSITION\n");
fprintf("====================================================\n");

fprintf("Patch length      : %.3f mm\n", ...
    optimizedLength*1000);

fprintf("Feed position     : %.3f mm\n", ...
    bestFeedPosition*1000);

fprintf("S11               : %.3f dB\n", ...
    minS11);

fprintf("Resistance        : %.3f Ohm\n", ...
    real(bestZ));

fprintf("Reactance         : %.3f Ohm\n", ...
    imag(bestZ));

fprintf("VSWR              : %.3f\n", ...
    bestVSWR);

fprintf("====================================================\n");

%% ========================================================
% 10. CREATE FINAL 2.4 GHz ANTENNA
% ========================================================

optimizedAntenna = patchMicrostripEnotch;

optimizedAntenna.Length = optimizedLength;
optimizedAntenna.Width = W;
optimizedAntenna.Height = h;

optimizedAntenna.Substrate = substrate;

optimizedAntenna.GroundPlaneLength = groundLength;
optimizedAntenna.GroundPlaneWidth = groundWidth;

optimizedAntenna.FeedOffset = [bestFeedPosition 0];

%% ========================================================
% 11. DISPLAY ANTENNA
% ========================================================

figure;

show(optimizedAntenna);

title("2.4 GHz Optimized E-Notched Patch");

%% ========================================================
% 12. PLOT FEED VS S11
% ========================================================

figure;

plot(feedPositions*1000,S11_feed,...
    'o-','LineWidth',1.5);

hold on;

plot(bestFeedPosition*1000,minS11,...
    'o','MarkerSize',9);

yline(-10,"--");

grid on;

xlabel("Feed Position (mm)");
ylabel("S_{11} (dB)");

title("2.4 GHz Feed Position Optimization");

hold off;

%% ========================================================
% 13. FULL LOWER-BAND S11
% ========================================================

frequencyFine = linspace(2.0e9,2.8e9,201);

Zfinal = impedance(optimizedAntenna,frequencyFine);

GammaFinal = (Zfinal-Z0)./(Zfinal+Z0);

S11Final = 20*log10(abs(GammaFinal));

VSWRFinal = (1+abs(GammaFinal))./(1-abs(GammaFinal));

%% ========================================================
% 14. LOWER-BAND S11 PLOT
% ========================================================

figure;

plot(frequencyFine/1e9,S11Final,...
    'LineWidth',1.5);

hold on;

yline(-10,"--");

xline(2.4,"--");

grid on;

xlabel("Frequency (GHz)");
ylabel("S_{11} (dB)");

title("Optimized Lower-Band S_{11}");

xlim([2.0 2.8]);

ylim([-40 5]);

hold off;

%% ========================================================
% 15. LOWER-BAND VSWR
% ========================================================

figure;

plot(frequencyFine/1e9,VSWRFinal,...
    'LineWidth',1.5);

hold on;

yline(2,"--");

xline(2.4,"--");

grid on;

xlabel("Frequency (GHz)");
ylabel("VSWR");

title("Optimized Lower-Band VSWR");

xlim([2.0 2.8]);

hold off;

%% ========================================================
% 16. FINAL RESULT
% ========================================================

[~,targetIndex] = min(abs(frequencyFine-fTarget));

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 9 FINAL RESULT\n");
fprintf("====================================================\n");

fprintf("Target frequency : %.3f GHz\n", ...
    fTarget/1e9);

fprintf("Patch length     : %.3f mm\n", ...
    optimizedLength*1000);

fprintf("Feed position    : %.3f mm\n", ...
    bestFeedPosition*1000);

fprintf("Frequency point  : %.4f GHz\n", ...
    frequencyFine(targetIndex)/1e9);

fprintf("S11              : %.3f dB\n", ...
    S11Final(targetIndex));

fprintf("VSWR             : %.3f\n", ...
    VSWRFinal(targetIndex));

fprintf("====================================================\n");

fprintf("\nSTEP 9 COMPLETED.\n");