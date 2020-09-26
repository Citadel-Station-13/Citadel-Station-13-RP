/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/datum/sprite_accessory

	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name			// the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species
	var/list/species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN)

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1

/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair
	icon = 'icons/mob/human_face_m.dmi'	  // default icon for all hairs
	var/icon_add = 'icons/mob/human_face.dmi'
	//Enhanced colours and hair for all
	var/color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN) //This lets all races use the default hairstyles.
	var/flags

	eighties
		name = "80's"
		icon_state = "hair_80s"

	afro
		name = "Afro"
		icon_state = "hair_afro"

	afro2
		name = "Afro 2"
		icon_state = "hair_afro2"

	afro_large
		name = "Big Afro"
		icon_state = "hair_bigafro"

	ahoge
		name = "Ahoge"
		icon_state = "hair_ahoge"
		icon_add = null

	bald //Everyone goes bald.
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		flags = HAIR_VERY_SHORT
		species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST) //Lets all the races be bald if they want.


	baldfade
		name = "Balding Fade"
		icon_state = "hair_baldfade"
		gender = MALE
		flags = HAIR_VERY_SHORT

	balding
		name = "Balding Hair"
		icon_state = "hair_e"
		gender = MALE
		flags = HAIR_VERY_SHORT

	bedhead
		name = "Bedhead"
		icon_state = "hair_bedhead"

	bedhead2
		name = "Bedhead 2"
		icon_state = "hair_bedheadv2"

	bedhead3
		name = "Bedhead 3"
		icon_state = "hair_bedheadv3"
		flags = HAIR_TIEABLE

	bedheadlong
		name = "Bedhead Long"
		icon_state = "hair_long_bedhead"
		flags = HAIR_TIEABLE

	beehive
		name = "Beehive"
		icon_state = "hair_beehive"
		flags = HAIR_TIEABLE

	beehive2
		name = "Beehive 2"
		icon_state = "hair_beehive2"
		flags = HAIR_TIEABLE

	belenko
		name = "Belenko"
		icon_state = "hair_belenko"
		flags = HAIR_TIEABLE

	belenkotied
		name = "Belenko Tied"
		icon_state = "hair_belenkotied"
		flags = HAIR_TIEABLE

	bob
		name = "Bob"
		icon_state = "hair_bobcut"
		species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)
		flags = HAIR_TIEABLE

	bobcutalt
		name = "Bob Chin Length"
		icon_state = "hair_bobcutalt"
		flags = HAIR_TIEABLE

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"
		species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)
		flags = HAIR_TIEABLE

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"

	bowlcut2
		name = "Bowl 2"
		icon_state = "hair_bowlcut2"

	grandebraid
		name = "Braid Grande"
		icon_state = "hair_grande"
		flags = HAIR_TIEABLE

	braid2
		name = "Braid Long"
		icon_state = "hair_hbraid"
		flags = HAIR_TIEABLE

	mbraid
		name = "Braid Medium"
		icon_state = "hair_shortbraid"
		flags = HAIR_TIEABLE

	braid
		name = "Floorlength Braid"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "hair_braid"

	bun
		name = "Bun"
		icon_state = "hair_bun"

	bun2
		name = "Bun 2"
		icon_state = "hair_bun2"

	bun3
		name = "Bun 3"
		icon_state = "hair_bun3"

	bun
		name = "Bun Casual"
		icon_state = "hair_bun"
		flags = HAIR_TIEABLE

	doublebun
		name = "Bun Double"
		icon_state = "hair_doublebun"
		flags = HAIR_TIEABLE

	tightbun
		name = "Bun Tight"
		icon_state = "hair_tightbun"
		gender = FEMALE
		flags = HAIR_VERY_SHORT | HAIR_TIEABLE

	buzz
		name = "Buzzcut"
		icon_state = "hair_buzzcut"
		flags = HAIR_VERY_SHORT
		species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

	crono
		name = "Chrono"
		icon_state = "hair_toriyama"

	cia
		name = "CIA"
		icon_state = "hair_cia"

	coffeehouse
		name = "Coffee House Cut"
		icon_state = "hair_coffeehouse"
		gender = MALE
		flags = HAIR_VERY_SHORT

	combover
		name = "Combover"
		icon_state = "hair_combover"

	country
		name = "Country"
		icon_state = "hair_country"

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"
		flags = HAIR_VERY_SHORT

	curls
		name = "Curls"
		icon_state = "hair_curls"
		flags = HAIR_TIEABLE

	cut
		name = "Cut Hair"
		icon_state = "hair_c"
		flags = HAIR_VERY_SHORT

	dave
		name = "Dave"
		icon_state = "hair_dave"

	devillock
		name = "Devil Lock"
		icon_state = "hair_devilock"

	dreadlocks
		name = "Dreadlocks"
		icon_state = "hair_dreads"

	mahdrills
		name = "Drillruru"
		icon_state = "hair_drillruru"

	emo
		name = "Emo"
		icon_state = "hair_emo"

	emo2
		name = "Emo Alt"
		icon_state = "hair_emo2"

	fringeemo
		name = "Emo Fringe"
		icon_state = "hair_emofringe"
		flags = HAIR_TIEABLE

	halfshaved
		name = "Emo Half-Shaved"
		icon_state = "hair_halfshaved"

	longemo
		name = "Emo Long"
		icon_state = "hair_emolong"
		flags = HAIR_TIEABLE

	highfade
		name = "Fade High"
		icon_state = "hair_highfade"
		gender = MALE
		flags = HAIR_VERY_SHORT

	medfade
		name = "Fade Medium"
		icon_state = "hair_medfade"
		flags = HAIR_VERY_SHORT

	lowfade
		name = "Fade Low"
		icon_state = "hair_lowfade"
		gender = MALE
		flags = HAIR_VERY_SHORT

	partfade
		name = "Fade Parted"
		icon_state = "hair_shavedpart"
		gender = MALE
		flags = HAIR_VERY_SHORT

	familyman
		name = "Family Man"
		icon_state = "hair_thefamilyman"

	father
		name = "Father"
		icon_state = "hair_father"

	feather
		name = "Feather"
		icon_state = "hair_feather"
		flags = HAIR_TIEABLE

	flair
		name = "Flaired Hair"
		icon_state = "hair_flair"
		flags = HAIR_TIEABLE

	sargeant
		name = "Flat Top"
		icon_state = "hair_sargeant"
		flags = HAIR_VERY_SHORT

	flowhair
		name = "Flow Hair"
		icon_state = "hair_f"

	longfringe
		name = "Fringe Long"
		icon_state = "hair_longfringe"
		flags = HAIR_TIEABLE

	longestalt
		name = "Fringe Longer"
		icon_state = "hair_vlongfringe"
		flags = HAIR_TIEABLE

	fringetail
		name = "Fringetail"
		icon_state = "hair_fringetail"
		flags = HAIR_TIEABLE|HAIR_VERY_SHORT

	gelled
		name = "Gelled Back"
		icon_state = "hair_gelled"

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"
		flags = HAIR_TIEABLE

	glossy
		name = "Glossy"
		icon_state = "hair_glossy"
		flags = HAIR_TIEABLE

	halfbang
		name = "Half-banged Hair"
		icon_state = "hair_halfbang"

	halfbangalt
		name = "Half-banged Hair Alt"
		icon_state = "hair_halfbang_alt"

	hedgehog
		name = "Hedgehog Hair"
		icon_state = "hair_hedgehog"
		icon_add = null

	hightight
		name = "High and Tight"
		icon_state = "hair_hightight"
		flags = HAIR_VERY_SHORT

	himecut
		name = "Hime Cut"
		icon_state = "hair_himecut"
		flags = HAIR_TIEABLE

	shorthime
		name = "Hime Cut Short"
		icon_state = "hair_shorthime"
		flags = HAIR_TIEABLE

	hitop
		name = "Hitop"
		icon_state = "hair_hitop"

	jade
		name = "Jade"
		icon_state = "hair_jade"

	jensen
		name = "Jensen"
		icon_state = "hair_jensen"

	joestar
		name = "Joestar"
		icon_state = "hair_joestar"

	kagami
		name = "Kagami"
		icon_state = "hair_kagami"
		flags = HAIR_TIEABLE

	kusangi
		name = "Kusanagi Hair"
		icon_state = "hair_kusanagi"

	long
		name = "Long Hair Shoulder-length"
		icon_state = "hair_b"
		flags = HAIR_TIEABLE
