%% STEP 11 - Robust Dual-Band Optimization
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
% 2. MATERIAL
% ========================================================

er = 4.3;
h = 1.6e-3;
tanDelta = 0.02;

%% ========================================================
% 3. ANTENNA DIMENSIONS
% ========================================================

patchLength = 29.7e-3;
patchWidth  = 37.9e-3;

groundLength = 50e-3;
groundWidth  = 50e-3;

%% ========================================================
% 4. FR-4
% ========================================================

substrate = dielectric;

substrate.Name = "FR4";
substrate.EpsilonR = er;
substrate.LossTangent = tanDelta;
substrate.Thickness = h;

%% ========================================================
% 5. OPTIMIZATION PARAMETERS
% ========================================================

% Notch length
notchLengths = 7e-3:0.5e-3:13e-3;

% Safer feed range
feedPositions = -10e-3:1e-3:10e-3;

% Fixed notch dimensions
notchWidth = 1e-3;

centerArmNotchLength = 2.8e-3;

centerArmNotchWidth = 6.2e-3;

%% ========================================================
% 6. RESULT MATRICES
% ========================================================

numberNotches = length(notchLengths);
numberFeeds = length(feedPositions);

S11_2p4 = NaN(numberNotches,numberFeeds);

S11_5 = NaN(numberNotches,numberFeeds);

Objective = Inf(numberNotches,numberFeeds);

%% ========================================================
% 7. TOTAL COMBINATIONS
% ========================================================

totalCombinations = numberNotches * numberFeeds;

successful = 0;
failed = 0;

fprintf("\n");
fprintf("====================================================\n");
fprintf("STEP 11 - ROBUST DUAL-BAND OPTIMIZATION\n");
fprintf("====================================================\n");

fprintf("Target 1 : %.2f GHz\n",f1/1e9);
fprintf("Target 2 : %.2f GHz\n",f2/1e9);

fprintf("Notch values : %d\n",numberNotches);
fprintf("Feed values  : %d\n",numberFeeds);

fprintf("Total combinations : %d\n",totalCombinations);

fprintf("\n");

%% ========================================================
% 8. OPTIMIZATION LOOP
% ========================================================

count = 0;

for n = 1:numberNotches

    for f = 1:numberFeeds

        count = count + 1;

        %% Create antenna

        ant = patchMicrostripEnotch;

        ant.Length = patchLength;
        ant.Width = patchWidth;
        ant.Height = h;

        %% E-notch

        ant.NotchLength = notchLengths(n);
        ant.NotchWidth = notchWidth;

        ant.CenterArmNotchLength = ...
            centerArmNotchLength;

        ant.CenterArmNotchWidth = ...
            centerArmNotchWidth;

        %% Substrate

        ant.Substrate = substrate;

        %% Ground

        ant.GroundPlaneLength = groundLength;
        ant.GroundPlaneWidth = groundWidth;

        %% Feed

        ant.FeedOffset = [feedPositions(f) 0];

        %% Try electromagnetic calculation

        try

            Z = impedance(ant,[f1 f2]);

            Gamma = (Z-Z0)./(Z+Z0);

            S11 = 20*log10(abs(Gamma));

            S11_2p4(n,f) = S11(1);

            S11_5(n,f) = S11(2);

            %% Worst-band objective

            Objective(n,f) = max(S11(1),S11(2));

            successful = successful + 1;

        catch

            %% Invalid geometry

            failed = failed + 1;

            S11_2p4(n,f) = NaN;

            S11_5(n,f) = NaN;

            Objective(n,f) = Inf;

        end

        %% Progress

        if mod(count,20) == 0

            fprintf( ...
                "Completed %3d / %3d | Successful = %3d | Failed = %3d\n", ...
                count, ...
                totalCombinations, ...
                successful, ...
                failed);

        end

    end

end

%% ========================================================
% 9. CHECK WHETHER ANY VALID RESULT EXISTS
% ========================================================

if successful == 0

    error("No valid antenna configuration was successfully simulated.");

end

%% ========================================================
% 10. FIND BEST COMBINATION
% ========================================================

[bestObjective,bestLinearIndex] = min(Objective(:));

[bestNotchIndex,bestFeedIndex] = ...
    ind2sub(size(Objective),bestLinearIndex);

bestNotchLength = notchLengths(bestNotchIndex);

bestFeedPosition = feedPositions(bestFeedIndex);

bestS11_2p4 = S11_2p4(bestNotchIndex,bestFeedIndex);

bestS11_5 = S11_5(bestNotchIndex,bestFeedIndex);

%% ========================================================
% 11. CREATE BEST ANTENNA
% ========================================================

bestAntenna = patchMicrostripEnotch;

bestAntenna.Length = patchLength;
bestAntenna.Width = patchWidth;
bestAntenna.Height = h;

bestAntenna.NotchLength = bestNotchLength;
bestAntenna.NotchWidth = notchWidth;

bestAntenna.CenterArmNotchLength = ...
    centerArmNotchLength;

bestAntenna.CenterArmNotchWidth = ...
    centerArmNotchWidth;

