/mob
	datum_flags = DF_USE_TAG
	density = 1
	layer = MOB_LAYER
	plane = MOB_PLANE
	animate_movement = 2
	flags = HEAR
	pass_flags_self = ATOM_PASS_MOB | ATOM_PASS_OVERHEAD_THROW

//! Core
	/// mobs use ids as ref tags instead of actual refs.
	var/static/next_mob_id = 0

//! Rendering
	/// Fullscreen objects
	var/list/fullscreens = list()

//! Intents
	/// How are we intending to move? Walk/run/etc.
	var/m_intent = MOVE_INTENT_RUN

//! Perspectives
	/// using perspective - if none, it'll be self - when client logs out, if using_perspective has reset_on_logout, this'll be unset.
	var/datum/perspective/using_perspective

//! Buckling
	/// Atom we're buckled to
	var/atom/movable/buckled
	/// Atom we're buckl**ing** to. Used to stop stuff like lava from incinerating those who are mid buckle.
	var/atom/movable/buckling


	var/datum/mind/mind
	/// Whether a mob is alive or dead. TODO: Move this to living - Nodrak
	var/stat = CONSCIOUS

//! Movespeed
	/// List of movement speed modifiers applying to this mob
	var/list/movespeed_modification				//Lazy list, see mob_movespeed.dm
	/// List of movement speed modifiers ignored by this mob. List -> List (id) -> List (sources)
	var/list/movespeed_mod_immunities			//Lazy list, see mob_movespeed.dm
	/// The calculated mob speed slowdown based on the modifiers list
	var/cached_multiplicative_slowdown
	/// Next world.time we will be able to move.
	var/move_delay = 0
	/// Last world.time we finished a move
	var/last_move_time = 0
	/// Last world.time we turned in our spot without moving (see: facing directions)
	var/last_turn = 0

//! Actionspeed
	/// List of action speed modifiers applying to this mob
	var/list/actionspeed_modification				//Lazy list, see mob_movespeed.dm
	/// List of action speed modifiers ignored by this mob. List -> List (id) -> List (sources)
	var/list/actionspeed_mod_immunities			//Lazy list, see mob_movespeed.dm
	/// The calculated mob action speed slowdown based on the modifiers list
	var/cached_multiplicative_actions_slowdown

//! Pixel Offsets
	/// are we shifted by the user?
	var/shifted_pixels = FALSE
	/// shifted pixel x
	var/shift_pixel_x = 0
	/// shifted pixel y
	var/shift_pixel_y = 0

//! Size
	//! todo kill this with fire it should just be part of icon_scale_x/y.
	/// our size multiplier
	var/size_multiplier = 1