/*
	longish
		name = "Longer Hair"
		icon_state = "hair_b2"
		flags = HAIR_TIEABLE
*/
	longer
		name = "Long Hair"
		icon_state = "hair_vlong"
		flags = HAIR_TIEABLE

	longeralt2
		name = "Long Hair Alt 2"
		icon_state = "hair_longeralt2"
		flags = HAIR_TIEABLE

	longest
		name = "Very Long Hair"
		icon_state = "hair_longest"
		flags = HAIR_TIEABLE

	manbun
		name = "Manbun"
		icon_state = "hair_manbun"
		flags = HAIR_TIEABLE

	modern
		name = "Modern"
		icon_state = "hair_modern"

	mohawk
		name = "Mohawk"
		icon_state = "hair_d"
		species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

	regulationmohawk
		name = "Mohawk Regulation"
		icon_state = "hair_shavedmohawk"
		flags = HAIR_VERY_SHORT

	reversemohawk
		name = "Mohawk Reverse"
		icon_state = "hair_reversemohawk"

	messy
		name = "Messy"
		icon_state = "hair_messy_tg"
		icon_add = null

	mohawkunshaven
		name = "Mohawk Unshaven"
		icon_state = "hair_unshaven_mohawk"

	mulder
		name = "Mulder"
		icon_state = "hair_mulder"

	newyou
		name = "New You"
		icon_state = "hair_newyou"
		flags = HAIR_TIEABLE

	nia
		name = "Nia"
		icon_state = "hair_nia"

	nitori
		name = "Nitori"
		icon_state = "hair_nitori"
		flags = HAIR_TIEABLE

	odango
		name = "Odango"
		icon_state = "hair_odango"
		flags = HAIR_TIEABLE

	ombre
		name = "Ombre"
		icon_state = "hair_ombre"
		flags = HAIR_TIEABLE

	oxton
		name = "Oxton"
		icon_state = "hair_oxton"

	longovereye
		name = "Overeye Long"
		icon_state = "hair_longovereye"
		flags = HAIR_TIEABLE

	shortovereye
		name = "Overeye Short"
		icon_state = "hair_shortovereye"

	veryshortovereyealternate
		name = "Overeye Very Short, Alternate"
		icon_state = "hair_veryshortovereyealternate"

	veryshortovereye
		name = "Overeye Very Short"
		icon_state = "hair_veryshortovereye"

	parted
		name = "Parted"
		icon_state = "hair_parted"

	partedalt
		name = "Parted Alt"
		icon_state = "hair_partedalt"

	pompadour
		name = "Pompadour"
		icon_state = "hair_pompadour"

	dandypomp
		name = "Pompadour Dandy"
		icon_state = "hair_dandypompadour"

	ponytail1
		name = "Ponytail 1"
		icon_state = "hair_ponytail"
		flags = HAIR_TIEABLE|HAIR_VERY_SHORT

	ponytail2
		name = "Ponytail 2"
		icon_state = "hair_pa"
		flags = HAIR_TIEABLE

	ponytail3
		name = "Ponytail 3"
		icon_state = "hair_ponytail3"
		flags = HAIR_TIEABLE

	ponytail4
		name = "Ponytail 4"
		icon_state = "hair_ponytail4"
		flags = HAIR_TIEABLE

	ponytail5
		name = "Ponytail 5"
		icon_state = "hair_ponytail5"
		flags = HAIR_TIEABLE

	ponytail6
		name = "Ponytail 6"
		icon_state = "hair_ponytail6"
		flags = HAIR_TIEABLE|HAIR_VERY_SHORT

	ponytail6_fixed //Eggnerd's done with waiting for upstream fixes lmao.
		name = "Ponytail 6 but fixed"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "hair_ponytail6"
		species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_NEVREAN, SPECIES_AKULA,SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST)

	sharpponytail
		name = "Ponytail Sharp"
		icon_state = "hair_sharpponytail"
		flags = HAIR_TIEABLE

	spikyponytail
		name = "Ponytail Spiky"
		icon_state = "hair_spikyponytail"
		flags = HAIR_TIEABLE

	poofy
		name = "Poofy"
		icon_state = "hair_poofy"
		flags = HAIR_TIEABLE

	poofy2
		name = "Poofy 2"
		icon_state = "hair_poofy2"
		flags = HAIR_TIEABLE

	quiff
		name = "Quiff"
		icon_state = "hair_quiff"

	nofade
		name = "Regulation Cut"
		icon_state = "hair_nofade"
		gender = MALE
		flags = HAIR_VERY_SHORT

	ronin
		name = "Ronin"
		icon_state = "hair_ronin"
		flags = HAIR_TIEABLE

	rosa
		name = "Rosa"
		icon_state = "hair_rosa"

	rows
		name = "Rows"
		icon_state = "hair_rows1"
		flags = HAIR_VERY_SHORT

	rows2
		name = "Rows 2"
		icon_state = "hair_rows2"
		flags = HAIR_TIEABLE

	rowbun
		name = "Row Bun"
		icon_state = "hair_rowbun"
		flags = HAIR_TIEABLE

	rowdualbraid
		name = "Row Dual Braid"
		icon_state = "hair_rowdualtail"
		flags = HAIR_TIEABLE

	rowbraid
		name = "Row Braid"
		icon_state = "hair_rowbraid"
		flags = HAIR_TIEABLE

	scully
		name = "Scully"
		icon_state = "hair_scully"

	shavehair
		name = "Shaved Hair"
		icon_state = "hair_shaved"
		flags = HAIR_VERY_SHORT

	shortbangs
		name = "Short Bangs"
		icon_state = "hair_shortbangs"

	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
		flags = HAIR_VERY_SHORT

	short2
		name = "Short Hair 2"
		icon_state = "hair_shorthair3"
		flags = HAIR_VERY_SHORT

	short3
		name = "Short Hair 3"
		icon_state = "hair_shorthair4"
		flags = HAIR_VERY_SHORT

	shy
		name = "Shy"
		icon_state = "hair_shy"

	sideponytail
		name = "Side Ponytail"
		icon_state = "hair_stail"
		flags = HAIR_TIEABLE

	sideponytail4 //Not happy about this... but it's for the save files.
		name = "Side Ponytail 2"
		icon_state = "hair_ponytailf"
		flags = HAIR_TIEABLE

	sideponytail2
		name = "Shoulder One"
		icon_state = "hair_oneshoulder"
		flags = HAIR_TIEABLE

	sideponytail3
		name = "Shoulder Tress"
		icon_state = "hair_tressshoulder"
		flags = HAIR_TIEABLE

	skinhead
		name = "Skinhead"
		icon_state = "hair_skinhead"
		flags = HAIR_VERY_SHORT

	sleeze
		name = "Sleeze"
		icon_state = "hair_sleeze"
		flags = HAIR_VERY_SHORT

	spiky
		name = "Spiky"
		icon_state = "hair_spikey"
		species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

	thinning
		name = "Thinning"
		icon_state = "hair_thinning"
		flags = HAIR_VERY_SHORT

	thinningfront
		name = "Thinning Front"
		icon_state = "hair_thinningfront"
		flags = HAIR_VERY_SHORT

	thinningback
		name = "Thinning Back"
		icon_state = "hair_thinningrear"
		flags = HAIR_VERY_SHORT

	topknot
		name = "Topknot"
		icon_state = "hair_topknot"
		flags = HAIR_TIEABLE

	trimflat
		name = "Trimmed Flat Top"
		icon_state = "hair_trimflat"
		gender = MALE
		flags = HAIR_VERY_SHORT
	shy
		name = "Shy"
		icon_state = "hair_shy"

	jade
		name = "Jade"
		icon_state = "hair_jade"
		flags = HAIR_TIEABLE

	trimmed
		name = "Trimmed"
		icon_state = "hair_trimmed"
		gender = MALE
		flags = HAIR_VERY_SHORT

	twintail
		name = "Twintail"
		icon_state = "hair_twintail"
		flags = HAIR_TIEABLE

	undercut1
		name = "Undercut"
		icon_state = "hair_undercut1"
		gender = MALE
		flags = HAIR_VERY_SHORT

	undercut2
		name = "Undercut Swept Right"
		icon_state = "hair_undercut2"
		gender = MALE
		flags = HAIR_VERY_SHORT

	undercut3
		name = "Undercut Swept Left"
		icon_state = "hair_undercut3"
		gender = MALE
		flags = HAIR_VERY_SHORT

	unkept
		name = "Unkept"
		icon_state = "hair_unkept"

	updo
		name = "Updo"
		icon_state = "hair_updo"
		flags = HAIR_TIEABLE

	vegeta
		name = "Vegeta"
		icon_state = "hair_toriyama2"

	volaju
		name = "Volaju"
		icon_state = "hair_volaju"
		flags = HAIR_TIEABLE

	wisp
		name = "Wisp"
		icon_state = "hair_wisp"
		flags = HAIR_TIEABLE

	zieglertail
		name = "Zieglertail"
		icon_state = "hair_ziegler"
		flags = HAIR_TIEABLE

	glossy
		name = "Glossy"
		icon_state = "hair_glossy"
		flags = HAIR_TIEABLE

	sharpponytail
		name = "Ponytail Sharp"
		icon_state = "hair_sharpponytail"
		flags = HAIR_TIEABLE

	newyou
		name = "New You"
		icon_state = "hair_newyou"
		flags = HAIR_TIEABLE

	partedalt
		name = "Parted Alt"
		icon_state = "hair_partedalt"

	amazon
		name = "Amazon"
		icon_state = "hair_amazon"
		flags = HAIR_TIEABLE

	straightlong
		name = "Straight Long"
		icon_state = "hair_straightlong"
		flags = HAIR_TIEABLE

	marysue
		name = "Mary Sue"
		icon_state = "hair_marysue"

	sideundercut
		name = "Side Undercut"
		icon_state = "hair_sideundercut"
		flags = HAIR_VERY_SHORT

	donutbun
		name = "Donut Bun"
		icon_state = "hair_donutbun"

	gentle2
		name = "Gentle 2, Long"
		icon_state = "hair_gentle2long"
		flags = HAIR_TIEABLE

	sweepshave
		name = "Sweep Shave"
		icon_state = "hair_sweepshave"

	beachwave
		name = "Beach Waves"
		icon_state = "hair_beachwave"
		flags = HAIR_TIEABLE

	celebcurls
		name = "Celeb Curls"
		icon_state = "hair_celebcurls"
		flags = HAIR_TIEABLE

	jessica
		name = "Jessica"
		icon_state = "hair_jessica"
		flags = HAIR_TIEABLE

	proper
		name = "Proper"
		icon_state = "hair_proper"

	himeup
		name = "Hime Updo"
		icon_state = "hair_himeup"
		flags = HAIR_TIEABLE

	front_braid
		name = "Braided front"
		icon_state = "hair_braidfront"
		flags = HAIR_TIEABLE

	antenna
		name = "Antenna"
		icon_state = "hair_antenna"

	protagonist
		name = "Slightly Long"
		icon_state = "hair_protagonist"
		flags = HAIR_TIEABLE

	braidtail
		name = "Braided Tail"
		icon_state = "hair_braidtail"
		flags = HAIR_TIEABLE

	business
		name = "Business Hair"
		icon_state = "hair_business"
		flags = HAIR_VERY_SHORT

	business3
		name = "Business Hair 3"
		icon_state = "hair_business3"
		flags = HAIR_VERY_SHORT

	business4
		name = "Business Hair 4"
		icon_state = "hair_business4"
		flags = HAIR_VERY_SHORT

	sidepartlongalt
		name = "Long Side Part"
		icon_state = "hair_longsidepart"
		flags = HAIR_TIEABLE

	miles
		name = "Miles Hair"
		icon_state = "hair_miles"

	vivi
		name = "Vivi"
		icon_state = "hair_vivi"

	astolfo
		name = "Astolfo"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "hair_astolfo"

	awoohair
		name = "Shoulder-length Messy"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "momijihair"

	citheronia
		name = "Citheronia Hair (Kira72)"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "citheronia_hair"
		ckeys_allowed = list("Kira72")
		do_colouration = 0

	taramaw
		name = "Hairmaw (Liquidfirefly)"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "maw_hair"
		ckeys_allowed = list("liquidfirefly")
		do_colouration = 0

	citheronia_colorable
		name = "Citheronia Hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "citheronia_hair_c"
		do_colouration = 1

	twindrills
		name = "Twin Drills"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "hair_twincurl"

	inkling
		name = "colorable mature inkling hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "inkling-colorable"
		color_blend_mode = ICON_MULTIPLY
		do_colouration = 1

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face_or_vr.dmi'
	var/color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST) //This lets all races use the facial hair styles.

	shaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER
		species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST) //This needed to be manually defined, apparantly.

	neck_fluff
		name = "Neck Fluff"
		icon = 'icons/mob/human_face_or_vr.dmi'
		icon_state = "facial_neckfluff"
		gender = NEUTER
		species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST)

	vulp_none
		name = "None"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "none"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_blaze
		name = "Blaze"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_blaze"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_vulpine
		name = "Vulpine"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_vulpine"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_earfluff
		name = "Earfluff"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_earfluff"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_mask
		name = "Mask"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_mask"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_patch
		name = "Patch"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_patch"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_ruff
		name = "Ruff"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_ruff"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_kita
		name = "Kita"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_kita"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_swift
		name = "Swift"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_swift"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"
		//Fuck it, everyone is Elvis. species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

	volaju
		name = "Volaju"
		icon_state = "facial_volaju"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

	threeOclock
		name = "3 O'clock Shadow"
		icon_state = "facial_3oclock"

	threeOclockstache
		name = "3 O'clock Shadow and Moustache"
		icon_state = "facial_3oclockmoustache"

	fiveOclock
		name = "5 O'clock Shadow"
		icon_state = "facial_5oclock"

	fiveOclockstache
		name = "5 O'clock Shadow and Moustache"
		icon_state = "facial_5oclockmoustache"

	sevenOclock
		name = "7 O'clock Shadow"
		icon_state = "facial_7oclock"

	sevenOclockstache
		name = "7 O'clock Shadow and Moustache"
		icon_state = "facial_7oclockmoustache"

	mutton
		name = "Mutton Chops"
		icon_state = "facial_mutton"

	muttonstache
		name = "Mutton Chops and Moustache"
		icon_state = "facial_muttonmus"

	walrus
		name = "Walrus Moustache"
		icon_state = "facial_walrus"

	croppedbeard
		name = "Full Cropped Beard"
		icon_state = "facial_croppedfullbeard"

	chinless
		name = "Chinless Beard"
		icon_state = "facial_chinlessbeard"

	tribeard
		name = "Tribeard"
		icon_state = "facial_tribeard"

	moonshiner
		name = "Moonshiner"
		icon_state = "facial_moonshiner"

	martial
		name = "Martial Artist"
		icon_state = "facial_martialartist"
