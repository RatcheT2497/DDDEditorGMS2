/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.EVENTS);

var n_events = ds_list_size(Stuff.all_events);
buffer_write(buffer, buffer_u32, n_events);

for (var i = 0; i < n_events; i++) {
    var event = Stuff.all_events[| i];
    var n_nodes = ds_list_size(event.nodes);
    // this was written in pieces before serialize_save_generic was
    // implemented so don't use it here
    buffer_write(buffer, buffer_string, event.name);
    buffer_write(buffer, buffer_u32, event.GUID);
    buffer_write(buffer, buffer_u32, n_nodes);
    
    for (var j = 0; j < n_nodes; j++) {
        var node = event.nodes[| j];
        buffer_write(buffer, buffer_string, node.name);
        buffer_write(buffer, buffer_u16, node.type);
        buffer_write(buffer, buffer_s32, floor(node.x));
        buffer_write(buffer, buffer_s32, floor(node.y));
        buffer_write(buffer, buffer_u32, node.GUID);
        
        var n_outbound = ds_list_size(node.outbound);
        buffer_write(buffer, buffer_u8, n_outbound);
        for (var k = 0; k < n_outbound; k++) {
            if (!node.outbound[| k]) {
                // empty string signifies a terminal node
                buffer_write(buffer, buffer_string, "");
            } else {
                buffer_write(buffer, buffer_string, node.outbound[| k].name);
            }
        }
        
        var n_data = ds_list_size(node.data);
        buffer_write(buffer, buffer_u8, n_data);
        for (var k = 0; k < n_data; k++) {
            buffer_write(buffer, buffer_string, node.data[| k]);
        }
        
        // if there's anything special in the node, save it here
        switch (node.type) {
            case EventNodeTypes.ENTRYPOINT:
            case EventNodeTypes.TEXT:
            case EventNodeTypes.SHOW_CHOICES:
                break;
            case EventNodeTypes.CONDITIONAL:
                var list_types = node.custom_data[| 0];
                var list_indices = node.custom_data[| 1];
                var list_comparisons = node.custom_data[| 2];
                var list_values = node.custom_data[| 3];
                var list_code = node.custom_data[| 4];
                
                buffer_write(buffer, buffer_u8, ds_list_size(list_types));
                for (var k = 0; k < ds_list_size(list_types); k++) {
                    buffer_write(buffer, buffer_u8, list_types[| k]);
                    buffer_write(buffer, buffer_s32, list_indices[| k]);
                    buffer_write(buffer, buffer_u8, list_comparisons[| k]);
                    buffer_write(buffer, buffer_f32, list_values[| k]);
                    buffer_write(buffer, buffer_string, list_code[| k]);
                }
                break;
            case EventNodeTypes.CUSTOM:
            default:
                buffer_write(buffer, buffer_u32, node.custom_guid);
                // the size of this list should already be known by the custom
                // event template
                var custom = guid_get(node.custom_guid);
                
                for (var k = 0; k < ds_list_size(node.custom_data); k++) {
                    var type = custom.types[| k];
                    switch (type[EventNodeCustomData.TYPE]) {
                        case DataTypes.INT:
                            var save_type = buffer_s32;
                            break;
                        case DataTypes.FLOAT:
                            var save_type = buffer_f32;
                            break;
                        case DataTypes.BOOL:
                            var save_type = buffer_u8;
                            break;
                        case DataTypes.STRING:
                        case DataTypes.CODE:
                            var save_type = buffer_string;
                            break; 
                        case DataTypes.ENUM:
                        case DataTypes.DATA:
                        case DataTypes.AUDIO_BGM:
                        case DataTypes.AUDIO_SE:
                        case DataTypes.ANIMATION:
                        case DataTypes.ENTITY:
                            var save_type = buffer_u32;
                            break;
                        case DataTypes.COLOR:
                        case DataTypes.MESH:
                        case DataTypes.TILESET:
                        case DataTypes.TILE:
                        case DataTypes.AUTOTILE:
                            stack_trace();
                            break;
                    }
                    
                    var n_custom_data = ds_list_size(node.custom_data[| k]);
                    buffer_write(buffer, buffer_u8, n_custom_data);
                    for (var l = 0; l < n_custom_data; l++) {
                        buffer_write(buffer, save_type, ds_list_find_value(node.custom_data[| k], l));
                    }
                }
                break;
        }
    }
}