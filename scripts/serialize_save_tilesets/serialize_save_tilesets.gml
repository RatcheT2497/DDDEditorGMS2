/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.TILESET);

// junk - embed settings were removed
buffer_write(argument0, buffer_u8, 0);

var n_tilesets = ds_list_size(Stuff.all_tilesets);
buffer_write(argument0, buffer_u16, n_tilesets);

for (var i = 0; i < n_tilesets; i++) {
    var ts = Stuff.all_tilesets[| i];
    
    buffer_write(argument0, buffer_string, ts.picture_name);
    
    // stash the sprite in the buffer (via surface)
    buffer_write_sprite(argument0, ts.picture);
    
    // all of the other things
    
    // THESE ARE INDICES IN Stuff.available_autotiles!
    // THOSE NEED TO BE SAVED AS WELL! Do it later though.
    // with that in mind, saving these are trivially easy.
    var n_autotiles = array_length_1d(ts.autotiles);
    buffer_write(argument0, buffer_u8, n_autotiles);
    
    for (var j = 0; j < n_autotiles; j++) {
        // s16 because no tile is "noone"
        buffer_write(argument0, buffer_s16, ts.autotiles[j]);
        
        buffer_write(argument0, buffer_u8, ts.at_passage[j]);
        buffer_write(argument0, buffer_u8, ts.at_priority[j]);
        buffer_write(argument0, buffer_u8, ts.at_flags[j]);
        buffer_write(argument0, buffer_u8, ts.at_tags[j]);
    }
    
    // all of these grids will be the same dimensions so the
    // data can be saved in one loop
    
    var t_grid_width = ds_grid_width(ts.passage);
    var t_grid_height = ds_grid_height(ts.passage);
    
    buffer_write(argument0, buffer_u16, t_grid_width);
    buffer_write(argument0, buffer_u16, t_grid_height);
    
    for (var j = 0; j < t_grid_width; j++) {
        for (var k = 0; k < t_grid_height; k++) {
            buffer_write(argument0, buffer_u8, ts.passage[# j, k]);
            buffer_write(argument0, buffer_u8, ts.priority[# j, k]);
            buffer_write(argument0, buffer_u8, ts.flags[# j, k]);
            buffer_write(argument0, buffer_u8, ts.tags[# j, k]);
        }
    }
}