/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/hair
	//Unathi stuff
	una_hood
		name = "Cobra Hood"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "soghun_hood"

	una_spines_long
		name = "Long Unathi Spines"
		icon_state = "soghun_longspines"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN) //Xenochimera get most hairstyles since they're abominations.

	una_spines_short
		name = "Short Unathi Spines"
		icon_state = "soghun_shortspines"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)


	una_frills_long
		name = "Long Unathi Frills"
		icon_state = "soghun_longfrills"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

	una_frills_short
		name = "Short Unathi Frills"
		icon_state = "soghun_shortfrills"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

	una_horns
		name = "Unathi Horns"
		icon_state = "soghun_horns"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

	una_bighorns
		name = "Unathi Big Horns"
		icon_state = "unathi_bighorn"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

	una_smallhorns
		name = "Unathi Small Horns"
		icon_state = "unathi_smallhorn"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

	una_ramhorns
		name = "Unathi Ram Horns"
		icon_state = "unathi_ramhorn"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

	una_sidefrills
		name = "Unathi Side Frills"
		icon_state = "unathi_sidefrills"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

	una_doublehorns
		name = "Double Unathi Horns"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "soghun_dubhorns"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

//Skrell 'hairstyles' - these were requested for a chimera and screw it, if one wants to eat seafood, go nuts
	skr_tentacle_veryshort
		name = "Skrell Very Short Tentacles"
		icon_state = "skrell_hair_veryshort"
		species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		gender = MALE

	skr_tentacle_short
		name = "Skrell Short Tentacles"
		icon_state = "skrell_hair_short"
		species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

	skr_tentacle_average
		name = "Skrell Average Tentacles"
		icon_state = "skrell_hair_average"
		species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

	skr_tentacle_verylong
		name = "Skrell Long Tentacles"
		icon_state = "skrell_hair_verylong"
		species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		gender = FEMALE

