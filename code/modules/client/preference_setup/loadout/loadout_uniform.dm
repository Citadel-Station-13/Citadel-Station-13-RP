// Uniform slot
/datum/gear/uniform
	display_name = "Civilian Blazer - Blue"
	sort_category = "Uniforms and Casual Dress"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform

/datum/gear/uniform/blazerskirt
	display_name = "Civilian Blazer - Skirt "
	path = /obj/item/clothing/under/blazer/skirt

/datum/gear/uniform/cheongsam
	display_name = "Civilian Cheongsam Selection"
	description = "Various color variations of an old earth dress style. They are pretty close fitting around the waist."

/datum/gear/uniform/cheongsam/New()
	..()
	var/list/cheongasms = list()
	for(var/cheongasm in typesof(/obj/item/clothing/under/cheongsam))
		var/obj/item/clothing/under/cheongsam/cheongasm_type = cheongasm
		cheongasms[initial(cheongasm_type.name)] = cheongasm_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cheongasms, /proc/cmp_text_asc))

/datum/gear/uniform/croptop
	display_name = "Civilian Croptop Selection"
	description = "Light shirts which shows the midsection of the wearer."

/datum/gear/uniform/croptop/New()
	..()
	var/list/croptops = list()
	for(var/croptop in typesof(/obj/item/clothing/under/croptop))
		var/obj/item/clothing/under/croptop/croptop_type = croptop
		croptops[initial(croptop_type.name)] = croptop_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(croptops, /proc/cmp_text_asc))

/datum/gear/uniform/kilt
	display_name = "Civilian kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/cuttop
	display_name = "Civilian Cut Top - Grey"
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/red
	display_name = "Civilian Cut Top - Red"
	path = /obj/item/clothing/under/cuttop/red

/datum/gear/uniform/jumpsuit
	display_name = "Civilian Jumpclothes Selection"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/list/jumpclothes = list()
	for(var/jump in typesof(/obj/item/clothing/under/color))
		var/obj/item/clothing/under/color/jumps = jump
		jumpclothes[initial(jumps.name)] = jumps
	gear_tweaks += new/datum/gear_tweak/path(sortTim(jumpclothes, /proc/cmp_text_asc))

/datum/gear/uniform/blueshortskirt
	display_name = "Civilian Short Skirt"
	path = /obj/item/clothing/under/blueshortskirt

/datum/gear/uniform/skirt
	display_name = "Civilian Skirts Selection"
	path = /obj/item/clothing/under/skirt

/datum/gear/uniform/skirt/New()
	..()
	var/list/skirts = list()
	for(var/skirt in (typesof(/obj/item/clothing/under/skirt)))
		//if(skirt in typesof(/obj/item/clothing/under/skirt/fluff))	//VOREStation addition
		//	continue												//VOREStation addition
		var/obj/item/clothing/under/skirt/skirt_type = skirt
		skirts[initial(skirt_type.name)] = skirt_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(skirts, /proc/cmp_text_asc))

/datum/gear/uniform/pants
	display_name = "Civilian Pants Selection"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(pants, /proc/cmp_text_asc))

/datum/gear/uniform/shorts
	display_name = "Civilian Shorts Selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(shorts, /proc/cmp_text_asc))

/datum/gear/uniform/job_skirt/ce
	display_name = "Chief Engineer Skirt"
	path = /obj/item/clothing/under/rank/chief_engineer/skirt
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/job_skirt/atmos
	display_name = "Atmospheric Skirt"
	path = /obj/item/clothing/under/rank/atmospheric_technician/skirt
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/uniform/job_skirt/eng
	display_name = "Engineering Skirt"
	path = /obj/item/clothing/under/rank/engineer/skirt
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/uniform/job_skirt/roboticist
	display_name = "Roboticist Skirt"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/uniform/job_skirt/cmo
	display_name = "Chief Medical Officer Skirt"
	path = /obj/item/clothing/under/rank/chief_medical_officer/skirt
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/job_skirt/chem
	display_name = "Chemist Skirt"
	path = /obj/item/clothing/under/rank/chemist/skirt
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/uniform/job_skirt/viro
	display_name = "Medical Skirt - Virologist"
	path = /obj/item/clothing/under/rank/virologist/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/uniform/job_skirt/med
	display_name = "Medical Skirt"
	path = /obj/item/clothing/under/rank/medical/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic")

