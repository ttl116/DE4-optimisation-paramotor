function [c, ceq] = nonlcon(x)
torque = 22;
HV = 44000;
density_Petrol = 720;
density_Air = 1.225e-6;
B = x(1);
S = x(2);
N_M = x(3);
R_AF = x(4);

V_cyl = (pi * B.^2 * S)/4;
m_air = density_Air * V_cyl;
m_fuel = m_air/(R_AF+1);
m_min = m_fuel * N_M /2;
V_tank = m_min*3*60/density_Petrol;

c = (HV * B^2 * S * 3.0625e-8/(R_AF+1)) - torque;

ceq = V_tank-15;
    V_cyl-200000;
    
end