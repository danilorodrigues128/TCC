function new_path = create_hold(path, hold_time)

new_path = path;

new_path.x = [path.x path.x(end)*ones(1,hold_time/path.MPC.Ts)];
new_path.y = [path.y path.y(end)*ones(1,hold_time/path.MPC.Ts)];
new_path.z = [path.z path.z(end)*ones(1,hold_time/path.Ts)];
new_path.yaw = [path.yaw path.yaw(end)*ones(1,hold_time/path.Ts)];

end

