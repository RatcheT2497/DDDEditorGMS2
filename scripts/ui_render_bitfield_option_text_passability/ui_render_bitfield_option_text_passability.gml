/// @description  void ui_render_bitfield_option_text_passability(UIBitFieldOption, x, y);
/// @param UIBitFieldOption
/// @param  x
/// @param  y

argument0.state=get_active_tileset().passage[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y]&argument0.value;

ui_render_bitfield_option_text(argument0, argument1, argument2);
