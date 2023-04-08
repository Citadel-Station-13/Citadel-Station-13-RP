/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair
	abstract_type = /datum/sprite_accessory/hair
	icon = 'icons/mob/human_face_m.dmi'	  // default icon for all hairs
	var/icon_add = 'icons/mob/human_face.dmi'
	//Enhanced colours and hair for all
	color_blend_mode = ICON_MULTIPLY
	apply_restrictions = FALSE
	var/hair_flags

/datum/sprite_accessory/hair/eighties
	name = "80's"
	id = "hair_80s"
	icon_state = "hair_80s"

/datum/sprite_accessory/hair/fluffyshort
	name = "Fluffy Short"
	id = "hair_fluffyshort"
	icon_state = "hair_fluffy_short"

/datum/sprite_accessory/hair/eighties_alt
	name = "80's (Alternative)"
	id = "hair_80s_alt"
	icon_state = "hair_80s_alt"

/datum/sprite_accessory/hair/afro
	name = "Afro"
	id = "hair_afro"
	icon_state = "hair_afro"

/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	id = "hair_afro2"
	icon_state = "hair_afro2"

/datum/sprite_accessory/hair/afro_large
	name = "Big Afro"
	id = "hair_afro_big"
	icon_state = "hair_bigafro"

/datum/sprite_accessory/hair/ahoge
	name = "Ahoge"
	id = "hair_ahoge"
	icon_state = "hair_ahoge"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = null

/datum/sprite_accessory/hair/bald //Everyone goes bald.
	name = "Bald"
	id = "hair_bald"
	icon_state = "bald"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/baldfade
	name = "Balding Fade"
	id = "hair_balding_fade"
	icon_state = "hair_baldfade"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/balding
	name = "Balding Hair"
	id = "hair_balding"
	icon_state = "hair_e"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/bedhead
	name = "Bedhead"
	id = "hair_bedhead"
	icon_state = "hair_bedhead"

/datum/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	id = "hair_bedhead2"
	icon_state = "hair_bedheadv2"

/datum/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	id = "hair_bedhead3"
	icon_state = "hair_bedheadv3"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bedheadlong
	name = "Bedhead Long"
	id = "hair_bedhead_long"
	icon_state = "hair_long_bedhead"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bedheadlongest
	name = "Bedhead Concerning"
	id = "hair_bedhead_longest"
	icon_state = "hair_longest_bedhead"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	id = "hair_beehive"
	icon_state = "hair_beehive"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	id = "hair_beehive2"
	icon_state = "hair_beehive2"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/belenko
	name = "Belenko"
	id = "hair_balenko"
	icon_state = "hair_belenko"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/belenkotied
	name = "Belenko Tied"
	id = "hair_balenko_tied"
	icon_state = "hair_belenkotied"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bob
	name = "Bob"
	id = "hair_bob"
	icon_state = "hair_bobcut"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bobcutalt
	name = "Bob Chin Length"
	id = "hair_bob_chin"
	icon_state = "hair_bobcutalt"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	id = "hair_bob_curl"
	icon_state = "hair_bobcurl"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bowl
	name = "Bowl"
	id = "hair_bowlcut"
	icon_state = "hair_bowlcut"

/datum/sprite_accessory/hair/bowlcut2
	name = "Bowl 2"
	id = "hair_bowlcut2"
	icon_state = "hair_bowlcut2"

/datum/sprite_accessory/hair/grandebraid
	name = "Braid Grande"
	id = "hair_braid_grande"
	icon_state = "hair_grande"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/braid2
	name = "Braid Long"
	id = "hair_braid_long"
	icon_state = "hair_hbraid"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/mbraid
	name = "Braid Medium"
	id = "hair_braid_medium"
	icon_state = "hair_shortbraid"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	id = "hair_braid_floorlength"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_braid"

