/// @description Movement if Vels set

if (!global.freezeactors && global.freezeactors_time <= 0) {
	x += v_hitbox_vel_x;
	v_hitbox_vel_y += v_hitbox_grv;
	y += v_hitbox_vel_y;
}
