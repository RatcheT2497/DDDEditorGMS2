/// @param MenuMenu
/// @param x
/// @param y

var x1 =argument1;
var y1 = argument2;
var x2 = x1 + argument0.width;
var y2 = y1 + argument0.height;

argument0.x = x1;
argument0.y = y1;

var tx = ui_get_text_x(argument0, x1, x2);
var ty = ui_get_text_y(argument0, y1, y2);

// click on the header
if (mouse_within_rectangle(x1, y1, x2, y2)) {
    draw_rectangle_colour(x1, y1, x2, y2, c_ui, c_ui, c_ui, c_ui, false);
    if (get_release_left() && !dialog_exists()) {
        menu_activate(argument0);
    }
}

draw_set_halign(argument0.alignment);
draw_set_valign(argument0.valignment);
draw_set_color(argument0.color);
draw_text(tx, ty, string(argument0.text));

if (menu_is_active(argument0)) {
    var separation = 16;
    var ww = separation * 2;
    for (var i = 0; i < ds_list_size(argument0.contents); i++) {
        var ew = string_width(string(argument0.contents[| i].text));
        if (argument0.contents[| i].onmouseup == momu_expand) {
            ew = ew + 16;
        }
        ww = max(ww, ew + separation * 2);
    }
    // todo limit hh and add a scroll bar if it flows offscreen
    var hh = argument0.height * ds_list_size(argument0.contents) + separation * 2;
    var xx = x1;
    if (xx + ww > CW) {
        xx = CW - ww;
    }
    var yy = y2;
    if (yy + hh > CH) {
        yy = CH - hh;
    }
    
    draw_rectangle_colour(xx, yy, xx + ww, yy + hh, c_white, c_white, c_white, c_white, false);
    
    for (var i = 0; i < ds_list_size(argument0.contents); i++) {
        var thing = argument0.contents[| i];
        if (thing.enabled) {
            var mx1 = xx;
            var my1 = y2 + argument0.height * i + separation
            var mx2 = mx1 + ww;
            var my2 = my1 + argument0.height;
            script_execute(thing.render, thing, mx1, my1, mx2, my2);
        }
    }
    
    draw_line_colour(xx, yy, xx, yy + hh, c_black, c_black);
    draw_line_colour(xx + ww, yy, xx + ww, yy + hh, c_black, c_black);
    draw_line_colour(xx, yy + hh, xx + ww, yy + hh, c_black, c_black);
}