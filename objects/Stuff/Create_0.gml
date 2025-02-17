/// @description setup

#region setup
enum SerializeThings {
    ERROR                   = 0x00000000,
    // basic stuff
    MESHES_META             = 0x00000001,
    MESHES_REF              = 0x00000002,
    MESHES                  = 0x00000003,
    x0000004                = 0x00000004,
    x0000005                = 0x00000005,
    x0000006                = 0x00000006,
    TILESET                 = 0x00000007,
    PARTICLES               = 0x00000008,
    NPCS                    = 0x00000009,
    x000000A                = 0x0000000A,
    FOLLOWERS               = 0x0000000B,
    x000000C                = 0x0000000C,
    MISC_GRAPHICS           = 0x0000000D,
    x000000E                = 0x0000000E,
    UI_GRAPHICS             = 0x0000000F,
    x0000010                = 0x00000010,
    GLOBAL_GRAPHICS         = 0x00000011,
    AUDIO_SE                = 0x00000012,
    x0000013                = 0x00000013,
    AUDIO_BGM               = 0x00000014,
    MAP_BATCH               = 0x00000015,
    MAP_DYNAMIC             = 0x00000016,
    EVENTS                  = 0x00000017,
    x0000018                = 0x00000018,
    AUTOTILES               = 0x00000019,
    MAP_META                = 0x0000001A,
    DATADATA                = 0x0000001B,
    EVENT_CUSTOM            = 0x0000001C,
    EVENT_TEMPLATE          = 0x0000001D,
    // game data
    DATA_ERROR              = 0x00000100,
    DATA_INSTANCES          = 0x00000101,
    // misc
    MISC_ERROR              = 0x00001000,
    MISC_MAP_META           = 0x00001001,
    MISC_GLOBAL             = 0x00001002,
    MISC_UI                 = 0x00001003,
    // the last one i think
    END_OF_FILE             = 0x00002000,
}

enum ETypes {
    ENTITY,
    ENTITY_TILE,
    ENTITY_TILE_AUTO,
    ENTITY_MESH,
    ENTITY_PAWN,
    ENTITY_EFFECT,
    ENTITY_EVENT,
    ENTITY_TERRAIN
}

enum ETypeFlags {
    ENTITY                  = 1 << 0,
    ENTITY_TILE             = 1 << 1,
    ENTITY_TILE_AUTO        = 1 << 2,
    ENTITY_MESH             = 1 << 3,
    ENTITY_PAWN             = 1 << 4,
    ENTITY_EFFECT           = 1 << 5,
    ENTITY_EVENT            = 1 << 6,
    ENTITY_TERRAIN          = 1 << 7,
}

etype_objects = [Entity,
    EntityTile,
    EntityAutoTile,
    EntityMesh,
    EntityPawn,
    EntityEffect,
    EntityEvent,
    EntityMeshTerrain
];

var buffer = buffer_load(PATH_LUA + "map.lua");
default_lua_map = buffer_read(buffer, buffer_text);
buffer_delete(buffer);
var buffer = buffer_load(PATH_LUA + "event-page-condition.lua");
default_lua_event_page_condition = buffer_read(buffer, buffer_text);
buffer_delete(buffer);
var buffer = buffer_load(PATH_LUA + "event-node-conditional.lua");
default_lua_event_node_conditional = buffer_read(buffer, buffer_text);
buffer_delete(buffer);
var buffer = buffer_load(PATH_LUA + "event-script.lua");
default_lua_event_script = buffer_read(buffer, buffer_text);
buffer_delete(buffer);

#endregion

alarm[0] = 1200;

/// this is basically World/Settings

randomize();

// persistent stuff
dt = 0;
time = 0;
time_int = 0;
frames = 0;

all_guids = ds_map_create();
all_refids = ds_map_create();           // it probably makes sense to make this a property of map, but i want to have all of the lookup maps in the same place
all_internal_names = ds_map_create();

tf = ["False", "True"];
on_off = ["Off", "On"];

comparison_text = ["<", "<=", "==", ">=", ">", "!="];

// local storage folders

if (!directory_exists(PATH_BACKUP_DATA)) {
    directory_create(PATH_BACKUP_DATA);
}

if (!directory_exists(PATH_BACKUP_MAP)) {
    directory_create(PATH_BACKUP_MAP);
}

if (!directory_exists(PATH_BACKUP_ASSET)) {
    directory_create(PATH_BACKUP_ASSET);
}

if (!directory_exists(PATH_VRA)) {
    directory_create(PATH_VRA);
}

