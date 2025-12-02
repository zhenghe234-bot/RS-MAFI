% RUN_RSMAFI
%   Main script to run the R¨CS MAFI root system visualization.
%   You can modify the vector 'times' below to generate models
%   for arbitrary days.

clear; close all; clc;

% ----- 1) choose time points (days) you want -------------------------
times = [32];   

% ----- 2) load parameters --------------------------------------------
params = parameters_RSMAFI();

refLimit = 70;          % plot range for x,y (mm)
depthMin = -130;        % z range (mm)
depthMax = 0;

nT = numel(times);
nRow = ceil(sqrt(nT));
nCol = ceil(nT / nRow);

figure('Color','w','Position',[100 100 1400 900]);

for k = 1:nT
    tDay = times(k);

    % build root system
    units = build_root_system_RSMAFI(tDay, params);

    % compute Df and theta for title
    Df_t   = fractal_dimension(tDay, params.Df_times, params.Df_values);
    theta1 = direction_angle(params.theta0_1, Df_t, params.k_theta);

    subplot(nRow, nCol, k);
    plot_root_system_RSMAFI(units, tDay, Df_t, theta1, refLimit, depthMin, depthMax);
end