/datum/sprite_accessory/hair/bun
	name = "Bun"
	id = "hair_bun"
	icon_state = "hair_bun"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bun2
	name = "Bun 2"
	id = "hair_bun2"
	icon_state = "hair_bun2"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bun3
	name = "Bun 3"
	id = "hair_bun3"
	icon_state = "hair_bun3"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bun
	name = "Bun Casual"
	id = "hair_bun_casual"
	icon_state = "hair_bun"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/doublebun
	name = "Bun Double"
	id = "hair_bun_double"
	icon_state = "hair_doublebun"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/tightbun
	name = "Bun Tight"
	id = "hair_bun_tight"
	icon_state = "hair_tightbun"
	gender = FEMALE
	hair_flags = HAIR_VERY_SHORT | HAIR_TIEABLE

/datum/sprite_accessory/hair/buzz
	name = "Buzzcut"
	id = "hair_buzzcut"
	icon_state = "hair_buzzcut"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/crono
	name = "Chrono"
	id = "hair_chrono"
	icon_state = "hair_toriyama"

/datum/sprite_accessory/hair/cia
	name = "CIA"
	id = "hair_cia"
	icon_state = "hair_cia"

/datum/sprite_accessory/hair/coffeehouse
	name = "Coffee House Cut"
	id = "hair_coffeehouse"
	icon_state = "hair_coffeehouse"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/combover
	name = "Combover"
	id = "hair_combover"
	icon_state = "hair_combover"

/datum/sprite_accessory/hair/country
	name = "Country"
	id = "hair_country"
	icon_state = "hair_country"

/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	id = "hair_crewcut"
	icon_state = "hair_crewcut"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/curls
	name = "Curls"
	id = "hair_curls"
	icon_state = "hair_curls"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	id = "hair_cut"
	icon_state = "hair_c"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/dave
	name = "Dave"
	id = "hair_dave"
	icon_state = "hair_dave"

/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	id = "hair_devillock"
	icon_state = "hair_devilock"

/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	id = "hair_dreadlocks"
	icon_state = "hair_dreads"

/datum/sprite_accessory/hair/mahdrills
	name = "Drillruru"
	id = "hair_drillruru"
	icon_state = "hair_drillruru"

/datum/sprite_accessory/hair/emo
	name = "Emo"
	id = "hair_emo"
	icon_state = "hair_emo"

/datum/sprite_accessory/hair/emo2
	name = "Emo Alt"
	id = "hair_emo_alt"
	icon_state = "hair_emo2"

/datum/sprite_accessory/hair/fringeemo
	name = "Emo Fringe"
	id = "hair_emo_fringe"
	icon_state = "hair_emofringe"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/halfshaved
	name = "Emo Half-Shaved"
	id = "hair_emo_halfshave"
	icon_state = "hair_halfshaved"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longemo
	name = "Emo Long"
	id = "hair_emo_long"
	icon_state = "hair_emolong"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/highfade
	name = "Fade High"
	id = "hair_fade_high"
	icon_state = "hair_highfade"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/medfade
	name = "Fade Medium"
	id = "hair_fade_medium"
	icon_state = "hair_medfade"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/lowfade
	name = "Fade Low"
	id = "hair_fade_low"
	icon_state = "hair_lowfade"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/partfade
	name = "Fade Parted"
	id = "hair_fade_parted"
	icon_state = "hair_shavedpart"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/familyman
	name = "Family Man"
	id = "hair_familyman"
	icon_state = "hair_thefamilyman"

/datum/sprite_accessory/hair/father
	name = "Father"
	id = "hair_father"
	icon_state = "hair_father"

/datum/sprite_accessory/hair/feather
	name = "Feather"
	id = "hair_feather"
	icon_state = "hair_feather"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/flair
	name = "Flaired Hair"
	id = "hair_flair"
	icon_state = "hair_flair"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sargeant
	name = "Flat Top"
	id = "hair_sargeant"
	icon_state = "hair_sargeant"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/flowhair
	name = "Flow Hair"
	id = "hair_flow"
	icon_state = "hair_f"

