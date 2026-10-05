%% STEP 6 - Feed Position Optimization
%
% Project:
% Design and Fabrication of a Dual-Band
% Microstrip Patch Antenna for 2.4/5 GHz
%
% MATLAB R2024b

clc;
clear;
close all;

%% =========================================================
% 1. DESIGN PARAMETERS
% ==========================================================

c = 3e8;

fr = 2.4e9;              % Target frequency

er = 4.3;                % FR-4 relative permittivity

h = 1.6e-3;              % Substrate thickness

tanDelta = 0.02;         % FR-4 loss tangent

Z0 = 50;                 % Reference impedance

%% =========================================================
% 2. PATCH DIMENSIONS
% ==========================================================

W = 37.9e-3;             % Patch width

L = 29.7e-3;             % Patch length

%% =========================================================
% 3. GROUND PLANE
% ==========================================================

groundWidth = 50e-3;

groundLength = 50e-3;

%% =========================================================
% 4. CREATE FR-4 SUBSTRATE
% ==========================================================

substrate = dielectric;

substrate.Name = "FR4";

substrate.EpsilonR = er;

substrate.LossTangent = tanDelta;

substrate.Thickness = h;

%% =========================================================
% 5. CREATE BASE ANTENNA
% ==========================================================

ant = patchMicrostrip;

ant.Length = L;

ant.Width = W;

ant.Height = h;

ant.Substrate = substrate;

ant.GroundPlaneLength = groundLength;

ant.GroundPlaneWidth = groundWidth;

%% =========================================================
% 6. FEED POSITION SWEEP
% =========================================================
%
% FeedOffset is measured from the center.
%
% Patch length = 29.7 mm
% Therefore the feed must remain inside the patch.
%
% We test from -12 mm to +12 mm.

feedPositions = linspace(-12e-3,12e-3,25);

%% =========================================================
% 7. CREATE RESULT ARRAYS
% ==========================================================

Z_results = zeros(size(feedPositions));

S11_results = zeros(size(feedPositions));

%% =========================================================
% 8. OPTIMIZATION LOOP
% ==========================================================

fprintf("\n");
fprintf("============================================\n");
fprintf("FEED POSITION OPTIMIZATION\n");
fprintf("============================================\n");

fprintf("Target frequency : %.2f GHz\n", fr/1e9);

fprintf("Reference impedance : %.2f Ohm\n", Z0);

fprintf("\n");

for k = 1:length(feedPositions)

    %% Set feed position

    ant.FeedOffset = [feedPositions(k) 0];

    %% Calculate impedance at 2.4 GHz

    Ztemp = impedance(ant,fr);

    Z_results(k) = Ztemp;

    %% Calculate reflection coefficient

    Gamma = (Ztemp - Z0) / (Ztemp + Z0);

    %% Calculate S11

    S11_results(k) = 20*log10(abs(Gamma));

    %% Display progress

    fprintf("Feed = %7.2f mm | ", ...
        feedPositions(k)*1000);

    fprintf("Z = %8.2f %+.2fj Ohm | ", ...
        real(Ztemp),imag(Ztemp));

    fprintf("S11 = %7.2f dB\n", ...
        S11_results(k));

end

%% =========================================================
% 9. FIND BEST FEED POSITION
% ==========================================================

[minS11,bestIndex] = min(S11_results);

bestFeedPosition = feedPositions(bestIndex);

bestZ = Z_results(bestIndex);

%% =========================================================
% 10. DISPLAY BEST RESULT
% ==========================================================

fprintf("\n");
fprintf("============================================\n");
fprintf("BEST FEED POSITION\n");
fprintf("============================================\n");

fprintf("Best feed position : %.3f mm\n", ...
    bestFeedPosition*1000);

fprintf("Minimum S11        : %.3f dB\n", ...
    minS11);

fprintf("Input resistance   : %.3f Ohm\n", ...
    real(bestZ));

fprintf("Input reactance    : %.3f Ohm\n", ...
    imag(bestZ));

fprintf("============================================\n");

%% =========================================================
% 11. CALCULATE VSWR
% ==========================================================

bestGamma = (bestZ-Z0)/(bestZ+Z0);

bestVSWR = (1+abs(bestGamma))/(1-abs(bestGamma));

fprintf("VSWR               : %.3f\n", ...
    bestVSWR);

fprintf("============================================\n");

%% =========================================================
% 12. PLOT S11 VS FEED POSITION
% ==========================================================

figure;

plot(feedPositions*1000,S11_results, ...
    'LineWidth',1.5);

hold on;

plot(bestFeedPosition*1000,minS11, ...
    'o','MarkerSize',8);

grid on;

xlabel("Feed Position (mm)");

ylabel("S_{11} (dB)");

title("Feed Position Optimization at 2.4 GHz");

yline(-10,'--');

hold off;

%% =========================================================
% 13. PLOT INPUT RESISTANCE
% ==========================================================

figure;

plot(feedPositions*1000, ...
    real(Z_results), ...
    'LineWidth',1.5);

hold on;

yline(50,'--');

grid on;

xlabel("Feed Position (mm)");

ylabel("Resistance (Ohm)");

title("Input Resistance vs Feed Position");

hold off;

%% =========================================================
% 14. PLOT INPUT REACTANCE
% ==========================================================

figure;

plot(feedPositions*1000, ...
    imag(Z_results), ...
    'LineWidth',1.5);

hold on;

yline(0,'--');

grid on;

xlabel("Feed Position (mm)");

ylabel("Reactance (Ohm)");

title("Input Reactance vs Feed Position");

hold off;

%% =========================================================
% 15. CREATE OPTIMIZED ANTENNA
% ==========================================================

optimizedAntenna = ant;

optimizedAntenna.FeedOffset = ...
    [bestFeedPosition 0];

%% =========================================================
% 16. DISPLAY OPTIMIZED ANTENNA
% ==========================================================

figure;

show(optimizedAntenna);

title("Optimized Feed Position - 2.4 GHz Patch");

%% =========================================================
% 17. FINAL SUMMARY
% ==========================================================

fprintf("\n");
fprintf("============================================\n");
fprintf("STEP 6 COMPLETE\n");
fprintf("============================================\n");

fprintf("Target frequency       : %.2f GHz\n", ...
    fr/1e9);

fprintf("Best feed position     : %.3f mm\n", ...
    bestFeedPosition*1000);

fprintf("Minimum S11            : %.3f dB\n", ...
    minS11);

fprintf("Resistance             : %.3f Ohm\n", ...
    real(bestZ));

fprintf("Reactance              : %.3f Ohm\n", ...
    imag(bestZ));

fprintf("VSWR                   : %.3f\n", ...
    bestVSWR);

fprintf("============================================\n");