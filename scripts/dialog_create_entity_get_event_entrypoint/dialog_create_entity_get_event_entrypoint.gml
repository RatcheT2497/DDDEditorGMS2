/// @description void dialog_create_entity_get_event_entrypoint(Dialog);
/// @param Dialog

// you might think it's odd that this is of a different size than the get_event
// dialog, except when they're the same size it's easy to not notice the contents
// changing if there's not a lot of them, and to think that something went wrong
var dw=320;
var dh=544;

// you can assume that this is valid data because this won't be called otherwise
var index=ui_list_selection(Camera.ui.element_entity_events);
var list=Camera.selected_entities;
var event=guid_get(list[| 0].object_events[| index].event_guid);

var dg=dialog_create(dw, dh, "Select entrypoint for: "+event.name, dialog_default, dc_close_no_questions_asked, argument0);

var columns=1;
var ew=(dw-columns*32)/columns;
var eh=24;

var vx1=dw/(columns*2)-16;
var vy1=0;
var vx2=vx1+dw/(columns*2)-16;
var vy2=vy1+eh;

var yy=64;
var spacing=16;

var el_list=create_list(16, yy, "Select an entrypoint", "<should never see this>", ew, eh, 16, null, false, dg);
for (var i=0; i<ds_list_size(event.nodes); i++) {
    if (event.nodes[| i].type==EventNodeTypes.ENTRYPOINT) {
        ds_list_add(el_list.entries, event.nodes[| i].GUID);
    }
}
ds_map_add(el_list.selected_entries, 0, true);
el_list.entries_are=ListEntries.GUIDS;
el_list.colorize=false;
dg.el_list=el_list;

var b_width=128;
var b_height=32;
var el_confirm=create_button(dw/2-b_width/2, dh-32-b_height/2, "Commit", b_width, b_height, fa_center, dmu_dialog_entity_get_event_entrypoint, dg);

ds_list_add(dg.contents, el_list,
    el_confirm);

keyboard_string="";

return dg;
