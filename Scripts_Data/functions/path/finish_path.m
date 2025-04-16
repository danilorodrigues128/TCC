function new_path = finish_path(path)

path.end_time = path.MPC.Ts*(size(path.x,2)-1);

new_path = create_hold(path,path.MPC.N*path.MPC.Ts);

end