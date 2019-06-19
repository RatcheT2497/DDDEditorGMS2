/// @param UIProgressBar
/// @param x
/// @param y

if (Stuff.fmod_sound != noone) {
    argument0.value = FMODGMS_Chan_Get_Position(Stuff.fmod_channel) / FMODGMS_Snd_Get_Length(Stuff.fmod_sound);
}

ui_render_progress_bar(argument0, argument1, argument2);

if (Stuff.setting_alphabetize_lists) {
    var listofthings = ds_list_sort_name_sucks(Stuff.all_bgm);
} else {
    var listofthings = Stuff.all_bgm;
}

var selection = ui_list_selection(argument0.root.el_list);
if (!ds_list_empty(listofthings) && selection !=noone) {
    var thing = listofthings[| selection];
    var length = FMODGMS_Snd_Get_Length(thing.fmod);
    
    var x1 = argument1 + argument0.x;
    var y1 = argument2 + argument0.y;
    var x2 = x1 + argument0.width;
    var y2 = y1 + argument0.height;

    var mid_yy = mean(y1, y2);
    var bar_y1 = mid_yy + argument0.thickness / 2;
    var bar_y2 = mid_yy - argument0.thickness / 2;
    var loop_start_x = x1 + thing.loop_start * AUDIO_FREQUENCY / length * argument0.width;
    var loop_end_x = x1 + thing.loop_end * AUDIO_FREQUENCY / length * argument0.width;
    
    draw_line_colour(loop_start_x, bar_y1, loop_start_x, bar_y2, c_red, c_red);
    draw_line_colour(loop_end_x, bar_y1, loop_end_x, bar_y2, c_red, c_red);
}
            
if (Stuff.setting_alphabetize_lists) {
    ds_list_destroy(listofthings);
}