if (!directory_exists(PATH_RESOURCES)) {
    directory_create(PATH_RESOURCES);
}

if (!directory_exists(PATH_TEMP_CODE)) {
    directory_create(PATH_TEMP_CODE);
}

if (!directory_exists(PATH_AUDIO)) {
    directory_create(PATH_AUDIO);
}

// these are constants in DDD.gmx but we're allowed to change them here
tile_width = 32;
tile_height = 32;
tile_depth = 32;

// uv size, not 3D size
tile_size = 32;

dimensions = Dimensions.THREED;

// ALL DATA THAT DOES NOT DEPEND ON ANYTHING ELSE!
// (except the other data defined in this section)

// This will cause a problem with texture pages later. They ought to be batched properly - and also,
// loaded from files

if (file_exists(PATH_PERMANENT + "b_chr_default.png")) {
    spr_character_default = sprite_add(PATH_PERMANENT + "b_chr_default.png", 0, false, false, 0, 0);
} else {
    spr_character_default = sprite_add(PATH_DUMMY + "b_chr_dummy.png", 0, false, false, 0, 0);
}

// this sounds like a reasonable limit, it's not based on anything though
available_autotiles = array_create(AUTOTILE_AVAILABLE_MAX);
array_clear(available_autotiles, noone);

if (file_exists(PATH_PERMANENT + "b_at_default_grass_0.png")) {
    var spr = sprite_add(PATH_PERMANENT + "b_at_default_grass_0.png", 0, false, false, 0, 0);
} else {
    var spr = sprite_add(PATH_DUMMY + "b_at_dummy_grass.png", 0, false, false, 0, 0);
}
available_autotiles[0] = [spr, "<default>", false, "", 1, 3];

all_tilesets = ds_list_create();
if (file_exists(PATH_PERMANENT + "b_tileset_overworld_0.png")) {
    var filename = PATH_PERMANENT + "b_tileset_overworld_0.png";
} else {
    var filename = PATH_DUMMY + "b_tileset_dummy_overworld.png";
}

#region autotile map
autotile_map = ds_map_create();
autotile_map[? 2] = 1;
autotile_map[? 8] = 2;
autotile_map[? 10] = 3;
autotile_map[? 11] = 4;
autotile_map[? 16] = 5;
autotile_map[? 18] = 6;
autotile_map[? 22] = 7;
autotile_map[? 24] = 8;
autotile_map[? 26] = 9;
autotile_map[? 27] = 10;
autotile_map[? 30] = 11;
autotile_map[? 31] = 12;

autotile_map[? 64] = 13;
autotile_map[? 66] = 14;
autotile_map[? 72] = 15;
autotile_map[? 74] = 16;
autotile_map[? 75] = 17;
autotile_map[? 80] = 18;
autotile_map[? 82] = 19;
autotile_map[? 86] = 20;
autotile_map[? 88] = 21;
autotile_map[? 90] = 22;
autotile_map[? 91] = 23;
autotile_map[? 94] = 24;

autotile_map[? 95] = 25;
autotile_map[? 104] = 26;
autotile_map[? 106] = 27;
autotile_map[? 107] = 28;
autotile_map[? 120] = 29;
autotile_map[? 122] = 30;
autotile_map[? 123] = 31;
autotile_map[? 126] = 32;
autotile_map[? 127] = 33;
autotile_map[? 208] = 34;
autotile_map[? 210] = 35;
autotile_map[? 214] = 36;

autotile_map[? 216] = 37;
autotile_map[? 218] = 38;
autotile_map[? 219] = 39;
autotile_map[? 222] = 40;
autotile_map[? 223] = 41;
autotile_map[? 248] = 42;
autotile_map[? 250] = 43;

autotile_map[? 251] = 44;
autotile_map[? 254] = 45;
autotile_map[? 255] = 46;
autotile_map[? 0] = 47;
#endregion

ds_list_add(all_tilesets, tileset_create(filename,
    // this is somewhat hard-coded;
    // the zeroth available tileset is automatically default_grass
    [0, noone, noone, noone, noone, noone, noone, noone,
        noone, noone, noone, noone, noone, noone, noone, noone]));

all_events = ds_list_create();
all_event_custom = ds_list_create();
all_event_templates = ds_list_create();
active_event = event_create("DefaultEvent");
event_node_info = noone;
ds_list_add(all_events, active_event);

switches = ds_list_create();         // [name, value]
variables = ds_list_create();        // [name, value]
for (var i = 0; i < BASE_GAME_VARIABLES; i++) {
    ds_list_add(switches, ["Switch" + string(i), false]);
    ds_list_add(variables, ["Variable" + string(i), 0]);
}

