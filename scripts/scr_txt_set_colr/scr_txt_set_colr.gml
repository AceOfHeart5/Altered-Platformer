/// @description scr_txt_set_text(o_txt, colr)

/// @param o_txt
/// @param colr

argument[0].v_txt_color = argument[1];

draw_set_font(argument[0].v_txt_font);
argument[0].v_txt_width = string_width(argument[0].v_txt_text);
argument[0].v_txt_height = string_height(argument[0].v_txt_text);