/datum/sprite_accessory/hair/longfringe
	name = "Fringe Long"
	id = "hair_fringe_long"
	icon_state = "hair_longfringe"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longestalt
	name = "Fringe Longer"
	id = "hair_fringe_verylong"
	icon_state = "hair_vlongfringe"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/fringetail
	name = "Fringetail"
	id = "hair_fringe_tail"
	icon_state = "hair_fringetail"
	hair_flags = HAIR_TIEABLE|HAIR_VERY_SHORT

/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	id = "hair_gelled"
	icon_state = "hair_gelled"

/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	id = "hair_gentle"
	icon_state = "hair_gentle"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/glossy
	name = "Glossy"
	id = "hair_glossy"
	icon_state = "hair_glossy"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	id = "hair_halfbang"
	icon_state = "hair_halfbang"

/datum/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair Alt"
	id = "hair_halfbang_alt"
	icon_state = "hair_halfbang_alt"

/datum/sprite_accessory/hair/hedgehog
	name = "Hedgehog Hair"
	id = "hair_hedgehog"
	icon_state = "hair_hedgehog"
	icon_add = null

/datum/sprite_accessory/hair/hightight
	name = "High and Tight"
	id = "hair_hightight"
	icon_state = "hair_hightight"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	id = "hair_hime"
	icon_state = "hair_himecut"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/shorthime
	name = "Hime Cut Short"
	id = "hair_hime_short"
	icon_state = "hair_shorthime"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	id = "hair_hitop"
	icon_state = "hair_hitop"

/datum/sprite_accessory/hair/jade
	name = "Jade"
	id = "hair_jade"
	icon_state = "hair_jade"

/datum/sprite_accessory/hair/jensen
	name = "Jensen"
	id = "hair_jensen"
	icon_state = "hair_jensen"

/datum/sprite_accessory/hair/joestar
	name = "Joestar"
	id = "hair_joestar"
	icon_state = "hair_joestar"

/datum/sprite_accessory/hair/kagami
	name = "Kagami"
	id = "hair_kagami"
	icon_state = "hair_kagami"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	id = "hair_kusanagi"
	icon_state = "hair_kusanagi"

/datum/sprite_accessory/hair/long
	name = "Long Hair Shoulder-length"
	id = "hair_long_shoulder"
	icon_state = "hair_b"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longer
	name = "Long Hair"
	id = "hair_long"
	icon_state = "hair_vlong"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longeralt2
	name = "Long Hair Alt 2"
	id = "hair_long_alt"
	icon_state = "hair_longeralt2"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longest
	name = "Very Long Hair"
	id = "hair_verylong"
	icon_state = "hair_longest"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/manbun
	name = "Manbun"
	id = "hair_manbun"
	icon_state = "hair_manbun"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/modern
	name = "Modern"
	id = "hair_modern"
	icon_state = "hair_modern"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	id = "hair_mohawk"
	icon_state = "hair_d"

/datum/sprite_accessory/hair/regulationmohawk
	name = "Mohawk Regulation"
	id = "hair_mohawk_regulation"
	icon_state = "hair_shavedmohawk"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/reversemohawk
	name = "Mohawk Reverse"
	id = "hair_mohawk_reverse"
	icon_state = "hair_reversemohawk"

/datum/sprite_accessory/hair/messy
	name = "Messy"
	id = "hair_messy"
	icon_state = "hair_messy_tg"
	icon_add = null

/datum/sprite_accessory/hair/mohawkunshaven
	name = "Mohawk Unshaven"
	id = "hair_mohawk_unshaven"
	icon_state = "hair_unshaven_mohawk"

/datum/sprite_accessory/hair/mulder
	name = "Mulder"
	id = "hair_mulder"
	icon_state = "hair_mulder"

/datum/sprite_accessory/hair/newyou
	name = "New You"
	id = "hair_newyou"
	icon_state = "hair_newyou"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/nia
	name = "Nia"
	id = "hair_nia"
	icon_state = "hair_nia"

