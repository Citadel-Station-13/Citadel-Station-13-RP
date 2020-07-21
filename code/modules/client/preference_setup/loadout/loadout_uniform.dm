// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/blazerskirt
	display_name = "blazer, blue with skirt"
	path = /obj/item/clothing/under/blazer/skirt

/datum/gear/uniform/cheongsam
	description = "Various color variations of an old earth dress style. They are pretty close fitting around the waist."
	display_name = "cheongsam selection"

/datum/gear/uniform/cheongsam/New()
	..()
	var/list/cheongasms = list()
	for(var/cheongasm in typesof(/obj/item/clothing/under/cheongsam))
		var/obj/item/clothing/under/cheongsam/cheongasm_type = cheongasm
		cheongasms[initial(cheongasm_type.name)] = cheongasm_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cheongasms, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/croptop
	description = "Light shirts which shows the midsection of the wearer."
	display_name = "croptop selection"

/datum/gear/uniform/croptop/New()
	..()
	var/list/croptops = list()
	for(var/croptop in typesof(/obj/item/clothing/under/croptop))
		var/obj/item/clothing/under/croptop/croptop_type = croptop
		croptops[initial(croptop_type.name)] = croptop_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(croptops, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/cuttop
	display_name = "cut top, grey"
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/red
	display_name = "cut top, red"
	path = /obj/item/clothing/under/cuttop/red

/datum/gear/uniform/jumpsuit
	display_name = "jumpclothes selection"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/list/jumpclothes = list()
	for(var/jump in typesof(/obj/item/clothing/under/color))
		var/obj/item/clothing/under/color/jumps = jump
		jumpclothes[initial(jumps.name)] = jumps
	gear_tweaks += new/datum/gear_tweak/path(sortTim(jumpclothes, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/skirt
	display_name = "skirt selection"
	path = /obj/item/clothing/under/skirt

/datum/gear/uniform/skirt/New()
	..()
	var/list/skirts = list()
	for(var/skirt in (typesof(/obj/item/clothing/under/skirt)))
		//if(skirt in typesof(/obj/item/clothing/under/skirt/fluff))	//VOREStation addition
		//	continue												//VOREStation addition
		var/obj/item/clothing/under/skirt/skirt_type = skirt
		skirts[initial(skirt_type.name)] = skirt_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(skirts, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/pants
	display_name = "pants selection"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(pants, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/shorts
	display_name = "shorts selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(shorts, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/job_skirt/ce
	display_name = "skirt, ce"
	path = /obj/item/clothing/under/rank/chief_engineer/skirt
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/job_skirt/atmos
	display_name = "skirt, atmos"
	path = /obj/item/clothing/under/rank/atmospheric_technician/skirt
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/uniform/job_skirt/eng
	display_name = "skirt, engineer"
	path = /obj/item/clothing/under/rank/engineer/skirt
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/uniform/job_skirt/roboticist
	display_name = "skirt, roboticist"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/uniform/job_skirt/cmo
	display_name = "skirt, cmo"
	path = /obj/item/clothing/under/rank/chief_medical_officer/skirt
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/job_skirt/chem
	display_name = "skirt, chemist"
	path = /obj/item/clothing/under/rank/chemist/skirt
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/uniform/job_skirt/viro
	display_name = "skirt, virologist"
	path = /obj/item/clothing/under/rank/virologist/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/uniform/job_skirt/med
	display_name = "skirt, medical"
	path = /obj/item/clothing/under/rank/medical/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic")

/datum/gear/uniform/job_skirt/sci
	display_name = "skirt, scientist"
	path = /obj/item/clothing/under/rank/scientist/skirt
	allowed_roles = list("Research Director","Scientist", "Xenobiologist")

/datum/gear/uniform/job_skirt/cargo
	display_name = "skirt, cargo"
	path = /obj/item/clothing/under/rank/cargotech/skirt
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/job_skirt/qm
	display_name = "skirt, QM"
	path = /obj/item/clothing/under/rank/cargo/skirt
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/job_skirt/warden
	display_name = "skirt, warden"
	path = /obj/item/clothing/under/rank/warden/skirt
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/uniform/job_skirt/security
	display_name = "skirt, security"
	path = /obj/item/clothing/under/rank/security/skirt
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/job_skirt/head_of_security
	display_name = "skirt, hos"
	path = /obj/item/clothing/under/rank/head_of_security/skirt
	allowed_roles = list("Head of Security")

/datum/gear/uniform/job_turtle/science
	display_name = "turtleneck, science"
	path = /obj/item/clothing/under/rank/scientist/turtleneck
	allowed_roles = list("Research Director", "Scientist", "Roboticist", "Xenobiologist")

/datum/gear/uniform/job_turtle/security
	display_name = "turtleneck, security"
	path = /obj/item/clothing/under/rank/security/turtleneck
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/job_turtle/engineering
	display_name = "turtleneck, engineering"
	path = /obj/item/clothing/under/rank/engineer/turtleneck
	allowed_roles = list("Chief Engineer", "Atmospheric Technician", "Station Engineer")

/datum/gear/uniform/job_turtle/medical
	display_name = "turtleneck, medical"
	path = /obj/item/clothing/under/rank/medical/turtleneck
	allowed_roles = list("Chief Medical Officer", "Paramedic", "Medical Doctor", "Psychologist", "Field Medic", "Chemist")

/datum/gear/uniform/jeans_qm
	display_name = "jeans, QM"
	path = /obj/item/clothing/under/rank/cargo/jeans
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/jeans_qmf
	display_name = "female jeans, QM"
	path = /obj/item/clothing/under/rank/cargo/jeans/female
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/jeans_cargo
	display_name = "jeans, cargo"
	path = /obj/item/clothing/under/rank/cargotech/jeans
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/jeans_cargof
	display_name = "female jeans, cargo"
	path = /obj/item/clothing/under/rank/cargotech/jeans/female
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/suit/lawyer
	display_name = "suit, one-piece selection"
	path = /obj/item/clothing/under/lawyer

/datum/gear/uniform/suit/lawyer/New()
	..()
	var/list/lsuits = list()
	for(var/lsuit in typesof(/obj/item/clothing/under/lawyer))
		var/obj/item/clothing/suit/lsuit_type = lsuit
		lsuits[initial(lsuit_type.name)] = lsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(lsuits, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/suit/suit_jacket
	display_name = "suit, modular selection"
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/suit/suit_jacket/New()
	..()
	var/list/msuits = list()
	for(var/msuit in typesof(/obj/item/clothing/under/suit_jacket))
		//if(msuit in typesof(/obj/item/clothing/under/suit_jacket/female/fluff))	//VOREStation addition
		//	continue															//VOREStation addition
		var/obj/item/clothing/suit/msuit_type = msuit
		msuits[initial(msuit_type.name)] = msuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(msuits, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/suit/amish  //amish
	display_name = "suit, amish"
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/gentle
	display_name = "suit, gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/gear/uniform/suit/gentleskirt
	display_name = "suit, lady"
	path = /obj/item/clothing/under/gentlesuit/skirt

/datum/gear/uniform/suit/white
	display_name = "suit, white"
	path = /obj/item/clothing/under/scratch

/datum/gear/uniform/suit/whiteskirt
	display_name = "suit, white skirt"
	path = /obj/item/clothing/under/scratch/skirt

/datum/gear/uniform/suit/detectiveskirt
	display_name = "suit, detective skirt (Detective)"
	path = /obj/item/clothing/under/det/skirt
	allowed_roles = list("Detective")

/datum/gear/uniform/suit/iaskirt
	display_name = "suit, Internal Affairs skirt (Internal Affairs)"
	path = /obj/item/clothing/under/rank/internalaffairs/skirt
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/uniform/suit/bartenderskirt
	display_name = "suit, bartender skirt (Bartender)"
	path = /obj/item/clothing/under/rank/bartender/skirt
	allowed_roles = list("Bartender")

/datum/gear/uniform/scrub
	display_name = "scrubs selection"
	path = /obj/item/clothing/under/rank/medical/scrubs

/datum/gear/uniform/scrub/New()
	..()
	var/list/scrubs = list()
	for(var/scrub in typesof(/obj/item/clothing/under/rank/medical/scrubs))
		var/obj/item/clothing/under/rank/medical/scrubs/scrub_type = scrub
		scrubs[initial(scrub_type.name)] = scrub_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(scrubs, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/oldwoman
	display_name = "old woman attire"
	path = /obj/item/clothing/under/oldwoman

/datum/gear/uniform/sundress
	display_name = "sundress"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/sundress/white
	display_name = "sundress, white"
	path = /obj/item/clothing/under/sundress_white

/datum/gear/uniform/dress_fire
	display_name = "flame dress"
	path = /obj/item/clothing/under/dress/dress_fire

/datum/gear/uniform/uniform_captain
	display_name = "uniform, Facility Director's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Facility Director")

/datum/gear/uniform/corpdetsuit
	display_name = "uniform, corporate (Detective)"
	path = /obj/item/clothing/under/det/corporate
	allowed_roles = list("Detective","Head of Security")

/datum/gear/uniform/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/corpwarsuit
	display_name = "uniform, corporate (Warden)"
	path = /obj/item/clothing/under/rank/warden/corp
	allowed_roles = list("Head of Security","Warden")

/datum/gear/uniform/corphossuit
	display_name = "uniform, corporate (Head of Security)"
	path = /obj/item/clothing/under/rank/head_of_security/corp
	allowed_roles = list("Head of Security")

/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr

	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/navysecsuit
	display_name = "uniform, navy blue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/navywarsuit
	display_name = "uniform, navy blue (Warden)"
	path = /obj/item/clothing/under/rank/warden/navyblue
	allowed_roles = list("Head of Security","Warden")

/datum/gear/uniform/navyhossuit
	display_name = "uniform, navy blue (Head of Security)"
	path = /obj/item/clothing/under/rank/head_of_security/navyblue
	allowed_roles = list("Head of Security")

/datum/gear/uniform/shortplaindress
	display_name = "plain dress"
	path = /obj/item/clothing/under/dress/white3

/datum/gear/uniform/shortplaindress/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/longdress
	display_name = "long dress"
	path = /obj/item/clothing/under/dress/white2

/datum/gear/uniform/longdress/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/longwidedress
	display_name = "long wide dress"
	path = /obj/item/clothing/under/dress/white4

/datum/gear/uniform/longwidedress/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/reddress
	display_name = "red dress with belt"
	path = /obj/item/clothing/under/dress/darkred

/datum/gear/uniform/whitewedding
	display_name= "white wedding dress"
	path = /obj/item/clothing/under/wedding/bride_white

/datum/gear/uniform/skirts
	display_name = "executive skirt"
	path = /obj/item/clothing/under/suit_jacket/female/skirt

/datum/gear/uniform/dresses
	display_name = "sailor dress"
	path = /obj/item/clothing/under/dress/sailordress

/datum/gear/uniform/dresses/eveninggown
	display_name = "red evening gown"
	path = /obj/item/clothing/under/dress/redeveninggown

/datum/gear/uniform/dresses/maid
	display_name = "maid uniform selection"
	path = /obj/item/clothing/under/dress/maid

/datum/gear/uniform/dresses/maid/New()
	..()
	var/list/maids = list()
	for(var/maid in typesof(/obj/item/clothing/under/dress/maid))
		var/obj/item/clothing/under/dress/maid/maid_type = maid
		maids[initial(maid_type.name)] = maid_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(maids, /proc/cmp_text_asc, TRUE))

/datum/gear/uniform/utility
	display_name = "utility, black"
	path = /obj/item/clothing/under/utility

/datum/gear/uniform/utility/blue
	display_name = "utility, blue"
	path = /obj/item/clothing/under/utility/blue

/datum/gear/uniform/utility/grey
	display_name = "utility, grey"
	path = /obj/item/clothing/under/utility/grey

/datum/gear/uniform/sweater
	display_name = "sweater, grey"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater

/datum/gear/uniform/brandsuit/aether
	display_name = "jumpsuit, aether"
	path = /obj/item/clothing/under/aether

/datum/gear/uniform/brandsuit/focal
	display_name = "jumpsuit, focal"
	path = /obj/item/clothing/under/focal

/datum/gear/uniform/mbill
	display_name = "outfit, major bill's"
	path = /obj/item/clothing/under/mbill

/datum/gear/uniform/pcrc
	display_name = "uniform, PCRC (Security)"
	path = /obj/item/clothing/under/pcrc
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/brandsuit/grayson
	display_name = "outfit, grayson"
	path = /obj/item/clothing/under/grayson

/datum/gear/uniform/brandsuit/wardt
	display_name = "jumpsuit, ward-takahashi"
	path = /obj/item/clothing/under/wardt

/datum/gear/uniform/frontier
	display_name = "outfit, frontier"
	path = 	/obj/item/clothing/under/frontier

/datum/gear/uniform/brandsuit/hephaestus
	display_name = "jumpsuit, hephaestus"
	path = 	/obj/item/clothing/under/hephaestus

/datum/gear/uniform/yogapants
	display_name = "yoga pants"
	path = /obj/item/clothing/under/pants/yogapants

/datum/gear/uniform/yogapants/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/black_corset
	display_name = "black corset"
	path = /obj/item/clothing/under/dress/black_corset

/datum/gear/uniform/flower_dress
	display_name = "flower dress"
	path = /obj/item/clothing/under/dress/flower_dress

/datum/gear/uniform/red_swept_dress
	display_name = "red swept dress"
	path = /obj/item/clothing/under/dress/red_swept_dress

/datum/gear/uniform/bathrobe
	display_name = "bathrobe"
	path = /obj/item/clothing/under/bathrobe

/datum/gear/uniform/flamenco
	display_name = "flamenco dress"
	path = /obj/item/clothing/under/dress/flamenco

/datum/gear/uniform/westernbustle
	display_name = "western bustle"
	path = /obj/item/clothing/under/dress/westernbustle

/datum/gear/uniform/circuitry
	display_name = "jumpsuit, circuitry (empty)"
	path = /obj/item/clothing/under/circuitry
// NEW UNIFORMS BEGIN HERE
/datum/gear/uniform/sifguard
	display_name = "uniform, crew"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew

/datum/gear/uniform/sifguard/medical
	display_name = "uniform, crew (medical)"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Field Medic")

/datum/gear/uniform/sifguard/science
	display_name = "uniform, crew (science)"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/research
	allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist")

/datum/gear/uniform/sifguard/engineering
	display_name = "uniform, crew (engineering)"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/uniform/sifguard/supply
	display_name = "uniform, crew (supply)"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/supply
	allowed_roles = list("Quartermaster","Cargo Technician","Shaft Miner")

/datum/gear/uniform/sifguard/security
	display_name = "uniform, crew (security)"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/security
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/uniform/sifguard/command
	display_name = "uniform, crew (command)"
	path = /obj/item/clothing/under/solgov/utility/sifguard/officer/crew
	allowed_roles = list("Head of Security","Facility Director","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

/datum/gear/uniform/fleet/medical
	display_name = "uniform, coveralls (medical)"
	path = /obj/item/clothing/under/solgov/utility/fleet/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Field Medic")

/*
/datum/gear/uniform/fleet/science
	display_name = "uniform, coveralls (science)"
	path = /obj/item/clothing/under/solgov/utility/fleet/research
	allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist")
*/

/datum/gear/uniform/fleet/engineering
	display_name = "uniform, coveralls (engineering)"
	path = /obj/item/clothing/under/solgov/utility/fleet/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/uniform/fleet/supply
	display_name = "uniform, coveralls (supply)"
	path = /obj/item/clothing/under/solgov/utility/fleet/supply
	allowed_roles = list("Quartermaster","Cargo Technician","Shaft Miner")

/datum/gear/uniform/fleet/security
	display_name = "uniform, coveralls (security)"
	path = /obj/item/clothing/under/solgov/utility/fleet/security
	cost = 2
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/uniform/fleet/command
	display_name = "uniform, coveralls (command)"
	path = /obj/item/clothing/under/solgov/utility/fleet/command
	allowed_roles = list("Head of Security","Facility Director","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

/datum/gear/uniform/marine/medical
	display_name = "uniform, fatigues (medical)"
	path = /obj/item/clothing/under/solgov/utility/marine/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Field Medic")

/*
/datum/gear/uniform/marine/science
	display_name = "uniform, fatigues (science)"
	path = /obj/item/clothing/under/solgov/utility/marine/research
	allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist")
*/

/datum/gear/uniform/marine/engineering
	display_name = "uniform, fatigues (engineering)"
	path = /obj/item/clothing/under/solgov/utility/marine/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/uniform/marine/supply
	display_name = "uniform, fatigues (supply)"
	path = /obj/item/clothing/under/solgov/utility/marine/supply
	allowed_roles = list("Quartermaster","Cargo Technician","Shaft Miner")

/datum/gear/uniform/marine/security
	display_name = "uniform, fatigues (security)"
	path = /obj/item/clothing/under/solgov/utility/marine/security
	cost = 2
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/uniform/marine/command
	display_name = "uniform, fatigues (command)"
	path = /obj/item/clothing/under/solgov/utility/marine/command
	allowed_roles = list("Head of Security","Facility Director","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

/datum/gear/uniform/marine/green
	display_name = "uniform, fatigues (green)"
	path = /obj/item/clothing/under/solgov/utility/marine/green

/datum/gear/uniform/marine/tan
	display_name = "uniform, fatigues (tan)"
	path = /obj/item/clothing/under/solgov/utility/marine/tan
/datum/gear/uniform/sleekoverall
	display_name = "sleek overalls"
	path = /obj/item/clothing/under/overalls/sleek

/datum/gear/uniform/sarired
	display_name = "sari, red"
	path = /obj/item/clothing/under/dress/sari

/datum/gear/uniform/sarigreen
	display_name = "sari, green"
	path = /obj/item/clothing/under/dress/sari/green

/datum/gear/uniform/wrappedcoat
	display_name = "modern wrapped coat"
	path = /obj/item/clothing/under/moderncoat

/datum/gear/uniform/ascetic
	display_name = "plain ascetic garb"
	path = /obj/item/clothing/under/ascetic

/datum/gear/uniform/pleated
	display_name = "pleated skirt"
	path = /obj/item/clothing/under/skirt/pleated

/datum/gear/uniform/pleated/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/lilacdress
	display_name = "lilac dress"
	path = /obj/item/clothing/under/dress/lilacdress

// April 2020 - Drof's Additions Begin Below
/datum/gear/uniform/stripeddress
	display_name = "striped dress"
	path = /obj/item/clothing/under/dress/stripeddress

/datum/gear/uniform/festivedress
	display_name = "festive dress"
	path = /obj/item/clothing/under/festivedress

/datum/gear/uniform/haltertop
	display_name = "halter top"
	path = /obj/item/clothing/under/haltertop

/datum/gear/uniform/littleblackdress
	display_name = "little black dress"
	path = /obj/item/clothing/under/littleblackdress

/datum/gear/uniform/bridgeofficer
	display_name = "bridge officer uniform"
	path = /obj/item/clothing/under/bridgeofficer
	allowed_roles = list("Command Secretary")

/datum/gear/uniform/paramedunidark
	display_name = "Dark Paramedic Uniform"
	path = /obj/item/clothing/under/paramedunidark
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/uniform/parameduniskirtdark
	display_name = "Dark Paramedic Skirt"
	path = /obj/item/clothing/under/parameduniskirtdark
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/uniform/suit/bartenderbtc
	display_name = "BTC Bartender"
	path = /obj/item/clothing/under/btcbartender
	allowed_roles = list("Bartender")

/datum/gear/uniform/paramedunilight
	display_name = "Light Paramedic Uniform"
	path = /obj/item/clothing/under/paramedunilight
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/uniform/parameduniskirtdark
	display_name = "Light Paramedic Skirt"
	path = /obj/item/clothing/under/parameduniskirtlight
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

datum/gear/uniform/dutchsuit
	display_name = "Western Suit"
	path = /obj/item/clothing/under/dutchuniform

datum/gear/uniform/victorianredshirt
	display_name = "Red Shirt Victorian Suit"
	path = /obj/item/clothing/under/victorianblred

datum/gear/uniform/victorianredvest
	display_name = "Red Vested Victorian Suit"
	path = /obj/item/clothing/under/victorianredvest

datum/gear/uniform/victoriansuit
	display_name = "Victorian Suit"
	path = /obj/item/clothing/under/victorianvest

datum/gear/uniform/victorianbluesuit
	display_name = "Blue Shirted Victorian Suit"
	path = /obj/item/clothing/under/victorianlightfire

datum/gear/uniform/victorianreddress
	display_name = "Victorian Red Dress"
	path = /obj/item/clothing/under/victorianreddress

datum/gear/uniform/victorianblackdress
	display_name = "Victorian Black Dress"
	path = /obj/item/clothing/under/victorianblackdress

datum/gear/uniform/bridgeofficer
	display_name = "bridge officer skirt"
	path = /obj/item/clothing/under/bridgeofficerskirt
	allowed_roles = list("Command Secretary")

datum/gear/uniform/fiendsuit
	display_name = "Fiendish Suit"
	path = /obj/item/clothing/under/fiendsuit

datum/gear/uniform/fienddress
	display_name = "Fiendish Dress"
	path = /obj/item/clothing/under/fienddress

datum/gear/uniform/leotard
	display_name = "Black leotard"
	path = /obj/item/clothing/under/leotard

datum/gear/uniform/undersuitemt
	display_name = "EMT Undersuit"
	path = /obj/item/clothing/uniform/undersuitemt
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

datum/gear/uniform/undersuithazard
	display_name = "Hazard Undersuit"
	path = /obj/item/clothing/uniform/undersuithazard
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

datum/gear/uniform/undersuitsec
	display_name = "Security Undersuit"
	path = /obj/item/clothing/uniform/undersuitsec
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

datum/gear/uniform/undersuitseccom
	display_name = "Security Command Undersuit"
	path = /obj/item/clothing/uniform/undersuitseccom
	allowed_roles = list("Head of Security","Warden")

datum/gear/uniform/undersuitcommand
	display_name = "Command Undersuit"
	path = /obj/item/clothing/uniform/undersuitcommand
	allowed_roles = list("Head of Security","Facility Director","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")