#region prefab events
// could subclass this but i need to get this done in a hurry
enum EventNodeTypes {
    ENTRYPOINT,
    TEXT,
    CUSTOM,
    INPUT_TEXT, SHOW_SCROLLING_TEXT,
    CONTROL_SWITCHES, CONTROL_VARIABLES, CONTROL_SELF_SWITCHES, CONTROL_SELF_VARIABLES, CONTROL_TIME,
    CONDITIONAL, INVOKE_EVENT, COMMENT, WAIT,
    TRANSFER_PLAYER, SET_ENTITY_LOCATION, SCROLL_MAP, SET_MOVEMENT_ROUTE,
    TINT_SCREEN, FLASH_SCREEN, SHAKE_SCREEN,
    PLAY_BGM, FADE_BGM, RESUME_BGM, PLAY_SE, STOP_SE,
    RETURN_TO_TITLE, CHANGE_MAP_DISPLAY_NAME, CHANGE_MAP_TILESET, CHANGE_MAP_BATTLE_SCENE, CHANGE_MAP_PARALLAX,
    SCRIPT, AUDIO_CONTORLS, ADVANCED0, ADVANCED1, ADVANCED2, ADVANCED3, ADVANCED4, ADVANCED5, ADVANCED6, ADVANCED7,
    // i forgot to put this one with the other text nodes
    SHOW_CHOICES,
}

