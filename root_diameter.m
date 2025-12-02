function d = root_diameter(Dmax_i, r_i, t, sigma_c, lambda_D)
%ROOT_DIAMETER Diameter model (Eq. (3)).
%   d = root_diameter(Dmax_i, r_i, t, sigma_c, lambda_D)
%   d_i(t) = D_max,i * (1 - exp(-r_i/D_max,i * t)) * exp(-lambda_D * sigma_c)

    baseDia = 1 - exp(-(r_i / Dmax_i) * t);
    soilDia = exp(-lambda_D * sigma_c);
    d       = Dmax_i * baseDia * soilDia;
end