//! Misc
	/// What we're interacting with right now, associated to list of reasons and the number of concurrent interactions for that reason.
	var/list/interacting_with

	var/next_move = null // For click delay, despite the misleading name.

	var/atom/movable/screen/hands = null
	var/atom/movable/screen/pullin = null
	var/atom/movable/screen/purged = null
	var/atom/movable/screen/internals = null
	var/atom/movable/screen/oxygen = null
	var/atom/movable/screen/i_select = null
	var/atom/movable/screen/m_select = null
	var/atom/movable/screen/toxin = null
	var/atom/movable/screen/fire = null
	var/atom/movable/screen/bodytemp = null
	var/atom/movable/screen/healths = null
	var/atom/movable/screen/throw_icon = null
	var/atom/movable/screen/nutrition_icon = null
	var/atom/movable/screen/hydration_icon = null
	var/atom/movable/screen/synthbattery_icon = null
	var/atom/movable/screen/pressure = null
	var/atom/movable/screen/pain = null
	var/atom/movable/screen/crafting = null
	var/atom/movable/screen/gun/item/item_use_icon = null
	var/atom/movable/screen/gun/radio/radio_use_icon = null
	var/atom/movable/screen/gun/move/gun_move_icon = null
	var/atom/movable/screen/gun/run/gun_run_icon = null
	var/atom/movable/screen/gun/mode/gun_setting_icon = null
	var/atom/movable/screen/ling/chems/ling_chem_display = null
	var/atom/movable/screen/wizard/energy/wiz_energy_display = null
	var/atom/movable/screen/wizard/instability/wiz_instability_display = null

	var/datum/plane_holder/plane_holder = null
	/// List of vision planes that should be graphically visible (list of their VIS_ indexes).
	var/list/vis_enabled = null
	/// List of atom planes that are logically visible/interactable (list of actual plane numbers).
	var/list/planes_visible = null

	/// Spells hud icons - this interacts with add_spell and remove_spell.
	var/list/atom/movable/screen/movable/spell_master/spell_masters = null
	/// Ability hud icons.
	var/atom/movable/screen/movable/ability_master/ability_master = null

	/**
	 * A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	 *
	 * A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	 * The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	 * I'll make some notes on where certain variable defines should probably go.
	 * Changing this around would probably require a good look-over the pre-existing code.
	 */
	var/atom/movable/screen/zone_sel/zone_sel = null

	/// Allows all mobs to use the me verb by default, will have to manually specify they cannot.
	var/use_me = 1
	var/damageoverlaytemp = 0
	var/computer_id = null
	var/already_placed = 0.0
	var/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""
	var/poll_answer = 0.0
	var/sdisabilities = 0	//?Carbon
	var/disabilities = 0	//?Carbon
	var/transforming = null	//?Carbon
	var/other = 0.0
	var/eye_blind = null	//?Carbon
	var/eye_blurry = null	//?Carbon
	var/ear_deaf = null		//?Carbon
	var/ear_damage = null	//?Carbon
	var/stuttering = null	//?Carbon
	var/slurring = null		//?Carbon
	var/real_name = null
	var/nickname = null
	var/flavor_text = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""
	var/exploit_addons = list()		//Assorted things that show up at the end of the exploit_record list
	var/blinded = null
	var/bhunger = 0			//?Carbon
	var/ajourn = 0
	var/druggy = 0			//?Carbon
	var/confused = 0		//?Carbon
	var/antitoxs = null
	var/phoron = null
	var/sleeping = 0		//?Carbon
	var/resting = 0			//?Carbon
	var/lying = 0
	var/lying_prev = 0

	/// Player pixel shifting, if TRUE, we need to reset on move.
	var/is_shifted = FALSE

	var/canmove = 1
	/// Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
	var/incorporeal_move = 0 //0 is off, 1 is normal, 2 is for ninjas.
	var/unacidable = 0
	/// List of things pinning this creature to walls. (see living_defense.dm)
	var/list/pinned = list()
	/// Embedded items, since simple mobs don't have organs.
	var/list/embedded = list()
	/// For speaking/listening.
	var/list/languages = list()
	/// For species who want reset to use a specified default.
	var/species_language = null
	/// For species who can only speak their default and no other languages. Does not affect understanding.
	var/only_species_language  = 0
	/// Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/list/speak_emote = list("says")
	/// Define emote default type, 1 for seen emotes, 2 for heard emotes.
	var/emote_type = 1
	/// Used for the ancient art of moonwalking.
	var/facing_dir = null

	/// For admin things like possession.
	var/name_archive

	var/timeofdeath = 0 //?Living

	var/bodytemperature = 310.055 //98.7 F
	var/drowsyness = 0 //?Carbon
	var/charges = 0

	var/nutrition = 400 //?Carbon
	var/hydration = 400 //?Carbon

	/// How long this guy is overeating. //?Carbon
	var/overeatduration = 0
	var/paralysis = 0
	var/stunned = 0
	var/weakened = 0
	var/losebreath = 0 //?Carbon
	var/_intent = null //?Living
	var/shakecamera = 0
	var/a_intent = INTENT_HELP //?Living
	var/m_int = null //?Living
	var/lastKnownIP = null

	var/seer = 0 //for cult//Carbon, probably Human

	var/datum/hud/hud_used = null

	var/list/grabbed_by = list(  )

	var/list/mapobjs = list()

	/// whether or not we're prepared to throw stuff.
	var/in_throw_mode = THROW_MODE_OFF

	var/music_lastplayed = "null"

	var/job = null //?Living

	var/const/blindness = 1 //?Carbon
	var/const/deafness = 2 //?Carbon
	var/const/muteness = 4 //?Carbon

	/// Maximum w_class the mob can pull.
	var/can_pull_size = ITEMSIZE_NO_CONTAINER
	/// Whether or not the mob can pull other mobs.
	var/can_pull_mobs = MOB_PULL_LARGER

	var/datum/dna/dna = null//?Carbon
	var/radiation = 0 //?Carbon

	var/list/mutations = list() //?Carbon
	//see: setup.dm for list of mutations

	var/voice_name = "unidentifiable voice"

	///Used for checking whether hostile simple animals will attack you, possibly more stuff later.
	var/faction = "neutral"
	/// To prevent pAIs/mice/etc from getting antag in autotraitor and future auto- modes. Uses inheritance instead of a bunch of typechecks.
	var/can_be_antagged = FALSE

	/// Generic list for proc holders. Only way I can see to enable certain verbs/procs. Should be modified if needed.
	var/proc_holder_list[] = list()//Right now unused.
	//Also unlike the spell list, this would only store the object in contents, not an object in itself.

	/* Add this line to whatever stat module you need in order to use the proc holder list.
	Unlike the object spell system, it's also possible to attach verb procs from these objects to right-click menus.
	This requires creating a verb for the object proc holder.

	if (proc_holder_list.len)//Generic list for proc_holder objects.
		for(var/obj/effect/proc_holder/P in proc_holder_list)
			statpanel("[P.panel]","",P)
	*/

	/// The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/mob/living/carbon/LAssailant = null

	/// Wizard's spell list, it can be used in other modes thanks to the "Give Spell" badmin button.
	var/list/spell/spell_list = list()

