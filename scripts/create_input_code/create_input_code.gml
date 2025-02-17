/// @param x
/// @param y
/// @param text
/// @param width
/// @param height
/// @param value-x1
/// @param value-y1
/// @param value-x2
/// @param value-y2
/// @param default-code
/// @param onvaluechange
/// @param root
/// @param [key]
/// @param [help]

with (instance_create_depth(argument[0], argument[1], 0, UIInputCode)) {
    text = argument[2];
    width = argument[3];
    height = argument[4];
    
    value_x1 = argument[5];
    value_y1 = argument[6];
    value_x2 = argument[7];
    value_y2 = argument[8];
    
    value = argument[9];
    onvaluechange = argument[10];
    
    root = argument[11];
    
    switch (argument_count) {
        case 14:
            help = argument[13];
        case 13:
            key = argument[12];
            break;
    }
    
    return id;
}