bestAntenna.Substrate = substrate;

bestAntenna.GroundPlaneLength = groundLength;
bestAntenna.GroundPlaneWidth = groundWidth;

bestAntenna.FeedOffset = [bestFeedPosition 0];

%% ========================================================
% 12. VSWR
% ========================================================

Zbest = impedance(bestAntenna,[f1 f2]);

GammaBest = (Zbest-Z0)./(Zbest+Z0);

VSWRbest = (1+abs(GammaBest))./(1-abs(GammaBest));

%% ========================================================
% 13. DISPLAY BEST DESIGN
% ========================================================

fprintf("\n");
fprintf("====================================================\n");
fprintf("BEST DUAL-BAND DESIGN\n");
fprintf("====================================================\n");

fprintf("Successful simulations : %d\n",successful);
fprintf("Failed simulations     : %d\n",failed);

fprintf("\n");

fprintf("Patch length : %.3f mm\n", ...
    patchLength*1000);

fprintf("Patch width  : %.3f mm\n", ...
    patchWidth*1000);

fprintf("Notch length : %.3f mm\n", ...
    bestNotchLength*1000);

fprintf("Feed position: %.3f mm\n", ...
    bestFeedPosition*1000);

fprintf("\n");

fprintf("2.4 GHz\n");
fprintf("S11  : %.3f dB\n",bestS11_2p4);
fprintf("VSWR : %.3f\n",VSWRbest(1));

fprintf("\n");

fprintf("5.0 GHz\n");
fprintf("S11  : %.3f dB\n",bestS11_5);
fprintf("VSWR : %.3f\n",VSWRbest(2));

fprintf("\n");

fprintf("Worst-band S11 : %.3f dB\n",bestObjective);

fprintf("====================================================\n");

%% ========================================================
% 14. 2.4 GHz HEATMAP
% ========================================================

figure;

imagesc(feedPositions*1000,...
        notchLengths*1000,...
        S11_2p4);

set(gca,"YDir","normal");

colorbar;

xlabel("Feed Position (mm)");
ylabel("Notch Length (mm)");

title("S_{11} at 2.4 GHz");

%% ========================================================
% 15. 5 GHz HEATMAP
% ========================================================

figure;

imagesc(feedPositions*1000,...
        notchLengths*1000,...
        S11_5);

set(gca,"YDir","normal");

colorbar;

xlabel("Feed Position (mm)");
ylabel("Notch Length (mm)");

title("S_{11} at 5 GHz");

%% ========================================================
% 16. OBJECTIVE HEATMAP
% ========================================================

figure;

imagesc(feedPositions*1000,...
        notchLengths*1000,...
        Objective);

set(gca,"YDir","normal");

colorbar;

xlabel("Feed Position (mm)");
ylabel("Notch Length (mm)");

title("Worst-Band S_{11}");

%% ========================================================
% 17. SHOW BEST ANTENNA
% ========================================================

figure;

show(bestAntenna);

title("Optimized Dual-Band E-Notched Antenna");

%% ========================================================
% 18. FULL FREQUENCY SWEEP
% ========================================================

frequency = linspace(1.8e9,6.0e9,301);

Zfull = impedance(bestAntenna,frequency);

GammaFull = (Zfull-Z0)./(Zfull+Z0);

S11Full = 20*log10(abs(GammaFull));

VSWRFull = (1+abs(GammaFull))./(1-abs(GammaFull));

%% ========================================================
% 19. FULL S11
% ========================================================

figure;

plot(frequency/1e9,S11Full,...
    "LineWidth",1.5);

hold on;

yline(-10,"--");

xline(2.4,"--");
xline(5.0,"--");

grid on;

xlabel("Frequency (GHz)");
ylabel("S_{11} (dB)");

title("Final Dual-Band S_{11}");

xlim([1.8 6]);
ylim([-40 5]);

hold off;

%% ========================================================
% 20. FULL VSWR
% ========================================================

figure;

plot(frequency/1e9,VSWRFull,...
    "LineWidth",1.5);

hold on;

yline(2,"--");

xline(2.4,"--");
xline(5.0,"--");

grid on;

xlabel("Frequency (GHz)");
ylabel("VSWR");

title("Final Dual-Band VSWR");

xlim([1.8 6]);
ylim([1 10]);

hold off;

%% ========================================================
% 21. FINAL RESULTS
% ========================================================

[~,index24] = min(abs(frequency-f1));

[~,index5] = min(abs(frequency-f2));

fprintf("\n");
fprintf("====================================================\n");
fprintf("FINAL RESULTS\n");
fprintf("====================================================\n");

fprintf("2.4 GHz:\n");
fprintf("S11  = %.3f dB\n",S11Full(index24));
fprintf("VSWR = %.3f\n",VSWRFull(index24));

fprintf("\n");

fprintf("5.0 GHz:\n");
fprintf("S11  = %.3f dB\n",S11Full(index5));
fprintf("VSWR = %.3f\n",VSWRFull(index5));

fprintf("\n");

fprintf("====================================================\n");
fprintf("STEP 11 COMPLETED\n");
fprintf("====================================================\n");