/datum/gear/uniform/job_skirt/sci
	display_name = "Science Skirt"
	path = /obj/item/clothing/under/rank/scientist/skirt
	allowed_roles = list("Research Director","Scientist", "Xenobiologist")

/datum/gear/uniform/job_skirt/cargo
	display_name = "Cargo Skirt"
	path = /obj/item/clothing/under/rank/cargotech/skirt
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/job_skirt/qm
	display_name = "Quartermaster Skirt"
	path = /obj/item/clothing/under/rank/cargo/skirt
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/job_skirt/warden
	display_name = "Warden Skirt"
	path = /obj/item/clothing/under/rank/warden/skirt
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/uniform/job_skirt/security
	display_name = "Security Skirt"
	path = /obj/item/clothing/under/rank/security/skirt
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/job_skirt/head_of_security
	display_name = "Head of Security Skirt"
	path = /obj/item/clothing/under/rank/head_of_security/skirt
	allowed_roles = list("Head of Security")


/datum/gear/uniform/job_turtle/
	description = "You feel the urge to talk about the Cosmos."

/datum/gear/uniform/job_turtle/science
	display_name = "Science Turtleneck"
	path = /obj/item/clothing/under/rank/scientist/turtleneck
	allowed_roles = list("Research Director", "Scientist", "Roboticist", "Xenobiologist")

/datum/gear/uniform/job_turtle/security
	display_name = "Security Turtleneck"
	path = /obj/item/clothing/under/rank/security/turtleneck
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/job_turtle/engineering
	display_name = "Engineering Turtleneck"
	path = /obj/item/clothing/under/rank/engineer/turtleneck
	allowed_roles = list("Chief Engineer", "Atmospheric Technician", "Station Engineer")

/datum/gear/uniform/job_turtle/medical
	display_name = "Medical Turtleneck"
	path = /obj/item/clothing/under/rank/medical/turtleneck
	allowed_roles = list("Chief Medical Officer", "Paramedic", "Medical Doctor", "Psychologist", "Field Medic", "Chemist")

/datum/gear/uniform/jeans_qm
	display_name = "Quartermaster Jeans"
	path = /obj/item/clothing/under/rank/cargo/jeans
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/jeans_qmf
	display_name = "Quartermaster Jeans - Female"
	path = /obj/item/clothing/under/rank/cargo/jeans/female
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/jeans_cargo
	display_name = "Cargo Jeans"
	path = /obj/item/clothing/under/rank/cargotech/jeans
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/jeans_cargof
	display_name = "Cargo Jeans - Female"
	path = /obj/item/clothing/under/rank/cargotech/jeans/female
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/suit/lawyer
	display_name = "Civilian Suit One-Piece Selection"
	path = /obj/item/clothing/under/lawyer

/datum/gear/uniform/suit/lawyer/New()
	..()
	var/list/lsuits = list()
	for(var/lsuit in typesof(/obj/item/clothing/under/lawyer))
		var/obj/item/clothing/suit/lsuit_type = lsuit
		lsuits[initial(lsuit_type.name)] = lsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(lsuits, /proc/cmp_text_asc))

/datum/gear/uniform/suit/suit_jacket
	display_name = "Civilian Suit Modular Selection"
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/suit/suit_jacket/New()
	..()
	var/list/msuits = list()
	for(var/msuit in typesof(/obj/item/clothing/under/suit_jacket))
		//if(msuit in typesof(/obj/item/clothing/under/suit_jacket/female/fluff))	//VOREStation addition
		//	continue															//VOREStation addition
		var/obj/item/clothing/suit/msuit_type = msuit
		msuits[initial(msuit_type.name)] = msuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(msuits, /proc/cmp_text_asc))

/datum/gear/uniform/suit/amish
	display_name = "Civilian Suit - Amish"
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/gentle
	display_name = "Civilian Suit - Gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/gear/uniform/suit/gentleskirt
	display_name = "Civilian Suit - Lady"
	path = /obj/item/clothing/under/gentlesuit/skirt

