class_name MapData

const MAP_NAME = 'map_name'
const SECTION = 'section'

const SECTION_NAME = 'section_name'
const SECTION_ID = 'section_id'
const ROOM = "room"

const ROOM_ID = "room_id"
const ROOM_DATA = "room_data"

const ROOM_DATA_OBJS = "room_data_objs"

const root = {MAP_NAME:TYPE_STRING,SECTION:{DictionaryHelper.KEY_ID:section_config}}
const section_config = {SECTION_ID:TYPE_INT,SECTION_NAME:TYPE_STRING,ROOM:[room_config]}
const room_config = {ROOM_ID:TYPE_INT,ROOM_DATA:room_data}
const room_data = {ROOM_DATA_OBJS:[]}
