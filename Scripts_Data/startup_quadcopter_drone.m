clear; clc;

% Install YUMIP solver
install_sedumi

% Parameters
quadcopter_parameters;
MPC_setup;

% Define path
create_path;

% Open Model
QuadcopterMPC