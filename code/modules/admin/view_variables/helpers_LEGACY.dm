/datum/proc/get_view_variables_options_legacy()
	return ""

/mob/get_view_variables_options_legacy()
	return ..() + {"
		<option value='?_src_=vars;[HrefToken()];mob_player_panel=[REF(src)]'>Show player panel</option>
		<option>---</option>
		<option value='?_src_=vars;[HrefToken()];give_modifier=[REF(src)]'>Give Modifier</option>
		<option value='?_src_=vars;[HrefToken()];give_spell=[REF(src)]'>Give Spell</option>
		<option value='?_src_=vars;[HrefToken()];give_disease2=[REF(src)]'>Give Disease</option>
		<option value='?_src_=vars;[HrefToken()];give_disease=[REF(src)]'>Give TG-style Disease</option>
		<option value='?_src_=vars;[HrefToken()];godmode=[REF(src)]'>Toggle Godmode</option>
		<option value='?_src_=vars;[HrefToken()];build_mode=[REF(src)]'>Toggle Build Mode</option>

		<option value='?_src_=vars;[HrefToken()];ninja=[REF(src)]'>Make Space Ninja</option>
		<option value='?_src_=vars;[HrefToken()];make_skeleton=[REF(src)]'>Make 2spooky</option>

		<option value='?_src_=vars;[HrefToken()];direct_control=[REF(src)]'>Assume Direct Control</option>
		<option value='?_src_=vars;[HrefToken()];drop_everything=[REF(src)]'>Drop Everything</option>

		<option value='?_src_=vars;[HrefToken()];regenerateicons=[REF(src)]'>Regenerate Icons</option>
		<option value='?_src_=vars;[HrefToken()];addlanguage=[REF(src)]'>Add Language</option>
		<option value='?_src_=vars;[HrefToken()];remlanguage=[REF(src)]'>Remove Language</option>
		<option value='?_src_=vars;[HrefToken()];addorgan=[REF(src)]'>Add Organ</option>
		<option value='?_src_=vars;[HrefToken()];remorgan=[REF(src)]'>Remove Organ</option>

		<option value='?_src_=vars;[HrefToken()];fix_nano=[REF(src)]'>Fix NanoUI</option>

		<option value='?_src_=vars;[HrefToken()];addverb=[REF(src)]'>Add Verb</option>
		<option value='?_src_=vars;[HrefToken()];remverb=[REF(src)]'>Remove Verb</option>
		<option>---</option>
		<option value='?_src_=vars;[HrefToken()];gib=[REF(src)]'>Gib</option>
		<option value='?_src_=vars;[HrefToken()];explode=[REF(src)]'>Trigger explosion</option>
		<option value='?_src_=vars;[HrefToken()];emp=[REF(src)]'>Trigger EM pulse</option>
		"}

/mob/living/carbon/human/get_view_variables_options_legacy()
	return ..() + {"/
		<option value='?_src_=vars;[HrefToken()];setspecies=[REF(src)]'>Set Species</option>
		<option value='?_src_=vars;[HrefToken()];makeai=[REF(src)]'>Make AI</option>
		<option value='?_src_=vars;[HrefToken()];makerobot=[REF(src)]'>Make cyborg</option>
		<option value='?_src_=vars;[HrefToken()];makemonkey=[REF(src)]'>Make monkey</option>
		<option value='?_src_=vars;[HrefToken()];makealien=[REF(src)]'>Make alien</option>
		"}

/obj/get_view_variables_options_legacy()
	return ..() + {"
		<option value='?_src_=vars;[HrefToken()];delall=[REF(src)]'>Delete all of type</option>
		"}