/* */ event_prefab[EventNodeTypes.INPUT_TEXT] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.SHOW_SCROLLING_TEXT] = create_event_node_prefab("NotYetImplemented", []);
event_prefab[EventNodeTypes.SHOW_CHOICES] = create_event_node_prefab("ShowChoices", [
    // conditional branch nodes are not actually handled as a prefab but i'm leaving this here for reference
    ["Message", DataTypes.STRING, 0, 16, false, "Option 1"],
    ["ID", DataTypes.INT, 0, 16, false, 0],
]);
event_prefab[EventNodeTypes.CONTROL_SWITCHES] = create_event_node_prefab("ControlGlobalSwitch", [
    ["Index", DataTypes.INT, 0, 1, false, -1, omu_event_attain_switch_data, event_prefab_render_switch_name],
    ["State", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_VARIABLES] = create_event_node_prefab("ControlGlobalVariable", [
    ["Index", DataTypes.INT, 0, 1, false, -1, omu_event_attain_variable_data, event_prefab_render_variable_name],
    ["Value", DataTypes.FLOAT, 0, 1, false, 0, omu_event_attain_variable_data],
    ["Relative?", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_SELF_SWITCHES] = create_event_node_prefab("ControlSelfSwitch", [
    ["Entity", DataTypes.ENTITY, 0, 1, false, 0, omu_event_attain_self_switch_data],
    ["Index", DataTypes.INT, 0, 1, false, 0, omu_event_attain_self_switch_data, event_prefab_render_self_switch_name],
    ["State", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_SELF_VARIABLES] = create_event_node_prefab("ControlSelfVariable", [
    ["Entity", DataTypes.ENTITY, 0, 1, false, 0, omu_event_attain_self_variable_data],
    ["Index", DataTypes.INT, 0, 1, false, 0, omu_event_attain_self_variable_data, event_prefab_render_self_variable_name],
    ["Value", DataTypes.FLOAT, 0, 1, false, 0, omu_event_attain_self_variable_data],
    ["Relative?", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_TIME] = create_event_node_prefab("ControlTimer", [
    ["Counting Down?", DataTypes.BOOL, 0, 1, false, true],
    ["Initial Time (seconds)", DataTypes.INT, 0, 1, false, 0],
    ["Display?", DataTypes.BOOL, 0, 1, false, false],
    ["Running?", DataTypes.BOOL, 0, 1, false, true],
]);
event_prefab[EventNodeTypes.CONDITIONAL] = create_event_node_prefab("Conditional", [
    // conditional branch nodes are not actually handled as a prefab but i'm leaving this here for reference
    ["Type", DataTypes.INT, 0, 1, false, 0],
    ["Index", DataTypes.INT, 0, 1, false, 0],
    ["Comparison", DataTypes.INT, 0, 1, false, 0],
    ["Value", DataTypes.INT, 0, 1, false, 0],
    ["Code", DataTypes.INT, 0, 1, false, 0],
]);
/* */ event_prefab[EventNodeTypes.INVOKE_EVENT] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.COMMENT] = create_event_node_prefab("NotYetImplemented", []);
event_prefab[EventNodeTypes.WAIT] = create_event_node_prefab("Wait", [["Seconds", DataTypes.FLOAT, 0, 1, false, 1]]);
/* */ event_prefab[EventNodeTypes.TRANSFER_PLAYER] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.SET_ENTITY_LOCATION] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.SCROLL_MAP] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.SET_MOVEMENT_ROUTE] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.TINT_SCREEN] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.FLASH_SCREEN] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.SHAKE_SCREEN] = create_event_node_prefab("NotYetImplemented", []);
event_prefab[EventNodeTypes.PLAY_BGM] = create_event_node_prefab("PlayBGM", [
    ["BGM", DataTypes.AUDIO_BGM, 0],
    ["Volume", DataTypes.INT, 0, 1, false, 100],
    ["Pitch", DataTypes.INT, 0, 1, false, 100]
]);
event_prefab[EventNodeTypes.FADE_BGM] = create_event_node_prefab("FadeBGM", [
    ["Volume", DataTypes.INT, 0, 1, false, 0],
    ["Time", DataTypes.FLOAT, 0, 1, false, 1],
    ["Stop On Complete?", DataTypes.BOOL, 0, 1, false, true]
]);
event_prefab[EventNodeTypes.RESUME_BGM] = create_event_node_prefab("ResumeAutomaticBGM", []);
// if you want fancier audio controls for sound effects, make an advanced event - i'm not going to write the FMOD effects into the basic one
event_prefab[EventNodeTypes.PLAY_SE] = create_event_node_prefab("PlaySoundEffect", [
    ["SoundEffect", DataTypes.AUDIO_SE, 0],
    ["Volume", DataTypes.INT, 0, 1, false, 100],
    ["Pitch", DataTypes.INT, 0, 1, false, 100]
]);
event_prefab[EventNodeTypes.STOP_SE] = create_event_node_prefab("StopAllSoundEffects", []);
/* */ event_prefab[EventNodeTypes.RETURN_TO_TITLE] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_DISPLAY_NAME] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_TILESET] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_BATTLE_SCENE] = create_event_node_prefab("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_PARALLAX] = create_event_node_prefab("NotYetImplemented", []);
event_prefab[EventNodeTypes.SCRIPT] = create_event_node_prefab("Script", [
    ["Code", DataTypes.CODE, 0, 1, true, default_lua_event_script]
]);
/* */ event_prefab[EventNodeTypes.AUDIO_CONTORLS] = create_event_node_prefab("NotYetImplemented", []);
#endregion

// stuff i couldn't do in game maker so i did in c++ instead
ds_stuff_init();

// camera setup may depend on some stuff existing in here, which
// is bad design, but this is just supposed to work and doesnt have
// to be well-designed
c_init();
c_world_create();

c_shape_tile = c_shape_create();
c_shape_begin_trimesh();
c_shape_add_triangle(0, 0, 0, tile_width, 0, 0, tile_width, tile_height, 0);
c_shape_add_triangle(tile_width, tile_height, 0, 0, tile_height, 0, 0, 0, 0);
c_shape_end_trimesh(c_shape_tile);
c_shape_block = c_shape_create();
c_shape_begin_trimesh();
// bottom
c_shape_add_triangle(0, 0, 0, tile_width, 0, 0, tile_width, tile_height, 0);
c_shape_add_triangle(tile_width, tile_height, 0, 0, tile_height, 0, 0, 0, 0);
// top
c_shape_add_triangle(0, 0, tile_depth, tile_width, 0, 0, tile_width, tile_height, tile_depth);
c_shape_add_triangle(tile_width, tile_height, tile_depth, 0, tile_height, 0, 0, 0, tile_depth);
// left
c_shape_add_triangle(0, 0, 0, 0, 0, tile_depth, 0, tile_height, tile_depth);
c_shape_add_triangle(0, tile_height, tile_depth, 0, tile_height, 0, 0, 0, 0);
// right
c_shape_add_triangle(tile_width, 0, 0, tile_width, 0, tile_depth, tile_width, tile_height, tile_depth);
c_shape_add_triangle(tile_width, tile_height, tile_depth, tile_width, tile_height, 0, tile_width, 0, 0);
// front
c_shape_add_triangle(0, 0, 0, 0, 0, tile_depth, tile_width, 0, tile_height);
c_shape_add_triangle(tile_width, 0, tile_height, tile_width, 0, 0, 0, 0, 0);
// back
c_shape_add_triangle(0, tile_height, 0, 0, tile_height, tile_depth, tile_width, tile_height, tile_height);
c_shape_add_triangle(tile_width, tile_height, tile_height, tile_width, tile_height, 0, 0, tile_height, 0);
c_shape_end_trimesh(c_shape_block);

// at some point there shouldn't necessarily need to be an active
// map in existence for this to work, but for now there does
data_clear_map();
instantiate(Controller);

// this depends on activemap
instantiate(Camera);

// data that gets loaded: needs the camera (and vertex formats) to be
// defined before running
vra_data = ds_map_create();
vra_name = "";
all_mesh_names = ds_list_create();
data_load_vra();

all_bgm = ds_list_create();
all_se = ds_list_create();

FMODGMS_Sys_Create();
FMODGMS_Sys_Initialize(32);

fmod_channel = FMODGMS_Chan_CreateChannel();
FMODGMS_Chan_Set_Frequency(fmod_channel, AUDIO_BASE_FREQUENCY);
fmod_sound = noone;
fmod_playing = false;
fmod_paused = false;

// this depends on activemap existing
uivc_select_autotile_refresh();

enum AvailableAutotileProperties {
    PICTURE, NAME, DELETEABLE, FILENAME, FRAMES, WIDTH
    // sprite index, display name, true for built-in graphics and false otherwise, filename, animation frames, horizontal segments
}

// this gets populated when you save or load something, and also using a map to
// store maps is funny for some reason
all_maps = ds_map_create();

all_data = ds_list_create();
original_data = noone;            // when you're modifying the data types and want to stash the old ones

error_log_messages = ds_list_create();

// help contents

enum HelpPages {
    OVERVIEW, WHATSNEW, GETTINGSTARTED, SYSTEMREQUIREMENTS,
    EDITORCOMPONENTS, TABS, MENUS,
    TAB_GENERAL, TAB_ENTITY, TAB_TILE, TAB_MESH, TAB_MOB, TAB_EFFECT, TAB_EVENT,
    TAB_MESH_EDITOR, TAB_TILE_EDITOR, TAB_AUTOTILE_EDITOR,
    AUTOTILES,
}

help_pages = ["overview", "whatsnew", "gettingstarted", "systemrequirements",
    "editorcomponents", "tabs", "menus",
    "general", "entityinstances", "tileinstances", "meshinstances", "mobinstances", "effectinstances", "eventinstances",
    "mesheditor", "tileeditor", "autotileeditor",
    "autotiles",];

enum Dimensions {
    TWOD,
    THREED
}

enum BattleStyles {
    TEAM_BASED,             // everyone stays on their own side
    MELEE,                  // boundaries are not respected
}

color_lookup = [c_red, c_green, c_blue, c_orange, c_aqua, c_fuchsia, c_purple, c_teal];

// global game settings

game_map_starting = "";
game_player_grid = true;
game_battle_style = BattleStyles.TEAM_BASED;

// save settings

save_name_map = "";
save_name_data = "";
save_name_assets = "";

// user settings
ini_open(DATA_INI);
setting_color = ini_read_real("config", "color", c_green);                  // BGR
setting_bezier_precision = ini_read_real("config", "bezier", 6);            // preferably keep this between like 4 and 16ish?
setting_backups = ini_read_real("config", "backups", 2);                    // 0 (none) through 9 (why would you keep that many backups)
setting_autosave = ini_read_real("config", "autosave", true);               // bool
setting_alphabetize_lists = ini_read_real("config", "alphabetize", true);   // bool
setting_npc_animate_rate = ini_read_real("config", "npc-speed", 4); // bool
setting_code_extension = ini_read_real("config", "code-ext", 0);            // 0 = txt, 1 = lua

setting_code_extension_map = [".txt", ".lua"];
ini_close();

//ds_stuff_registry();

// the autosave/load is nice, BUT it will make the game break if there's an error
// in either of them. so either do a LOT of validation or have a way to clear the
// autosaves if problems happen.

if (setting_autosave && file_exists("auto" + EXPORT_EXTENSION_DATA)) {
    // data's got to come first because it's the one that gets to decide to delete
    // existing data istances - this is messy and ought to be redone later
    serialize_load("auto" + EXPORT_EXTENSION_DATA);
    serialize_load("auto" + EXPORT_EXTENSION_ASSETS);
    if (file_exists("auto" + EXPORT_EXTENSION_MAP)) {
        // no need to store the map name in a variable since that's set based
        // on the internal name
        serialize_load("auto" + EXPORT_EXTENSION_MAP);
    }
    save_name_assets = "";
    save_name_data = "";
    save_name_map = "";
}