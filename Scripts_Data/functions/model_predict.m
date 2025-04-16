function X_next = model_predict(X, U, Yaw, G, Ts, g)

b_x = G(1);
b_y = G(2);

Ad = [1 0 Ts 0
      0 1 0 Ts
      0 0 1 0
      0 0 0 1];

Bd = [g*cos(Yaw)*(Ts^2)/2  g*sin(Yaw)*(Ts^2)/2
      g*sin(Yaw)*(Ts^2)/2 -g*cos(Yaw)*(Ts^2)/2
      g*cos(Yaw)*Ts        g*sin(Yaw)*Ts
      g*sin(Yaw)*Ts       -g*cos(Yaw)*Ts];

Pd = [(Ts^2*b_x)/2
      (Ts^2*b_y)/2
       Ts*b_x
       Ts*b_y];

X_next = Ad*X + Bd*U + Pd;

end