//Tajaran hairstyles
	taj_ears
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_clean
		name = "Tajara Clean"
		icon_state = "hair_clean"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_bangs
		name = "Tajara Bangs"
		icon_state = "hair_bangs"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_braid
		name = "Tajara Braid"
		icon_state = "hair_tbraid"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_shaggy
		name = "Tajara Shaggy"
		icon_state = "hair_shaggy"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_mohawk
		name = "Tajaran Mohawk"
		icon_state = "hair_mohawk"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_plait
		name = "Tajara Plait"
		icon_state = "hair_plait"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_straight
		name = "Tajara Straight"
		icon_state = "hair_straight"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_long
		name = "Tajara Long"
		icon_state = "hair_long"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_rattail
		name = "Tajara Rat Tail"
		icon_state = "hair_rattail"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_spiky
		name = "Tajara Spiky"
		icon_state = "hair_tajspiky"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_messy
		name = "Tajara Messy"
		icon_state = "hair_messy"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_curls
		name = "Tajaran Curly"
		icon_state = "hair_curly"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_wife
		name = "Tajaran Housewife"
		icon_state = "hair_wife"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_victory
		name = "Tajaran Victory Curls"
		icon_state = "hair_victory"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_bob
		name = "Tajaran Bob"
		icon_state = "hair_tbob"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

	taj_ears_fingercurl
		name = "Tajaran Finger Curls"
		icon_state = "hair_fingerwave"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

