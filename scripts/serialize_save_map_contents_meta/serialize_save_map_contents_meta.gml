/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.MAP_META);

// unlike most other data types we don't save in a loop here because
// there can only be one map loaded at a time

buffer_write(argument0, buffer_string, ActiveMap.name);
buffer_write(argument0, buffer_string, ActiveMap.internal_name);
buffer_write(argument0, buffer_string, ActiveMap.summary);

buffer_write(argument0, buffer_u16, ActiveMap.xx);
buffer_write(argument0, buffer_u16, ActiveMap.yy);
buffer_write(argument0, buffer_u16, ActiveMap.zz);

buffer_write(argument0, buffer_u8, ActiveMap.tileset);

buffer_write(argument0, buffer_f32, ActiveMap.fog_start);
buffer_write(argument0, buffer_f32, ActiveMap.fog_end);

var bools = pack(ActiveMap.indoors, ActiveMap.draw_water, ActiveMap.fast_travel_to, ActiveMap.fast_travel_from,
    ActiveMap.is_3d);

buffer_write(argument0, buffer_u32, bools);
buffer_write(argument0, buffer_string, ActiveMap.code);

// MESH_AUTOTILE_INCLUSIONS

for (var i = 0; i < array_length_1d(ActiveMap.mesh_autotile_raw); i++) {
    var data = ActiveMap.mesh_autotile_raw[i];
    if (data) {
        buffer_write(argument0, buffer_bool, true);
        buffer_write(argument0, buffer_u32, buffer_get_size(data));
        buffer_write_buffer(argument0, data);
    } else {
        buffer_write(argument0, buffer_bool, false);
    }
}