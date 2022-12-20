/**
 * A set of constants used to determine which type of mute an admin wishes to apply.
 * Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO, etc. = (MUTE_IC << 1)
 * Therefore there needs to be a gap between the flags for the automute flags.
 */
#define MUTE_IC        (1<<0)
#define MUTE_OOC       (1<<1)
#define MUTE_PRAY      (1<<2)
#define MUTE_ADMINHELP (1<<3)
#define MUTE_DEADCHAT  (1<<4)
#define MUTE_ALL       (~0)

//! Number of identical messages required to get the spam-prevention auto-mute thing to trigger warnings and automutes.
#define SPAM_TRIGGER_WARNING  5
#define SPAM_TRIGGER_AUTOMUTE 10

//! Some constants for DB_Ban
#define BANTYPE_PERMA       1
#define BANTYPE_TEMP        2
#define BANTYPE_JOB_PERMA   3
#define BANTYPE_JOB_TEMP    4
#define BANTYPE_ANY_FULLBAN 5 // Used to locate stuff to unban.

/// Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.
#define ROUNDSTART_LOGOUT_REPORT_TIME 6000

//! Admin permissions.
#define R_BUILDMODE   (1<<0)
#define R_ADMIN       (1<<1)
#define R_BAN         (1<<2)
#define R_FUN         (1<<3)
#define R_SERVER      (1<<4)
#define R_DEBUG       (1<<5)
#define R_POSSESS     (1<<6)
#define R_PERMISSIONS (1<<7)
#define R_STEALTH     (1<<8)
#define R_REJUVINATE  (1<<9)
#define R_VAREDIT     (1<<10)
#define R_SOUNDS      (1<<11)
#define R_SPAWN       (1<<12)
#define R_MOD         (1<<13)
#define R_EVENT	      (1<<14)

#define R_HOST        (1<<15)
/// This holds the maximum value for a permission. It is used in iteration, so keep it updated.
#define R_MAXPERMISSION R_HOST

#define SMITE_AUTOSAVE              "10 Second Autosave"
#define SMITE_AUTOSAVE_WIDE         "10 Second Autosave (AoE)"
#define SMITE_BLUESPACEARTILLERY    "Bluespace Artillery"
#define SMITE_BREAKLEGS             "Break Legs"
#define SMITE_DARKSPACE_ABDUCT      "Darkspace Abduction"
#define SMITE_DISLOCATEALL          "Dislocate All Limbs"
#define SMITE_LIGHTNINGBOLT         "Lightning Bolt"
#define SMITE_SHADEKIN_ATTACK       "Shadekin (Attack)"
#define SMITE_SHADEKIN_NOMF         "Shadekin (Devour)"
#define SMITE_SPONTANEOUSCOMBUSTION "Spontaneous Combustion"

#define ADMIN_LOOKUP(user)           ("[key_name_admin(user)][ADMIN_QUE(user)]")
#define ADMIN_LOOKUPFLW(user)        ("[key_name_admin(user)][ADMIN_QUE(user)] [ADMIN_FLW(user)]")
#define COORD(src)                   ("[src ? src.Admin_Coordinates_Readable() : "nonexistent location"]")
#define AREACOORD(src)               ("[src ? src.Admin_Coordinates_Readable(TRUE) : "nonexistent location"]")
#define ADMIN_COORDJMP(src)          ("[src ? src.Admin_Coordinates_Readable(FALSE, TRUE) : "nonexistent location"]")
#define ADMIN_VERBOSEJMP(src)        ("[src ? src.Admin_Coordinates_Readable(TRUE, TRUE) : "nonexistent location"]")

