class_name LevelCode

# ENCODE
static func encode_level(data : Dictionary):
	var strings = []
	var properties = [
		"game_version",
		"level_name",
		"level_author",
		"level_description",
		"thumbnail_url"
	]
	var properties_string = ""
	var pindex = 0
	for property in properties:
		properties_string += encode_value(get_property_id(properties[pindex]))
		properties_string += "="
		properties_string += encode_value(data[properties[pindex]])
		pindex += 1
		if pindex < properties.size():
			properties_string += ","
	strings.append(properties_string)
	
	var areas_string = ""
	var index = 0
	for area in data.area_data:
		if index > 0:
			areas_string += "["
		areas_string += encode_area(area)
		index += 1
	strings.append(areas_string)
	
	var final_string = ""
	var findex = 0
	for string in strings:
		if findex > 0:
			final_string += "@"
		final_string += string
		findex += 1
	return final_string

static func encode_area(data : Dictionary):
	var strings = []
	var properties = [
		"music_url",
		"background_id",
		"foreground_id",
		"effect_id"
	]
	var properties_string = ""
	var pindex = 0
	for property in properties:
		properties_string += encode_value(get_property_id(properties[pindex]))
		properties_string += "="
		properties_string += encode_value(data[properties[pindex]])
		pindex += 1
		if pindex < properties.size():
			properties_string += ","
	strings.append(properties_string)
	
	var objects_string = ""
	var index = 0
	for object in data.objects:
		if index > 0:
			objects_string += "|"
		objects_string += encode_object(object)
		index += 1
	strings.append(objects_string)
	
	var final_string = ""
	var findex = 0
	for string in strings:
		if findex > 0:
			final_string += "]"
		final_string += string
		findex += 1
	return final_string

static func encode_object(data : Dictionary):
	var base_properties_list = preload("res://level/objects/BasePropertyList.tres")
	
	# section 1
	var strings = []
	var basic_string = ""
	basic_string += encode_value(get_property_id("type_id"))
	basic_string += "="
	basic_string += encode_value(data.type_id)
	strings.append(basic_string)
	
	# section 2
	var base_string = ""
	var encode_base = []
	for property in data.base_properties:
		if data.base_properties[property] != LevelObject.find_first_with_key(property, base_properties_list.properties).default[0]:
			encode_base.append(property)
	if encode_base.size() > 0:
		var index = 0
		for property in encode_base:
			base_string += encode_value(get_property_id(property))
			base_string += "="
			base_string += encode_value(data.base_properties[property])
			index += 1
			if index < encode_base.size():
				base_string += ","
		strings.append(base_string)
	if data.base_properties.size() <= 0 && data.properties.size() > 0:
		strings.append("")
	
	# section 3
	var properties_list
	if data.list_path != "":
		properties_list = load(data.list_path)
	var custom_string = ""
	var encode_custom = []
	for property in data.properties:
		if data.properties[property] != LevelObject.find_first_with_key(property, properties_list.properties).default[0]:
			encode_custom.append(property)
	if encode_custom.size() > 0:
		var index = 0
		for property in encode_custom:
			custom_string += encode_value(get_property_id(property))
			custom_string += "="
			custom_string += encode_value(data.properties[property])
			index += 1
			if index < encode_custom.size():
				custom_string += ","
		strings.append(custom_string)
	
	# time to combine em
	var final_string = ""
	var index = 0
	for string in strings:
		if index > 0:
			final_string += "#"
		final_string += string
		index += 1
	return(final_string)

static func encode_value(value) -> String:
	match typeof(value):
		TYPE_INT:
			return math_util.base64_encode_int(value)
		TYPE_REAL:
			value = stepify(value, 0.01)
			var values = str(value).split(".")
			var string = math_util.base64_encode_int(int(values[0]))
			if values.size() > 1:
				string += "."
				string += math_util.base64_encode_int(int(values[1]))
			return string
		TYPE_BOOL:
			return str(int(value))
		TYPE_STRING:
			return value.percent_encode()
		TYPE_VECTOR2:
			return encode_value(value.x) + "$" + encode_value(value.y)
		TYPE_COLOR:
			return value.to_html(false)
		TYPE_VECTOR2_ARRAY:
			var string = ""
			var count = 0
			for vec2 in value:
				count += 1
				string += encode_value(vec2)
				if count != value.size():
					string += ")"
			return string
	return ""

# DECODE
static func decode_level(data: String):
	var level = {}
	var level_array = data.split("@")
	var properties_array = level_array[0].split(",")
	for property in properties_array:
		var decoded = decode_property(property)
		level[decoded[0]] = decoded[1]
	
	level.area_data = []
	var area_array = level_array[1].split("[")
	for area in area_array:
		var decoded = decode_area(area)
		level.area_data.append(decoded)
	
	return level

static func decode_area(data: String):
	var area = {
		"objects": []
	}
	var area_array = data.split("]")
	var properties_array = area_array[0].split(",")
	for property in properties_array:
		var decoded = decode_property(property)
		area[decoded[0]] = decoded[1]
	
	var objects_array = area_array[1].split("|")
	for object in objects_array:
		var decoded = decode_object(object)
		area.objects.append(decoded)
	
	return area

static func decode_object(data : String):
	var object = {
		"type_id": 0,
		"base_properties": {},
		"properties": {}
	}
	var arrays = data.split("#")
	
	var index = 0
	for array in arrays:
		if array == "":
			index += 1
		else:
			array = array.split(",")
			for property in array:
				property = decode_property(property)
				match (index):
					0:
						object[property[0]] = property[1]
					1:
						object["base_properties"][property[0]] = property[1]
					2:
						object["properties"][property[0]] = property[1]
				
			index += 1
	return object

static func decode_property(property : String):
	var property_array = property.split("=")
	var property_id = decode_value(property_array[0], TYPE_INT)
	var property_key = get_property_key(property_id)
	var property_value = decode_value(property_array[1], get_type_from_id(property_id))
	return [property_key, property_value]

static func decode_value(value, type):
	match type:
		TYPE_INT:
			return math_util.base64_decode_int(value)
		TYPE_REAL:
			var values = value.split(".")
			var string = str(math_util.base64_decode_int(values[0]))
			if values.size() > 1:
				string += "."
				string += str(math_util.base64_decode_int(values[1]))
			return float(string)
		TYPE_BOOL:
			return true if int(value) == 1 else false
		TYPE_STRING:
			return value.percent_decode()
		TYPE_VECTOR2:
			var values = value.split("$")
			var x = decode_value(values[0], TYPE_REAL)
			var y = decode_value(values[1], TYPE_REAL)
			return Vector2(x, y)
		TYPE_COLOR:
			return Color(value)
		TYPE_VECTOR2_ARRAY:
			var values = value.split(")")
			var array = []
			for vec2 in values:
				array.append(decode_value(vec2, TYPE_VECTOR2))
			return PoolVector2Array(array)
	return ""

# OTHER
static func get_property_id(property : String):
	var property_ids = preload("res://level/objects/PropertyIDs.tres")
	return property_ids.ids.find(property)

static func get_property_key(id : int):
	var property_ids = preload("res://level/objects/PropertyIDs.tres")

	return property_ids.ids[id]

static func get_type_from_id(id : int):
	var property_types = preload("res://level/objects/PropertyTypes.tres")
	return property_types.ids[id]
