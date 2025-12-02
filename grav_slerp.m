function v_new = grav_slerp(v_old, gravityVec, g_strength)
%GRAV_SLERP Spherical interpolation of direction towards gravity.
%   v_new = grav_slerp(v_old, gravityVec, g_strength)
%   rotates v_old towards gravityVec by a fraction g_strength (0¨C1).

    % --- make column vectors and cast to double ---
    v0 = double(v_old(:));
    g  = double(gravityVec(:));

    % --- make sure they have the same length (defensive coding) ---
    n  = min(numel(v0), numel(g));
    v0 = v0(1:n);
    g  = g(1:n);

    % --- normalize both vectors ---
    if norm(v0) == 0
        v_new = v_old;    % degenerate case, keep original
        return;
    end
    if norm(g) == 0
        v_new = v_old;
        return;
    end

    v0 = v0 / norm(v0);
    g  = g  / norm(g);

    % --- compute angle between v0 and g ---
    d  = sum(v0 .* g);                 % dot product, lengths already matched
    d  = max(min(d, 1), -1);           % clamp to [-1, 1]
    om = acos(d);

    % --- if almost aligned or very small rotation requested ---
    if om < 1e-6 || g_strength <= 0
        v_new = v0.';                  % return row vector
        return;
    end

    % --- spherical linear interpolation ---
    t       = g_strength;
    s       = sin(om);
    v_interp = (sin((1-t)*om)/s)*v0 + (sin(t*om)/s)*g;

    % --- normalize and return as row vector ---
    v_interp = v_interp / norm(v_interp);
    v_new    = v_interp.';             % 1¡Án row vector
end
