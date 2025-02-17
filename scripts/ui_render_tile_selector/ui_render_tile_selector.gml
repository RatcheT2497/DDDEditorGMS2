/// @param UITileSelector
/// @param x
/// @param y

var selector = argument0;
var xx = argument1;
var yy = argument2;

var x1 = selector.x + xx;
var y1 = selector.y + yy;
var x2 = selector.x + selector.width;
var y2 = selector.y + selector.height;

var ts = get_active_tileset();

var tex_width = sprite_get_width(ts.picture);
var tex_height = sprite_get_height(ts.picture);

draw_set_color(c_white);
draw_checkerbox(selector.x, selector.y, selector.width, selector.height);

draw_sprite_part(ts.picture, 0, selector.tile_view_x, selector.tile_view_y,
    selector.width, selector.height, selector.x, selector.y);

for (var i = selector.tile_view_x; i < selector.tile_view_x + selector.width; i = (i div Stuff.tile_size) * Stuff.tile_size + Stuff.tile_size) {
    draw_line_colour(x1 + i - selector.tile_view_x, y1, x1 + i - selector.tile_view_x, y2, c_blue, c_blue);
}

for (var i = selector.tile_view_y; i < selector.tile_view_y + selector.height; i = (i div Stuff.tile_size) * Stuff.tile_size + Stuff.tile_size) {
    draw_line_colour(x1, y1 + i - selector.tile_view_y, x2, y1 + i - selector.tile_view_y, c_blue, c_blue);
}

// drawing the selection is a pain

var selx1 = x1 + Stuff.tile_size * Camera.selection_fill_tile_x - selector.tile_view_x;
var sely1 = y1 + Stuff.tile_size * Camera.selection_fill_tile_y - selector.tile_view_y;
var selx2 = x1 + Stuff.tile_size * (Camera.selection_fill_tile_x + 1) - selector.tile_view_x;
var sely2 = y1 + Stuff.tile_size * (Camera.selection_fill_tile_y + 1) - selector.tile_view_y;

draw_rectangle_colour(clamp(selx1, x1, x2), clamp(sely1, y1, y2), clamp(selx2, x1, x2), clamp(sely2, y1, y2),
    c_purple, c_purple, c_purple, c_purple, true);
draw_rectangle_colour(clamp(selx1 + 1, x1, x2), clamp(sely1 + 1, y1, y2), clamp(selx2 - 1, x1, x2), clamp(sely2 - 1, y1, y2),
    c_purple, c_purple, c_purple, c_purple, true);
draw_rectangle_colour(clamp(selx1 - 1, x1, x2), clamp(sely1 - 1, y1, y2), clamp(selx2 + 1, x1, x2), clamp(sely2 + 1, y1, y2),
    c_purple, c_purple, c_purple, c_purple, true);

draw_rectangle_colour(x1, y1, x2 - 1, y2 - 1, c_black, c_black, c_black, c_black, true);

// drawing the data on the tile is also a pain

draw_set_font(FDefault12Bold);
draw_set_halign(fa_center);
// the current valign is middle already

var dx1 = selector.tile_view_x div Stuff.tile_size;
var dy1 = selector.tile_view_y div Stuff.tile_size;
var dx2 = ((selector.tile_view_x + selector.width) div Stuff.tile_size) + 1;
var dy2 = ((selector.tile_view_y + selector.height) div Stuff.tile_size) + 1;
var da = 0.75;

for (var i = dx1; i < dx2; i++) {
    for (var j = dy1; j < dy2; j++) {
        var textx = x1 + i * Stuff.tile_size - selector.tile_view_x + Stuff.tile_size / 2;
        var texty = y1 + j * Stuff.tile_size - selector.tile_view_y + Stuff.tile_size / 2;
        // the 8s here are magic numbers, do not touch anything or everything will explode violently
        if ((textx - 8) >= x1 && (textx + 8) <= x2 && (texty - 8) >= y1 && (texty + 8) <= y2) {
            // could make this outside of the for loop except it displays something different
            // for the passage data than the numbers, since the numbers are meaningless
            switch (Camera.tile_data_view) {
                case TileSelectorDisplayMode.PASSAGE:
                    var value = ts.passage[# i, j];
                    if (value == 0) {
                        draw_text_colour(textx, texty, string("X"), c_black, c_black, c_black, c_black, da);
                    } else if (value == TILE_PASSABLE) {
                        draw_text_colour(textx, texty, string("O"), c_black, c_black, c_black, c_black, da);
                    } else {
                        draw_text_colour(textx, texty, string("*"), c_black, c_black, c_black, c_black, da);
                    }
                    break;
                case TileSelectorDisplayMode.PRIORITY:
                    draw_text_colour(textx, texty, string(ts.priority[# i, j]), c_black, c_black, c_black, c_black, da);
                    break;
                case TileSelectorDisplayMode.FLAGS:
                    draw_text_colour(textx, texty, string(ts.flags[# i, j]), c_black, c_black, c_black, c_black, da);
                    break;
                case TileSelectorDisplayMode.TAGS:
                    draw_text_colour(textx, texty, string(ts.tags[# i, j]), c_black, c_black, c_black, c_black, da);
                    break;
            }
        }
    }
}

draw_set_halign(fa_left);
draw_set_font(FDefault12);

// theoretically you should check to see if dialog is active but please just never
// put one of these in a dialog box, that would be awful
var inbounds = mouse_within_rectangle_determine(selector.check_view, x1, y1, x2 - 1, y2 - 1);
if (inbounds) {
    // select a tile
    var tx = (Camera.MOUSE_X - x1 + selector.tile_view_x) div Stuff.tile_size;
    var ty = (Camera.MOUSE_Y - y1 + selector.tile_view_y) div Stuff.tile_size;
    if (Controller.press_left) {
        // this is kinda dumb because realistically you're not going to be doing anything besides this with the
        // tileset picker, but for now make it look the same as the other value change code
        script_execute(selector.onvaluechange, selector, tx, ty);
    } else if (Controller.press_right) {
        script_execute(selector.onvaluechangebackwards, selector, tx, ty);
    } else if (Controller.press_help) {
        //ds_stuff_help_auto(selector);
    }
}
    
// pan around
if (Controller.mouse_right) {
    if (selector.offset_x >- 1) {
        selector.tile_view_x = clamp(selector.tile_view_x + selector.offset_x - Camera.MOUSE_X, 0, tex_width - selector.width);
        selector.tile_view_y = clamp(selector.tile_view_y + selector.offset_y - Camera.MOUSE_Y, 0, tex_height - selector.height);
    }
    if (selector.offset_x > -1 || inbounds) {
        selector.offset_x = Camera.MOUSE_X;
        selector.offset_y = Camera.MOUSE_Y;
        draw_scroll();
        window_set_cursor(cr_none);
    }
} else {
    if (selector.offset_x != -1) {
        window_set_cursor(cr_default);
        selector.offset_x = -1;
        selector.offset_y = -1;
    }
}