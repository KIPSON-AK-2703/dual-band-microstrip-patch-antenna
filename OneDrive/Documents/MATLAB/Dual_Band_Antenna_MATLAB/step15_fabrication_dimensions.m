%% STEP 15 - Fabrication-Ready Dimensions
%
% Dual-Band Microstrip Patch Antenna
% Target: 2.4 GHz / 5 GHz
%
% MATLAB R2024b

clc;
clear;
close all;

%% ========================================================
% 1. FINAL ANTENNA PARAMETERS
% ========================================================
%
% REPLACE THESE WITH YOUR ACTUAL STEP 11 VALUES
%

patchLength = 29.7;       % mm
patchWidth  = 37.9;       % mm

substrateThickness = 1.6; % mm

groundLength = 50.0;      % mm
groundWidth  = 50.0;      % mm

notchLength = 9.0;        % mm
notchWidth  = 1.0;        % mm

centerNotchLength = 2.8;  % mm
centerNotchWidth  = 6.2;  % mm

feedPosition = -7.0;      % mm

%% ========================================================
% 2. TARGET FREQUENCIES
% ========================================================

f1 = 2.4;   % GHz

f2 = 5.0;   % GHz

%% ========================================================
% 3. MATERIAL
% ========================================================

epsilonR = 4.3;

lossTangent = 0.02;

material = "FR-4";

%% ========================================================
% 4. DISPLAY FABRICATION TABLE
% ========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("FABRICATION-READY ANTENNA DIMENSIONS\n");
fprintf("====================================================\n");

fprintf("\n");

fprintf("Material\n");
fprintf("--------------------------------------------\n");

fprintf("Substrate          : %s\n",material);

fprintf("Relative epsilon   : %.2f\n",epsilonR);

fprintf("Loss tangent       : %.3f\n",lossTangent);

fprintf("Thickness          : %.2f mm\n", ...
    substrateThickness);

fprintf("\n");

fprintf("Patch\n");
fprintf("--------------------------------------------\n");

fprintf("Patch Length       : %.3f mm\n", ...
    patchLength);

fprintf("Patch Width        : %.3f mm\n", ...
    patchWidth);

fprintf("\n");

fprintf("Ground Plane\n");
fprintf("--------------------------------------------\n");

fprintf("Ground Length      : %.3f mm\n", ...
    groundLength);

fprintf("Ground Width       : %.3f mm\n", ...
    groundWidth);

fprintf("\n");

fprintf("E-Notch\n");
fprintf("--------------------------------------------\n");

fprintf("Notch Length       : %.3f mm\n", ...
    notchLength);

fprintf("Notch Width        : %.3f mm\n", ...
    notchWidth);

fprintf("Center Notch Length: %.3f mm\n", ...
    centerNotchLength);

fprintf("Center Notch Width : %.3f mm\n", ...
    centerNotchWidth);

fprintf("\n");

fprintf("Feed\n");
fprintf("--------------------------------------------\n");

fprintf("Feed Position      : %.3f mm\n", ...
    feedPosition);

fprintf("\n");

fprintf("Frequency Targets\n");
fprintf("--------------------------------------------\n");

fprintf("Band 1             : %.2f GHz\n",f1);

fprintf("Band 2             : %.2f GHz\n",f2);

fprintf("\n");

fprintf("====================================================\n");

%% ========================================================
% 5. TOTAL BOARD SIZE
% ========================================================

boardArea = groundLength * groundWidth;

fprintf("\n");
fprintf("BOARD INFORMATION\n");
fprintf("====================================================\n");

fprintf("PCB Length : %.2f mm\n",groundLength);

fprintf("PCB Width  : %.2f mm\n",groundWidth);

fprintf("PCB Area   : %.2f mm^2\n",boardArea);

fprintf("====================================================\n");

%% ========================================================
% 6. FABRICATION CHECKS
% ========================================================

fprintf("\n");
fprintf("FABRICATION CHECK\n");
fprintf("====================================================\n");

if patchLength < groundLength
    fprintf("Patch length vs board : PASS\n");
else
    fprintf("Patch length vs board : CHECK\n");
end

if patchWidth < groundWidth
    fprintf("Patch width vs board  : PASS\n");
else
    fprintf("Patch width vs board  : CHECK\n");
end

if substrateThickness > 0
    fprintf("Substrate thickness   : PASS\n");
else
    fprintf("Substrate thickness   : FAIL\n");
end

fprintf("====================================================\n");

%% ========================================================
% 7. SAVE DIMENSIONS TO MAT FILE
% ========================================================

save("final_antenna_dimensions.mat", ...
    "patchLength", ...
    "patchWidth", ...
    "substrateThickness", ...
    "groundLength", ...
    "groundWidth", ...
    "notchLength", ...
    "notchWidth", ...
    "centerNotchLength", ...
    "centerNotchWidth", ...
    "feedPosition", ...
    "f1", ...
    "f2", ...
    "epsilonR", ...
    "lossTangent");

fprintf("\n");
fprintf("Dimensions saved to:\n");
fprintf("final_antenna_dimensions.mat\n");

fprintf("\nSTEP 15 COMPLETED.\n");