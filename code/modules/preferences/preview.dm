/**
 * Lines up and un-overlaps character edit previews. Also un-splits taurs.
 *
 * todo: refactor
 */
/datum/preferences/proc/update_character_previews()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	if(!mannequin.dna) // Special handling for preview icons before SSAtoms has initailized.
		mannequin.dna = new /datum/dna(null)
	mannequin.delete_inventory(TRUE)
	if(regen_limbs)
		var/datum/species/current_species = real_species_datum()
		current_species.create_organs(mannequin)
		regen_limbs = 0
	dress_preview_mob(mannequin)
	mannequin.update_transform()
	mannequin.toggle_tail_vr(setting = TRUE)
	mannequin.toggle_wing_vr(setting = TRUE)
	mannequin.compile_overlays()
	set_character_renders(new /mutable_appearance(mannequin))

// todo: refactor
/datum/preferences/proc/dress_preview_mob(var/mob/living/carbon/human/mannequin, flags)
	copy_to(mannequin, flags)

	if(!equip_preview_mob)
		return

	var/datum/role/job/previewJob = SSjob.job_by_id(preview_job_id())

	if((equip_preview_mob & EQUIP_PREVIEW_LOADOUT) && !(previewJob && (equip_preview_mob & EQUIP_PREVIEW_JOB) && (previewJob.type == /datum/role/job/station/ai || previewJob.type == /datum/role/job/station/cyborg)))
		equip_loadout(mannequin, flags, previewJob)

	if((equip_preview_mob & EQUIP_PREVIEW_JOB) && previewJob)
		mannequin.job = previewJob.title
		previewJob.equip_preview(mannequin, get_job_alt_title_name(previewJob))

/datum/preferences/proc/set_character_renders(mutable_appearance/MA)
	if(!client)
		return

	var/atom/movable/screen/setup_preview/bg/BG= LAZYACCESS(char_render_holders, "BG")
	if(!BG)
		BG = new
		BG.plane = TURF_PLANE
		BG.icon = 'icons/effects/setup_backgrounds_vr.dmi'
		BG.pref = src
		LAZYSET(char_render_holders, "BG", BG)
		client.screen |= BG
	BG.icon_state = bgstate
	BG.screen_loc = preview_screen_locs["BG"]

	for(var/D in GLOB.cardinal)
		var/atom/movable/screen/setup_preview/O = LAZYACCESS(char_render_holders, "[D]")
		if(!O)
			O = new
			O.pref = src
			LAZYSET(char_render_holders, "[D]", O)
			client.screen |= O
		O.appearance = MA
		O.dir = D
		O.screen_loc = preview_screen_locs["[D]"]

/datum/preferences/proc/show_character_renders()
	if(!client || !char_render_holders)
		return
	for(var/render_holder in char_render_holders)
		client.screen |= char_render_holders[render_holder]

/datum/preferences/proc/clear_character_renders()
	for(var/index in char_render_holders)
		var/atom/movable/screen/S = char_render_holders[index]
		client?.screen -= S
		qdel(S)
	char_render_holders = null
