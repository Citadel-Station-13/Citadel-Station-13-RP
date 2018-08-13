// Request Console Presets!  Make mapping 400% easier!
// By using these presets we can rename the departments easily.

//Request Console Department Types
#define RC_ASSIST 1		//Request Assistance
#define RC_SUPPLY 2		//Request Supplies
#define RC_INFO   4		//Relay Info

/*/obj/machinery/requests_console/preset
	name = ""
	department = ""
	departmentType = ""
	announcementConsole = 0 */

/obj/machinery/requests_console/preset/chemistry
	name = "Chemistry RC"
	department = "Chemistry"
	departmentType = RC_SUPPLY

/obj/machinery/requests_console/preset/kitchen
	name = "Kitchen RC"
	department = "Kitchen"
	departmentType = RC_SUPPLY

/obj/machinery/requests_console/preset/bar
	name = "Bar RC"
	department = "Bar"
	departmentType = RC_SUPPLY

/obj/machinery/requests_console/preset/arrivals
	name = "Arrivals RC"
	department = "Arrivals"

/obj/machinery/requests_console/preset/director
	name = "Director RC"
	department = "Director's Desk"
	departmentType = RC_ASSIST | RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/hop
	name = "HOP RC"
	department = "Head of Personnel's Desk"
	departmentType = RC_ASSIST | RC_INFO
	announcementConsole = 1

