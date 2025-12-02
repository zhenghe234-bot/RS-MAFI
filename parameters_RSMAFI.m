function params = parameters_RSMAFI()
%PARAMETERS_RSMAFI Define model parameters for the R¨CS MAFI root system.
%   params = PARAMETERS_RSMAFI() returns a structure containing all
%   parameters needed by the RS-MAFI visualization code.

    % ----- Root orders: 1, 2, 3 -----
    % Each order has:
    %   s         - growth coefficient (mm/day)
    %   Lmax      - potential maximum length (mm)
    %   Dmax      - maximum diameter (mm)
    %   B         - number of laterals
    %   dx        - segment length (mm)
    %   branchAngle0 - base branching angle (rad, will be updated for order 1)
    %   g_strength   - gravitropism strength (0¨C1)
    %   jitter       - random perturbation in x,y (mm)

    % Order 1 (primary roots)
    p1.s            = 14.6;
    p1.Lmax         = 121.0;
    p1.Dmax         = 0.84;
    p1.B            = 10;
    p1.dx           = 3.0;
    p1.branchAngle0 = deg2rad(30);   % will be updated by fractal dimension
    p1.g_strength   = 0.30;
    p1.jitter       = 1.5;
    p1.la           = 35.1;          % apical zone length (mm)
    p1.lc           = 38.7;          % central branching zone (mm)
    p1.lb           = 5.3;           % basal zone (mm)
    
    % Order 2
    p2.s            = 8.4;
    p2.Lmax         = 16.1;
    p2.Dmax         = 0.63;
    p2.B            = 6;
    p2.dx           = 2.0;
    p2.branchAngle0 = deg2rad(60);
    p2.g_strength   = 0.10;
    p2.jitter       = 0.8;
    p2.la           = 4.1;
    p2.lc           = 4.5;
    p2.lb           = 1.5;
    
    % Order 3
    p3.s            = 1.3;
    p3.Lmax         = 5.8;
    p3.Dmax         = 0.22;
    p3.B            = 1;
    p3.dx           = 1.0;
    p3.branchAngle0 = deg2rad(75);
    p3.g_strength   = 0.05;
    p3.jitter       = 0.5;
    p3.la           = 3.1;
    p3.lc           = 2.7;
    p3.lb           = 0.0; 
    
    params.rootParams = [p1, p2, p3];

    % ----- Soil and empirical parameters (from S1 example) -----
    params.n0         = 0.471;
    params.Vcontainer = 5.30e6;      % mm^3
    params.a_shear    = 216.6;       % coefficient in sigma_c(n)
    params.Vroot_8    = 48.0;        % mm^3 at Day 8
    [~, sigma_c8]     = soil_update(params.Vroot_8, ...
                                    params.n0, params.Vcontainer, params.a_shear);

    % For visualization we use a constant shear strength ~ Day-8 value
    params.sigma_c_const = sigma_c8; % ~112 kPa

    % Elongation soil resistance coefficient (Eq. (2))
    params.lambda_L = 8.6e-4;        % kPa^-1

    % Fractal dimension measurements (Fig. 7)
    params.Df_times  = [8 16 24 32];
    params.Df_values = [1.22 1.45 1.63 1.78];

    % Direction regulation (Eq. (9))
    params.theta0_1 = 30.0;          % initial angle for 1st-order roots (deg)
    params.k_theta  = 28.2;          % coefficient k_theta
    params.sigma_c_func = @(t) max(60, 112 - 1.25*(t - 8)); 
end
