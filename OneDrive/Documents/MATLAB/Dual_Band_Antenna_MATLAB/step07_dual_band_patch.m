%% STEP 7 - Dual-Band Microstrip Patch Antenna
%
% Project:
% Design and Fabrication of a Dual-Band
% Microstrip Patch Antenna for 2.4/5 GHz
%
% MATLAB R2024b
%
% Method:
% E-notched microstrip patch
%
% Target frequencies:
% 2.4 GHz and 5.0 GHz

clc;
clear;
close all;

%% =========================================================
% 1. DESIGN PARAMETERS
% ==========================================================

c = 3e8;

f1 = 2.4e9;       % Lower target frequency
f2 = 5.0e9;       % Upper target frequency

er = 4.3;         % FR-4 relative permittivity
h = 1.6e-3;       % Substrate thickness
tanDelta = 0.02;  % FR-4 loss tangent

Z0 = 50;           % Reference impedance

%% =========================================================
% 2. PATCH DIMENSIONS
% ==========================================================

W = 37.9e-3;       % Patch width
L = 29.7e-3;       % Patch length

groundWidth = 50e-3;
groundLength = 50e-3;

%% =========================================================
% 3. CREATE FR-4 SUBSTRATE
% ==========================================================

substrate = dielectric;

substrate.Name = "FR4";
substrate.EpsilonR = er;
substrate.LossTangent = tanDelta;
substrate.Thickness = h;

%% =========================================================
% 4. DISPLAY DESIGN INFORMATION
% ==========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("DUAL-BAND MICROSTRIP PATCH ANTENNA\n");
fprintf("====================================================\n");

fprintf("Lower target frequency : %.2f GHz\n",f1/1e9);
fprintf("Upper target frequency : %.2f GHz\n",f2/1e9);

fprintf("Substrate              : FR-4\n");
fprintf("Relative permittivity  : %.2f\n",er);
fprintf("Substrate thickness    : %.2f mm\n",h*1000);
fprintf("Loss tangent            : %.3f\n",tanDelta);

fprintf("\nPatch dimensions:\n");
fprintf("Patch width             : %.2f mm\n",W*1000);
fprintf("Patch length            : %.2f mm\n",L*1000);

fprintf("\nGround dimensions:\n");
fprintf("Ground width            : %.2f mm\n",groundWidth*1000);
fprintf("Ground length           : %.2f mm\n",groundLength*1000);

fprintf("====================================================\n");

%% =========================================================
% 5. CREATE E-NOTCHED PATCH
% ==========================================================

ant = patchMicrostripEnotch;

%% Patch dimensions

ant.Length = L;
ant.Width = W;
ant.Height = h;

%% Substrate

ant.Substrate = substrate;

%% Ground plane

ant.GroundPlaneLength = groundLength;
ant.GroundPlaneWidth = groundWidth;

%% =========================================================
% 6. DISPLAY INITIAL ANTENNA
% ==========================================================

figure;

show(ant);

title("Initial E-Notched Dual-Band Patch Antenna");

%% =========================================================
% 7. FREQUENCY SWEEP
% ==========================================================

fStart = 1.5e9;
fStop = 6.0e9;

N = 301;

frequency = linspace(fStart,fStop,N);

%% =========================================================
% 8. CALCULATE INPUT IMPEDANCE
% ==========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("RUNNING FREQUENCY SWEEP\n");
fprintf("====================================================\n");

fprintf("Frequency range : %.2f - %.2f GHz\n", ...
    fStart/1e9,fStop/1e9);

fprintf("Number of points: %d\n",N);

fprintf("Please wait...\n");

Z = impedance(ant,frequency);

fprintf("Calculation completed.\n");

%% =========================================================
% 9. CALCULATE REFLECTION COEFFICIENT
% ==========================================================

Gamma = (Z-Z0)./(Z+Z0);

%% =========================================================
% 10. CALCULATE S11
% ==========================================================

S11_dB = 20*log10(abs(Gamma));

%% =========================================================
% 11. CALCULATE VSWR
% ==========================================================

VSWR = (1+abs(Gamma))./(1-abs(Gamma));

