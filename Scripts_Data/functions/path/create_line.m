function new_path = create_line(path, destination, max_speed)

new_path = path;

origin = [path.x(end) path.y(end) path.z(end)];

distance_traveled = sqrt(sum((destination-origin).^2));
travel_time = distance_traveled/max_speed;

dx = path.MPC.Ts*(destination(1)-origin(1))/travel_time;
dy = path.MPC.Ts*(destination(2)-origin(2))/travel_time;
dz = path.Ts*(destination(3)-origin(3))/travel_time;

new_path.x = [path.x linspace(origin(1)+dx, destination(1), ceil(travel_time/path.MPC.Ts))];
new_path.y = [path.y linspace(origin(2)+dy, destination(2), ceil(travel_time/path.MPC.Ts))];
new_path.z = [path.z linspace(origin(3)+dz, destination(3), ceil(travel_time/path.Ts))];
new_path.yaw = [path.yaw path.yaw(end)*ones(1,ceil(travel_time/path.Ts))];

end

