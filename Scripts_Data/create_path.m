path_figures = 0;

waypoints = [
    15 5 1
    10 10 1
];

path = start_path([0 0], [10 10], Ts, 80, MPC_config);
path = create_takeoff(path, 1, 0, 5);
path = create_line(path, [10 0 1], 2);
path = create_spline(path, waypoints, 2);
path = create_hold(path, 5);
path = finish_path(path);

if path_figures
    close all;
    figure();

    plot(path.MPC.Ts:path.MPC.Ts:(size(path.x,2)*path.MPC.Ts), path.x);
    grid on;
    xlim([0 path.end_time]);
    pbaspect([2 1 1]);
    xlabel("Time [s]");
    ylabel("x [m]");
    title("Path - X");

    figure();
    plot(path.MPC.Ts:path.MPC.Ts:(size(path.y,2)*path.MPC.Ts), path.y);
    grid on;
    xlabel("Time [s]");
    ylabel("y [m]");
    title("Path - Y");

    figure();
    plot(path.Ts:path.Ts:(size(path.z,2)*path.Ts), path.z);
    grid on;
    xlim([0,8]);
    xlabel("Time [s]");
    ylabel("z [m]");
    title("Path - Z");

    figure();
    plot(path.Ts:path.Ts:(size(path.yaw,2)*path.Ts), rad2deg(path.yaw));
    grid on;
    xlabel("Time [s]");
    ylabel("\psi [deg]");
    title("Path - Yaw");

    figure();
    plot3(path.x, path.y, path.z(round(linspace(1,size(path.z,2),size(path.x,2)))));
    xlabel("x");
    ylabel("y");
    zlabel("z");
    axis equal;
    zlim([0 max(path.z)]);
    grid on;
end