function units = build_root_system_RSMAFI(tDay, params)
%BUILD_ROOT_SYSTEM_RSMAFI Build a 3-D root system for a given day.
%   units = build_root_system_RSMAFI(tDay, params) returns an array
%   of segments (start, finish, order, diameter, area) for visualization.

    rootParams = params.rootParams;
    numOrders  = numel(rootParams);

    % ----- 1) fractal dimension and angle for order-1 (Eq. (8) & (9)) ---
    Df_t   = fractal_dimension(tDay, params.Df_times, params.Df_values);
    theta1 = direction_angle(params.theta0_1, Df_t, params.k_theta); % degrees
    branchAngle1 = deg2rad(theta1);
    rootParams(1).branchAngle0 = branchAngle1;

    % ----- 2) elongation lengths for each order (Eq. (2)) ---------------
    % soil shear strength at current time
    if isfield(params, 'sigma_c_func')
        sigma_c_current = params.sigma_c_func(tDay);
    else
        sigma_c_current = params.sigma_c_const;
    end

    Ltargets = zeros(1,numOrders);
    for i = 1:numOrders
        Ltargets(i) = root_length(rootParams(i).Lmax, ...
                                  rootParams(i).s, ...
                                  tDay, ...
                                  sigma_c_current, ...
                                  params.lambda_L);
    end

    % ----- 2.1 override primary root length by measured values ----------
    % These are the measured maximum lengths of the 1st-order root
    % used in the paper (Day 8, 16, 24, 32):
    fixedTimes   = [ 8   16   24    32 ];
    L1_measured  = [68   93  109   121 ];   % mm

    idx = find(abs(tDay - fixedTimes) < 1e-6, 1);
    if ~isempty(idx)
        % Enforce the measured primary-root length at this time
        Ltargets(1) = L1_measured(idx);
    end

    % ----- 3) recursively build segments --------------------------------
    units = struct('start',{},'finish',{},'order',{}, ...
                   'diameter',{},'area',{});

    seedPos    = [0 0 0];
    seedOrient = [0 0 -1];   % initial vertical direction (downward)

    % === create three primary roots around the crown ===
    nPrimary = 3;  % number of primary roots at the seed

    for k = 1:nPrimary
        % azimuth angle for each primary root (0, 120, 240 degrees)
        beta = 2*pi*(k-1)/nPrimary;

        % orientation of this primary root:
        % rotate from seedOrient by branchAngle0 around a horizontal axis
        orient1 = branch_orientation(seedOrient, rootParams(1).branchAngle0, beta);

        % grow order-1 root and its higher-order laterals
        units = grow_one_order(1, seedPos, orient1, ...
                               Ltargets, rootParams, units, tDay);
    end
end


function units = grow_one_order(order, startPos, orient, ...
                                Ltargets, rootParams, units, tDay)
%GROW_ONE_ORDER Grow one root order along an axis and recursively
%   spawn higher-order laterals.

    numOrders = numel(rootParams);
    if order > numOrders
        return;
    end

    p       = rootParams(order);
    Ltotal  = Ltargets(order);
    if Ltotal <= 0
        return;
    end

    dx      = p.dx;
    nSeg    = max(1, floor(Ltotal / dx));
    segLen  = Ltotal / nSeg;

    if p.B > 0
        % time-dependent branching factor (0~1)
        if tDay <= 5
            f_branch = 0.0;      % no laterals before Day 5
        elseif tDay < 10
            f_branch = 0.4;      % about 40% of potential laterals at Day 8
        elseif tDay < 20
            f_branch = 0.7;      % about 70% around Day 16
        else
            f_branch = 1.0;      % after Day 20, use full B
        end

        B_eff = max(0, floor(p.B * f_branch));  % effective number of laterals

        if B_eff > 0
            branchPositions = linspace(0.3*Ltotal, Ltotal, B_eff);
        else
            branchPositions = [];
        end
    else
        branchPositions = [];
    end

    nextB        = 1;
    accumulatedL = 0.0;

    currPos = startPos;
    currDir = orient;

    for j = 1:nSeg
        % gravitropism
        if p.g_strength > 0
            currDir = grav_slerp(currDir, [0 0 -1], p.g_strength);
        end

        % grow one segment
        endPos = currPos + segLen * currDir;

        % local jitter in x,y
        if p.jitter > 0
            endPos(1:2) = endPos(1:2) + (rand(1,2) - 0.5)*2*p.jitter;
        end

        diam = p.Dmax;
        area = pi * (diam/2)^2;

        units(end+1) = struct( ... %#ok<AGROW>
            'start',    currPos, ...
            'finish',   endPos, ...
            'order',    order, ...
            'diameter', diam, ...
            'area',     area);

        accumulatedL = accumulatedL + segLen;

        % ----- branching rule: only after Day 5 -------------------------
        if tDay > 5 && order < numOrders && ~isempty(branchPositions)
            if nextB <= numel(branchPositions) && ...
               accumulatedL >= branchPositions(nextB)

                % child orientation: branch away from current direction
                beta_child  = 2*pi*rand();   % random azimuth
                childOrient = branch_orientation(currDir, ...
                                                 p.branchAngle0, ...
                                                 beta_child);

                units = grow_one_order(order+1, endPos, childOrient, ...
                                       Ltargets, rootParams, units, tDay);
                nextB = nextB + 1;
            end
        end

        currPos = endPos;
    end
end
