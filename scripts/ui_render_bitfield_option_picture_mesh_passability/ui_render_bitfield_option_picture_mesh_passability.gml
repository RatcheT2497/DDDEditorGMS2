/// @description void ui_render_bitfield_option_picture_mesh_passability(UIBitFieldOption, x, y);
/// @param UIBitFieldOption
/// @param x
/// @param y

// mesh data is stored in proto-objects represented by arrays, i have no idea why i made
// it like that but i did and now i have to deal with it
if (data_vra_exists()) {
    var data=Stuff.vra_data[? Stuff.all_mesh_names[| Camera.selection_fill_mesh]];
    argument0.state=data[@ MeshArrayData.PASSAGE]&argument0.value;
}

ui_render_bitfield_option_picture(argument0, argument1, argument2);