/datum/sprite_accessory/hair/nitori
	name = "Nitori"
	id = "hair_nitori"
	icon_state = "hair_nitori"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/odango
	name = "Odango"
	id = "hair_odango"
	icon_state = "hair_odango"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	id = "hair_ombre"
	icon_state = "hair_ombre"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/oxton
	name = "Oxton"
	id = "hair_oxton"
	icon_state = "hair_oxton"

/datum/sprite_accessory/hair/longovereye
	name = "Overeye Long"
	id = "hair_overeye_long"
	icon_state = "hair_longovereye"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/shortovereye
	name = "Overeye Short"
	id = "hair_overeye_short"
	icon_state = "hair_shortovereye"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/veryshortovereyealternate
	name = "Overeye Very Short, Alternate"
	id = "hair_overeye_veryshort_alt"
	icon_state = "hair_veryshortovereyealternate"

/datum/sprite_accessory/hair/veryshortovereye
	name = "Overeye Very Short"
	id = "hair_overeye_veryshort"
	icon_state = "hair_veryshortovereye"

/datum/sprite_accessory/hair/parted
	name = "Parted"
	id = "hair_parted"
	icon_state = "hair_parted"

/datum/sprite_accessory/hair/partedalt
	name = "Parted Alt"
	id = "hair_parted_alt"
	icon_state = "hair_partedalt"

/datum/sprite_accessory/hair/pixie
	name = "Pixie"
	id = "hair_pixie"
	icon_state = "hair_pixie"

/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	id = "hair_pompadour"
	icon_state = "hair_pompadour"

/datum/sprite_accessory/hair/dandypomp
	name = "Pompadour Dandy"
	id = "hair_pompadour_dandy"
	icon_state = "hair_dandypompadour"

/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail 1"
	id = "hair_ponytail"
	icon_state = "hair_ponytail"
	hair_flags = HAIR_TIEABLE|HAIR_VERY_SHORT

/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	id = "hair_ponytail2"
	icon_state = "hair_pa"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	id = "hair_ponytail3"
	icon_state = "hair_ponytail3"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	id = "hair_ponytail4"
	icon_state = "hair_ponytail4"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail5
	name = "Ponytail 5"
	id = "hair_ponytail5"
	icon_state = "hair_ponytail5"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail6
	name = "Ponytail 6"
	id = "hair_ponytail6"
	icon_state = "hair_ponytail6"
	hair_flags = HAIR_TIEABLE|HAIR_VERY_SHORT

/datum/sprite_accessory/hair/ponytail6_fixed //Eggnerd's done with waiting for upstream fixes lmao.
	name = "Ponytail 6 but fixed"
	id = "hair_ponytail6_alt"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_ponytail6"

/datum/sprite_accessory/hair/sharpponytail
	name = "Ponytail Sharp"
	id = "hair_ponytail_sharp"
	icon_state = "hair_sharpponytail"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/spikyponytail
	name = "Ponytail Spiky"
	id = "hair_ponytail_spiky"
	icon_state = "hair_spikyponytail"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/highponytail
	name = "High Ponytail"
	id = "hair_ponytail_high"
	icon_state = "hair_highponytail"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/poofy
	name = "Poofy"
	id = "hair_poofy"
	icon_state = "hair_poofy"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/poofy2
	name = "Poofy 2"
	id = "hair_poofy2"
	icon_state = "hair_poofy2"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	id = "hair_quiff"
	icon_state = "hair_quiff"

/datum/sprite_accessory/hair/nofade
	name = "Regulation Cut"
	id = "hair_regulation"
	icon_state = "hair_nofade"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/ronin
	name = "Ronin"
	id = "hair_ronin"
	icon_state = "hair_ronin"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rosa
	name = "Rosa"
	id = "hair_rosa"
	icon_state = "hair_rosa"

