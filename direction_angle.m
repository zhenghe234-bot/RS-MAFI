function theta_t = direction_angle(theta0, Df_t, k_theta)
%DIRECTION_ANGLE Directional angle regulated by fractal dimension.
%   theta_t = direction_angle(theta0, Df_t, k_theta)
%   implements:
%     theta(t) = theta0 + k_theta * (D_f(t) - 1)

    theta_t = theta0 + k_theta * (Df_t - 1.0);
end
