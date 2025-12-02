function Df_t = fractal_dimension(t, timeList, Df_values)
%FRACTAL_DIMENSION Linear interpolation of the fractal dimension D_f(t).
%   Df_t = fractal_dimension(t, timeList, Df_values) implements Eq. (8).

    if t <= timeList(1)
        Df_t = Df_values(1);
    elseif t >= timeList(end)
        Df_t = Df_values(end);
    else
        Df_t = interp1(timeList, Df_values, t, 'linear');
    end
end
