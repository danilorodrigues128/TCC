function new_path = create_spline(path, waypoints, max_speed)

new_path = path;

x = [path.x(end) waypoints(:,1)'];
y = [path.y(end) waypoints(:,2)'];
z = [path.z(end) waypoints(:,3)'];

clamp = zeros(3,2);
if size(path.x,2) >= 2
    clamp(1:2,1) = [path.x(end)-path.x(end-1);path.y(end)-path.y(end-1)]/path.MPC.Ts;
end

travel_time = 0.5;
while true
    t = linspace(0, travel_time, size(waypoints,1)+1);
    
    position_fcn = csape(t,[x;y;z],'clamped',clamp);
    velocity_fcn = fnder(position_fcn);
    
    speed_fcn = @(t)sqrt(sum(fnval(velocity_fcn,t).^2));
    if any(speed_fcn(path.Ts:path.Ts:travel_time) > max_speed)
        travel_time = travel_time + 0.5;
        continue;
    end
    break;
end

positionXY = fnval(position_fcn,path.MPC.Ts:path.MPC.Ts:travel_time);
positionZ = fnval(position_fcn,path.Ts:path.Ts:travel_time);
px = positionXY(1,:);
py = positionXY(2,:);
pz = positionZ(3,:);

velocity = fnval(velocity_fcn,path.Ts:path.Ts:travel_time);
vx = velocity(1,:);
vy = velocity(2,:);

yaw = atan2(vy,vx); yaw(end) = yaw(end-1);

yawRate = zeros(size(yaw));
for i = 2:size(yawRate,2)-2
    yawRate(i) = abs(yaw(i+1)-yaw(i))/path.Ts;
end

if any(yawRate > path.limits.yawRate)
    warning("Maximum yawRate reached!");
end

new_path.x = [path.x px];
new_path.y = [path.y py];
new_path.z = [path.z pz];
new_path.yaw = [path.yaw yaw];

end

