var controller_left = Controller.mouse_left;
var controller_right = Controller.mouse_right;
var controller_middle = Controller.mouse_middle;

var controller_press_left = Controller.press_left;
var controller_press_right = Controller.press_right;
var controller_press_middle = Controller.press_middle;

var controller_release_left = Controller.release_left;
var controller_release_right = Controller.release_right;
var controller_release_middle = Controller.release_middle;

// There are other ways to do this, but disable controller (mouse) input if
// the mouse isn't in the view

if (!mouse_within_view(view_fullscreen)) {
    Controller.mouse_left = false;
    Controller.mouse_right = false;
    Controller.mouse_middle = false;
    
    Controller.press_left = false;
    Controller.press_right = false;
    Controller.press_middle = false;
    
    Controller.release_left = false;
    Controller.release_right = false;
    Controller.release_middle = false;
}

d3d_end();

draw_set_color(c_white);
draw_set_font(FDefault12);
draw_set_valign(fa_middle);

var checker_width = sprite_get_width(b_tileset_checkers);
var checker_height = sprite_get_height(b_tileset_checkers);

draw_checkerbox((XVIEW div checker_width) * checker_width - checker_width,
    (YVIEW div checker_height) * checker_height - checker_height, WVIEW + checker_width * 2, HVIEW + checker_height * 2);

draw_active_event();

draw_rectangle_colour(XVIEW, YVIEW + HVIEW - 16, XVIEW + WVIEW, YVIEW + HVIEW, c_white, c_white, c_white, c_white, false);
draw_text_colour(XVIEW + 16, YVIEW + HVIEW - 8, string("Canvas at (" + string(XVIEW) + ", " + string(YVIEW) + "); mouse at (" +
    string(mouse_x_view) + ", " + string(mouse_y_view) + ")"), c_black, c_black, c_black, c_black, 1);

if (Controller.mouse_right) {
    if (!dialog_exists()) {
        window_set_cursor(cr_none);
        draw_scroll();
		
        camera_set_view_pos(view_get_camera(view_current), XVIEW - (mouse_x - Controller.mouse_x_previous), YVIEW - (mouse_y - Controller.mouse_y_previous));
    }
} else {
    window_set_cursor(cr_default);
}

// Reset controller input

if (!mouse_within_view(view_fullscreen)) {
    Controller.mouse_left = controller_left;
    Controller.mouse_right = controller_right;
    Controller.mouse_middle = controller_middle;
    
    Controller.press_left = controller_press_left;
    Controller.press_right = controller_press_right;
    Controller.press_middle = controller_press_middle;
    
    Controller.release_left = controller_release_left;
    Controller.release_right = controller_release_right;
    Controller.release_middle = controller_release_middle;
}