/datum/gear/uniform/suit/white
	display_name = "Civilian Suit - White"
	path = /obj/item/clothing/under/scratch

/datum/gear/uniform/suit/whiteskirt
	display_name = "Civilian Suit - White Skirt"
	path = /obj/item/clothing/under/scratch/skirt

/datum/gear/uniform/suit/detectiveskirt
	display_name = "Detective Suit - Skirt"
	path = /obj/item/clothing/under/det/skirt
	allowed_roles = list("Detective")

/datum/gear/uniform/suit/iaskirt
	display_name = "Internal Affairs Suit - Skirt"
	path = /obj/item/clothing/under/rank/internalaffairs/skirt
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/uniform/suit/bartenderskirt
	display_name = "Bartender - Suit - Skirt"
	path = /obj/item/clothing/under/rank/bartender/skirt
	allowed_roles = list("Bartender")

/datum/gear/uniform/scrub
	display_name = "Civilian Scrubs Selection"
	path = /obj/item/clothing/under/rank/medical/scrubs

/datum/gear/uniform/scrub/New()
	..()
	var/list/scrubs = list()
	for(var/scrub in typesof(/obj/item/clothing/under/rank/medical/scrubs))
		var/obj/item/clothing/under/rank/medical/scrubs/scrub_type = scrub
		scrubs[initial(scrub_type.name)] = scrub_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(scrubs, /proc/cmp_text_asc))

/datum/gear/uniform/oldwoman
	display_name = "Civilian Old Woman Attire"
	path = /obj/item/clothing/under/oldwoman

/datum/gear/uniform/sundress
	display_name = "Civilian Sundress"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/sundress/white
	display_name = "Civilian Sundress - White"
	path = /obj/item/clothing/under/sundress_white

/datum/gear/uniform/dress_fire
	display_name = "Civilian Flame Dress"
	path = /obj/item/clothing/under/dress/dress_fire

/datum/gear/uniform/uniform_captain
	display_name = "Facility Director Uniform - Dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Facility Director")

/datum/gear/uniform/corpdetsuit
	display_name = "Detective Uniform - Corporate"
	path = /obj/item/clothing/under/det/corporate
	allowed_roles = list("Detective","Head of Security")

/datum/gear/uniform/corpsecsuit
	display_name = "Security Uniform - Corporate"
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/corpwarsuit
	display_name = "Warden Uniform - Corporate"
	path = /obj/item/clothing/under/rank/warden/corp
	allowed_roles = list("Head of Security","Warden")

/datum/gear/uniform/corphossuit
	display_name = "Head of Security Uniform - Corporate"
	path = /obj/item/clothing/under/rank/head_of_security/corp
	allowed_roles = list("Head of Security")

/datum/gear/uniform/uniform_hop
	display_name = "Head of Personnel Uniform - Dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/uniform_hr
	display_name = "Head of Personnel Uniform - HR Director"
	path = /obj/item/clothing/under/dress/dress_hr

	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/navysecsuit
	display_name = "Security Uniform - Navy Blue"
	path = /obj/item/clothing/under/rank/security/navyblue
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/navywarsuit
	display_name = "Warden Uniform - Navy Blue"
	path = /obj/item/clothing/under/rank/warden/navyblue
	allowed_roles = list("Head of Security","Warden")

/datum/gear/uniform/navyhossuit
	display_name = "Head of Security Uniform - Navy Blue"
	path = /obj/item/clothing/under/rank/head_of_security/navyblue
	allowed_roles = list("Head of Security")

/datum/gear/uniform/whitedress
	display_name = "Civilian White Wedding Dress"
	path = /obj/item/clothing/under/dress/white

/datum/gear/uniform/longdress
	display_name = "Civilian Long Dress"
	path = /obj/item/clothing/under/dress/white2

/datum/gear/uniform/longdress/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/shortplaindress
	display_name = "Civilian Plain Dress"
	path = /obj/item/clothing/under/dress/white3

/datum/gear/uniform/shortplaindress/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/longwidedress
	display_name = "Civilian Long Wide Dress"
	path = /obj/item/clothing/under/dress/white4