#define ADMIN_QUE(user)              ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminmoreinfo=[REF(user)]'>[SPAN_TOOLTIP("See a short summary about the player.","?")]</a>)")
#define ADMIN_FLW(user)              ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservefollow=[REF(user)]'>[SPAN_TOOLTIP("Orbit this player.","FLW")]</a>)")
#define ADMIN_PP(user)               ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=[REF(user)]'>[SPAN_TOOLTIP("Open this user's player panel.","PP")]</a>)")
#define ADMIN_VV(atom)               ("(<a href='?_src_=vars;[HrefToken(forceGlobal = TRUE)];Vars=[REF(atom)]'>[SPAN_TOOLTIP("Open their atom's variable viewer.","VV")]</a>)")
#define ADMIN_SM(user)               ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];subtlemessage=[REF(user)]'>[SPAN_TOOLTIP("Send this user a subtle message.","SM")]</a>)")
#define ADMIN_TP(user)               ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];traitor=[REF(user)]'>[SPAN_TOOLTIP("Open this user's traitor panel.","TP")]</a>)")
#define ADMIN_KICK(user)             ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];boot2=[REF(user)]'>[SPAN_TOOLTIP("Open a prompt to kick this user.","KICK")]</a>)")
#define ADMIN_CENTCOM_REPLY(user)    ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];CentComReply=[REF(user)]'>[SPAN_TOOLTIP("Open a prompt to reply to this fax.","RPLY")]</a>)")
#define ADMIN_SYNDICATE_REPLY(user)  ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];SyndicateReply=[REF(user)]'>[SPAN_TOOLTIP("Open a prompt to reply to this fax.","RPLY")]</a>)")
#define ADMIN_SC(user)               ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminspawncookie=[REF(user)]'>[SPAN_TOOLTIP("Give this user a cookie!","SC")]</a>)")
#define ADMIN_ST(user)               ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminspawntreat=[REF(user)]'>[SPAN_TOOLTIP("Give this user a dog treat!","ST")]</a>)")
#define ADMIN_SMITE(user)            ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminsmite=[REF(user)]'>[SPAN_TOOLTIP("Open a prompt to smite this heathen.","SMITE")]</a>)")
#define ADMIN_JMP(src)               ("(<a href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>[SPAN_TOOLTIP("Jump to this location.","JMP")]</a>)")
#define ADMIN_FULLMONTY_NONAME(user) ("[ADMIN_QUE(user)] [ADMIN_PP(user)] [ADMIN_VV(user)] [ADMIN_SM(user)] [ADMIN_FLW(user)] [ADMIN_TP(user)] [ADMIN_SMITE(user)]")
#define ADMIN_FULLMONTY(user)        ("[key_name_admin(user)] [ADMIN_FULLMONTY_NONAME(user)]")

/atom/proc/Admin_Coordinates_Readable(area_name, admin_jump_ref)
	var/turf/T = Safe_COORD_Location()
	return T ? "[area_name ? "[get_area_name(T, TRUE)] " : " "]([T.x],[T.y],[T.z])[admin_jump_ref ? " [ADMIN_JMP(T)]" : ""]" : "nonexistent location"

/atom/proc/Safe_COORD_Location()
	var/atom/A = drop_location()
	if(!A)
		return // Not a valid atom.
	var/turf/T = get_step(A, 0) // Resolve where the thing is.
	if(!T) // Incase it's inside a valid drop container, inside another container. ie if a mech picked up a closet and has it inside it's internal storage.
		var/atom/last_try = A.loc?.drop_location() // One last try, otherwise fuck it.
		if(last_try)
			T = get_step(last_try, 0)
	return T

/turf/Safe_COORD_Location()
	return src

/**
 *! AHELP Commands.
 */
#define ADMIN_AHELP_REJECT(user)    ("(<a href='?_src_=holder;ahelp=[user];ahelp_action=reject'>[SPAN_TOOLTIP("Reject and close this ticket.","REJT")]</a>)")
#define ADMIN_AHELP_IC(user)        ("(<a href='?_src_=holder;ahelp=[user];ahelp_action=icissue'>[SPAN_TOOLTIP("Close this ticket and mark it IC.","IC")]</a>)")
#define ADMIN_AHELP_CLOSE(user)     ("(<a href='?_src_=holder;ahelp=[user];ahelp_action=close'>[SPAN_TOOLTIP("Close this ticket.","CLOSE")]</a>)")
#define ADMIN_AHELP_RESOLVE(user)   ("(<a href='?_src_=holder;ahelp=[user];ahelp_action=resolve'>[SPAN_TOOLTIP("Close this ticket and mark it as Resolved.","RSLVE")]</a>)")
#define ADMIN_AHELP_HANDLE(user)    ("(<a href='?_src_=holder;ahelp=[user];ahelp_action=handleissue'>[SPAN_TOOLTIP("Alert other Administrators that you're handling this ticket.","HANDLE")]</a>)")
#define ADMIN_AHELP_FULLMONTY(user) ("[ADMIN_AHELP_REJECT(user)] [ADMIN_AHELP_IC(user)] [ADMIN_AHELP_CLOSE(user)] [ADMIN_AHELP_RESOLVE(user)] [ADMIN_AHELP_HANDLE(user)]")

#define AHELP_ACTIVE   1
#define AHELP_CLOSED   2
#define AHELP_RESOLVED 3

// LOG BROWSE TYPES
#define BROWSE_ROOT_ALL_LOGS     1
#define BROWSE_ROOT_CURRENT_LOGS 2
