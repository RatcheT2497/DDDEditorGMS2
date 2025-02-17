/// @param RadioOption
/// @param x
/// @param y

var option = argument0;
var xx = argument1;
var yy = argument2;

var x1 = option.x + xx;
var y1 = option.y + yy;
var x2 = x1 + option.width;
var y2 = y1 + option.height;

var tx = ui_get_text_x(option, x1, x2);
var ty = ui_get_text_y(option, y1, y2);

var enabled = option.root.interactive && option.interactive;

// this is not quite the same as ui_render_text
draw_set_halign(option.alignment);
draw_set_valign(option.valignment);
var c = enabled ? option.color : c_gray;
draw_text_colour(tx + 32, ty, string(option.text), c, c, c, c, 1);

var router = 8;
var rinner = 4;

if (!enabled) {
    draw_circle_colour(tx + 16, ty, router, c_ltgray, c_ltgray, false);
}
draw_circle(tx + 16, ty, router, true);

if (option.root.value == option.value) {
    if (!enabled) {
        draw_set_alpha(0.5);
    }
    draw_circle_colour(tx + 16, ty, rinner, c_green, c_green, false);
    draw_set_alpha(1);
}

// option.root is the radio array object that contains the element.
// option.root.root is the panel that it lives on.
if (enabled && dialog_is_active(option.root.root)) {
    var inbounds = mouse_within_rectangle_determine(option.check_view, x1, y1, x2, y2);
    if (inbounds) {
        if (get_release_left()) {
            option.root.value = option.value;
            script_execute(option.root.onvaluechange, option);
        } else if (Controller.press_help) {
            //ds_stuff_help_auto(option);
        }
    }
}