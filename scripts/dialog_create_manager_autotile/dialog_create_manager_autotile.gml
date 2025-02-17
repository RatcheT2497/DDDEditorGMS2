/// @description void dialog_create_manager_autotile(Dialog);
/// @param Dialog

var dw=512;
var dh=400;

var dg=dialog_create(dw, dh, "Data: Availalbe Autotiles", dialog_default, dc_close_no_questions_asked, argument0);

var ew=(dw-64)/2;
var eh=24;

var vx1=dw/4+16;
var vy1=0;
var vx2=vx1+80;
var vy2=vy1+eh;

var b_width=128;
var b_height=32;

var yy=64;

// much of this was cannibalized from dialog_create_autotile_selector

var n=AUTOTILE_AVAILABLE_MAX;
dg.el_list=create_list(16, yy, "Available autotiles: "+string(n), "", dw/2-16, b_height, 7, null, false, dg);
for (var i=0; i<AUTOTILE_AVAILABLE_MAX; i++) {
    var at_data=Stuff.available_autotiles[i];
    if (is_array(at_data)) {
        create_list_entries(dg.el_list, string(i)+". "+at_data[AvailableAutotileProperties.NAME], c_black);
    } else {
        create_list_entries(dg.el_list, string(i)+". <none loaded>", c_black);
    }
}

dg.el_preview=create_image_button(dw/2+16, yy, "If an autotile was loaded into this slot it would be previewed here", noone, dw/2-32, dw/2-32, fa_center, null, dg);
dg.el_preview.render=ui_render_image_button_autotile_preview;

yy=yy+dg.el_preview.height+16;

dg.el_load=create_button(dw*3/4, yy, "Load Autotile", b_width, b_height, fa_center, null, dg, HelpPages.AUTOTILES, fa_center, fa_top);

dg.el_confirm=create_button(dw/2, dh-32-b_height/2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg, HelpPages.AUTOTILES, fa_center);

ds_list_add(dg.contents, dg.el_list, dg.el_confirm, dg.el_preview, dg.el_load);

keyboard_string="";

return dg;