/datum/gear/uniform/longwidedress/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/reddress
	display_name = "Civilian Red Dress - Belted"
	path = /obj/item/clothing/under/dress/darkred

/datum/gear/uniform/wedding
	display_name = "Civilian Wedding Dress selection"
	path = /obj/item/clothing/under/wedding

/datum/gear/uniform/wedding/New()
	..()
	var/list/weddings = list()
	for(var/wedding in typesof(/obj/item/clothing/under/wedding))
		var/obj/item/clothing/under/wedding/wedding_type = wedding
		weddings[initial(wedding_type.name)] = wedding_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(weddings, /proc/cmp_text_asc))


/datum/gear/uniform/suit/reallyblack
	display_name = "Civilian Executive Suit"
	path = /obj/item/clothing/under/suit_jacket/really_black

/datum/gear/uniform/skirts
	display_name = "Civilian Executive Skirt"
	path = /obj/item/clothing/under/suit_jacket/female/skirt

/datum/gear/uniform/dresses
	display_name = "Civilian Sailor Dress"
	path = /obj/item/clothing/under/dress/sailordress

/datum/gear/uniform/dresses/eveninggown
	display_name = "Civilian Red Evening Gown"
	path = /obj/item/clothing/under/dress/redeveninggown

/datum/gear/uniform/dresses/maid
	display_name = "Civilian Maid Uniform Selection"
	path = /obj/item/clothing/under/dress/maid

/datum/gear/uniform/dresses/maid/New()
	..()
	var/list/maids = list()
	for(var/maid in typesof(/obj/item/clothing/under/dress/maid))
		var/obj/item/clothing/under/dress/maid/maid_type = maid
		maids[initial(maid_type.name)] = maid_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(maids, /proc/cmp_text_asc))

/datum/gear/uniform/utility
	display_name = "Civilian Utility - Black"
	path = /obj/item/clothing/under/utility

/datum/gear/uniform/utility/blue
	display_name = "Civilian Utility - Blue"
	path = /obj/item/clothing/under/utility/blue

/datum/gear/uniform/utility/grey
	display_name = "Civilian Utility - Grey"
	path = /obj/item/clothing/under/utility/grey

/datum/gear/uniform/sweater
	display_name = "Civilian Sweater - Grey"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater

/datum/gear/uniform/brandsuit/aether
	display_name = "Civilian Jumpsuit - Aether"
	path = /obj/item/clothing/under/aether

/datum/gear/uniform/brandsuit/focal
	display_name = "Civilian Jumpsuit - Focal"
	path = /obj/item/clothing/under/focal

/datum/gear/uniform/mbill
	display_name = "Civilian Outfit - Major Bill's"
	path = /obj/item/clothing/under/mbill

/datum/gear/uniform/pcrc
	display_name = "Security Uniform - PCRC"
	path = /obj/item/clothing/under/pcrc
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/brandsuit/grayson
	display_name = "Civilian Outfit - Grayson"
	path = /obj/item/clothing/under/grayson

/datum/gear/uniform/brandsuit/wardt
	display_name = "Civilian Jumpsuit - Ward-Takahashi"
	path = /obj/item/clothing/under/wardt

/datum/gear/uniform/frontier
	display_name = "Civilian Outfit - Frontier"
	path = 	/obj/item/clothing/under/frontier

/datum/gear/uniform/brandsuit/hephaestus
	display_name = "Civilian Jumpsuit - Hephaestus"
	path = 	/obj/item/clothing/under/hephaestus

/datum/gear/uniform/yogapants
	display_name = "Civilian Yoga Pants"
	path = /obj/item/clothing/under/pants/yogapants

/datum/gear/uniform/yogapants/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/black_corset
	display_name = "Civilian Black Corset"
	path = /obj/item/clothing/under/dress/black_corset

/datum/gear/uniform/flower_dress
	display_name = "Civilian Flower Dress"
	path = /obj/item/clothing/under/dress/flower_dress

/datum/gear/uniform/red_swept_dress
	display_name = "Civilian Red Swept Dress"
	path = /obj/item/clothing/under/dress/red_swept_dress

