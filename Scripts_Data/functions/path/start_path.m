function path = start_path(init_pos, target_pos, Ts, max_yaw_rate, MPC_config)

path.init_pos = [init_pos 0.14];
path.target_pos = [target_pos 0.14];

path.x = [init_pos(1)];
path.y = [init_pos(2)];
path.z = [0.14];
path.yaw = [0];

path.Ts = Ts;
path.MPC.Ts = MPC_config.Ts;
path.MPC.N = MPC_config.N;
path.limits.yawRate = deg2rad(max_yaw_rate);
path.end_time = 0;

end

