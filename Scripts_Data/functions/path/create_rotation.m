function new_path = create_rotation(path, yaw)

new_path = path;

yaw = deg2rad(yaw);
rotation_time = abs(path.yaw(end)-yaw)/path.limits.yawRate;

delta_yaw = mod(yaw-path.yaw(end)+pi,2*pi)-pi;
if delta_yaw < -pi
    delta_yaw = delta_yaw + 2*pi;
end

new_path.x = [new_path.x path.x(end)*ones(1,ceil(rotation_time/path.MPC.Ts))];
new_path.y = [new_path.y path.y(end)*ones(1,ceil(rotation_time/path.MPC.Ts))];
new_path.z = [new_path.z path.z(end)*ones(1,ceil(rotation_time/path.Ts))];
new_path.yaw = [new_path.yaw linspace(path.yaw(end),path.yaw(end)+delta_yaw,ceil(rotation_time/path.Ts))];

end