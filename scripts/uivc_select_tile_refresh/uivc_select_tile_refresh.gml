/// @description  void uivc_select_tile_refresh(tx, ty);
/// @param tx
/// @param  ty

var ts=get_active_tileset();
// refresh values that don't like to do it on their own
Camera.ui.t_p_tile_editor.element_priority.value=string(ts.priority[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y]);
Camera.ui.t_p_tile_editor.element_tag.value=string(ts.tags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y]);
