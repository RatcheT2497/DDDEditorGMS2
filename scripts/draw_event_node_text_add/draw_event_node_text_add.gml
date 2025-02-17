/// @param x
/// @param y
/// @param node

var xx = argument0;
var yy = argument1;
var node = argument2;

draw_sprite(spr_plus_minus, 0, xx, yy);

var tolerance = 8;
if (mouse_within_rectangle_view(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
    draw_sprite(spr_plus_minus, 1, xx, yy);
    if (get_release_left()) {
        ds_list_add(node.data, "Text line " + string(ds_list_size(node.data)));
        ds_list_add(node.outbound, noone);
    }
}