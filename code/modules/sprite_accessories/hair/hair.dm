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
	color_blend_mode = ICON_MULTIPLY
	apply_restrictions = FALSE
	var/flags

/datum/sprite_accessory/hair/eighties
	name = "80's"
	icon_state = "hair_80s"

/datum/sprite_accessory/hair/eighties_alt
	name = "80's (Alternative)"
	icon_state = "hair_80s_alt"

/datum/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "hair_afro"

/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "hair_afro2"

/datum/sprite_accessory/hair/afro_large
	name = "Big Afro"
	icon_state = "hair_bigafro"

/datum/sprite_accessory/hair/ahoge
	name = "Ahoge"
	icon_state = "hair_ahoge"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = null

/datum/sprite_accessory/hair/bald //Everyone goes bald.
	name = "Bald"
	icon_state = "bald"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/baldfade
	name = "Balding Fade"
	icon_state = "hair_baldfade"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "hair_e"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/bedhead
	name = "Bedhead"
	icon_state = "hair_bedhead"

/datum/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	icon_state = "hair_bedheadv2"

/datum/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	icon_state = "hair_bedheadv3"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bedheadlong
	name = "Bedhead Long"
	icon_state = "hair_long_bedhead"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "hair_beehive"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "hair_beehive2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/belenko
	name = "Belenko"
	icon_state = "hair_belenko"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/belenkotied
	name = "Belenko Tied"
	icon_state = "hair_belenkotied"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "hair_bobcut"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bobcutalt
	name = "Bob Chin Length"
	icon_state = "hair_bobcutalt"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "hair_bobcurl"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "hair_bowlcut"

/datum/sprite_accessory/hair/bowlcut2
	name = "Bowl 2"
	icon_state = "hair_bowlcut2"

/datum/sprite_accessory/hair/grandebraid
	name = "Braid Grande"
	icon_state = "hair_grande"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/braid2
	name = "Braid Long"
	icon_state = "hair_hbraid"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/mbraid
	name = "Braid Medium"
	icon_state = "hair_shortbraid"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_braid"

/datum/sprite_accessory/hair/bun
	name = "Bun"
	icon_state = "hair_bun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bun2
	name = "Bun 2"
	icon_state = "hair_bun2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bun3
	name = "Bun 3"
	icon_state = "hair_bun3"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bun
	name = "Bun Casual"
	icon_state = "hair_bun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/doublebun
	name = "Bun Double"
	icon_state = "hair_doublebun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/tightbun
	name = "Bun Tight"
	icon_state = "hair_tightbun"
	gender = FEMALE
	flags = HAIR_VERY_SHORT | HAIR_TIEABLE

/datum/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "hair_buzzcut"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/crono
	name = "Chrono"
	icon_state = "hair_toriyama"

/datum/sprite_accessory/hair/cia
	name = "CIA"
	icon_state = "hair_cia"

/datum/sprite_accessory/hair/coffeehouse
	name = "Coffee House Cut"
	icon_state = "hair_coffeehouse"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "hair_combover"

/datum/sprite_accessory/hair/country
	name = "Country"
	icon_state = "hair_country"

/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "hair_crewcut"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "hair_curls"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "hair_c"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/dave
	name = "Dave"
	icon_state = "hair_dave"

/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "hair_devilock"

/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "hair_dreads"

/datum/sprite_accessory/hair/mahdrills
	name = "Drillruru"
	icon_state = "hair_drillruru"

/datum/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "hair_emo"

/datum/sprite_accessory/hair/emo2
	name = "Emo Alt"
	icon_state = "hair_emo2"

/datum/sprite_accessory/hair/fringeemo
	name = "Emo Fringe"
	icon_state = "hair_emofringe"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/halfshaved
	name = "Emo Half-Shaved"
	icon_state = "hair_halfshaved"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longemo
	name = "Emo Long"
	icon_state = "hair_emolong"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/highfade
	name = "Fade High"
	icon_state = "hair_highfade"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/medfade
	name = "Fade Medium"
	icon_state = "hair_medfade"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/lowfade
	name = "Fade Low"
	icon_state = "hair_lowfade"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/partfade
	name = "Fade Parted"
	icon_state = "hair_shavedpart"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/familyman
	name = "Family Man"
	icon_state = "hair_thefamilyman"

