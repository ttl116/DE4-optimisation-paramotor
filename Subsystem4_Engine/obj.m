function m_min = obj(x)
density_Air = 1.225e-6;
B = x(1);
S = x(2);
N_M = x(3);
R_AF = x(4);

V_cyl = (pi * B.^2 * S)/4;
m_air = density_Air * V_cyl;
m_fuel = m_air/(R_AF+1);
m_min = m_fuel * N_M /2;
end