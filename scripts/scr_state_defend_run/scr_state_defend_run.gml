/// @description scr_state_defend_run(o_actor)
/// @param actor_id

var ID = argument[0];
var state = ID.v_act_state_cur;

ID.image_speed = 0;

// determine velocity
if (state.v_state_defend_time > 0) {
	state.v_state_defend_time--;
	if (ID.v_act_vel_y < ID.v_act_vel_y_max) ID.v_act_vel_y += ID.v_act_grv;
	ID.v_act_vel_y = scr_obj_approachdist_y_at_x_against_obj(ID, ID.v_act_vel_y, ID.x, o_wall);
	ID.v_act_vel_x = scr_obj_approachdist_x_at_y_against_obj(ID, ID.v_act_vel_x, scr_act_potypos(ID, ID.v_act_vel_y), o_wall);
} else {
	if (place_meeting(ID.x, ID.y + 1, o_wall)){
		ID.v_act_vel_x = 0;
		ID.v_act_vel_y = 0;
	} else {
		if (ID.v_act_vel_y >= 0 && ID.v_act_actcon.v_actcon_pressed_down) ID.v_act_vel_y = ID.v_act_vel_y_max;
		scr_act_calcairvals(ID, ID.v_act_grv, 0.15);
	}
	
	if (state.v_state_defend_blockID != undefined) {
		state.v_state_defend_blockID.x = scr_act_potxpos(ID, ID.v_act_vel_x);
		state.v_state_defend_blockID.y = scr_act_potypos(ID, ID.v_act_vel_y);
	
		if (ID.v_act_faceright) state.v_state_defend_blockID.x += state.v_state_defend_offset_x;
		else state.v_state_defend_blockID.x -= state.v_state_defend_offset_x;
		state.v_state_defend_blockID.y += state.v_state_defend_offset_y;
	}

	if (!ID.v_act_actcon.v_actcon_button3) {
		state.v_state_defend_continue = false;
		instance_destroy(state.v_state_defend_blockID);
		state.v_state_defend_blockID = undefined;
	}
}
