/// @param UIThing

var thing = argument0;

// safe
var index = ui_list_selection(Camera.ui.element_entity_events);
var list = Camera.selected_entities
var entity = list[| 0];
var page = entity.object_events[| index];

page.condition_switch_global_enabled = argument0.value;