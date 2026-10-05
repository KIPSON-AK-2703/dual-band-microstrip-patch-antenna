%% STEP 1 - Dual-Band Microstrip Patch Antenna
% Project: Design and Fabrication of a Dual-Band
% Microstrip Patch Antenna for 2.4/5 GHz

clc;
clear;
close all;

%% Project Information

projectName = "Dual-Band Microstrip Patch Antenna";
lowerFrequency = 2.4e9;
upperFrequency = 5.0e9;

fprintf("Project: %s\n", projectName);
fprintf("Lower target frequency: %.2f GHz\n", lowerFrequency/1e9);
fprintf("Upper target frequency: %.2f GHz\n", upperFrequency/1e9);

%% Check Antenna Toolbox

which patchMicrostrip

%% Create a test microstrip patch antenna

ant = patchMicrostrip;

%% Display the test antenna

figure;
show(ant);

title("MATLAB Antenna Toolbox - Test Microstrip Patch");