/datum/sprite_accessory/hair/rows
	name = "Rows"
	id = "hair_row"
	icon_state = "hair_rows1"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/rows2
	name = "Rows 2"
	id = "hair_row2"
	icon_state = "hair_rows2"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rowbun
	name = "Row Bun"
	id = "hair_row_bun"
	icon_state = "hair_rowbun"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rowdualbraid
	name = "Row Dual Braid"
	id = "hair_row_braid_dual"
	icon_state = "hair_rowdualtail"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rowbraid
	name = "Row Braid"
	id = "hair_row_braid"
	icon_state = "hair_rowbraid"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sabitsuki
	name = "Sabitsuki"
	id = "hair_sabitsuki"
	icon_state = "hair_sabitsuki"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/scully
	name = "Scully"
	id = "hair_scully"
	icon_state = "hair_scully"

/datum/sprite_accessory/hair/shavehair
	name = "Shaved Hair"
	id = "hair_shaved"
	icon_state = "hair_shaved"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/shortbangs
	name = "Short Bangs"
	id = "hair_bangs_short"
	icon_state = "hair_shortbangs"

/datum/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	id = "hair_short"
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/short2
	name = "Short Hair 2"
	id = "hair_short2"
	icon_state = "hair_shorthair3"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/shortalt2
	name = "Short Hair 2 Alt"
	id = "hair_short2_alt"
	icon_state = "shorthair3a"
	hair_flags = HAIR_VERY_SHORT
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'

/datum/sprite_accessory/hair/short3
	name = "Short Hair 3"
	id = "hair_short3"
	icon_state = "hair_shorthair4"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/shy
	name = "Shy"
	id = "hair_fluttershy"	// let's be brutally honest about what htis is
	icon_state = "hair_shy"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail
	name = "Side Ponytail"
	id = "hair_ponytail_side"
	icon_state = "hair_stail"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail4 //Not happy about this... but it's for the save files.
	name = "Side Ponytail 2"
	id = "hair_ponytail_side2"
	icon_state = "hair_ponytailf"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail2
	name = "Shoulder One"
	id = "hair_shoulder_one"
	icon_state = "hair_oneshoulder"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail3
	name = "Shoulder Tress"
	id = "hair_shoulder_tress"
	icon_state = "hair_tressshoulder"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	id = "hair_skinhead"
	icon_state = "hair_skinhead"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/sleeze
	name = "Sleeze"
	id = "hair_sleaze"
	icon_state = "hair_sleeze"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	id = "hair_spiky"
	icon_state = "hair_spikey"

/datum/sprite_accessory/hair/thinning
	name = "Thinning"
	id = "hair_thinning"
	icon_state = "hair_thinning"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	id = "hair_thinning_front"
	icon_state = "hair_thinningfront"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/thinningback
	name = "Thinning Back"
	id = "hair_thinning_back"
	icon_state = "hair_thinningrear"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/topknot
	name = "Topknot"
	id = "hair_topknot"
	icon_state = "hair_topknot"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/trimflat
	name = "Trimmed Flat Top"
	id = "hair_trimmed_flat"
	icon_state = "hair_trimflat"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/jade
	name = "Jade"
	id = "hair_jade"
	icon_state = "hair_jade"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/trimmed
	name = "Trimmed"
	id = "hair_trimmed"
	icon_state = "hair_trimmed"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/twintai1
	name = "Twintail"
	id = "hair_twintails"
	icon_state = "hair_twintail"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/twintail2
	name = "Twintail Short"
	id = "hair_twintails_short"
	icon_state = "hair_twintailshort"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/undercut1
	name = "Undercut"
	id = "hair_undercut"
	icon_state = "hair_undercut1"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/undercut2
	name = "Undercut Swept Right"
	id = "hair_undercut_right"
	icon_state = "hair_undercut2"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/undercut3
	name = "Undercut Swept Left"
	id = "hair_undercut_left"
	icon_state = "hair_undercut3"
	gender = MALE
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/undercutlong
	name = "Undercut Long"
	id = "hair_undercut_long"
	icon_state = "hair_undercutlong"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/unkept
	name = "Unkept"
	id = "hair_upkept"
	icon_state = "hair_unkept"

