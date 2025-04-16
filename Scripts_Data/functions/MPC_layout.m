function output = MPC_layout(input, MPC_config, show_figures)

path_size = size(input(4+MPC_config.nx+MPC_config.nu:end),1)/2;

% Disassemble input
X = input(1:MPC_config.nx);
Yaw = input(1+MPC_config.nx);
U = input(2+MPC_config.nx:1+MPC_config.nx+MPC_config.nu);
G = input(2+MPC_config.nx+MPC_config.nu:3+MPC_config.nx+MPC_config.nu);
H = reshape(input(4+MPC_config.nx+MPC_config.nu:3+MPC_config.nx+MPC_config.nu+2*path_size),2,path_size);

% Setup optimization
yalmip('clear');

X_sym = sdpvar(MPC_config.nx,MPC_config.N);
U_sym = sdpvar(MPC_config.nu,MPC_config.N);

X_sym(:,1) = X;
U_sym(:,1) = U;
J = 0;
Constraints = [];

for n = 1:MPC_config.N
    % Model prediction
    X_sym(:,n+1) = model_predict(X_sym(:,n), U_sym(:,n), Yaw, G, MPC_config.Ts, MPC_config.g);

    % Error calculation
    positionError = X_sym(1:2,n+1) - H(:,n);
    if n > 1
        Omega = (U_sym(:,n)-U_sym(:,n-1))/MPC_config.Ts;

        Constraints = [Constraints
                        abs(U_sym(1,n)) <= MPC_config.limits.pitch
                        abs(U_sym(2,n)) <= MPC_config.limits.roll];
    else
        Omega = 0;
    end

    % Cost function
    J = J + norm(MPC_config.Q*positionError,1) + norm(MPC_config.R*U_sym(:,n),1) + norm(MPC_config.S*Omega,1);
end

options = sdpsettings('verbose',0,'solver','sedumi','sedumi.maxiter',100);

% Optimize
optimize(Constraints,J,options);

output = zeros(MPC_config.nu+2*MPC_config.N,1);
for n = 1:MPC_config.nu
    output(n) = value(U_sym(n,2));
end

posPrediction = zeros(MPC_config.N,2);
for n = 1:MPC_config.N
    posPrediction(n,:) = [value(X_sym(1,n)) value(X_sym(2,n))];
end

output(MPC_config.nu+1:end) = reshape(posPrediction,2*MPC_config.N,1);

if show_figures
    close all

    % Get results
    pos = NaN(MPC_config.N,2);
    for n = 1:MPC_config.N
        pos(n,:) = [value(X_sym(1,n)) value(X_sym(2,n))];
    end

    vel = NaN(MPC_config.N,2);
    for n = 1:MPC_config.N
        vel(n,:) = [value(X_sym(3,n)) value(X_sym(4,n))];
    end

    attitude = NaN(MPC_config.N,2);
    for n = 1:MPC_config.N
        attitude(n,:) = rad2deg([value(U_sym(1,n)) value(U_sym(2,n))]);
    end

    % Plot
    figure();
    plot(pos(:,1));
    hold on;
    plot(H(1,:), 'r');
    hold off;
    grid on;
    legend("p_x", "p_{x,r}");
    xlabel("Time [s]");
    ylabel("p_x [m]");
    title("Posição X");

    figure();
    plot(pos(:,2));
    hold on;
    plot(H(2,:), 'r');
    hold off;
    grid on;
    legend("p_y", "p_{y,r}");
    xlabel("Time [s]");
    ylabel("p_y [m]");
    title("Posição Y");

    figure();
    plot(vel(:,1));
    hold on;
    plot(vel(:,2));
    hold off;
    grid on;
    legend("vx", "vy");
    xlabel("Time [s]");
    ylabel("v [m/s]");
    title("Velocity");

    figure();
    plot(attitude(:,1));
    hold on;
    plot(attitude(:,2));
    hold off;
    grid on;
    legend("\theta", "\phi");
    xlabel("Time [s]");
    ylabel("U [deg]");
    title("Pitch and Roll");
end

end