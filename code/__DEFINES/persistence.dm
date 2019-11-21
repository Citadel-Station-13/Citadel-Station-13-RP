#define SERIALIZATION_VAR_CHANGED(var)				(var != initial(var))		//if a var was changed from compile time

#define SERIALIZE_VAR_INTO(list, var)	\
	if(SERIALIZATION_VAR_CHANGED(var))	\
		list[#var] = var

#define DESERIALIZE_VAR_FROM(list, var)		\
	if(list[#var])	\
		var = list[#var]

//Not really persistence but (de)serialize_list() options
#define SERIALIZE_PIXEL_OFFSETS 			"SERIALIZE_PIXEL_OFFSETS"
#define SERIALIZE_IGNORE_NAME				"SERIALIZE_IGNORE_NAME"
#define SERIALIZE_DIR						"SERIALIZE_DIR"
#define SERIALIZE_IGNORE_COLOR				"SERIALIZE_IGNORE_COLOR"