/datum/gear/uniform/bathrobe
	display_name = "Civilian Bathrobe"
	path = /obj/item/clothing/under/bathrobe

/datum/gear/uniform/flamenco
	display_name = "Civilian Flamenco Dress"
	path = /obj/item/clothing/under/dress/flamenco

/datum/gear/uniform/westernbustle
	display_name = "Civilian Western Bustle"
	path = /obj/item/clothing/under/dress/westernbustle

/datum/gear/uniform/circuitry
	display_name = "Civilian Jumpsuit - Circuitry"
	path = /obj/item/clothing/under/circuitry
// NEW UNIFORMS BEGIN HERE
/datum/gear/uniform/sifguard
	display_name = "Civilian Uniform - Crew"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew

/datum/gear/uniform/sifguard/medical
	display_name = "Medical Uniform - Crew"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Field Medic")

/datum/gear/uniform/sifguard/science
	display_name = "Science Uniform - Crew"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/research
	allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist")

/datum/gear/uniform/sifguard/engineering
	display_name = "Engineering Uniform - Crew"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/uniform/sifguard/supply
	display_name = "Cargo Uniform - Crew"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/supply
	allowed_roles = list("Quartermaster","Cargo Technician","Shaft Miner")

/datum/gear/uniform/sifguard/security
	display_name = "Security Uniform - Crew"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/security
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/uniform/sifguard/command
	display_name = "Command Uniform - Crew"
	path = /obj/item/clothing/under/solgov/utility/sifguard/officer/crew
	allowed_roles = list("Head of Security","Facility Director","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Command Secretary")

/datum/gear/uniform/fleet/medical
	display_name = "Medical Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Field Medic")


/datum/gear/uniform/fleet/science
	display_name = "Science Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/exploration
	allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist")


/datum/gear/uniform/fleet/engineering
	display_name = "Engineering Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/uniform/fleet/supply
	display_name = "Cargo Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/supply
	allowed_roles = list("Quartermaster","Cargo Technician","Shaft Miner")

/datum/gear/uniform/fleet/security
	display_name = "Security Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/security
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/uniform/fleet/command
	display_name = "Command Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/command
	allowed_roles = list("Head of Security","Facility Director","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Command Secretary")

/datum/gear/uniform/marine/medical
	display_name = "Medical Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Field Medic")

/datum/gear/uniform/marine/science
	display_name = "Science Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/exploration
	allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist")

/datum/gear/uniform/marine/engineering
	display_name = "Engineering Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/uniform/marine/supply
	display_name = "Cargo Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/supply
	allowed_roles = list("Quartermaster","Cargo Technician","Shaft Miner")

/datum/gear/uniform/marine/security
	display_name = "Security Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/security
	cost = 2
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/uniform/marine/command
	display_name = "Command Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/command
	allowed_roles = list("Head of Security","Facility Director","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Command Secretary")

/datum/gear/uniform/marine/green
	display_name = "Civilian Uniform - Green Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/green

/datum/gear/uniform/marine/tan
	display_name = "Civilian Uniform - Tan Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/tan
/datum/gear/uniform/sleekoverall
	display_name = "Civilian Overalls - Sleek"
	path = /obj/item/clothing/under/overalls/sleek

/datum/gear/uniform/sarired
	display_name = "Civilian Sari - Red"
	path = /obj/item/clothing/under/dress/sari

/datum/gear/uniform/sarigreen
	display_name = "Civilian Sari - Green"
	path = /obj/item/clothing/under/dress/sari/green

/datum/gear/uniform/wrappedcoat
	display_name = "Civilian Modern Wrapped Coat"
	path = /obj/item/clothing/under/moderncoat

/datum/gear/uniform/ascetic
	display_name = "Civilian Plain Ascetic Garb"
	path = /obj/item/clothing/under/ascetic

/datum/gear/uniform/pleated
	display_name = "Civilian Pleated Skirt"
	path = /obj/item/clothing/under/skirt/pleated

/datum/gear/uniform/pleated/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/lilacdress
	display_name = "Civilian Lilac Dress"
	path = /obj/item/clothing/under/dress/lilacdress

/datum/gear/uniform/stripeddress
	display_name = "Civilian Striped Dress"
	path = /obj/item/clothing/under/dress/stripeddress

