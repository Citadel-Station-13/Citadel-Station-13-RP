// These pins can only contain directions (1,2,4,8...) or null.
/datum/integrated_io/dir
	name = "dir pin"

/datum/integrated_io/dir/ask_for_pin_data(mob/user)
	var/new_data = input("Please type in a valid dir number.  \
	Valid dirs are;\n\
	North/Fore = [TEXT_NORTH],\n\
	South/Aft = [TEXT_SOUTH],\n\
	East/Starboard = [TEXT_EAST],\n\
	West/Port = [TEXT_WEST],\n\
	Northeast = [NORTHEAST],\n\
	Northwest = [NORTHWEST],\n\
	Southeast = [SOUTHEAST],\n\
	Southwest = [SOUTHWEST],\n\
	Up = [UP],\n\
	Down = [DOWN]","[src] dir writing") as null|num
	if(isnum(new_data) && holder.check_interactivity(user) )
		to_chat(user, "<span class='notice'>You input [new_data] into the pin.</span>")
		write_data_to_pin(new_data)

/datum/integrated_io/dir/write_data_to_pin(new_data)
	if(!isnull(new_data) && (new_data in GLOB.alldirs_multiz)) //why would you make it pass if it's null?
		data = new_data
		holder.on_data_written()

/datum/integrated_io/dir/display_pin_type()
	return IC_FORMAT_DIR

/datum/integrated_io/dir/display_data(input)
	if(!isnull(data))
		return "([dir2text(data)])"
	return ..()