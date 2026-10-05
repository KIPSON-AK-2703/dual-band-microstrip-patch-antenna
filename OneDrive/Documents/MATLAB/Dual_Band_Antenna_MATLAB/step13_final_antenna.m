%% STEP 13 - Final Antenna Geometry
%
% Dual-Band Microstrip Patch Antenna
% Target: 2.4 GHz / 5 GHz
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
% 2. FR-4 PARAMETERS
% ========================================================

er = 4.3;

h = 1.6e-3;

tanDelta = 0.02;

%% ========================================================
% 3. FINAL DIMENSIONS
% ========================================================
%
% IMPORTANT:
% Replace the values below with the actual BEST values
% from STEP 11.
%

patchLength = 29.7e-3;
patchWidth  = 37.9e-3;

notchLength = 9e-3;
notchWidth  = 1e-3;

centerArmNotchLength = 2.8e-3;
centerArmNotchWidth  = 6.2e-3;

feedPosition = -7e-3;

groundLength = 50e-3;
groundWidth  = 50e-3;

%% ========================================================
% 4. CREATE FR-4
% ========================================================

substrate = dielectric;

substrate.Name = "FR4";

substrate.EpsilonR = er;

substrate.LossTangent = tanDelta;

substrate.Thickness = h;

%% ========================================================
% 5. CREATE FINAL ANTENNA
% ========================================================

finalAntenna = patchMicrostripEnotch;

finalAntenna.Length = patchLength;

finalAntenna.Width = patchWidth;

finalAntenna.Height = h;

finalAntenna.NotchLength = notchLength;

finalAntenna.NotchWidth = notchWidth;

finalAntenna.CenterArmNotchLength = ...
    centerArmNotchLength;

finalAntenna.CenterArmNotchWidth = ...
    centerArmNotchWidth;

finalAntenna.Substrate = substrate;

finalAntenna.GroundPlaneLength = groundLength;

finalAntenna.GroundPlaneWidth = groundWidth;

finalAntenna.FeedOffset = [feedPosition 0];

%% ========================================================
% 6. DISPLAY FINAL ANTENNA
% ========================================================

figure;

show(finalAntenna);

title("FINAL DUAL-BAND MICROSTRIP PATCH ANTENNA");

%% ========================================================
% 7. ANTENNA DIMENSION REPORT
% ========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("FINAL ANTENNA DIMENSIONS\n");
fprintf("====================================================\n");

fprintf("Patch length             : %.3f mm\n", ...
    patchLength*1000);

fprintf("Patch width              : %.3f mm\n", ...
    patchWidth*1000);

fprintf("Substrate thickness      : %.3f mm\n", ...
    h*1000);

fprintf("Ground length            : %.3f mm\n", ...
    groundLength*1000);

fprintf("Ground width             : %.3f mm\n", ...
    groundWidth*1000);

fprintf("Main notch length        : %.3f mm\n", ...
    notchLength*1000);

fprintf("Main notch width         : %.3f mm\n", ...
    notchWidth*1000);

fprintf("Center notch length      : %.3f mm\n", ...
    centerArmNotchLength*1000);

fprintf("Center notch width       : %.3f mm\n", ...
    centerArmNotchWidth*1000);

fprintf("Feed position            : %.3f mm\n", ...
    feedPosition*1000);

fprintf("====================================================\n");

%% ========================================================
% 8. FINAL FREQUENCY SWEEP
% ========================================================

frequency = linspace(1.8e9,6.0e9,401);

fprintf("\nCalculating final antenna response...\n");

Z = impedance(finalAntenna,frequency);

%% ========================================================
% 9. S11
% ========================================================

Gamma = (Z-Z0)./(Z+Z0);

S11 = 20*log10(abs(Gamma));

%% ========================================================
% 10. VSWR
% ========================================================

VSWR = (1+abs(Gamma))./(1-abs(Gamma));

%% ========================================================
% 11. FINAL S11 GRAPH
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

title("FINAL DUAL-BAND S_{11}");

xlim([1.8 6]);

ylim([-40 5]);

hold off;

%% ========================================================
% 12. FINAL VSWR GRAPH
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

title("FINAL DUAL-BAND VSWR");

xlim([1.8 6]);

ylim([1 10]);

hold off;

%% ========================================================
% 13. 2.4 GHz RESULT
% ========================================================

[~,index24] = min(abs(frequency-f1));

Z24 = Z(index24);

fprintf("\n");
fprintf("====================================================\n");
fprintf("2.4 GHz FINAL RESULT\n");
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
% 14. 5 GHz RESULT
% ========================================================

[~,index5] = min(abs(frequency-f2));

Z5 = Z(index5);

fprintf("\n");
fprintf("====================================================\n");
fprintf("5 GHz FINAL RESULT\n");
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
% 15. FINAL VERIFICATION
% ========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("DESIGN REQUIREMENT CHECK\n");
fprintf("====================================================\n");

if S11(index24) <= -10
    fprintf("2.4 GHz S11 : PASS\n");
else
    fprintf("2.4 GHz S11 : FAIL\n");
end

if S11(index5) <= -10
    fprintf("5 GHz S11   : PASS\n");
else
    fprintf("5 GHz S11   : FAIL\n");
end

if VSWR(index24) <= 2
    fprintf("2.4 GHz VSWR: PASS\n");
else
    fprintf("2.4 GHz VSWR: FAIL\n");
end

if VSWR(index5) <= 2
    fprintf("5 GHz VSWR  : PASS\n");
else
    fprintf("5 GHz VSWR  : FAIL\n");
end

fprintf("====================================================\n");

fprintf("\nSTEP 13 COMPLETED.\n");