%% =========================================================
% 12. PLOT S11
% ==========================================================

figure;

plot(frequency/1e9,S11_dB,'LineWidth',1.5);

grid on;

xlabel("Frequency (GHz)");
ylabel("S_{11} (dB)");

title("S_{11} of Initial Dual-Band Patch");

xlim([1.5 6]);

ylim([-40 5]);

hold on;

yline(-10,"--");

xline(2.4,"--");
xline(5.0,"--");

hold off;

%% =========================================================
% 13. FIND RESONANCES
% ==========================================================

% Find local minima of S11

[pks,locs] = findpeaks(-S11_dB);

resonanceFrequencies = frequency(locs);

%% =========================================================
% 14. DISPLAY POSSIBLE RESONANCES
% ==========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("POSSIBLE RESONANCES\n");
fprintf("====================================================\n");

for k = 1:length(resonanceFrequencies)

    fprintf("Resonance %d : %.4f GHz\n", ...
        k,resonanceFrequencies(k)/1e9);

end

%% =========================================================
% 15. FIND S11 NEAR 2.4 GHz
% ==========================================================

[~,index1] = min(abs(frequency-f1));

S11_2p4 = S11_dB(index1);

Z_2p4 = Z(index1);

VSWR_2p4 = VSWR(index1);

fprintf("\n");
fprintf("====================================================\n");
fprintf("RESULT AT 2.4 GHz\n");
fprintf("====================================================\n");

fprintf("Frequency : %.4f GHz\n", ...
    frequency(index1)/1e9);

fprintf("S11       : %.3f dB\n",S11_2p4);

fprintf("Resistance: %.3f Ohm\n",real(Z_2p4));

fprintf("Reactance : %.3f Ohm\n",imag(Z_2p4));

fprintf("VSWR      : %.3f\n",VSWR_2p4);

%% =========================================================
% 16. FIND S11 NEAR 5 GHz
% ==========================================================

[~,index2] = min(abs(frequency-f2));

S11_5 = S11_dB(index2);

Z_5 = Z(index2);

VSWR_5 = VSWR(index2);

fprintf("\n");
fprintf("====================================================\n");
fprintf("RESULT AT 5 GHz\n");
fprintf("====================================================\n");

fprintf("Frequency : %.4f GHz\n", ...
    frequency(index2)/1e9);

fprintf("S11       : %.3f dB\n",S11_5);

fprintf("Resistance: %.3f Ohm\n",real(Z_5));

fprintf("Reactance : %.3f Ohm\n",imag(Z_5));

fprintf("VSWR      : %.3f\n",VSWR_5);

%% =========================================================
% 17. INPUT IMPEDANCE PLOT
% ==========================================================

figure;

plot(frequency/1e9,real(Z),'LineWidth',1.5);

hold on;

plot(frequency/1e9,imag(Z),'LineWidth',1.5);

grid on;

xlabel("Frequency (GHz)");
ylabel("Impedance (Ohm)");

title("Input Impedance");

legend("Resistance","Reactance");

xlim([1.5 6]);

yline(0,"--");

xline(2.4,"--");
xline(5.0,"--");

hold off;

%% =========================================================
% 18. VSWR PLOT
% ==========================================================

figure;

plot(frequency/1e9,VSWR,'LineWidth',1.5);

grid on;

xlabel("Frequency (GHz)");
ylabel("VSWR");

title("VSWR of Dual-Band Patch");

xlim([1.5 6]);

ylim([1 10]);

yline(2,"--");

xline(2.4,"--");
xline(5.0,"--");

%% =========================================================
% 19. FINAL SUMMARY
% ==========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 7 SUMMARY\n");
fprintf("====================================================\n");

fprintf("Target 1 : %.2f GHz\n",f1/1e9);
fprintf("S11      : %.3f dB\n",S11_2p4);

fprintf("\n");

fprintf("Target 2 : %.2f GHz\n",f2/1e9);
fprintf("S11      : %.3f dB\n",S11_5);

fprintf("\n");

fprintf("====================================================\n");
fprintf("STEP 7 COMPLETED\n");
fprintf("====================================================\n");