/datum/gear/uniform/festivedress
	display_name = "Civilian Festive Dress"
	path = /obj/item/clothing/under/festivedress

/datum/gear/uniform/haltertop
	display_name = "Civilian Halter Top"
	path = /obj/item/clothing/under/haltertop

/datum/gear/uniform/littleblackdress
	display_name = "Civilian Little Black Dress"
	path = /obj/item/clothing/under/littleblackdress

/datum/gear/uniform/bridgeofficer
	display_name = "Bridge Officer Uniform"
	path = /obj/item/clothing/under/bridgeofficer
	allowed_roles = list("Command Secretary")

/datum/gear/uniform/paramedunidark
	display_name = "Paramedic Uniform - Dark"
	path = /obj/item/clothing/under/paramedunidark
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/uniform/parameduniskirtdark
	display_name = "Paramedic Skirt - Dark"
	path = /obj/item/clothing/under/parameduniskirtdark
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/uniform/suit/bartenderbtc
	display_name = "Bartender Uniform - BTC"
	path = /obj/item/clothing/under/btcbartender
	allowed_roles = list("Bartender")

/datum/gear/uniform/paramedunilight
	display_name = "Paramedic Uniform - Light"
	path = /obj/item/clothing/under/paramedunilight
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/uniform/parameduniskirtdark
	display_name = "Paramedic Skirt - Light"
	path = /obj/item/clothing/under/parameduniskirtlight
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

datum/gear/uniform/dutchsuit
	display_name = "Civilian Western Suit"
	path = /obj/item/clothing/under/dutchuniform

datum/gear/uniform/victorianredshirt
	display_name = "Civilian Red Shirt Victorian Suit"
	path = /obj/item/clothing/under/victorianblred

datum/gear/uniform/victorianredvest
	display_name = "Civilian Red Vested Victorian Suit"
	path = /obj/item/clothing/under/victorianredvest

datum/gear/uniform/victoriansuit
	display_name = "Civilian Victorian Suit"
	path = /obj/item/clothing/under/victorianvest

datum/gear/uniform/victorianbluesuit
	display_name = "Civilian Blue Shirted Victorian Suit"
	path = /obj/item/clothing/under/victorianlightfire

datum/gear/uniform/victorianreddress
	display_name = "Civilian Victorian Red Dress"
	path = /obj/item/clothing/under/victorianreddress

datum/gear/uniform/victorianblackdress
	display_name = "Civilian Victorian Black Dress"
	path = /obj/item/clothing/under/victorianblackdress

datum/gear/uniform/bridgeofficer
	display_name = "Bridge Officer Skirt"
	path = /obj/item/clothing/under/bridgeofficerskirt
	allowed_roles = list("Command Secretary")

datum/gear/uniform/fiendsuit
	display_name = "Civilian Fiendish Suit"
	path = /obj/item/clothing/under/fiendsuit

datum/gear/uniform/fienddress
	display_name = "Civilian Fiendish Dress"
	path = /obj/item/clothing/under/fienddress

datum/gear/uniform/leotard
	display_name = "Civilian Black Leotard"
	path = /obj/item/clothing/under/leotard

datum/gear/uniform/leotardcolor
	display_name = "Civilian Colored Leotard"
	path = /obj/item/clothing/under/leotardcolor

/datum/gear/uniform/leotardcolor/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

datum/gear/uniform/verglasdress
	display_name = "Civilian Verglas Dress"
	path = /obj/item/clothing/under/verglasdress

datum/gear/uniform/fashionminiskirt
	display_name = "Civilian Fashionable Miniskirt"
	path = /obj/item/clothing/under/fashionminiskirt

/datum/gear/uniform/fashionminiskirt/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

datum/gear/uniform/bodysuiteva
	display_name = "Civilian EVA Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuiteva

datum/gear/uniform/bodysuitemt
	display_name = "Medical Bodysuit EMT"
	path = /obj/item/clothing/under/bodysuit/bodysuitemt
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")


datum/gear/uniform/bodysuitexplocom
	display_name = "Exploration Command Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitexplocom
	allowed_roles = list("Research Director","Pathfinder")

