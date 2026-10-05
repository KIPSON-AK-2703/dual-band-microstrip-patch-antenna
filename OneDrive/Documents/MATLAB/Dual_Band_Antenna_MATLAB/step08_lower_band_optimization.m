%% STEP 8 - Lower Band Optimization
%
% Target:
% Move lower resonance toward 2.4 GHz
%
% MATLAB R2024b

clc;
clear;
close all;

%% ========================================================
% 1. PARAMETERS
% =========================================================

fTarget = 2.4e9;

er = 4.3;
h = 1.6e-3;
tanDelta = 0.02;

Z0 = 50;

%% ========================================================
% 2. INITIAL PATCH DIMENSIONS
% =========================================================

W = 37.9e-3;
L = 29.7e-3;

groundWidth = 50e-3;
groundLength = 50e-3;

%% ========================================================
% 3. FR-4 SUBSTRATE
% =========================================================

substrate = dielectric;

substrate.Name = "FR4";
substrate.EpsilonR = er;
substrate.LossTangent = tanDelta;
substrate.Thickness = h;

%% ========================================================
% 4. PATCH LENGTH VALUES
% =========================================================

% Test several patch lengths around the current value.

lengthValues = (28:0.5:33)*1e-3;

%% ========================================================
% 5. FREQUENCY RANGE
% =========================================================

frequency = linspace(2.0e9,3.0e9,101);

%% ========================================================
% 6. RESULT ARRAYS
% =========================================================

bestFrequency = zeros(size(lengthValues));
bestS11 = zeros(size(lengthValues));

%% ========================================================
% 7. OPTIMIZATION
% =========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("LOWER BAND OPTIMIZATION\n");
fprintf("====================================================\n");

fprintf("Target frequency = %.2f GHz\n",fTarget/1e9);

fprintf("\n");

for k = 1:length(lengthValues)

    %% Create antenna

    ant = patchMicrostripEnotch;

    ant.Length = lengthValues(k);
    ant.Width = W;
    ant.Height = h;

    ant.Substrate = substrate;

    ant.GroundPlaneLength = groundLength;
    ant.GroundPlaneWidth = groundWidth;

    %% Frequency sweep

    Z = impedance(ant,frequency);

    %% Reflection coefficient

    Gamma = (Z-Z0)./(Z+Z0);

    %% S11

    S11 = 20*log10(abs(Gamma));

    %% Find minimum S11

    [minValue,index] = min(S11);

    bestS11(k) = minValue;

    bestFrequency(k) = frequency(index);

    fprintf("Length = %6.2f mm | Resonance = %6.3f GHz | S11 = %7.2f dB\n", ...
        lengthValues(k)*1000, ...
        bestFrequency(k)/1e9, ...
        bestS11(k));

end

%% ========================================================
% 8. FIND LENGTH CLOSEST TO 2.4 GHz
% =========================================================

frequencyError = abs(bestFrequency-fTarget);

[~,bestIndex] = min(frequencyError);

optimizedLength = lengthValues(bestIndex);

fprintf("\n");
fprintf("====================================================\n");
fprintf("BEST PATCH LENGTH FOR 2.4 GHz\n");
fprintf("====================================================\n");

fprintf("Patch length       : %.3f mm\n", ...
    optimizedLength*1000);

fprintf("Resonant frequency : %.4f GHz\n", ...
    bestFrequency(bestIndex)/1e9);

fprintf("Minimum S11        : %.3f dB\n", ...
    bestS11(bestIndex));

fprintf("====================================================\n");

%% ========================================================
% 9. PLOT RESONANT FREQUENCY
% =========================================================

figure;

plot(lengthValues*1000,bestFrequency/1e9,...
    'o-','LineWidth',1.5);

hold on;

yline(2.4,'--');

grid on;

xlabel("Patch Length (mm)");
ylabel("Resonant Frequency (GHz)");

title("Lower Resonant Frequency vs Patch Length");

hold off;

%% ========================================================
% 10. PLOT S11
% =========================================================

figure;

plot(lengthValues*1000,bestS11,...
    'o-','LineWidth',1.5);

hold on;

yline(-10,'--');

grid on;

xlabel("Patch Length (mm)");
ylabel("Minimum S_{11} (dB)");

title("S_{11} vs Patch Length");

hold off;

%% ========================================================
% 11. CREATE OPTIMIZED ANTENNA
% =========================================================

optimizedAntenna = patchMicrostripEnotch;

optimizedAntenna.Length = optimizedLength;
optimizedAntenna.Width = W;
optimizedAntenna.Height = h;

optimizedAntenna.Substrate = substrate;

optimizedAntenna.GroundPlaneLength = groundLength;
optimizedAntenna.GroundPlaneWidth = groundWidth;

%% ========================================================
% 12. DISPLAY ANTENNA
% =========================================================

figure;

show(optimizedAntenna);

title("Optimized Lower-Band E-Notched Patch");

%% ========================================================
% 13. FINAL MESSAGE
% =========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 8 COMPLETED\n");
fprintf("====================================================\n");

fprintf("Optimized patch length : %.3f mm\n", ...
    optimizedLength*1000);

fprintf("Lower resonance        : %.4f GHz\n", ...
    bestFrequency(bestIndex)/1e9);

fprintf("Minimum S11            : %.3f dB\n", ...
    bestS11(bestIndex));

fprintf("====================================================\n");