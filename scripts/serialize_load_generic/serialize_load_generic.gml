/// @param buffer
/// @param Data
/// @param version

var version = argument2;

argument1.name = buffer_read(argument0, buffer_string);
internal_name_set(argument1, buffer_read(argument0, buffer_string));
argument1.flags = buffer_read(argument0, buffer_u32);
guid_set(argument1, buffer_read(argument0, buffer_u32));