//Teshari things
	teshari
		name = "Teshari Default"
		icon_state = "teshari_default"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_altdefault
		name = "Teshari Alt. Default"
		icon_state = "teshari_ears"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_tight
		name = "Teshari Tight"
		icon_state = "teshari_tight"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_excited
		name = "Teshari Spiky"
		icon_state = "teshari_spiky"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_spike
		name = "Teshari Spike"
		icon_state = "teshari_spike"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_long
		name = "Teshari Overgrown"
		icon_state = "teshari_long"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_burst
		name = "Teshari Starburst"
		icon_state = "teshari_burst"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_shortburst
		name = "Teshari Short Starburst"
		icon_state = "teshari_burst_short"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_mohawk
		name = "Teshari Mohawk"
		icon_state = "teshari_mohawk"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_pointy
		name = "Teshari Pointy"
		icon_state = "teshari_pointy"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_upright
		name = "Teshari Upright"
		icon_state = "teshari_upright"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_mane
		name = "Teshari Mane"
		icon_state = "teshari_mane"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_droopy
		name = "Teshari Droopy"
		icon_state = "teshari_droopy"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_mushroom
		name = "Teshari Mushroom"
		icon_state = "teshari_mushroom"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_twies
		name = "Teshari Twies"
		icon_state = "teshari_twies"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_backstrafe
		name = "Teshari Backstrafe"
		icon_state = "teshari_backstrafe"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_longway
		name = "Teshari Long way"
		icon_state = "teshari_longway"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_tree
		name = "Teshari Tree"
		icon_state = "teshari_tree"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)

	teshari_fluffymohawk
		name = "Teshari Fluffy Mohawk"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "teshari_fluffymohawk"
		species_allowed = list(SPECIES_TESHARI)

// Vox things
	vox_braid_long
		name = "Long Vox braid"
		icon_state = "vox_longbraid"
		species_allowed = list(SPECIES_VOX)

	vox_braid_short
		name = "Short Vox Braid"
		icon_state = "vox_shortbraid"
		species_allowed = list(SPECIES_VOX)

	vox_quills_short
		name = "Short Vox Quills"
		icon_state = "vox_shortquills"
		species_allowed = list(SPECIES_VOX)

	vox_quills_kingly
		name = "Kingly Vox Quills"
		icon_state = "vox_kingly"
		species_allowed = list(SPECIES_VOX)

	vox_quills_mohawk
		name = "Quill Mohawk"
		icon_state = "vox_mohawk"
		species_allowed = list(SPECIES_VOX)

	vox_quills_afro
		name = "Vox Afro"
		icon_state = "vox_afro"
		species_allowed = list(SPECIES_VOX)

	vox_quills_mohawk
		name = "Vox Mohawk"
		icon_state = "vox_mohawk"
		species_allowed = list(SPECIES_VOX)

	vox_quills_yasu
		name = "Vox Yasuhiro"
		icon_state = "vox_yasu"
		species_allowed = list(SPECIES_VOX)

	vox_quills_horns
		name = "Vox Quorns"
		icon_state = "vox_horns"
		species_allowed = list(SPECIES_VOX)

	vox_quills_nights
		name = "Vox Nights"
		icon_state = "vox_nights"
		species_allowed = list(SPECIES_VOX)

	vox_quills_surf
		name = "Vox Surf"
		icon_state = "vox_surf"
		species_allowed = list(SPECIES_VOX)

	vox_quills_cropped
		name = "Vox Cropped"
		icon_state = "vox_cropped"
		species_allowed = list(SPECIES_VOX)

	vox_quills_bald
		name = "Vox Bald"
		icon_state = "vox_bald"
		species_allowed = list(SPECIES_VOX)

	vox_quills_ruffhawk
		name = "Vox Ruffhawk"
		icon_state = "vox_ruff_hawk"
		species_allowed = list(SPECIES_VOX)

	vox_quills_rows
		name = "Vox Rows"
		icon_state = "vox_rows"
		species_allowed = list(SPECIES_VOX)

	vox_quills_mange
		name = "Vox Mange"
		icon_state = "vox_mange"
		species_allowed = list(SPECIES_VOX)

	vox_quills_pony
		name = "Vox Pony"
		icon_state = "vox_pony"
		species_allowed = list(SPECIES_VOX)

//Cheesewedge things
	sergal_plain
		name = "Sergal Plain"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "serg_plain"
		species_allowed = list(SPECIES_SERGAL)

	sergal_medicore
		name = "Sergal Medicore"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "serg_medicore"
		species_allowed = list(SPECIES_SERGAL)

	sergal_tapered
		name = "Sergal Tapered"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "serg_tapered"
		species_allowed = list(SPECIES_SERGAL)

	sergal_fairytail
		name = "Sergal Fairytail"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "serg_fairytail"
		species_allowed = list(SPECIES_SERGAL)

// Vulpa stuffs
	vulp_hair_none
		name = "None"
		icon_state = "bald"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_hair_kajam
		name = "Kajam"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "kajam"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_keid
		name = "Keid"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "keid"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_adhara
		name = "Adhara"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "adhara"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_kleeia
		name = "Kleeia"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "kleeia"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_mizar
		name = "Mizar"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "mizar"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_apollo
		name = "Apollo"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "apollo"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_belle
		name = "Belle"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "belle"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_bun
		name = "Bun"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "bun"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_jagged
		name = "Jagged"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "jagged"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_curl
		name = "Curl"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "curl"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_hawk
		name = "Hawk"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "hawk"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_anita
		name = "Anita"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "anita"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_short
		name = "Short"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "short"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_spike
		name = "Spike"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "spike"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		gender = NEUTER

//xeno stuffs
	xeno_head_drone_color
		name = "Drone dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_drone"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER
// figure this one out for better coloring
	xeno_head_sentinel_color
		name = "Sentinal dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_sentinel"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_queen_color
		name = "Queen dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_queen"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_hunter_color
		name = "Hunter dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_hunter"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_praetorian_color
		name = "Praetorian dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_praetorian"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

// Shadekin stuffs
	shadekin_hair_short
		name = "Shadekin Short Hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "shadekin_short"
		species_allowed = list(SPECIES_SHADEKIN)
		gender = NEUTER

	shadekin_hair_poofy
		name = "Shadekin Poofy Hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "shadekin_poofy"
		species_allowed = list(SPECIES_SHADEKIN)
		gender = NEUTER

	shadekin_hair_long
		name = "Shadekin Long Hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "shadekin_long"
		species_allowed = list(SPECIES_SHADEKIN)
		gender = NEUTER

	shadekin_hair_rivyr
		name = "Rivyr Hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "shadekin_rivyr"
		ckeys_allowed = list("verysoft")
		species_allowed = list(SPECIES_SHADEKIN)
		gender = NEUTER