/datum/sprite_accessory/hair/updo
	name = "Updo"
	id = "hair_updo"
	icon_state = "hair_updo"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/vegeta
	name = "Vegeta"
	id = "hair_vegeta"
	icon_state = "hair_toriyama2"

/datum/sprite_accessory/hair/volaju
	name = "Volaju"
	id = "hair_volaju"
	icon_state = "hair_volaju"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/wisp
	name = "Wisp"
	id = "hair_wisp"
	icon_state = "hair_wisp"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/zieglertail
	name = "Zieglertail"
	id = "hair_ziegler"
	icon_state = "hair_ziegler"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/glossy
	name = "Glossy"
	id = "hair_glossy"
	icon_state = "hair_glossy"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sharpponytail
	name = "Ponytail Sharp"
	id = "hair_ponytail_sharp"
	icon_state = "hair_sharpponytail"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/partedalt
	name = "Parted Alt"
	id = "hair_parted2"
	icon_state = "hair_partedalt"

/datum/sprite_accessory/hair/amazon
	name = "Amazon"
	id = "hair_amazon"
	icon_state = "hair_amazon"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/straightlong
	name = "Straight Long"
	id = "hair_long_straight"
	icon_state = "hair_straightlong"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/marysue
	name = "Mary Sue"
	id = "hair_marysue"
	icon_state = "hair_marysue"

/datum/sprite_accessory/hair/sideundercut
	name = "Side Undercut"
	id = "hair_undercut_side"
	icon_state = "hair_sideundercut"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/donutbun
	name = "Donut Bun"
	id = "hair_bun_donut"
	icon_state = "hair_donutbun"

/datum/sprite_accessory/hair/gentle2
	name = "Gentle 2, Long"
	id = "hair_gentle2"
	icon_state = "hair_gentle2long"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sweepshave
	name = "Sweep Shave"
	id = "hair_sweepshave"
	icon_state = "hair_sweepshave"

/datum/sprite_accessory/hair/beachwave
	name = "Beach Waves"
	id = "hair_beachwave"
	icon_state = "hair_beachwave"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/celebcurls
	name = "Celeb Curls"
	id = "hair_curls_celeb"
	icon_state = "hair_celebcurls"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bigcurls
	name = "Big Curls"
	id = "hair_curls_big"
	icon_state = "hair_bigcurls"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/jessica
	name = "Jessica"
	id = "hair_jessica"
	icon_state = "hair_jessica"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/proper
	name = "Proper"
	id = "hair_proper"
	icon_state = "hair_proper"

/datum/sprite_accessory/hair/himeup
	name = "Hime Updo"
	id = "hair_hime_updo"
	icon_state = "hair_himeup"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/front_braid
	name = "Braided front"
	id = "hair_braid_front"
	icon_state = "hair_braidfront"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/antenna
	name = "Antenna"
	id = "hair_antenna"
	icon_state = "hair_antenna"

/datum/sprite_accessory/hair/protagonist
	name = "Slightly Long"
	id = "hair_protagonist"
	icon_state = "hair_protagonist"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/braidtail
	name = "Braided Tail"
	id = "hair_braid_tail"
	icon_state = "hair_braidtail"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/business
	name = "Business Hair"
	id = "hair_business"
	icon_state = "hair_business"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/business3
	name = "Business Hair 3"
	id = "hair_business3"
	icon_state = "hair_business3"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/business4
	name = "Business Hair 4"
	id = "hair_business4"
	icon_state = "hair_business4"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/sidepartlongalt
	name = "Long Side Part"
	id = "hair_sidepart_long"
	icon_state = "hair_longsidepart"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/miles
	name = "Miles Hair"
	id = "hair_miles"
	icon_state = "hair_miles"

