/// @param name

if (ds_map_exists(Stuff.all_internal_names, argument0)) {
    ds_map_delete(Stuff.all_internal_names, argument0);
    return true;
}

return false;