/datum/sprite_accessory/hair/father
	name = "Father"
	icon_state = "hair_father"

/datum/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "hair_feather"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "hair_flair"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "hair_sargeant"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/flowhair
	name = "Flow Hair"
	icon_state = "hair_f"

/datum/sprite_accessory/hair/longfringe
	name = "Fringe Long"
	icon_state = "hair_longfringe"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longestalt
	name = "Fringe Longer"
	icon_state = "hair_vlongfringe"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/fringetail
	name = "Fringetail"
	icon_state = "hair_fringetail"
	flags = HAIR_TIEABLE|HAIR_VERY_SHORT

/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "hair_gelled"

/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "hair_gentle"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/glossy
	name = "Glossy"
	icon_state = "hair_glossy"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "hair_halfbang"

/datum/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair Alt"
	icon_state = "hair_halfbang_alt"

/datum/sprite_accessory/hair/hedgehog
	name = "Hedgehog Hair"
	icon_state = "hair_hedgehog"
	icon_add = null

/datum/sprite_accessory/hair/hightight
	name = "High and Tight"
	icon_state = "hair_hightight"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "hair_himecut"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/shorthime
	name = "Hime Cut Short"
	icon_state = "hair_shorthime"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hair_hitop"

/datum/sprite_accessory/hair/jade
	name = "Jade"
	icon_state = "hair_jade"

/datum/sprite_accessory/hair/jensen
	name = "Jensen"
	icon_state = "hair_jensen"

/datum/sprite_accessory/hair/joestar
	name = "Joestar"
	icon_state = "hair_joestar"

/datum/sprite_accessory/hair/kagami
	name = "Kagami"
	icon_state = "hair_kagami"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	icon_state = "hair_kusanagi"

/datum/sprite_accessory/hair/long
	name = "Long Hair Shoulder-length"
	icon_state = "hair_b"
	flags = HAIR_TIEABLE
/*
	longish
	name = "Longer Hair"
	icon_state = "hair_b2"
	flags = HAIR_TIEABLE
*/
/datum/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "hair_vlong"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longeralt2
	name = "Long Hair Alt 2"
	icon_state = "hair_longeralt2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "hair_longest"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/manbun
	name = "Manbun"
	icon_state = "hair_manbun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/modern
	name = "Modern"
	icon_state = "hair_modern"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "hair_d"

/datum/sprite_accessory/hair/regulationmohawk
	name = "Mohawk Regulation"
	icon_state = "hair_shavedmohawk"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/reversemohawk
	name = "Mohawk Reverse"
	icon_state = "hair_reversemohawk"

/datum/sprite_accessory/hair/messy
	name = "Messy"
	icon_state = "hair_messy_tg"
	icon_add = null

/datum/sprite_accessory/hair/mohawkunshaven
	name = "Mohawk Unshaven"
	icon_state = "hair_unshaven_mohawk"

/datum/sprite_accessory/hair/mulder
	name = "Mulder"
	icon_state = "hair_mulder"

/datum/sprite_accessory/hair/newyou
	name = "New You"
	icon_state = "hair_newyou"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/nia
	name = "Nia"
	icon_state = "hair_nia"

/datum/sprite_accessory/hair/nitori
	name = "Nitori"
	icon_state = "hair_nitori"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "hair_odango"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "hair_ombre"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/oxton
	name = "Oxton"
	icon_state = "hair_oxton"

/datum/sprite_accessory/hair/longovereye
	name = "Overeye Long"
	icon_state = "hair_longovereye"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/shortovereye
	name = "Overeye Short"
	icon_state = "hair_shortovereye"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/veryshortovereyealternate
	name = "Overeye Very Short, Alternate"
	icon_state = "hair_veryshortovereyealternate"

/datum/sprite_accessory/hair/veryshortovereye
	name = "Overeye Very Short"
	icon_state = "hair_veryshortovereye"

/datum/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "hair_parted"

/datum/sprite_accessory/hair/partedalt
	name = "Parted Alt"
	icon_state = "hair_partedalt"

/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "hair_pompadour"

/datum/sprite_accessory/hair/dandypomp
	name = "Pompadour Dandy"
	icon_state = "hair_dandypompadour"

/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail 1"
	icon_state = "hair_ponytail"
	flags = HAIR_TIEABLE|HAIR_VERY_SHORT