/datum/sprite_accessory/facial_hair

	taj_sideburns
		name = "Tajaran Sideburns"
		icon_state = "facial_sideburns"
		species_allowed = list(SPECIES_TAJ)

	taj_mutton
		name = "Tajaran Mutton"
		icon_state = "facial_mutton"
		species_allowed = list(SPECIES_TAJ)

	taj_pencilstache
		name = "Tajaran Pencilstache"
		icon_state = "facial_pencilstache"
		species_allowed = list(SPECIES_TAJ)

	taj_moustache
		name = "Tajaran Moustache"
		icon_state = "facial_moustache"
		species_allowed = list(SPECIES_TAJ)

	taj_goatee
		name = "Tajaran Goatee"
		icon_state = "facial_goatee"
		species_allowed = list(SPECIES_TAJ)

	taj_smallstache
		name = "Tajaran Smallsatche"
		icon_state = "facial_smallstache"
		species_allowed = list(SPECIES_TAJ)

// More Vox things

	vox_face_colonel
		name = "Vox Colonel"
		icon_state = "vox_colonel"
		species_allowed = list(SPECIES_VOX)

	vox_face_fu
		name = "Quill Fu"
		icon_state = "vox_fu"
		species_allowed = list(SPECIES_VOX)

	vox_face_neck
		name = "Neck Quills"
		icon_state = "vox_neck"
		species_allowed = list(SPECIES_VOX)

	vox_face_beard
		name = "Quill Beard"
		icon_state = "vox_beard"
		species_allowed = list(SPECIES_VOX)

	vox_ruff_beard
		name = "Ruff Beard"
		icon_state = "vox_ruff_beard"
		species_allowed = list(SPECIES_VOX)

	vox_shaved_beard
		name = "Vox Shaved"
		icon_state = "vox_bald"
		species_allowed = list(SPECIES_VOX)

//unathi horn beards and the like

	una_chinhorn
		name = "Unathi Chin Horn"
		icon_state = "facial_chinhorns"
		species_allowed = list(SPECIES_UNATHI)

	una_hornadorns
		name = "Unathi Horn Adorns"
		icon_state = "facial_hornadorns"
		species_allowed = list(SPECIES_UNATHI)

	una_spinespikes
		name = "Unathi Spine Spikes"
		icon_state = "facial_spikes"
		species_allowed = list(SPECIES_UNATHI)

	una_dorsalfrill
		name = "Unathi Dorsal Frill"
		icon_state = "facial_dorsalfrill"
		species_allowed = list(SPECIES_UNATHI)


//Teshari things
	teshari_beard
		name = "Teshari Beard"
		icon_state = "teshari_chin"
		species_allowed = list(SPECIES_TESHARI)
		gender = NEUTER

	teshari_scraggly
		name = "Teshari Scraggly"
		icon_state = "teshari_scraggly"
		species_allowed = list(SPECIES_TESHARI)
		gender = NEUTER

	teshari_chops
		name = "Teshari Chops"
		icon_state = "teshari_gap"
		species_allowed = list(SPECIES_TESHARI)
		gender = NEUTER

