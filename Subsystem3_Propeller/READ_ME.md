# DE_Optimisation_Subsystem3
Design Engineering Optimisation module coursework individual component

Created by: Anusha Sonthalia

Team: Joseph Shepard, Hannah Lau, Elspeth Peatman

Date Created: Friday 13 Dec 2019

Date Last Edited: Friday 13 Dec 2019


## Description
This directory contains the specific code used to compute the optimisation for the efficiency of the propeller wing. The code should be read in conjuction with the accompanying report which explains detials of the methods and models. 

## Organisation
There are two code files and a remaining set of data files. All data files beginning with "xf-naca..." are downoads from [the NACA database.](http://airfoiltools.com/airfoil/naca4digit) The two ".m" files are intended to function as follows:
* DataCollator.m contains code which parses through all downloaded data files to produce two .csv files which contains the compiled drag and lift coefficient testing data in the format specified.
* Optimatorinator.m conatins code which creates a non-linear regression model based on the collated data and uses it to perform an gradient based optimisation as detailed in the report.

## Installation
The code was written in MATLAB_R2019b and should be run in the same programme to avoid issues. The Global 
Optimisation and Polyfitn toolboxes are requred in MatLab to run these files.

## Assessment notes
Unfortunately, the code cannot run in it's entirety due to an unsolved error in the formation of nonlinear constraint functions. Nonetheless, the progress insofar has been commentd and explained in detail throughout the code files.
 
