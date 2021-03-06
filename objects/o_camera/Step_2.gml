/// @description Update Camera Position

if (v_camera_viewroom) {
	v_camera_width = room_width;
	v_camera_height = room_height;
} else {
	v_camera_width = global.resolution_width;
	v_camera_height = global.resolution_height;
}

camera_set_view_size(v_camera, v_camera_width, v_camera_height);
/*
surface_resize changes the pixel density of both the normal layer and the gui layer. 
*/
surface_resize(application_surface, global.resolution_width, global.resolution_height);

//determine destination
if (v_camera_follow != undefined && instance_exists(v_camera_follow)) {
	v_camera_to_x = v_camera_follow.x;
	v_camera_to_y = v_camera_follow.y;

	//update camera position
	var camera_x_move = 0;
	var camera_y_move = 0;
	switch (v_camera_type) {
		case enum_camera.smooth:
		camera_x_move = (v_camera_to_x - x) / 25;
		if (camera_x_move < 0) camera_x_move = floor(camera_x_move);
		else camera_x_move = ceil(camera_x_move);
		camera_y_move = (v_camera_to_y - y) / 25;
		if (camera_y_move < 0) camera_y_move = floor(camera_y_move);
		else camera_y_move = ceil(camera_y_move);
		break;
		case enum_camera.plain:
		if (abs(v_camera_follow.x - x) > v_camera_boundary_x) camera_x_move = (v_camera_follow.x - x) - v_camera_boundary_x * sign(v_camera_follow.x - x);
		if (abs(v_camera_follow.y - y) > v_camera_boundary_y) camera_y_move = (v_camera_follow.y - y) - v_camera_boundary_y * sign(v_camera_follow.y - y);
		break;
		case enum_camera.rigid:
		x = v_camera_follow.x;
		y = v_camera_follow.y;
		break;
	}
	x += camera_x_move;
	y += camera_y_move;
} else {
	/*
	We need to manually set the position of the camera in rooms that don't contain
	an o_player object. There are very few of them, and we will handle them here:
	*/
	if (room == main_menu) {
		x = 0;
		y = 0;
	}
}

x = clamp(x, camera_get_view_width(v_camera) * 0.5, room_width - camera_get_view_width(v_camera) * 0.5);
y = clamp(y, camera_get_view_height(v_camera) * 0.5, room_height - camera_get_view_height(v_camera) * 0.5);

// note that shake_time gets set to shake_frames in the camera shake script, as do the first offset values
if (v_camera_shake_offset_x != 0 || v_camera_shake_offset_y != 0) {
	if (v_camera_shake_step1 > 0) {
		v_camera_shake_step1--;
		if (v_camera_shake_step1 <= 0) {
			v_camera_shake_offset_x *= -1;
			v_camera_shake_offset_y *= -1;
			v_camera_shake_step2 = v_camera_shake_framesperstep;
		}
	}
	if (v_camera_shake_step2 > 0) {
		v_camera_shake_step2--;
		if (v_camera_shake_step2 <= 0) {
			v_camera_shake_offset_x = (abs(v_camera_shake_offset_x) - 1) * sign(v_camera_shake_offset_x) * -1;
			v_camera_shake_offset_y = (abs(v_camera_shake_offset_y) - 1) * sign(v_camera_shake_offset_y) * -1;
			v_camera_shake_step1 = v_camera_shake_framesperstep;
		}
	}
}

if (!global.screeshake_on) {
	v_camera_shake_offset_x = 0;
	v_camera_shake_offset_y = 0;
}

/*
Our camera object is not the actual "camera" the engine uses to display the game.
even though we've moved it around in the game space, the true engine camera hasn't moved at all.
This script moves it, assuming x/y is the exact center of where we want the camera.
*/
var xpos = x - camera_get_view_width(v_camera) * 0.5 + v_camera_shake_offset_x;
var ypos = y - camera_get_view_height(v_camera) * 0.5 + v_camera_shake_offset_y;
camera_set_view_pos(v_camera, xpos, ypos);
