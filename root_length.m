function L = root_length(Lmax_i, s_i, t, sigma_c, lambda_L)
%ROOT_LENGTH Elongation model (Eq. (2) in the manuscript).
%   L = root_length(Lmax_i, s_i, t, sigma_c, lambda_L)
%   computes:
%     l_i(t) = L_max,i * (1 - exp(-s_i/L_max,i * t)) * exp(-lambda_L * sigma_c)

    if Lmax_i <= 0
        L = 0;
        return;
    end

    baseGrowth = 1 - exp(-(s_i / Lmax_i) * t);
    soilFactor = exp(-lambda_L * sigma_c);

    L = Lmax_i * baseGrowth * soilFactor;
end
