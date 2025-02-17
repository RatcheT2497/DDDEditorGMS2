/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

var x1 = bitfield.x + xx;
var y1 = bitfield.y + yy;
var x2 = x1 + bitfield.width;
var y2 = y1 + bitfield.height;

if (bitfield.state) {
    draw_rectangle_colour(x1, y1, x2, y2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
}

// not entirely sure what the deal with this is, normally I can draw rectangle outlines
// without worrying about whether the edges are off by a pixel or not. whatever.
draw_rectangle_colour(x1 + 1, y1 + 1, x2 - 1, y2 - 1, c_black, c_black, c_black, c_black, true);

if (bitfield.interactive && dialog_is_active(bitfield.root)) {
    var inbounds = mouse_within_rectangle_determine(bitfield.check_view, x1, y1, x2, y2);
    if (inbounds) {
        if (get_release_left()) {
            script_execute(bitfield.onvaluechange, bitfield);
        } else if (Controller.press_help) {
            //ds_stuff_help_auto(bitfield);
        }
    }
}