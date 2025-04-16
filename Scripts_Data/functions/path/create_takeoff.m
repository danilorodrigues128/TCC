function new_path = create_takeoff(path, altitude, yaw, takeoff_time)

new_path = path;

yaw = deg2rad(yaw);

delta_yaw = mod(yaw-path.yaw(end)+pi,2*pi)-pi;
if delta_yaw < -pi
    delta_yaw = delta_yaw + 2*pi;
end

new_path.x = [path.x path.x(end)*ones(1,takeoff_time/path.MPC.Ts)];
new_path.y = [path.y path.y(end)*ones(1,takeoff_time/path.MPC.Ts)];
new_path.z = [path.z linspace(0.14,altitude,takeoff_time/path.Ts)];
new_path.yaw = [path.yaw path.yaw(end)*ones(1,2/path.Ts) linspace(path.yaw(end),path.yaw(end)+delta_yaw,(takeoff_time-4)/path.Ts) yaw*ones(1,2/path.Ts)];

end

