function orient = branch_orientation(parentDir, theta, beta)
%BRANCH_ORIENTATION Compute child root direction from parent direction,
%   branching angle theta (rad) and azimuth beta (rad).

    v0 = parentDir(:) / norm(parentDir);

    if abs(v0(3)) < 0.99
        arb = [0 0 1];
    else
        arb = [1 0 0];
    end

    u1 = cross(v0, arb);  u1 = u1 / norm(u1);
    u2 = cross(v0, u1);   u2 = u2 / norm(u2);

    orient = cos(theta)*v0 + sin(theta)*(cos(beta)*u1 + sin(beta)*u2);
    orient = (orient / norm(orient)).';
end
