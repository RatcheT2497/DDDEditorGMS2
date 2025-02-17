/// @param DataMoveRoute

if (argument0.buffer) {
    vertex_delete_buffer(argument0.buffer);
    argument0.buffer = noone;
}

var xx = 0;
var yy = 0;
var zz = 0;         // this will not work well with sloped terrain
var n_actions = 0;

argument0.extra = false;

// essentailly the rng seed
var c = Stuff.color_lookup[argument0.GUID % array_length_1d(Stuff.color_lookup)];
var cube_size = 2;

var buffer = vertex_create_buffer();
vertex_begin(buffer, Camera.vertex_format_line);

vertex_cube_line(buffer, 0, 0, 0, c, 1, cube_size);

for (var i = 0; i < ds_list_size(argument0.steps); i++) {
    var data = argument0.steps[| i];
    var stop = false;
    
    switch (data[@ 0]) {
        // these either use some kind of random motion or use absolute coordinates,
        // so there's not much good in drawing them
        case MoveRouteActions.MOVE_RANDOM:
        case MoveRouteActions.MOVE_TOWARDS_PLAYER:
        case MoveRouteActions.MOVE_AWAY_PLAYER:
        case MoveRouteActions.MOVE_FORWARD:
        case MoveRouteActions.MOVE_BACKWARD:
        case MoveRouteActions.MOVE_TO:
        case MoveRouteActions.MOVE_JUMP:
            argument0.extra = true;
            argument0.extra_xx = xx;
            argument0.extra_yy = yy;
            argument0.extra_zz = zz;
            stop = true;
            break;
        // actual things
        case MoveRouteActions.MOVE_DOWN:
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            yy = yy + TILE_HEIGHT * data[@ 1];
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            n_actions++;
            break;
        case MoveRouteActions.MOVE_LEFT:
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            xx = xx - TILE_WIDTH * data[@ 1];
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            n_actions++;
            break;
        case MoveRouteActions.MOVE_RIGHT:
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            xx = xx + TILE_WIDTH * data[@ 1];
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            n_actions++;
            break;
        case MoveRouteActions.MOVE_UP:
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            yy = yy - TILE_HEIGHT * data[@ 1];
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            n_actions++;
            break;
        case MoveRouteActions.MOVE_LOWER_LEFT:
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            xx = xx - TILE_WIDTH * data[@ 1];
            yy = yy + TILE_HEIGHT * data[@ 1];
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            n_actions++;
            break;
        case MoveRouteActions.MOVE_LOWER_RIGHT:
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            xx = xx + TILE_WIDTH * data[@ 1];
            yy = yy + TILE_HEIGHT * data[@ 1];
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            n_actions++;
            break;
        case MoveRouteActions.MOVE_UPPER_LEFT:
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            xx = xx - TILE_WIDTH * data[@ 1];
            yy = yy - TILE_HEIGHT * data[@ 1];
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            n_actions++;
            break;
        case MoveRouteActions.MOVE_UPPER_RIGHT:
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            xx = xx + TILE_WIDTH * data[@ 1];
            yy = yy - TILE_HEIGHT * data[@ 1];
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            n_actions++;
            break;
        case MoveRouteActions.MOVE_ACTUALLY_JUMP:
            vertex_point_line(buffer, xx, yy, zz, c, 1);
            vertex_point_line(buffer, xx, yy, zz + TILE_DEPTH * data[@ 1], c, 1);
            vertex_cube_line(buffer, xx, yy, zz + TILE_DEPTH * data[@ 1], c, 1, cube_size);
            n_actions++;
            break;
    }
    if (stop) {
        break;
    }
}

if (n_actions > 0) {
    vertex_end(buffer);
    vertex_freeze(buffer);
    argument0.buffer = buffer;
} else {
    vertex_delete_buffer(buffer);
}