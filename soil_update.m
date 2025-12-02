function [n_t, sigma_c_t] = soil_update(Vroot_t, n0, Vcontainer, a_shear)
%SOIL_UPDATE Porosity and shear strength feedback.
%   [n_t, sigma_c_t] = soil_update(Vroot_t, n0, Vcontainer, a_shear)
%   implements:
%     n(t)        = n0 - V_root(t) / V_container
%     sigma_c(n)  = a_shear * (1 - n/100)

    n_t       = n0 - Vroot_t / Vcontainer;
    sigma_c_t = a_shear * (1 - n_t/100);
end
