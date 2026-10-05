%% STEP 2 - Initial Antenna Design Calculations
% Project:
% Design and Fabrication of a Dual-Band
% Microstrip Patch Antenna for 2.4/5 GHz

clc;
clear;
close all;

%% Basic Parameters

c = 3e8;              % Speed of light (m/s)

fr = 2.4e9;           % Lower target frequency (Hz)

er = 4.3;             % Relative dielectric constant

h = 1.6e-3;           % Substrate thickness (m)

tanDelta = 0.02;      % Loss tangent

fprintf("============================================\n");
fprintf("DUAL-BAND MICROSTRIP PATCH ANTENNA\n");
fprintf("STEP 2 - DESIGN CALCULATIONS\n");
fprintf("============================================\n\n");

fprintf("Target frequency       : %.2f GHz\n", fr/1e9);
fprintf("Relative permittivity  : %.2f\n", er);
fprintf("Substrate thickness    : %.2f mm\n", h*1000);
fprintf("Loss tangent           : %.3f\n\n", tanDelta);

%% Patch Width

W = (c/(2*fr)) * sqrt(2/(er + 1));

fprintf("Patch Width W          : %.3f mm\n", W*1000);

%% Effective Dielectric Constant

eeff = ((er + 1)/2) + ...
       ((er - 1)/2) * ...
       (1 + 12*h/W)^(-0.5);

fprintf("Effective permittivity : %.4f\n", eeff);

%% Effective Patch Length

Leff = c/(2*fr*sqrt(eeff));

fprintf("Effective length Leff  : %.3f mm\n", Leff*1000);

%% Fringing Field Extension

deltaL = 0.412*h * ...
    ((eeff + 0.3) * (W/h + 0.264)) / ...
    ((eeff - 0.258) * (W/h + 0.8));

fprintf("Length extension dL    : %.3f mm\n", deltaL*1000);

%% Physical Patch Length

L = Leff - 2*deltaL;

fprintf("Physical patch length L: %.3f mm\n", L*1000);

%% Free-Space Wavelength

lambda0 = c/fr;

fprintf("Free-space wavelength  : %.3f mm\n", lambda0*1000);

%% Initial Substrate Dimensions

substrateLength = 50e-3;
substrateWidth  = 50e-3;

fprintf("Substrate length       : %.1f mm\n", ...
    substrateLength*1000);

fprintf("Substrate width        : %.1f mm\n", ...
    substrateWidth*1000);

%% Final Design Values

fprintf("\n============================================\n");
fprintf("INITIAL DESIGN PARAMETERS\n");
fprintf("============================================\n");

fprintf("Frequency               = %.2f GHz\n", fr/1e9);
fprintf("Dielectric constant     = %.2f\n", er);
fprintf("Substrate thickness     = %.2f mm\n", h*1000);
fprintf("Patch width W           = %.3f mm\n", W*1000);
fprintf("Effective permittivity  = %.4f\n", eeff);
fprintf("Effective length Leff   = %.3f mm\n", Leff*1000);
fprintf("Length extension dL     = %.3f mm\n", deltaL*1000);
fprintf("Patch length L          = %.3f mm\n", L*1000);
fprintf("Substrate width         = %.1f mm\n", substrateWidth*1000);
fprintf("Substrate length        = %.1f mm\n", substrateLength*1000);

fprintf("============================================\n");