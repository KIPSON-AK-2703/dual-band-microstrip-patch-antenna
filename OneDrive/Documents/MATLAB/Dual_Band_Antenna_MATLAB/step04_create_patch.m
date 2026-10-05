%% STEP 4 - Create Initial 2.4 GHz Patch Antenna
%
% Project:
% Design and Fabrication of a Dual-Band
% Microstrip Patch Antenna for 2.4/5 GHz

clc;
clear;
close all;

%% Design Parameters

c = 3e8;

fr = 2.4e9;

er = 4.3;

h = 1.6e-3;

tanDelta = 0.02;

%% Patch Dimensions
% Use the exact values obtained from Step 2
% if they are different from these rounded values.

W = 37.9e-3;

L = 29.7e-3;

%% Ground / Substrate Dimensions

groundWidth = 50e-3;

groundLength = 50e-3;

%% Feed Width
% Use the exact value calculated in Step 3
% if different.

Wf = 3.0e-3;

%% Create FR-4 Substrate

substrate = dielectric;

substrate.Name = "FR4";

substrate.EpsilonR = er;

substrate.LossTangent = tanDelta;

substrate.Thickness = h;

%% Create Microstrip Patch

ant = patchMicrostrip;

ant.Length = L;

ant.Width = W;

ant.Height = h;

ant.Substrate = substrate;

ant.GroundPlaneLength = groundLength;

ant.GroundPlaneWidth = groundWidth;

%% Display 3D Antenna

figure;

show(ant);

title("Initial 2.4 GHz Microstrip Patch Antenna");

%% Top View

figure;

show(ant);

view(2);

axis equal;

title("Top View - Microstrip Patch Antenna");

%% Side View

figure;

show(ant);

view(90,0);

axis equal;

title("Side View - Microstrip Patch Antenna");

%% Display Parameters

fprintf("\n============================================\n");
fprintf("INITIAL PATCH ANTENNA\n");
fprintf("============================================\n");

fprintf("Frequency       : %.2f GHz\n", fr/1e9);

fprintf("Patch Length    : %.3f mm\n", L*1000);

fprintf("Patch Width     : %.3f mm\n", W*1000);

fprintf("Substrate       : FR-4\n");

fprintf("Epsilon R       : %.2f\n", er);

fprintf("Thickness       : %.3f mm\n", h*1000);

fprintf("Ground Length   : %.3f mm\n", groundLength*1000);

fprintf("Ground Width    : %.3f mm\n", groundWidth*1000);

fprintf("Feed Width      : %.3f mm\n", Wf*1000);

fprintf("============================================\n");