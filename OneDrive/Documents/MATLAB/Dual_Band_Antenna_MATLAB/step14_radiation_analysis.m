%% STEP 14 - Radiation Characteristics
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

%% ========================================================
% 2. FR-4 PARAMETERS
% ========================================================

er = 4.3;

h = 1.6e-3;

tanDelta = 0.02;

%% ========================================================
% 3. FINAL ANTENNA PARAMETERS
% ========================================================
%
% IMPORTANT:
% Replace these with the actual optimized values
% from STEP 11.

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

ant = patchMicrostripEnotch;

ant.Length = patchLength;

ant.Width = patchWidth;

ant.Height = h;

ant.NotchLength = notchLength;

ant.NotchWidth = notchWidth;

ant.CenterArmNotchLength = ...
    centerArmNotchLength;

ant.CenterArmNotchWidth = ...
    centerArmNotchWidth;

ant.Substrate = substrate;

ant.GroundPlaneLength = groundLength;

ant.GroundPlaneWidth = groundWidth;

ant.FeedOffset = [feedPosition 0];

%% ========================================================
% 6. DISPLAY ANTENNA
% ========================================================

figure;

show(ant);

title("Final Dual-Band Antenna");

%% ========================================================
% 7. 2.4 GHz 3D RADIATION PATTERN
% ========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("2.4 GHz RADIATION ANALYSIS\n");
fprintf("====================================================\n");

fprintf("Calculating 2.4 GHz radiation pattern...\n");

figure;

pattern(ant,f1);

title("3D Radiation Pattern - 2.4 GHz");

%% ========================================================
% 8. 5 GHz 3D RADIATION PATTERN
% ========================================================

fprintf("\n");
fprintf("Calculating 5 GHz radiation pattern...\n");

figure;

pattern(ant,f2);

title("3D Radiation Pattern - 5 GHz");

%% ========================================================
% 9. 2.4 GHz GAIN PATTERN
% ========================================================

fprintf("\n");
fprintf("Calculating 2.4 GHz gain pattern...\n");

figure;

pattern(ant,f1,...
    "Type","gain");

title("Gain Pattern - 2.4 GHz");

%% ========================================================
% 10. 5 GHz GAIN PATTERN
% ========================================================

fprintf("\n");
fprintf("Calculating 5 GHz gain pattern...\n");

figure;

pattern(ant,f2,...
    "Type","gain");

title("Gain Pattern - 5 GHz");

%% ========================================================
% 11. DIRECTIVITY AT 2.4 GHz
% ========================================================

fprintf("\n");
fprintf("Calculating 2.4 GHz directivity...\n");

D24 = pattern(ant,f1,...
    0,...
    0,...
    "Type","directivity");

fprintf("Directivity at 2.4 GHz = %.3f dBi\n",D24);

%% ========================================================
% 12. DIRECTIVITY AT 5 GHz
% ========================================================

fprintf("\n");
fprintf("Calculating 5 GHz directivity...\n");

D5 = pattern(ant,f2,...
    0,...
    0,...
    "Type","directivity");

fprintf("Directivity at 5 GHz = %.3f dBi\n",D5);

%% ========================================================
% 13. PEAK GAIN
% ========================================================

fprintf("\n");
fprintf("Calculating peak gain...\n");

gain24 = pattern(ant,f1,...
    0,...
    0,...
    "Type","gain");

gain5 = pattern(ant,f2,...
    0,...
    0,...
    "Type","gain");

fprintf("Gain at 2.4 GHz = %.3f dBi\n",gain24);

fprintf("Gain at 5 GHz   = %.3f dBi\n",gain5);

%% ========================================================
% 14. RADIATION EFFICIENCY
% ========================================================

fprintf("\n");
fprintf("Calculating radiation efficiency...\n");

eff24 = efficiency(ant,f1);

eff5 = efficiency(ant,f2);

fprintf("Efficiency at 2.4 GHz = %.3f %%\n",eff24*100);

fprintf("Efficiency at 5 GHz   = %.3f %%\n",eff5*100);

%% ========================================================
% 15. FINAL SUMMARY
% ========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 14 FINAL SUMMARY\n");
fprintf("====================================================\n");

fprintf("\n2.4 GHz\n");

fprintf("Directivity : %.3f dBi\n",D24);

fprintf("Gain        : %.3f dBi\n",gain24);

fprintf("Efficiency  : %.3f %%\n",eff24*100);

fprintf("\n5 GHz\n");

fprintf("Directivity : %.3f dBi\n",D5);

fprintf("Gain        : %.3f dBi\n",gain5);

fprintf("Efficiency  : %.3f %%\n",eff5*100);

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 14 COMPLETED\n");
fprintf("====================================================\n");