/// @param buffer
/// @param version

var version = argument1;

data_clear_map();

ActiveMap.name = buffer_read(argument0, buffer_string);
ActiveMap.internal_name = buffer_read(argument0, buffer_string);
ActiveMap.summary = buffer_read(argument0, buffer_string);

Stuff.save_name_map = ActiveMap.internal_name + EXPORT_EXTENSION_MAP;

var xx = buffer_read(argument0, buffer_u16);
var yy = buffer_read(argument0, buffer_u16);
var zz = buffer_read(argument0, buffer_u16);

ActiveMap.tileset = buffer_read(argument0, buffer_u8);

data_resize_map(xx, yy, zz);

ActiveMap.fog_start = buffer_read(argument0, buffer_f32);
ActiveMap.fog_end = buffer_read(argument0, buffer_f32);
    
var bools = buffer_read(argument0, buffer_u32);
ActiveMap.indoors = unpack(bools, 0);
ActiveMap.draw_water = unpack(bools, 1);
ActiveMap.fast_travel_to = unpack(bools, 2);
ActiveMap.fast_travel_from = unpack(bools, 3);

ActiveMap.is_3d = unpack(bools, 4);
ActiveMap.code = buffer_read(argument0, buffer_string);

if (version >= DataVersions.MESH_AUTOTILE_INCLUSION) {
    for (var i = 0; i < array_length_1d(ActiveMap.mesh_autotile_raw); i++) {
        var exists = buffer_read(argument0, buffer_bool);
        if (exists) {
            var size = buffer_read(argument0, buffer_u32);
            ActiveMap.mesh_autotile_raw[i] = buffer_read_buffer(argument0, size);
            ActiveMap.mesh_autotiles[i] = vertex_create_buffer_from_buffer(ActiveMap.mesh_autotile_raw[i], Camera.vertex_format);
            vertex_freeze(ActiveMap.mesh_autotiles[i]);
        }
    }
}