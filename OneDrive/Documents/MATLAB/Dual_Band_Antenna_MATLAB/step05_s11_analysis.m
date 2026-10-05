%% STEP 5 - S11 Analysis of Initial Patch Antenna
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

c = 3e8;                 % Speed of light (m/s)

fr = 2.4e9;              % Target frequency (Hz)

er = 4.3;                % FR-4 relative permittivity

h = 1.6e-3;              % Substrate thickness (m)

tanDelta = 0.02;         % FR-4 loss tangent

%% Patch dimensions
% Initial dimensions obtained from Step 2

W = 37.9e-3;             % Patch width (m)

L = 29.7e-3;             % Patch length (m)

%% Ground plane

groundWidth = 50e-3;     % Ground width (m)

groundLength = 50e-3;    % Ground length (m)

%% Reference impedance

Z0 = 50;                 % Reference impedance (Ohms)

%% =========================================================
% 2. CREATE FR-4 MATERIAL
% ==========================================================

substrate = dielectric;

substrate.Name = "FR4";

substrate.EpsilonR = er;

substrate.LossTangent = tanDelta;

substrate.Thickness = h;

%% =========================================================
% 3. CREATE MICROSTRIP PATCH
% ==========================================================

ant = patchMicrostrip;

ant.Length = L;

ant.Width = W;

ant.Height = h;

ant.Substrate = substrate;

ant.GroundPlaneLength = groundLength;

ant.GroundPlaneWidth = groundWidth;

%% =========================================================
% 4. SET FEED LOCATION
% =========================================================
%
% The previous error occurred because the default
% FeedOffset was outside the patch geometry.
%
% Patch length = 29.7 mm
% Half patch length = 14.85 mm
%
% Therefore -7 mm is safely inside the patch.

ant.FeedOffset = [-7e-3 0];

%% =========================================================
% 5. DISPLAY ANTENNA
% ==========================================================

figure;

show(ant);

title("Initial 2.4 GHz Microstrip Patch Antenna");

%% =========================================================
% 6. DISPLAY FEED LOCATION
% ==========================================================

fprintf("\n");
fprintf("============================================\n");
fprintf("ANTENNA GEOMETRY\n");
fprintf("============================================\n");

fprintf("Patch Length       : %.3f mm\n", L*1000);

fprintf("Patch Width        : %.3f mm\n", W*1000);

fprintf("Substrate Thickness: %.3f mm\n", h*1000);

fprintf("Ground Length      : %.3f mm\n", ...
    groundLength*1000);

fprintf("Ground Width       : %.3f mm\n", ...
    groundWidth*1000);

fprintf("Feed Offset X      : %.3f mm\n", ...
    ant.FeedOffset(1)*1000);

fprintf("Feed Offset Y      : %.3f mm\n", ...
    ant.FeedOffset(2)*1000);

fprintf("============================================\n");

%% =========================================================
% 7. FREQUENCY SWEEP
% ==========================================================

fStart = 1.8e9;          % Start frequency

fStop = 6.0e9;           % Stop frequency

N = 201;                 % Number of frequency points

frequency = linspace(fStart, fStop, N);

%% =========================================================
% 8. CALCULATE INPUT IMPEDANCE
% ==========================================================

fprintf("\n");
fprintf("============================================\n");
fprintf("IMPEDANCE CALCULATION\n");
fprintf("============================================\n");

fprintf("Calculating antenna impedance...\n");
fprintf("Frequency range: %.1f - %.1f GHz\n", ...
    fStart/1e9, fStop/1e9);

fprintf("Number of points: %d\n", N);

fprintf("Please wait...\n\n");

Z = impedance(ant, frequency);

fprintf("Impedance calculation completed.\n");

%% =========================================================
% 9. CALCULATE REFLECTION COEFFICIENT
% ==========================================================

Gamma = (Z - Z0) ./ (Z + Z0);

%% =========================================================
% 10. CALCULATE S11 IN dB
% ==========================================================

S11_dB = 20 * log10(abs(Gamma));

%% =========================================================
% 11. PLOT S11
% ==========================================================

figure;

plot(frequency/1e9, S11_dB, ...
    'LineWidth', 1.5);

grid on;

xlabel("Frequency (GHz)");

ylabel("S_{11} (dB)");

title("S_{11} of Initial Microstrip Patch Antenna");

xlim([1.8 6]);

ylim([-40 5]);

yline(-10, '--');

xline(2.4, '--');

%% =========================================================
% 12. FIND MINIMUM S11
% ==========================================================

[minS11, minIndex] = min(S11_dB);

resonantFrequency = frequency(minIndex);

