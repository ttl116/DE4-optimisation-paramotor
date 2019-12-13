README
==============
Main script
---------
The main.m MATLAB script should be run.

MATLAB script nonlcon.m describes the non-linear constraints.

MATLAB script obj.m describes the objective function.

Execution time
----------
The execution time is approximately 0.01 seconds, run on Windows 10 with Intel® Core™ i7 processor.

Dependencies
----------
The script requires only MATLAB_R2017A.

System level optimisation
----------
The link with the system level optimisation comes in with Anusha's output of an optimum value of torque. It can be inputted into the nonlcon.m script in the relevant field to get an optimum fuel consumption at the system level.

Discrepancies between the report and the code
----------
- Originally x(3) in the code was air-fuel ratio, while x(4) was the engine speed. In table 2 of the report the x values were shown to be in this order, whereas in the rest of the report x(3) is the engine speed and x(4) is the air-fuel ratio. The code has since been changed to be consistent with the rest of the report.
- In the report torque was set to be 18. In fact, the code was run with torque set to 22 to get the results shown in section C.