/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "hair_pa"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "hair_ponytail3"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	icon_state = "hair_ponytail4"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail5
	name = "Ponytail 5"
	icon_state = "hair_ponytail5"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail6
	name = "Ponytail 6"
	icon_state = "hair_ponytail6"
	flags = HAIR_TIEABLE|HAIR_VERY_SHORT

/datum/sprite_accessory/hair/ponytail6_fixed //Eggnerd's done with waiting for upstream fixes lmao.
	name = "Ponytail 6 but fixed"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_ponytail6"

/datum/sprite_accessory/hair/sharpponytail
	name = "Ponytail Sharp"
	icon_state = "hair_sharpponytail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/spikyponytail
	name = "Ponytail Spiky"
	icon_state = "hair_spikyponytail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/highponytail
	name = "High Ponytail"
	icon_state = "hair_highponytail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/poofy
	name = "Poofy"
	icon_state = "hair_poofy"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/poofy2
	name = "Poofy 2"
	icon_state = "hair_poofy2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "hair_quiff"

/datum/sprite_accessory/hair/nofade
	name = "Regulation Cut"
	icon_state = "hair_nofade"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/ronin
	name = "Ronin"
	icon_state = "hair_ronin"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rosa
	name = "Rosa"
	icon_state = "hair_rosa"

/datum/sprite_accessory/hair/rows
	name = "Rows"
	icon_state = "hair_rows1"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/rows2
	name = "Rows 2"
	icon_state = "hair_rows2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rowbun
	name = "Row Bun"
	icon_state = "hair_rowbun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rowdualbraid
	name = "Row Dual Braid"
	icon_state = "hair_rowdualtail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rowbraid
	name = "Row Braid"
	icon_state = "hair_rowbraid"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/scully
	name = "Scully"
	icon_state = "hair_scully"

/datum/sprite_accessory/hair/shavehair
	name = "Shaved Hair"
	icon_state = "hair_shaved"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/shortbangs
	name = "Short Bangs"
	icon_state = "hair_shortbangs"

/datum/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/short2
	name = "Short Hair 2"
	icon_state = "hair_shorthair3"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/shortalt2
	name = "Short Hair 2 Alt"
	icon_state = "shorthair3a"
	flags = HAIR_VERY_SHORT
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'

/datum/sprite_accessory/hair/short3
	name = "Short Hair 3"
	icon_state = "hair_shorthair4"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/shy
	name = "Shy"
	icon_state = "hair_shy"

/datum/sprite_accessory/hair/sideponytail
	name = "Side Ponytail"
	icon_state = "hair_stail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail4 //Not happy about this... but it's for the save files.
	name = "Side Ponytail 2"
	icon_state = "hair_ponytailf"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail2
	name = "Shoulder One"
	icon_state = "hair_oneshoulder"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail3
	name = "Shoulder Tress"
	icon_state = "hair_tressshoulder"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "hair_skinhead"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/sleeze
	name = "Sleeze"
	icon_state = "hair_sleeze"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "hair_spikey"

/datum/sprite_accessory/hair/thinning
	name = "Thinning"
	icon_state = "hair_thinning"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	icon_state = "hair_thinningfront"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/thinningback
	name = "Thinning Back"
	icon_state = "hair_thinningrear"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/topknot
	name = "Topknot"
	icon_state = "hair_topknot"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/trimflat
	name = "Trimmed Flat Top"
	icon_state = "hair_trimflat"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/jade
	name = "Jade"
	icon_state = "hair_jade"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/trimmed
	name = "Trimmed"
	icon_state = "hair_trimmed"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/twintai1
	name = "Twintail"
	icon_state = "hair_twintail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/twintail2
	name = "Twintail Short"
	icon_state = "hair_twintailshort"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/undercut1
	name = "Undercut"
	icon_state = "hair_undercut1"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/undercut2
	name = "Undercut Swept Right"
	icon_state = "hair_undercut2"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/undercut3
	name = "Undercut Swept Left"
	icon_state = "hair_undercut3"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/undercutlong
	name = "Undercut Long"
	icon_state = "hair_undercutlong"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/unkept
	name = "Unkept"
	icon_state = "hair_unkept"

