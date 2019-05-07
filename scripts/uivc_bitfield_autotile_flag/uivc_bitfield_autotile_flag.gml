/// @description  uivc_bitfield_autotile_flag(UIThing);
/// @param UIThing

var ts=get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]!=noone){
    // you could use ^= but
    var longexpr=ts.at_flags[Camera.selection_fill_autotile];
    longexpr=longexpr^argument0.value;
    
    ts.at_flags[Camera.selection_fill_autotile]=longexpr;
}
