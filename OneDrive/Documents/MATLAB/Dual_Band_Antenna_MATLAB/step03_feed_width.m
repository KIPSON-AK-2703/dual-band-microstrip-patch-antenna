%% STEP 3 - 50 Ohm Microstrip Feed Width

clc;
clear;
close all;

%% Design Parameters

er = 4.3;          % Relative dielectric constant
h = 1.6e-3;        % Substrate thickness (m)
Z0 = 50;            % Desired characteristic impedance (Ohms)

fprintf("============================================\n");
fprintf("50 OHM MICROSTRIP FEED DESIGN\n");
fprintf("============================================\n\n");

fprintf("Relative permittivity : %.2f\n", er);
fprintf("Substrate thickness   : %.2f mm\n", h*1000);
fprintf("Target impedance      : %.2f Ohm\n\n", Z0);

%% Search for Feed Width

W_values = linspace(0.1e-3, 10e-3, 10000);

Z_values = zeros(size(W_values));

for k = 1:length(W_values)
    Z_values(k) = calculateZ0(W_values(k), h, er);
end

%% Find Width Closest to 50 Ohm

[~, index] = min(abs(Z_values - Z0));

Wf = W_values(index);
Z_calculated = Z_values(index);

fprintf("Calculated feed width : %.3f mm\n", Wf*1000);
fprintf("Calculated impedance  : %.3f Ohm\n", Z_calculated);

%% Plot Impedance vs Feed Width

figure;

plot(W_values*1000, Z_values, 'LineWidth', 1.5);

grid on;

xlabel('Feed Width (mm)');
ylabel('Characteristic Impedance (\Omega)');

title('Microstrip Feed Width vs Characteristic Impedance');

hold on;

plot(Wf*1000, Z_calculated, 'o', 'MarkerSize', 8);

yline(50, '--');

hold off;

%% Final Feed Parameter

fprintf("\n============================================\n");
fprintf("FINAL FEED PARAMETER\n");
fprintf("============================================\n");

fprintf("Feed width Wf = %.3f mm\n", Wf*1000);
fprintf("Target Z0     = %.2f Ohm\n", Z0);
fprintf("Calculated Z0 = %.3f Ohm\n", Z_calculated);

fprintf("============================================\n");


%% Calculation Function
% IMPORTANT: Keep this function at the very bottom.

function Z0 = calculateZ0(W, h, er)

    u = W/h;

    % Effective dielectric constant

    eeff = (er + 1)/2 + ...
           (er - 1)/2 * ...
           (1 + 12/u)^(-0.5);

    % Characteristic impedance

    if u <= 1

        Z0 = (60/sqrt(eeff)) * ...
             log(8/u + u/4);

    else

        Z0 = (120*pi) / ...
             (sqrt(eeff) * ...
             (u + 1.393 + 0.667*log(u + 1.444)));

    end

end