fprintf("\n");
fprintf("============================================\n");
fprintf("INITIAL ANTENNA S11 RESULT\n");
fprintf("============================================\n");

fprintf("Minimum S11        : %.2f dB\n", ...
    minS11);

fprintf("Resonant frequency : %.4f GHz\n", ...
    resonantFrequency/1e9);

fprintf("============================================\n");

%% =========================================================
% 13. FIND S11 CLOSEST TO 2.4 GHz
% ==========================================================

[~, targetIndex] = min(abs(frequency - fr));

targetFrequency = frequency(targetIndex);

targetS11 = S11_dB(targetIndex);

fprintf("\n");

fprintf("============================================\n");
fprintf("RESULT AT 2.4 GHz\n");
fprintf("============================================\n");

fprintf("Actual frequency point : %.4f GHz\n", ...
    targetFrequency/1e9);

fprintf("S11                    : %.2f dB\n", ...
    targetS11);

%% =========================================================
% 14. INPUT IMPEDANCE AT 2.4 GHz
% ==========================================================

Z_target = Z(targetIndex);

fprintf("\n");

fprintf("Input impedance near 2.4 GHz:\n");

fprintf("Resistance = %.2f Ohm\n", ...
    real(Z_target));

fprintf("Reactance  = %.2f Ohm\n", ...
    imag(Z_target));

fprintf("============================================\n");

%% =========================================================
% 15. PLOT INPUT IMPEDANCE
% ==========================================================

figure;

plot(frequency/1e9, real(Z), ...
    'LineWidth', 1.5);

hold on;

plot(frequency/1e9, imag(Z), ...
    'LineWidth', 1.5);

grid on;

xlabel("Frequency (GHz)");

ylabel("Impedance (Ohm)");

title("Input Impedance of Initial Patch Antenna");

legend("Resistance", "Reactance", ...
    "Location", "best");

xlim([1.8 6]);

xline(2.4, '--');

yline(0, '--');

hold off;

%% =========================================================
% 16. CALCULATE VSWR
% ==========================================================

VSWR = (1 + abs(Gamma)) ./ ...
       (1 - abs(Gamma));

%% =========================================================
% 17. PLOT VSWR
% ==========================================================

figure;

plot(frequency/1e9, VSWR, ...
    'LineWidth', 1.5);

grid on;

xlabel("Frequency (GHz)");

ylabel("VSWR");

title("VSWR of Initial Microstrip Patch Antenna");

xlim([1.8 6]);

ylim([1 10]);

yline(2, '--');

xline(2.4, '--');

%% =========================================================
% 18. VSWR AT 2.4 GHz
% ==========================================================

targetVSWR = VSWR(targetIndex);

fprintf("\n");
fprintf("VSWR near 2.4 GHz = %.3f\n", ...
    targetVSWR);

%% =========================================================
% 19. CHECK -10 dB BANDWIDTH
% ==========================================================

below10dB = S11_dB <= -10;

indices = find(below10dB);

fprintf("\n");
fprintf("============================================\n");
fprintf("-10 dB BANDWIDTH CHECK\n");
fprintf("============================================\n");

if isempty(indices)

    fprintf("No frequency point satisfies S11 <= -10 dB.\n");

else

    fLower = frequency(indices(1));

    fUpper = frequency(indices(end));

    bandwidth = fUpper - fLower;

    fprintf("Lower frequency : %.4f GHz\n", ...
        fLower/1e9);

    fprintf("Upper frequency : %.4f GHz\n", ...
        fUpper/1e9);

    fprintf("Bandwidth       : %.2f MHz\n", ...
        bandwidth/1e6);

end

%% =========================================================
% 20. FINAL SUMMARY
% ==========================================================

fprintf("\n");
fprintf("============================================\n");
fprintf("STEP 5 FINAL SUMMARY\n");
fprintf("============================================\n");

fprintf("Target frequency          : %.2f GHz\n", ...
    fr/1e9);

fprintf("Calculated resonance     : %.4f GHz\n", ...
    resonantFrequency/1e9);

fprintf("Minimum S11              : %.2f dB\n", ...
    minS11);

fprintf("S11 near 2.4 GHz         : %.2f dB\n", ...
    targetS11);

fprintf("VSWR near 2.4 GHz        : %.3f\n", ...
    targetVSWR);

fprintf("Resistance near 2.4 GHz : %.2f Ohm\n", ...
    real(Z_target));

fprintf("Reactance near 2.4 GHz  : %.2f Ohm\n", ...
    imag(Z_target));

fprintf("============================================\n");

fprintf("\nSTEP 5 COMPLETED.\n");