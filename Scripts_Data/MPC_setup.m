%---[PARAMETERS]---%
MPC_config.Ts = 0.1;
MPC_config.N = 40;
MPC_config.g = g;

MPC_config.nx = 4;
MPC_config.nu = 2;

MPC_config.Q = 3*eye(2);
MPC_config.R = 5*eye(2);
MPC_config.S = 3*eye(2);

MPC_config.limits.pitch = deg2rad(30); % deg
MPC_config.limits.roll = deg2rad(30); % deg

%---[FUNCTION SETUP]---%
MPC = @(input)MPC_layout(input,MPC_config,false);