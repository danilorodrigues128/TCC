function new_path = create_landing(path, landing_time)

new_path = path;

new_path.x = [path.x path.x(end)*ones(1,landing_time/path.MPC.Ts)];
new_path.y = [path.y path.y(end)*ones(1,landing_time/path.MPC.Ts)];
new_path.yaw = [path.yaw path.yaw(end)*ones(1,landing_time/path.Ts)];

a = (50*path.z(end)-7)/(50*landing_time^2);
b = -(50*path.z(end)-7)/(25*landing_time);
c = path.z(end);
t = path.Ts:path.Ts:landing_time;

new_path.z = [path.z a*t.^2+b*t+c];

end