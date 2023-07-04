GLOBAL_LIST_INIT(char_directory_tags, list("Pred", "Prey", "Switch", "Non-Vore", "Unset"))
GLOBAL_LIST_INIT(char_directory_erptags, list("Top", "Bottom", "Switch", "No ERP", "Unset"))
GLOBAL_LIST_EMPTY(meteor_list)

GLOBAL_LIST_INIT(server_taglines, world.file2list("config/strings/server_taglines.txt"))

/// List of wire colors for each object type of that round. One for airlocks, one for vendors, etc.
GLOBAL_LIST_EMPTY(wire_color_directory) // This is an associative list with the `holder_type` as the key, and a list of colors as the value.

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
GLOBAL_LIST_EMPTY(tagger_locations)
