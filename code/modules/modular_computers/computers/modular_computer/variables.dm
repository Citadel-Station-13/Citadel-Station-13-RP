// This is the base type that handles everything. Subtypes can be easily created by tweaking variables in this file to your liking.

/obj/item/modular_computer
	name = "Modular Computer"
	desc = "A modular computer. You shouldn't see this."

	/// Whether the computer is turned on.
	var/enabled = FALSE
	/// Whether the computer is active/opened/it's screen is on.
	var/screen_on = TRUE
	/// A currently active program running on the computer.
	var/datum/computer_file/program/active_program = null
	/// A flag that describes this device type.
	var/hardware_flag = 0
	/// Last tick power usage of this computer.
	var/last_power_usage = 0
	/// Used for deciding if battery percentage has chandged.
	var/last_battery_percent = 0
	var/last_world_time = "00:00"
	var/list/last_header_icons
	/// Whether the computer is emagged.
	var/computer_emagged = FALSE
	/// Set automatically. Whether the computer used APC power last tick.
	var/apc_powered = FALSE
	/// Power usage when the computer is open (screen is active) and can be interacted with. Remember hardware can use power too.
	var/base_active_power_usage = 50
	/// Power usage when the computer is idle and screen is off. (currently only applies to laptops)
	var/base_idle_power_usage = 5
	/// Error screen displayed.
	var/bsod = FALSE

	// Modular computers can run on various devices. Each DEVICE (Laptop, Console, Tablet,..)
	// must have it's own DMI file. Icon states must be called exactly the same in all files, but may look differently
	// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	/// This thing isn't meant to be used on it's own. Subtypes should supply their own icon.
	icon = null
	icon_state = null
	/// No pixelshifting by placing on tables, etc.
	//center_of_mass = null
	/// And no random pixelshifting on-creation either.
	//randpixel = 0

	/// Icon state when the computer is turned off.
	var/icon_state_unpowered = null
	/// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/icon_state_menu = "menu"
	var/icon_state_screensaver = null
	/// Maximal hardware size. Currently, tablets have 1, laptops 2 and consoles 3. Limits what hardware types can be installed.
	var/max_hardware_size = 0
	/// Amount of steel sheets refunded when disassembling an empty frame of this computer.
	var/steel_sheet_cost = 5
	/// Intensity of light this computer emits. Comparable to numbers light fixtures use.
	var/light_strength = 0
	/// Idle programs on background. They still receive process calls but can't be interacted with.
	var/list/idle_threads = list()

	//! Damage of the chassis. If the chassis takes too much damage it will break apart.
	/// Current damage level.
	var/damage = 0
	/// Damage level at which the computer ceases to operate.
	var/broken_damage = 50
	/// Damage level at which the computer breaks apart.
	var/max_damage = 100

	//! Important hardware (must be installed for computer to work)
	/// CPU. Without it the computer won't run. Better CPUs can run more programs at once.
	var/obj/item/computer_hardware/processor_unit/processor_unit
	/// Network Card component of this computer. Allows connection to NTNet.
	var/obj/item/computer_hardware/network_card/network_card
	/// Hard Drive component of this computer. Stores programs and files.
	var/obj/item/computer_hardware/hard_drive/hard_drive

	//! Optional hardware (improves functionality, but is not critical for computer to work in most cases)
	/// An internal power source for this computer. Can be recharged.
	var/obj/item/computer_hardware/battery_module/battery_module
	/// ID Card slot component of this computer.  Mostly for HoP modification console that needs ID slot for modification.
	var/obj/item/computer_hardware/card_slot/card_slot
	/// Nano Printer component of this computer, for your everyday paperwork needs.
	var/obj/item/computer_hardware/nano_printer/nano_printer
	/// Portable data storage.
	var/obj/item/computer_hardware/hard_drive/portable/portable_drive
	/// AI slot, an intellicard housing that allows modifications of AIs.
	var/obj/item/computer_hardware/ai_slot/ai_slot
	/// Tesla Link, Allows remote charging from nearest APC.
	var/obj/item/computer_hardware/tesla_link/tesla_link