/datum/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "hair_updo"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/vegeta
	name = "Vegeta"
	icon_state = "hair_toriyama2"

/datum/sprite_accessory/hair/volaju
	name = "Volaju"
	icon_state = "hair_volaju"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/wisp
	name = "Wisp"
	icon_state = "hair_wisp"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/zieglertail
	name = "Zieglertail"
	icon_state = "hair_ziegler"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/glossy
	name = "Glossy"
	icon_state = "hair_glossy"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sharpponytail
	name = "Ponytail Sharp"
	icon_state = "hair_sharpponytail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/newyou
	name = "New You"
	icon_state = "hair_newyou"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/partedalt
	name = "Parted Alt"
	icon_state = "hair_partedalt"

/datum/sprite_accessory/hair/amazon
	name = "Amazon"
	icon_state = "hair_amazon"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/straightlong
	name = "Straight Long"
	icon_state = "hair_straightlong"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/marysue
	name = "Mary Sue"
	icon_state = "hair_marysue"

/datum/sprite_accessory/hair/sideundercut
	name = "Side Undercut"
	icon_state = "hair_sideundercut"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/donutbun
	name = "Donut Bun"
	icon_state = "hair_donutbun"

/datum/sprite_accessory/hair/gentle2
	name = "Gentle 2, Long"
	icon_state = "hair_gentle2long"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sweepshave
	name = "Sweep Shave"
	icon_state = "hair_sweepshave"

/datum/sprite_accessory/hair/beachwave
	name = "Beach Waves"
	icon_state = "hair_beachwave"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/celebcurls
	name = "Celeb Curls"
	icon_state = "hair_celebcurls"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bigcurls
	name = "Big Curls"
	icon_state = "hair_bigcurls"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/jessica
	name = "Jessica"
	icon_state = "hair_jessica"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/proper
	name = "Proper"
	icon_state = "hair_proper"

/datum/sprite_accessory/hair/himeup
	name = "Hime Updo"
	icon_state = "hair_himeup"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/front_braid
	name = "Braided front"
	icon_state = "hair_braidfront"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/antenna
	name = "Antenna"
	icon_state = "hair_antenna"

/datum/sprite_accessory/hair/protagonist
	name = "Slightly Long"
	icon_state = "hair_protagonist"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/braidtail
	name = "Braided Tail"
	icon_state = "hair_braidtail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/business
	name = "Business Hair"
	icon_state = "hair_business"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/business3
	name = "Business Hair 3"
	icon_state = "hair_business3"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/business4
	name = "Business Hair 4"
	icon_state = "hair_business4"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/sidepartlongalt
	name = "Long Side Part"
	icon_state = "hair_longsidepart"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/miles
	name = "Miles Hair"
	icon_state = "hair_miles"

/datum/sprite_accessory/hair/vivi
	name = "Vivi"
	icon_state = "hair_vivi"

/datum/sprite_accessory/hair/taro
	name = "Taro"
	icon_state = "hair_taro"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/astolfo
	name = "Astolfo"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_astolfo"

/datum/sprite_accessory/hair/awoohair
	name = "Shoulder-length Messy"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "momijihair"

/datum/sprite_accessory/hair/citheronia
	name = "Citheronia Hair (Kira72)"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "citheronia_hair"
	ckeys_allowed = list("Kira72")
	do_colouration = 0

/datum/sprite_accessory/hair/taramaw
	name = "Hairmaw (Liquidfirefly)"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "maw_hair"
	ckeys_allowed = list("liquidfirefly")
	do_colouration = 0

/datum/sprite_accessory/hair/citheronia_colorable
	name = "Citheronia Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "citheronia_hair_c"
	do_colouration = 1

/datum/sprite_accessory/hair/twindrills
	name = "Twin Drills"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_twincurl"

/datum/sprite_accessory/hair/myopia
	name = "Myopia"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "myopia"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/shortish
	name = "Shortish"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "bshort-1"

/datum/sprite_accessory/hair/shortmess
	name = "Short Mess"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "bshort-2"

/datum/sprite_accessory/hair/peaked
	name = "Peaked"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "bshort-3"

/datum/sprite_accessory/hair/blindbangs
	name = "Blind Bangs"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "blindbangs"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/reallyblindbangs
	name = "Grudge"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "grudge"
	flags = HAIR_TIEABLE