/*
////////////////////////////
/  =--------------------=  /
/  ==  Body Markings   ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/marking
	icon = 'icons/mob/human_races/markings.dmi'
	do_colouration = 1 //Almost all of them have it, COLOR_ADD
	var/color_blend_mode = ICON_ADD

	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajaran inner-ear coloring overlay stuff.
	species_allowed = list()

	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD

	tat_heart
		name = "Tattoo (Heart, Torso)"
		icon_state = "tat_heart"
		body_parts = list(BP_TORSO)

	tat_hive
		name = "Tattoo (Hive, Back)"
		icon_state = "tat_hive"
		body_parts = list(BP_TORSO)

	tat_nightling
		name = "Tattoo (Nightling, Back)"
		icon_state = "tat_nightling"
		body_parts = list(BP_TORSO)

	tat_campbell
		name = "Tattoo (Campbell, R.Arm)"
		icon_state = "tat_campbell"
		body_parts = list(BP_R_ARM)

		left
			name = "Tattoo (Campbell, L.Arm)"
			body_parts = list(BP_L_ARM)

		rightleg
			name = "Tattoo (Campbell, R.Leg)"
			body_parts = list(BP_R_LEG)

		leftleg
			name = "Tattoo (Campbell, L.Leg)"
			body_parts = list (BP_L_LEG)

	tat_silverburgh
		name = "Tattoo (Silverburgh, R.Leg)"
		icon_state = "tat_silverburgh"
		body_parts = list (BP_R_LEG)

		left
			name = "Tattoo (Silverburgh, L.Leg)"
			icon_state = "tat_silverburgh"
			body_parts = list (BP_L_LEG)

	tat_tiger
		name = "Tattoo (Tiger Stripes, Body)"
		icon_state = "tat_tiger"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

	taj_paw_socks
		name = "Socks Coloration (Taj)"
		icon_state = "taj_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(SPECIES_TAJ)

	una_paw_socks
		name = "Socks Coloration (Una)"
		icon_state = "una_pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(SPECIES_UNATHI)

	paw_socks
		name = "Socks Coloration (Generic)"
		icon_state = "pawsocks"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

	paw_socks_belly
		name = "Socks,Belly Coloration (Generic)"
		icon_state = "pawsocksbelly"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

	belly_hands_feet
		name = "Hands,Feet,Belly Color (Minor)"
		icon_state = "bellyhandsfeetsmall"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

	hands_feet_belly_full
		name = "Hands,Feet,Belly Color (Major)"
		icon_state = "bellyhandsfeet"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

	hands_feet_belly_full_female
		name = "Hands,Feet,Belly Color (Major, Female)"
		icon_state = "bellyhandsfeet_female"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_TAJ)

	patches
		name = "Color Patches"
		icon_state = "patches"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)
		species_allowed = list(SPECIES_TAJ)

	patchesface
		name = "Color Patches (Face)"
		icon_state = "patchesface"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	bands
		name = "Color Bands"
		icon_state = "bands"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

	bandsface
		name = "Color Bands (Face)"
		icon_state = "bandsface"
		body_parts = list(BP_HEAD)

	tiger_stripes
		name = "Tiger Stripes"
		icon_state = "tiger"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)
		species_allowed = list(SPECIES_TAJ) //There's a tattoo for non-cats

	tigerhead
		name = "Tiger Stripes (Head, Minor)"
		icon_state = "tigerhead"
		body_parts = list(BP_HEAD)

	tigerface
		name = "Tiger Stripes (Head, Major)"
		icon_state = "tigerface"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ) //There's a tattoo for non-cats

	backstripe
		name = "Back Stripe"
		icon_state = "backstripe"
		body_parts = list(BP_TORSO)

	heterochromia
		name = "Heterochromia (right eye)"
		icon_state = "heterochromia"
		body_parts = list(BP_HEAD)

	//Taj specific stuff
	taj_belly
		name = "Belly Fur (Taj)"
		icon_state = "taj_belly"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_TAJ)

	taj_bellyfull
		name = "Belly Fur Wide (Taj)"
		icon_state = "taj_bellyfull"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_TAJ)

	taj_earsout
		name = "Outer Ear (Taj)"
		icon_state = "taj_earsout"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_earsin
		name = "Inner Ear (Taj)"
		icon_state = "taj_earsin"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_nose
		name = "Nose Color (Taj)"
		icon_state = "taj_nose"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_crest
		name = "Chest Fur Crest (Taj)"
		icon_state = "taj_crest"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_TAJ)

	taj_muzzle
		name = "Muzzle Color (Taj)"
		icon_state = "taj_muzzle"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_face
		name = "Cheeks Color (Taj)"
		icon_state = "taj_face"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	taj_all
		name = "All Taj Head (Taj)"
		icon_state = "taj_all"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TAJ)

	//Una specific stuff
	una_face
		name = "Face Color (Una)"
		icon_state = "una_face"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_UNATHI)

	una_facelow
		name = "Face Color Low (Una)"
		icon_state = "una_facelow"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_UNATHI)

	una_scutes
		name = "Scutes (Una)"
		icon_state = "una_scutes"
		body_parts = list(BP_TORSO)
		species_allowed = list(SPECIES_UNATHI)

	//Tesh stuff.

	teshi_heterochromia
		name = "Teshari Heterochromia"
		icon_state = "teshi_heterochromia"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TESHARI)

	//Vox stuff

	vox_coloration
		name = "Vox Two Tone"
		icon_state = "vox_two_tone"
		body_parts = list(BP_HEAD,BP_L_HAND,BP_R_HAND,BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM)
		species_allowed = list(SPECIES_VOX)

/datum/sprite_accessory/marking/vr
	icon = 'icons/mob/human_races/markings_vr.dmi'

	vulp_belly
		name = "belly fur (Vulp)"
		icon_state = "vulp_belly"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO,BP_GROIN)

	vulp_fullbelly
		name = "full belly fur (Vulp)"
		icon_state = "vulp_fullbelly"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO,BP_GROIN)

	vulp_crest
		name = "belly crest (Vulp)"
		icon_state = "vulp_crest"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO,BP_GROIN)

	vulp_nose
		name = "nose (Vulp)"
		icon_state = "vulp_nose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_short_nose
		name = "nose, short (Vulp)"
		icon_state = "vulp_short_nose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	snoutstripe
		name = "snout stripe (Vulp)"
		icon_state = "snoutstripe"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_face
		name = "face (Vulp)"
		icon_state = "vulp_face"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_facealt
		name = "face, alt. (Vulp)"
		icon_state = "vulp_facealt"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_earsface
		name = "ears and face (Vulp)"
		icon_state = "vulp_earsface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_all
		name = "all head highlights (Vulp)"
		icon_state = "vulp_all"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	sergal_full
		name = "Sergal Markings"
		icon_state = "sergal_full"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
		species_allowed = list("Sergal")

	sergal_full_female
		name = "Sergal Markings (Female)"
		icon_state = "sergal_full_female"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
		species_allowed = list("Sergal")

	monoeye
		name = "Monoeye"
		icon_state = "monoeye"
		body_parts = list(BP_HEAD)

	spidereyes
		name = "Spider Eyes"
		icon_state = "spidereyes"
		body_parts = list(BP_HEAD)

	sergaleyes
		name = "Sergal Eyes"
		icon_state = "eyes_sergal"
		body_parts = list(BP_HEAD)

	brows
		name = "Eyebrows"
		icon_state = "brows"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	nevrean_female
		name = "Female Nevrean beak"
		icon_state = "nevrean_f"
		body_parts = list(BP_HEAD)
		color_blend_mode = ICON_MULTIPLY
		gender = FEMALE

	nevrean_male
		name = "Male Nevrean beak"
		icon_state = "nevrean_m"
		body_parts = list(BP_HEAD)
		color_blend_mode = ICON_MULTIPLY
		gender = MALE

	spots
		name = "Spots"
		icon_state = "spots"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

	shaggy_mane
		name = "Shaggy mane/feathers"
		icon_state = "shaggy"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO)

	jagged_teeth
		name = "Jagged teeth"
		icon_state = "jagged"
		body_parts = list(BP_HEAD)

	blank_face
		name = "Blank round face (use with monster mouth)"
		icon_state = "blankface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	monster_mouth
		name = "Monster mouth"
		icon_state = "monster"
		body_parts = list(BP_HEAD)

	saber_teeth
		name = "Saber teeth"
		icon_state = "saber"
		body_parts = list(BP_HEAD)

	fangs
		name = "Fangs"
		icon_state = "fangs"
		body_parts = list(BP_HEAD)

	tusks
		name = "Tusks"
		icon_state = "tusks"
		body_parts = list(BP_HEAD)

	otie_face
		name = "Otie face"
		icon_state = "otieface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	otie_nose
		name = "Otie nose"
		icon_state = "otie_nose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	otienose_lite
		name = "Short otie nose"
		icon_state = "otienose_lite"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	backstripes
		name = "Back stripes"
		icon_state = "otiestripes"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO,BP_HEAD)

	belly_butt
		name = "Belly and butt"
		icon_state = "bellyandbutt"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_GROIN,BP_TORSO)

	fingers_toes
		name = "Fingers and toes"
		icon_state = "fingerstoes"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

	otie_socks
		name = "Fingerless socks"
		icon_state = "otiesocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

	corvid_beak
		name = "Corvid beak"
		icon_state = "corvidbeak"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	corvid_belly
		name = "Corvid belly"
		icon_state = "corvidbelly"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_GROIN,BP_TORSO,BP_HEAD)

	cow_body
		name = "Cow markings"
		icon_state = "cowbody"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

	cow_nose
		name = "Cow nose"
		icon_state = "cownose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	zmask
		name = "Eye mask"
		icon_state = "zmask"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	zbody
		name = "Thick jagged stripes"
		icon_state = "zbody"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_TORSO)

	znose
		name = "Jagged snout"
		icon_state = "znose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	otter_nose
		name = "Otter nose"
		icon_state = "otternose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	otter_face
		name = "Otter face"
		icon_state = "otterface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	deer_face
		name = "Deer face"
		icon_state = "deerface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	sharkface
		name = "Akula snout"
		icon_state = "sharkface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	sheppy_face
		name = "Shepherd snout"
		icon_state = "shepface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	sheppy_back
		name = "Shepherd back"
		icon_state = "shepback"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO,BP_GROIN)

	zorren_belly_male
		name = "Zorren Male Torso"
		icon_state = "zorren_belly"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO,BP_GROIN)

	zorren_belly_female
		name = "Zorren Female Torso"
		icon_state = "zorren_belly_female"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO,BP_GROIN)

	zorren_back_patch
		name = "Zorren Back Patch"
		icon_state = "zorren_backpatch"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO)

	zorren_face_male
		name = "Zorren Male Face"
		icon_state = "zorren_face"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		gender = MALE

	zorren_face_female
		name = "Zorren Female Face"
		icon_state = "zorren_face_female"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		gender = FEMALE

	zorren_muzzle_male
		name = "Zorren Male Muzzle"
		icon_state = "zorren_muzzle"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		gender = MALE

	zorren_muzzle_female
		name = "Zorren Female Muzzle"
		icon_state = "zorren_muzzle_female"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		gender = FEMALE

	zorren_socks
		name = "Zorren Socks"
		icon_state = "zorren_socks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

	zorren_longsocks
		name = "Zorren Longsocks"
		icon_state = "zorren_longsocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

	tesh_feathers
		name = "Teshari Feathers"
		icon_state = "tesh-feathers"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

	harpy_feathers
		name = "Rapala leg Feather"
		icon_state = "harpy-feathers"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG)

	harpy_legs
		name = "Rapala leg coloring"
		icon_state = "harpy-leg"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

	chooves
		name = "Cloven hooves"
		icon_state = "chooves"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT)

	alurane
		name = "Alraune Body"
		icon_state = "alurane"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

	body_tone
		name = "Body toning (for emergency contrast loss)"
		icon_state = "btone"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

	gloss
		name = "Full body gloss"
		icon_state = "gloss"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

	eboop_panels
		name = "Eggnerd FBP panels"
		icon_state = "eboop"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

	osocks_rarm
		name = "Modular Longsock (right arm)"
		icon_state = "osocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_R_ARM,BP_R_HAND)

	osocks_larm
		name = "Modular Longsock (left arm)"
		icon_state = "osocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_ARM,BP_L_HAND)

	osocks_rleg
		name = "Modular Longsock (right leg)"
		icon_state = "osocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_R_FOOT,BP_R_LEG)

	osocks_lleg
		name = "Modular Longsock (left leg)"
		icon_state = "osocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_L_LEG)

	animeeyesinner
		name = "Anime Eyes Inner"
		icon_state = "animeeyesinner"
		body_parts = list(BP_HEAD)

	animeeyesouter
		name = "Anime Eyes Outer"
		icon_state = "animeeyesouter"
		body_parts = list(BP_HEAD)

	panda_eye_marks
		name = "Panda Eye Markings"
		icon_state = "eyes_panda"
		body_parts = list(BP_HEAD)
		species_allowed = list("Human")

	catwomantorso
		name = "Catwoman chest stripes"
		icon_state = "catwomanchest"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_TORSO)

	catwomangroin
		name = "Catwoman groin stripes"
		icon_state = "catwomangroin"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_GROIN)

	catwoman_rleg
		name = "Catwoman right leg stripes"
		icon_state = "catwomanright"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_R_LEG)

	catwoman_lleg
		name = "Catwoman left leg stripes"
		icon_state = "catwomanleft"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG)

	teshi_fluff
		name = "Teshari underfluff"
		icon_state = "teshi_fluff"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_GROIN,BP_TORSO,BP_HEAD)

	teshi_small_feathers
		name = "Teshari small wingfeathers"
		icon_state = "teshi_sf"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND,BP_TORSO)

	spirit_lights
		name = "Ward - Spirit FBP Lights"
		icon_state = "lights"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_HEAD)

	spirit_lights_body
		name = "Ward - Spirit FBP Lights (body)"
		icon_state = "lights"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO)

	spirit_lights_head
		name = "Ward - Spirit FBP Lights (head)"
		icon_state = "lights"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	spirit_panels
		name = "Ward - Spirit FBP Panels"
		icon_state = "panels"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

	spirit_panels_body
		name = "Ward - Spirit FBP Panels (body)"
		icon_state = "panels"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

	spirit_panels_head
		name = "Ward - Spirit FBP Panels (head)"
		icon_state = "panels"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	tentacle_head
		name = "Squid Head"
		icon_state = "tentaclehead"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	tentacle_mouth
		name = "Tentacle Mouth"
		icon_state = "tentaclemouth"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	rosette
		name = "Rosettes"
		icon_state = "rosette"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

	heterochromia
		name = "Heterochromia"
		icon_state = "heterochromia"
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN) //This lets all races use the default hairstyles.

	werewolf_nose
		name = "Werewolf nose"
		icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
		icon_state = "werewolf_nose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_WEREBEAST)

	werewolf_face
		name = "Werewolf face"
		icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
		icon_state = "werewolf"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_WEREBEAST)

	werewolf_belly
		name = "Werewolf belly"
		icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
		icon_state = "werewolf"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_GROIN,BP_TORSO)
		species_allowed = list(SPECIES_WEREBEAST)

	werewolf_socks
		name = "Werewolf socks"
		icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
		icon_state = "werewolf"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
		species_allowed = list(SPECIES_WEREBEAST)

	shadekin_snoot
		name = "Shadekin Snoot"
		icon_state = "shadekin-snoot"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_SHADEKIN)

	taj_nose_alt
		name = "Nose Color, alt. (Taj)"
		icon_state = "taj_nosealt"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	talons
		name = "Talons"
		icon_state = "talons"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

	claws
		name = "Claws"
		icon_state = "claws"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_HAND,BP_R_HAND)

	equine_snout //Why the long face? Works best with sergal bodytype.
		name = "Equine Snout"
		icon_state = "donkey"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	equine_nose
		name = "Equine Nose"
		icon_state = "dnose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	teshari_large_eyes
		name = "Teshari large eyes"
		icon_state = "teshlarge_eyes"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		species_allowed = list(SPECIES_TESHARI)

	teshari_coat
		name = "Teshari coat"
		icon_state = "tesh_coat"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_HEAD)
		species_allowed = list(SPECIES_TESHARI)

	teshari_pattern_male
		name = "Teshari male pattern"
		icon_state = "tesh-pattern-male"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
		species_allowed = list(SPECIES_TESHARI)

	teshari_pattern_female
		name = "Teshari female pattern"
		icon_state = "tesh-pattern-fem"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
		species_allowed = list(SPECIES_TESHARI)

//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now
/datum/sprite_accessory/skin
	icon = 'icons/mob/human_races/r_human.dmi'

	human
		name = "Default human skin"
		icon_state = "default"
		species_allowed = list(SPECIES_HUMAN,SPECIES_HUMAN_VATBORN)

	human_tatt01
		name = "Tatt01 human skin"
		icon_state = "tatt1"
		species_allowed = list(SPECIES_HUMAN,SPECIES_HUMAN_VATBORN)

	tajaran
		name = "Default tajaran skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_tajaran.dmi'
		species_allowed = list(SPECIES_TAJ)

	unathi
		name = "Default Unathi skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_lizard.dmi'
		species_allowed = list(SPECIES_UNATHI)

	skrell
		name = "Default skrell skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_skrell.dmi'
		species_allowed = list(SPECIES_SKRELL)