datum/gear/uniform/bodysuitexplo
	display_name = "Exploration Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitexplo
	allowed_roles = list("Reasearch Director","Pathfinder","Scientist","Roboticist","Xenobiologist","Explorer","Search and Rescue")

datum/gear/uniform/bodysuitminer
	display_name = "Mining Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitminer
	allowed_roles = list("Cargo Technician","Shaft Miner")

datum/gear/uniform/bodysuithazard
	display_name = "Engineering Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuithazard
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Shaft Miner")

datum/gear/uniform/bodysuitsec
	display_name = "Security Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitsec
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

datum/gear/uniform/bodysuitseccom
	display_name = "Security Command Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitseccom
	allowed_roles = list("Head of Security","Warden")

datum/gear/uniform/bodysuitcommand
	display_name = "Command Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitcommand
	allowed_roles = list("Head of Security","Facility Director","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

// And after nearly successfully hanging myself, this is where the real game begins
/datum/gear/uniform/future_fashion_light_blue_striped
	display_name = "Futuristic Light Blue-Striped Jumpsuit"
	path = /obj/item/clothing/under/future_fashion_light_blue_striped

/datum/gear/uniform/future_fashion_dark_blue_striped
	display_name = "Futuristic Dark Blue-Striped Jumpsuit"
	path = /obj/item/clothing/under/future_fashion_dark_blue_striped

/datum/gear/uniform/future_fashion_red_striped
	display_name = "Futuristic Red-Striped Jumpsuit"
	path = /obj/item/clothing/under/future_fashion_red_striped

/datum/gear/uniform/future_fashion_green_striped
	display_name = "Futuristic Green-Striped Jumpsuit"
	path = /obj/item/clothing/under/future_fashion_green_striped

/datum/gear/uniform/future_fashion_orange_striped
	display_name = "Futuristic Orange-Striped Jumpsuit"
	path = /obj/item/clothing/under/future_fashion_orange_striped

/datum/gear/uniform/future_fashion_purple_striped
	display_name = "Futuristic Purple-Striped Jumpsuit"
	path = /obj/item/clothing/under/future_fashion_purple_striped

/datum/gear/uniform/suit/permit
	display_name = "Civilian Nudity Permit"
	path = /obj/item/clothing/under/permit
/*
// Polaris overrides
/datum/gear/uniform/solgov/pt/sifguard
	display_name = "pt uniform, planetside sec"
	path = /obj/item/clothing/under/solgov/pt/sifguard
*/


/*
Swimsuits
*/

/datum/gear/uniform/swimsuits
	display_name = "Swimsuits Selection"
	path = /obj/item/storage/box/fluff/swimsuit

/datum/gear/uniform/swimsuits/New()
	..()
	var/list/swimsuits = list()
	for(var/swimsuit in typesof(/obj/item/storage/box/fluff/swimsuit))
		var/obj/item/storage/box/fluff/swimsuit/swimsuit_type = swimsuit
		swimsuits[initial(swimsuit_type.name)] = swimsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(swimsuits, /proc/cmp_text_asc))

/datum/gear/uniform/suit/gnshorts
	display_name = "Civilian GN Shorts"
	path = /obj/item/clothing/under/fluff/gnshorts

// Latex maid dress
/datum/gear/uniform/latexmaid
	display_name = "Civilian Latex Maid Dress"
	path = /obj/item/clothing/under/fluff/latexmaid

//Tron Siren outfit
/datum/gear/uniform/siren
	display_name = "Civilian Jumpsuit - Siren"
	path = /obj/item/clothing/under/fluff/siren

/datum/gear/uniform/suit/v_nanovest
	display_name = "Civilian Varmacorp Nanovest"
	path = /obj/item/clothing/under/fluff/v_nanovest

// Uniform slot
/datum/gear/uniform/pilot
	display_name = "Pilot Uniform"
	path = /obj/item/clothing/under/rank/pilot2
	allowed_roles = list("Pilot")

/datum/gear/uniform/uniform_janitor_starcon
	display_name = "Janitor Jumpsuit - Alt"
	path = /obj/item/clothing/under/rank/janitor/starcon
	allowed_roles = list("Janitor")