/datum/sprite_accessory/hair/vivi
	name = "Vivi"
	id = "hair_vivi"
	icon_state = "hair_vivi"

/datum/sprite_accessory/hair/taro
	name = "Taro"
	id = "hair_taro"
	icon_state = "hair_taro"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/judge
	name = "Judge"
	id = "hair_judge"
	icon_state = "hair_judge"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/mia
	name = "Mia"
	id = "hair_mia"
	icon_state = "hair_mia"

/datum/sprite_accessory/hair/elize
	name = "Elize"
	id = "hair_elize"
	icon_state = "hair_elize"

/datum/sprite_accessory/hair/longbraid
	name = "Long Braid"
	id = "hair_longbraid"
	icon_state = "hair_longbraid"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/emoright
	name = "Emo Right"
	id = "hair_emoright"
	icon_state = "hair_emoright"

/datum/sprite_accessory/hair/aradia
	name = "Aradia"
	id = "hair_aradia"
	icon_state = "hair_aradia"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/dirk
	name = "Dirk"
	id = "hair_dirk"
	icon_state = "hair_dirk"

/datum/sprite_accessory/hair/equius
	name = "Equius"
	id = "hair_equius"
	icon_state = "hair_equius"

/datum/sprite_accessory/hair/feferi
	name = "Feferi"
	id = "hair_feferi"
	icon_state = "hair_feferi"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/gamzee
	name = "Gamzee"
	id = "hair_gamzee"
	icon_state = "hair_gamzee"

/datum/sprite_accessory/hair/kanaya
	name = "Kanaya"
	id = "hair_kanaya"
	icon_state = "hair_kanaya"

/datum/sprite_accessory/hair/nepeta
	name = "Nepeta"
	id = "hair_nepeta"
	icon_state = "hair_nepeta"

/datum/sprite_accessory/hair/rose
	name = "Rose"
	id = "hair_rose"
	icon_state = "hair_rose"

/datum/sprite_accessory/hair/roxy
	name = "Roxy"
	id = "hair_roxy"
	icon_state = "hair_roxy"

/datum/sprite_accessory/hair/terezi
	name = "Terezi"
	id = "hair_terezi"
	icon_state = "hair_terezi"

/datum/sprite_accessory/hair/vriska
	name = "Vriska"
	id = "hair_vriska"
	icon_state = "hair_vriska"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/flipped
	name = "Flipped"
	id = "hair_flipped"
	icon_state = "hair_flipped"

/datum/sprite_accessory/hair/darcy
	name = "Darcy"
	id = "hair_darcy"
	icon_state = "hair_darcy"

/datum/sprite_accessory/hair/antonio
	name = "Antonio"
	id = "hair_antonio"
	icon_state = "hair_antonio"

/datum/sprite_accessory/hair/sweptfringe
	name = "Swept Fringe"
	id = "hair_sweptfringe"
	icon_state = "hair_sweptfringe"

/datum/sprite_accessory/hair/mialong
	name = "Mia Long"
	id = "hair_mialong"
	icon_state = "hair_mialong"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/dreadslong
	name = "Long Dreadlocks"
	id = "hair_dreadslong"
	icon_state = "hair_dreadslong"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/jeanponytail
	name = "Jean Ponytail"
	id = "hair_jeanponytail"
	icon_state = "hair_jeanponytail"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/shouldersweep
	name = "Shoulder Swept"
	id = "hair_shouldersweep"
	icon_state = "hair_shouldersweep"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/afropuffdouble
	name = "Afropuff"
	id = "hair_afropuffdouble"
	icon_state = "hair_afropuffdouble"

/datum/sprite_accessory/hair/afropuffleft
	name = "Afropuff Left"
	id = "hair_afropuffleft"
	icon_state = "hair_afropuffleft"