//Changlings, but can be used in other modes
//	var/obj/effect/proc_holder/changpower/list/power_list = list()

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	/// Set to TRUE to trigger update_icons() at the next life() call.
	var/update_icon = TRUE

	/// Bitflags defining which status effects can be inflicted. (replaces canweaken, canstun, etc)
	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH

	var/area/lastarea = null

	/// Can they be tracked by the AI?
	var/digitalcamo = FALSE

	/// Can they interact with station electronics?
	var/silicon_privileges = NONE

	///Used by admins to possess objects. All mobs should have this var.
	var/obj/control_object

	/// Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/universal_speak = FALSE //? Set to TRUE to enable the mob to speak to everyone.
	var/universal_understand = FALSE //? Set to TRUE to enable the mob to understand everyone, not necessarily speak

	/// Whether this mob's ability to stand has been affected.
	var/stance_damage = 0

	/**
	 * If set, indicates that the client "belonging" to this (clientless) mob is currently controlling some other mob
	 * so don't treat them as being SSD even though their client var is null.
	 */
	var/mob/teleop = null //? This is mainly used for adghosts to hear things from their actual body.

	/// The current turf being examined in the stat panel.
	var/turf/listed_turf = null

	var/list/active_genes=list()
	var/mob_size = MOB_MEDIUM
	// Used for lings to not see deadchat, and to have ghosting behave as if they were not really dead.
	var/forbid_seeing_deadchat = FALSE

	///Determines mob's ability to see shadows. 1 = Normal vision, 0 = darkvision.
	var/seedarkness = 1

	var/get_rig_stats = 0

	/// Skip processing life() if there's just no players on this Z-level.
	var/low_priority = TRUE

	/// Icon to use when attacking w/o anything in-hand.
	var/attack_icon
	/// Icon State to use when attacking w/o anything in-hand.
	var/attack_icon_state

	var/registered_z

	/// For mechs and fighters ambiance. Can be used in other cases.
	var/in_enclosed_vehicle = 0

	var/last_radio_sound = -INFINITY

	/// A mock client, provided by tests and friends
	var/datum/client_interface/mock_client

	//! ## Virgo Defines
	/// Do I have the HUD enabled?
	var/vantag_hud = FALSE
	/// Allows flight.
	var/flying = FALSE
	/// For holding onto a temporary form.
	var/mob/temporary_form
	/// Time of client loss, set by Logout(), for timekeeping.
	var/disconnect_time = null

	var/atom/movable/screen/shadekin/shadekin_display = null
	var/atom/movable/screen/xenochimera/danger_level/xenochimera_danger_display = null

	//! Typing Indicator
	var/typing = FALSE
	var/mutable_appearance/typing_indicator
