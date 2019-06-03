/// @description void omu_event_rename_event(UIThing);
/// @param UIThing

var event=Stuff.all_events[| ui_list_selection(argument0.root.el_event_list)];
var new_name=get_string("New name for "+event.name+"? (Letters, digits, underscore and $ only, please.)", event.name);

if (validate_string_event_name(new_name)) {
    event.name=new_name;
}