/datum/sprite_accessory/hair/afropuffright
	name = "Afropuff Right"
	id = "hair_afropuffright"
	icon_state = "hair_afropuffright"

/datum/sprite_accessory/hair/suave
	name = "Suave"
	id = "hair_suave"
	icon_state = "hair_suave"

/datum/sprite_accessory/hair/suave2
	name = "Suave Alt"
	id ="hair_suave2"
	icon_state = "hair_suave2"

/datum/sprite_accessory/hair/jane
	name = "Jane"
	id = "hair_jane"
	icon_state = "hair_jane"

/datum/sprite_accessory/hair/rockstarcurls
	name = "Rockstar Curls"
	id = "hair_rockstarcurls"
	icon_state = "hair_rockstarcurls"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/band
	name = "Banded Long"
	id = "hair_band"
	icon_state = "hair_band"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bieb
	name = "Beaver"
	id = "hair_bieb"
	icon_state = "hair_bieb"

/datum/sprite_accessory/hair/fabio
	name = "Fabio"
	id = "hair_fabio"
	icon_state = "hair_fabio"

/datum/sprite_accessory/hair/froofylong
	name = "Froofy Long"
	id = "hair_froofy_long"
	icon_state = "hair_froofy_long"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/glammetal
	name = "Glammetal"
	id = "hair_glammetal"
	icon_state = "hair_glammetal"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/midb
	name = "Mid-length hair"
	id = "hair_midb"
	icon_state = "hair_midb"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/halfshavedL
	name = "Half Shaved Left"
	id = "hair_halfshavedL"
	icon_state = "hair_halfshavedL"

/datum/sprite_accessory/hair/rockandroll
	name = "Rock and Roll"
	id = "hair_rockandroll"
	icon_state = "hair_rockandroll"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/shortflip
	name = "Flip Short"
	id = "hair_shortflip"
	icon_state = "hair_shortflip"

/datum/sprite_accessory/hair/dreadlongalt
	name = "Long Dreadlocks Alt"
	id = "hair_dreadlongalt"
	icon_state = "hair_dreadlongalt"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/keanu
	name = "Keanu"
	id = "hair_keanu"
	icon_state = "hair_keanu"

/datum/sprite_accessory/hair/long3
	name = "Long Hair Alt 3"
	id = "hair_long3"
	icon_state = "hair_long3"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/supernova
	name = "Supernova"
	id = "hair_supernova"
	icon_state = "hair_supernova"

/datum/sprite_accessory/hair/astolfo
	name = "Astolfo"
	id = "hair_astolfo"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_astolfo"

/datum/sprite_accessory/hair/awoohair
	name = "Shoulder-length Messy"
	id = "hair_messy_shoulder"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "momijihair"

/datum/sprite_accessory/hair/citheronia_colorable
	name = "Citheronia Hair"
	id = "hair_citheronia"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "citheronia_hair_c"
	do_colouration = 1

/datum/sprite_accessory/hair/twindrills
	name = "Twin Drills"
	id = "hair_twindrills"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_twincurl"

/datum/sprite_accessory/hair/myopia
	name = "Myopia"
	id = "hair_myopia"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "myopia"
	hair_flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/shortish
	name = "Shortish"
	id = "hair_shortish"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "bshort-1"

/datum/sprite_accessory/hair/shortmess
	name = "Short Mess"
	id = "hair_short_mess"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "bshort-2"

/datum/sprite_accessory/hair/peaked
	name = "Peaked"
	id = "hair_peaked"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "bshort-3"

/datum/sprite_accessory/hair/blindbangs
	name = "Blind Bangs"
	id = "hair_bangs_blind"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "blindbangs"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/reallyblindbangs
	name = "Grudge"
	id = "hair_grudge"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "grudge"
	hair_flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/zone
	name = "Zone"
	id = "hair_zone"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "zone"
/datum/sprite_accessory/hair/halfcut
	name = "Halfcut"
	id = "hair_halfcut"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "halfcut"
