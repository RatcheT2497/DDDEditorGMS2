event_inherited();

save_script=serialize_save_entity_effect;
load_script=serialize_load_entity_effect;

name="Effect";
etype=ETypes.ENTITY_EFFECT;

ActiveMap.population[ETypes.ENTITY_EFFECT]++;

// editor properties

slot=MapCellContents.EFFECT;
batchable=false;

// there will be other things here probably
on_select=safc_on_effect;

