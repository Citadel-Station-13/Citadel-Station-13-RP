// Uniform slot
/datum/loadout_entry/uniform/
	name = "Blazer - Blue"
	path = /obj/item/clothing/under/blazer
	slot = SLOT_ID_UNIFORM
	sort_category = LOADOUT_CATEGORY_UNIFORMS

/datum/loadout_entry/uniform/blazer_skirt
	name = "Blazer - Skirt "
	path = /obj/item/clothing/under/blazer/skirt

/datum/loadout_entry/uniform/cheongsam
	name = "Cheongsam Selection"
	description = "Various color variations of an old earth dress style. They are pretty close fitting around the waist."

/datum/loadout_entry/uniform/cheongsam/New()
	..()
	var/list/cheongsams = list()
	for(var/cheongsam in typesof(/obj/item/clothing/under/cheongsam))
		var/obj/item/clothing/under/cheongsam/cheongsam_type = cheongsam
		cheongsams[initial(cheongsam_type.name)] = cheongsam_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(cheongsams, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/cheongsam_male
	name = "Cheongsam (Male) - Black"
	path = /obj/item/clothing/under/cheong

/datum/loadout_entry/uniform/cheongsam_male/white
	name = "Cheongsam (Male) - White"
	path = /obj/item/clothing/under/cheong/white

/datum/loadout_entry/uniform/cheongsam_male/red
	name = "Cheongsam (Male) - Red"
	path = /obj/item/clothing/under/cheong/red

/datum/loadout_entry/uniform/qipao
	name = "Qipao"
	path = /obj/item/clothing/under/qipao

/datum/loadout_entry/uniform/qipao/white
	name = "Qipao - White"
	path = /obj/item/clothing/under/qipao/white

/datum/loadout_entry/uniform/qipao/red
	name = "Qipao - Red"
	path = /obj/item/clothing/under/qipao/red

/datum/loadout_entry/uniform/croptop
	name = "Croptop Selection"
	description = "Light shirts which shows the midsection of the wearer."

/datum/loadout_entry/uniform/croptop/New()
	..()
	var/list/croptops = list()
	for(var/croptop in typesof(/obj/item/clothing/under/croptop))
		var/obj/item/clothing/under/croptop/croptop_type = croptop
		croptops[initial(croptop_type.name)] = croptop_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(croptops, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/kilt
	name = "Kilt"
	path = /obj/item/clothing/under/kilt

/datum/loadout_entry/uniform/cuttop
	name = "Cut Top - Grey"
	path = /obj/item/clothing/under/cuttop

/datum/loadout_entry/uniform/cuttop/red
	name = "Cut Top - Red"
	path = /obj/item/clothing/under/cuttop/red

/datum/loadout_entry/uniform/jumpsuit
	name = "Jumpclothes Selection"
	path = /obj/item/clothing/under/color/grey

/datum/loadout_entry/uniform/jumpsuit/New()
	..()
	var/list/jumpclothes = list()
	for(var/jump in typesof(/obj/item/clothing/under/color))
		var/obj/item/clothing/under/color/jumps = jump
		jumpclothes[initial(jumps.name)] = jumps
	tweaks += new/datum/loadout_tweak/path(tim_sort(jumpclothes, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/blueshortskirt
	name = "Short Skirt"
	path = /obj/item/clothing/under/blueshortskirt

/datum/loadout_entry/uniform/skirt
	name = "Skirts Selection"
	path = /obj/item/clothing/under/skirt

/datum/loadout_entry/uniform/skirt/New()
	..()
	var/list/skirts = list()
	for(var/skirt in (typesof(/obj/item/clothing/under/skirt)))
		var/obj/item/clothing/under/skirt/skirt_type = skirt
		skirts[initial(skirt_type.name)] = skirt_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(skirts, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/pants
	name = "Pants Selection"
	path = /obj/item/clothing/under/pants/white

/datum/loadout_entry/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(pants, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/shorts
	name = "Shorts Selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/loadout_entry/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(shorts, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/suit/lawyer
	name = "Suit One-Piece Selection"
	path = /obj/item/clothing/under/lawyer

/datum/loadout_entry/uniform/suit/lawyer/New()
	..()
	var/list/lsuits = list()
	for(var/lsuit in typesof(/obj/item/clothing/under/lawyer))
		var/obj/item/clothing/suit/lsuit_type = lsuit
		lsuits[initial(lsuit_type.name)] = lsuit_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(lsuits, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/suit/suit_jacket
	name = "Suit Modular Selection"
	path = /obj/item/clothing/under/suit_jacket

/datum/loadout_entry/uniform/suit/suit_jacket/New()
	..()
	var/list/msuits = list()
	for(var/msuit in typesof(/obj/item/clothing/under/suit_jacket))
		var/obj/item/clothing/suit/msuit_type = msuit
		msuits[initial(msuit_type.name)] = msuit_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(msuits, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/suit/amish
	name = "Suit - Amish"
	path = /obj/item/clothing/under/sl_suit

/datum/loadout_entry/uniform/suit/gentle
	name = "Suit - Gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/loadout_entry/uniform/suit/gentleskirt
	name = "Suit - Lady"
	path = /obj/item/clothing/under/gentlesuit/skirt

/datum/loadout_entry/uniform/suit/white
	name = "Suit - White"
	path = /obj/item/clothing/under/scratch

/datum/loadout_entry/uniform/suit/whiteskirt
	name = "Suit - White Skirt"
	path = /obj/item/clothing/under/scratch/skirt

/datum/loadout_entry/uniform/scrub
	name = "Scrubs Selection"
	path = /obj/item/clothing/under/rank/medical/scrubs

/datum/loadout_entry/uniform/scrub/New()
	..()
	var/list/scrubs = list()
	for(var/scrub in typesof(/obj/item/clothing/under/rank/medical/scrubs))
		var/obj/item/clothing/under/rank/medical/scrubs/scrub_type = scrub
		scrubs[initial(scrub_type.name)] = scrub_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(scrubs, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/scrub_fem
	name = "Scrubs Selection - Female"
	path = /obj/item/clothing/under/rank/medical/scrubs_fem

/datum/loadout_entry/uniform/scrub_fem/New()
	..()
	var/list/scrubs_fem = list()
	for(var/scrub_fem in typesof(/obj/item/clothing/under/rank/medical/scrubs_fem))
		var/obj/item/clothing/under/rank/medical/scrubs_fem/scrub_type = scrub_fem
		scrubs_fem[initial(scrub_type.name)] = scrub_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(scrubs_fem, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/oldwoman
	name = "Old Woman Attire"
	path = /obj/item/clothing/under/oldwoman

/datum/loadout_entry/uniform/sundress
	name = "Sundress"
	path = /obj/item/clothing/under/sundress

/datum/loadout_entry/uniform/sundress/white
	name = "Sundress - White"
	path = /obj/item/clothing/under/sundress_white

/datum/loadout_entry/uniform/turtlebaggy_selection
	name = "Baggy Turtleneck Selection"
	path = /obj/item/clothing/under/turtlebaggy

/datum/loadout_entry/uniform/turtlebaggy_selection/New()
	..()
	var/list/turtlebaggy_selection = list()
	for(var/turtlebaggy in typesof(/obj/item/clothing/under/turtlebaggy))
		var/obj/item/clothing/under/turtlebaggy_type = turtlebaggy
		turtlebaggy_selection[initial(turtlebaggy_type.name)] = turtlebaggy_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(turtlebaggy_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/pentagramdress
	name = "Pentagram Dress"
	path = /obj/item/clothing/under/pentagramdress

/datum/loadout_entry/uniform/dress_fire
	name = "Flame Dress"
	path = /obj/item/clothing/under/dress/dress_fire

/datum/loadout_entry/uniform/whitedress
	name = "White Wedding Dress"
	path = /obj/item/clothing/under/dress/white

/datum/loadout_entry/uniform/longdress
	name = "Long Dress"
	path = /obj/item/clothing/under/dress/white2

/datum/loadout_entry/uniform/shortplaindress
	name = "Plain Dress"
	path = /obj/item/clothing/under/dress/white3

/datum/loadout_entry/uniform/longwidedress
	name = "Long Wide Dress"
	path = /obj/item/clothing/under/dress/white4

/datum/loadout_entry/uniform/reddress
	name = "Red Dress - Belted"
	path = /obj/item/clothing/under/dress/darkred

/datum/loadout_entry/uniform/wedding
	name = "Wedding Dress Selection"
	path = /obj/item/clothing/under/wedding

/datum/loadout_entry/uniform/wedding/New()
	..()
	var/list/weddings = list()
	for(var/wedding in typesof(/obj/item/clothing/under/wedding))
		var/obj/item/clothing/under/wedding/wedding_type = wedding
		weddings[initial(wedding_type.name)] = wedding_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(weddings, /proc/cmp_text_asc))


/datum/loadout_entry/uniform/suit/reallyblack
	name = "Executive Suit"
	path = /obj/item/clothing/under/suit_jacket/really_black

/datum/loadout_entry/uniform/skirts
	name = "Executive Skirt"
	path = /obj/item/clothing/under/suit_jacket/female/skirt

/datum/loadout_entry/uniform/dresses
	name = "Sailor Dress"
	path = /obj/item/clothing/under/dress/sailordress

/datum/loadout_entry/uniform/dresses/eveninggown
	name = "Red Evening Gown"
	path = /obj/item/clothing/under/dress/redeveninggown

/datum/loadout_entry/uniform/dresses/maid
	name = "Maid Uniform Selection"
	path = /obj/item/clothing/under/dress/maid

/datum/loadout_entry/uniform/dresses/maid/New()
	..()
	var/list/maids = list()
	for(var/maid in typesof(/obj/item/clothing/under/dress/maid))
		var/obj/item/clothing/under/dress/maid/maid_type = maid
		maids[initial(maid_type.name)] = maid_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(maids, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/utility
	name = "Utility - Black"
	path = /obj/item/clothing/under/utility

/datum/loadout_entry/uniform/utility/blue
	name = "Utility - Blue"
	path = /obj/item/clothing/under/utility/blue

/datum/loadout_entry/uniform/utility/grey
	name = "Utility - Grey"
	path = /obj/item/clothing/under/utility/grey

/datum/loadout_entry/uniform/sweater
	name = "Sweater - Grey"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater

/datum/loadout_entry/uniform/brandjumpsuit_selection
	name = "Branded Jumpsuit Selection"
	path = /obj/item/clothing/under/brandjumpsuit/aether

/datum/loadout_entry/uniform/brandjumpsuit_selection/New()
	..()
	var/list/brandjumpsuit_selection = list()
	for(var/brandjumpsuit in typesof(/obj/item/clothing/under/brandjumpsuit))
		var/obj/item/clothing/under/brandjumpsuit_type = brandjumpsuit
		brandjumpsuit_selection[initial(brandjumpsuit_type.name)] = brandjumpsuit_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(brandjumpsuit_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/yogapants
	name = "Yoga Pants"
	path = /obj/item/clothing/under/pants/yogapants

/datum/loadout_entry/uniform/black_corset
	name = "Black Corset"
	path = /obj/item/clothing/under/dress/black_corset

/datum/loadout_entry/uniform/flower_dress
	name = "Flower Dress"
	path = /obj/item/clothing/under/dress/flower_dress

/datum/loadout_entry/uniform/red_swept_dress
	name = "Red Swept Dress"
	path = /obj/item/clothing/under/dress/red_swept_dress

/datum/loadout_entry/uniform/bathrobe
	name = "Bathrobe"
	path = /obj/item/clothing/under/bathrobe

/datum/loadout_entry/uniform/flamenco
	name = "Flamenco Dress"
	path = /obj/item/clothing/under/dress/flamenco

/datum/loadout_entry/uniform/westernbustle
	name = "Western Bustle"
	path = /obj/item/clothing/under/dress/westernbustle

/datum/loadout_entry/uniform/circuitry
	name = "Jumpsuit - Circuitry"
	path = /obj/item/clothing/under/circuitry

/datum/loadout_entry/uniform/sysguard
	name = "Uniform - Crew"
	path = /obj/item/clothing/under/oricon/utility/sysguard/crew

/datum/loadout_entry/uniform/marine/green
	name = "Uniform - Green Fatigues"
	path = /obj/item/clothing/under/oricon/utility/marine/green

/datum/loadout_entry/uniform/marine/tan
	name = "Uniform - Tan Fatigues"
	path = /obj/item/clothing/under/oricon/utility/marine/tan

/datum/loadout_entry/uniform/overalls
	name = "Overalls"
	path = /obj/item/clothing/under/overalls

/datum/loadout_entry/uniform/overalls_fem
	name = "Overalls - Female"
	path = /obj/item/clothing/under/overalls_fem

/datum/loadout_entry/uniform/sleekoverall
	name = "Overalls - Sleek"
	path = /obj/item/clothing/under/overalls/sleek

/datum/loadout_entry/uniform/sleekoverall_fem
	name = "Overalls - Sleek - Female"
	path = /obj/item/clothing/under/overalls/sleek_fem

/datum/loadout_entry/uniform/sarired
	name = "Sari - Red"
	path = /obj/item/clothing/under/dress/sari

/datum/loadout_entry/uniform/sarigreen
	name = "Sari - Green"
	path = /obj/item/clothing/under/dress/sari/green

/datum/loadout_entry/uniform/kamishimo
	name = "Kamishimo"
	path = /obj/item/clothing/under/kamishimo

/datum/loadout_entry/uniform/kimono
	name = "Kimono - Plain"
	path = /obj/item/clothing/under/kimono

/datum/loadout_entry/uniform/kimono_black
	name = "Kimono - Black"
	path = /obj/item/clothing/under/kimono_black

/datum/loadout_entry/uniform/kimono_sakura
	name = "Kimono - Sakura"
	path = /obj/item/clothing/under/kimono_sakura

/datum/loadout_entry/uniform/kimono_fancy
	name = "Kimono - Festival"
	path = /obj/item/clothing/under/kimono_fancy

/datum/loadout_entry/uniform/kimono_selection
	name = "Kimono Selection"
	description = "Colorful variants of the basic kimono. Stylish and comfy!"

/datum/loadout_entry/uniform/kimono_selection/New()
	..()
	var/list/kimonos = list()
	for(var/kimono in typesof(/obj/item/clothing/under/kimono))
		var/obj/item/clothing/under/kimono/kimono_type = kimono
		kimonos[initial(kimono_type.name)] = kimono_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(kimonos, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/pyjamas_red
	name = "Pyjamas - Red"
	path = /obj/item/clothing/under/redpyjamas

/datum/loadout_entry/uniform/pyjamas_blue
	name = "Pyjamas - Blue"
	path = /obj/item/clothing/under/bluepyjamas

/datum/loadout_entry/uniform/pyjamas_red_fem
	name = "Pyjamas - Red - Female"
	path = /obj/item/clothing/under/redpyjamas_fem

/datum/loadout_entry/uniform/pyjamas_blue_fem
	name = "Pyjamas - Blue - Female"
	path = /obj/item/clothing/under/bluepyjamas_fem

/datum/loadout_entry/uniform/wrappedcoat
	name = "Modern Wrapped Coat"
	path = /obj/item/clothing/under/moderncoat

/datum/loadout_entry/uniform/ascetic
	name = "Plain Ascetic Garb"
	path = /obj/item/clothing/under/ascetic

/datum/loadout_entry/uniform/ascetic_fem
	name = "Plain Ascetic Garb - Female"
	path = /obj/item/clothing/under/ascetic_fem

/datum/loadout_entry/uniform/pleated
	name = "Pleated Skirt"
	path = /obj/item/clothing/under/skirt/pleated

/datum/loadout_entry/uniform/lilacdress
	name = "Lilac Dress"
	path = /obj/item/clothing/under/dress/lilacdress

/datum/loadout_entry/uniform/stripeddress
	name = "Striped Dress"
	path = /obj/item/clothing/under/dress/stripeddress

/datum/loadout_entry/uniform/festivedress
	name = "Festive Dress"
	path = /obj/item/clothing/under/festivedress

/datum/loadout_entry/uniform/haltertop
	name = "Halter Top"
	path = /obj/item/clothing/under/haltertop

/datum/loadout_entry/uniform/littleblackdress
	name = "Little Black Dress"
	path = /obj/item/clothing/under/littleblackdress

/datum/loadout_entry/uniform/dutchsuit
	name = "Western Suit"
	path = /obj/item/clothing/under/dutchuniform

/datum/loadout_entry/uniform/victorianredshirt
	name = "Red Shirted Victorian Suit"
	path = /obj/item/clothing/under/victorianblred

/datum/loadout_entry/uniform/victorianredshirt/female
	name = "Red Shirted Victorian Suit - Female"
	path = /obj/item/clothing/under/fem_victorianblred

/datum/loadout_entry/uniform/victorianredvest
	name = "Red Vested Victorian Suit"
	path = /obj/item/clothing/under/victorianredvest

/datum/loadout_entry/uniform/victorianredvest/female
	name = "Red Vested Victorian Suit - Female"
	path = /obj/item/clothing/under/fem_victorianredvest

/datum/loadout_entry/uniform/victoriansuit
	name = "Victorian Suit"
	path = /obj/item/clothing/under/victorianvest

/datum/loadout_entry/uniform/victoriansuit/female
	name = "Victorian Suit - Female"
	path = /obj/item/clothing/under/fem_victorianvest

/datum/loadout_entry/uniform/victorianbluesuit
	name = "Blue Shirted Victorian Suit"
	path = /obj/item/clothing/under/victorianlightfire

/datum/loadout_entry/uniform/victorianbluesuit/female
	name = "Blue Shirted Victorian Suit - Female"
	path = /obj/item/clothing/under/fem_victorianlightfire

/datum/loadout_entry/uniform/victorianreddress
	name = "Victorian Red Dress"
	path = /obj/item/clothing/under/victorianreddress

/datum/loadout_entry/uniform/victorianblackdress
	name = "Victorian Black Dress"
	path = /obj/item/clothing/under/victorianblackdress

/datum/loadout_entry/uniform/fiendsuit
	name = "Fiendish Suit"
	path = /obj/item/clothing/under/fiendsuit

/datum/loadout_entry/uniform/fienddress
	name = "Fiendish Dress"
	path = /obj/item/clothing/under/fienddress

/datum/loadout_entry/uniform/leotard
	name = "Black Leotard"
	path = /obj/item/clothing/under/leotard

/datum/loadout_entry/uniform/leotardcolor
	name = "Colored Leotard"
	path = /obj/item/clothing/under/leotardcolor

/datum/loadout_entry/uniform/verglasdress
	name = "Verglas Dress"
	path = /obj/item/clothing/under/verglasdress

/datum/loadout_entry/uniform/fashionminiskirt
	name = "Fashionable Miniskirt"
	path = /obj/item/clothing/under/fashionminiskirt

/datum/loadout_entry/uniform/bodysuit
	name = "Standard Bodysuit"
	path = /obj/item/clothing/under/bodysuit

/datum/loadout_entry/uniform/bodysuit_fem
	name = "Standard Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit_fem

/datum/loadout_entry/uniform/bodysuiteva
	name = "EVA Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuiteva

/datum/loadout_entry/uniform/bodysuiteva_fem
	name = "EVA Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuiteva_fem

/datum/loadout_entry/uniform/future_fashion_selection
	name = "Futuristic Striped Jumpsuit Selection"
	path = /obj/item/clothing/under/future_fashion

/datum/loadout_entry/uniform/future_fashion_selection/New()
	..()
	var/list/future_fashion_selection = list()
	for(var/future_fashion in typesof(/obj/item/clothing/under/future_fashion))
		var/obj/item/clothing/under/future_fashion/future_fashion_type = future_fashion
		future_fashion_selection[initial(future_fashion_type.name)] = future_fashion_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(future_fashion_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/suit/permit
	name = "Nudity Permit"
	path = /obj/item/clothing/under/permit


/*
Swimsuits
*/

/datum/loadout_entry/uniform/swimsuits
	name = "Swimsuit Selection"
	path = /obj/item/clothing/under/swimsuit

/datum/loadout_entry/uniform/swimsuits/New()
	..()
	var/list/swimsuits = list()
	for(var/swimsuit in typesof(/obj/item/clothing/under/swimsuit))
		var/obj/item/clothing/under/swimsuit/swimsuit_type = swimsuit
		swimsuits[initial(swimsuit_type.name)] = swimsuit_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(swimsuits, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/suit/gnshorts
	name = "GN Shorts"
	path = /obj/item/clothing/under/fluff/gnshorts

// Latex maid dress
/datum/loadout_entry/uniform/latexmaid
	name = "Latex Maid Dress"
	path = /obj/item/clothing/under/fluff/latexmaid

//Tron Siren outfit
/datum/loadout_entry/uniform/siren
	name = "Jumpsuit - Siren"
	path = /obj/item/clothing/under/fluff/siren

/datum/loadout_entry/uniform/suit/v_nanovest
	name = "Varmacorp Nanovest"
	path = /obj/item/clothing/under/fluff/v_nanovest

/datum/loadout_entry/uniform/greyskirt_female
	name = "Grey Skirt"
	path = /obj/item/clothing/under/greyskirt_female

/datum/loadout_entry/uniform/highwayman_clothes
	name = "Highwayman Outfit"
	path = /obj/item/clothing/under/highwayman_clothes

/datum/loadout_entry/uniform/highwayman_clothes_fem
	name = "Highwayman Outfit - Female"
	path = /obj/item/clothing/under/highwayman_clothes_fem

/datum/loadout_entry/uniform/businessskirt
	name = "Business Skirt"
	path = /obj/item/clothing/under/businessskirt_female

/datum/loadout_entry/uniform/simpledress
	name = "Simple Dress"
	path = /obj/item/clothing/under/simpledress

/datum/loadout_entry/uniform/formalredcoat
	name = "Formal Coat - Red"
	path = /obj/item/clothing/under/redcoatformal

/datum/loadout_entry/uniform/vice
	name = "Vice Officers Jumpsuit"
	path = /obj/item/clothing/under/rank/vice

/datum/loadout_entry/uniform/saare
	name = "SAARE Uniform"
	path = /obj/item/clothing/under/saare

/datum/loadout_entry/uniform/saare_fem
	name = "SAARE Uniform - Female"
	path = /obj/item/clothing/under/saare_fem

/datum/loadout_entry/uniform/hawaiianpink
	name = "Suit - Pink Hawaiian"
	path = /obj/item/clothing/under/hawaiian

/datum/loadout_entry/uniform/geisha
	name = "Geisha Outfit"
	path = /obj/item/clothing/under/geisha

/datum/loadout_entry/uniform/blueshift
	name = "Suit - Light Blue"
	path = /obj/item/clothing/under/blueshift

/datum/loadout_entry/uniform/office_worker
	name = "Suit - Office Worker"
	path = /obj/item/clothing/under/office_worker

/datum/loadout_entry/uniform/tracksuit_blue
	name = "Tracksuit - Blue"
	path = /obj/item/clothing/under/tracksuit_blue

/datum/loadout_entry/uniform/tribal_tunic
	name = "Tunic - Simple"
	path = /obj/item/clothing/under/tribal_tunic

/datum/loadout_entry/uniform/tribal_tunic_fem
	name = "Tunic - Simple - Female"
	path = /obj/item/clothing/under/tribal_tunic_fem

/datum/loadout_entry/uniform/druidic_gown
	name = "Tunic - Flowered"
	path = /obj/item/clothing/under/druidic_gown

/datum/loadout_entry/uniform/druidic_gown_fem
	name = "Tunic - Flowered - Female"
	path = /obj/item/clothing/under/druidic_gown_fem

/datum/loadout_entry/uniform/laconic
	name = "Laconic Field Suit"
	path = /obj/item/clothing/under/laconic

/datum/loadout_entry/uniform/bountyskin
	name = "Bounty Hunters Skinsuit"
	path = /obj/item/clothing/under/bountyskin

/datum/loadout_entry/uniform/navy_jumpsuit
	name = "Navy Gray Jumpsuit"
	path = /obj/item/clothing/under/navy_gray

/datum/loadout_entry/uniform/gray_smooth
	name = "Gray Smooth Jumpsuit"
	path = /obj/item/clothing/under/smooth_gray

/datum/loadout_entry/uniform/chiming_dress
	name = "Chiming Dress"
	path = /obj/item/clothing/under/chiming_dress

/datum/loadout_entry/uniform/waiter
	name = "Waiters Outfit"
	path = /obj/item/clothing/under/waiter

/datum/loadout_entry/uniform/waiter_fem
	name = "Waiters Outfit - Female"
	path = /obj/item/clothing/under/waiter_fem

/datum/loadout_entry/uniform/assistantformal
	name = "Assistants Formal Uniform"
	path = /obj/item/clothing/under/assistantformal

/datum/loadout_entry/uniform/assistantformal_fem
	name = "Assistants Formal Uniform - Female"
	path = /obj/item/clothing/under/assistantformal_fem

/datum/loadout_entry/uniform/cropdress
	name = "Cropped Dress"
	path = /obj/item/clothing/under/dress/cropdress

/datum/loadout_entry/uniform/twistdress
	name = "Twisted Dress"
	path = /obj/item/clothing/under/dress/twistdress

/datum/loadout_entry/uniform/antediluvian
	name = "Antediluvian Corset"
	path = /obj/item/clothing/under/antediluvian

/datum/loadout_entry/uniform/antediluvian_dress
	name = "Antediluvian Dress"
	path = /obj/item/clothing/under/antediluvian/dress

/datum/loadout_entry/accessory/antediluvian_gloves_alt
	name = "Antediluvian Bracers Alternate"
	path = /obj/item/clothing/accessory/antediluvian_gloves/alt

/datum/loadout_entry/accessory/antediluvian_socks
	name = "Antediluvian Socks"
	path = /obj/item/clothing/accessory/antediluvian_socks

/datum/loadout_entry/accessory/antediluvian_necklace
	name = "Antediluvian Necklace"
	path = /obj/item/clothing/accessory/antediluvian_necklace

/datum/loadout_entry/accessory/antediluvian_flaps
	name = "Antediluvian Flaps"
	path = /obj/item/clothing/accessory/antediluvian_flaps

/datum/loadout_entry/uniform/hasie
	name = "Hasie Designer Skirt/Vest"
	path = /obj/item/clothing/under/hasie

/datum/loadout_entry/uniform/utility_fur_pants
	name = "Utility Fur Pants"
	path = /obj/item/clothing/under/utility_fur_pants

/datum/loadout_entry/uniform/sitri
	name = "Sitri Striped Sweater"
	path = /obj/item/clothing/under/sitri

/datum/loadout_entry/uniform/halfmoon
	name = "Half Moon Outfit"
	path = /obj/item/clothing/under/half_moon

/datum/loadout_entry/uniform/toga
	name = "Toga"
	path = /obj/item/clothing/under/toga

/datum/loadout_entry/uniform/countess
	name = "Countess Dress"
	path = /obj/item/clothing/under/countess

/datum/loadout_entry/uniform/baroness
	name = "Baroness Dress"
	path = /obj/item/clothing/under/baroness

/datum/loadout_entry/uniform/yoko
	name = "Scavenging Sniper Set"
	path = /obj/item/clothing/under/yoko

/datum/loadout_entry/uniform/kamina
	name = "Spiral Hero Outfit"
	path = /obj/item/clothing/under/kamina

/datum/loadout_entry/uniform/tape
	name = "Body Tape Wrapping"
	path = /obj/item/clothing/under/tape

/datum/loadout_entry/uniform/revealing
	name = "Revealing Cocktail Dress"
	path = /obj/item/clothing/under/revealing

/datum/loadout_entry/uniform/belial
	name = "Belial Striped Shirt and Shorts"
	path = /obj/item/clothing/under/belial

/datum/loadout_entry/uniform/lilin
	name = "Lilin Sash Dress"
	path = /obj/item/clothing/under/lilin

/datum/loadout_entry/uniform/asmodai
	name = "Asmodai Laced Blouse"
	path = /obj/item/clothing/under/asmodai

/datum/loadout_entry/uniform/blackshortsripped
	name = "Ripped Black Shorts"
	path = /obj/item/clothing/under/blackshortsripped

/datum/loadout_entry/uniform/summerdress_selection
	name = "Summer Dress Selection"
	path = /obj/item/clothing/under/dress/summer

/datum/loadout_entry/uniform/summerdress_selection/New()
	..()
	var/list/summerdress_selection = list()
	for(var/summerdress in typesof(/obj/item/clothing/under/dress/summer))
		var/obj/item/clothing/under/summerdress_type = summerdress
		summerdress_selection[initial(summerdress_type.name)] = summerdress_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(summerdress_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/skinsuit_selection
	name = "Skinsuit Selection - Male"
	path = /obj/item/clothing/under/skinsuit

/datum/loadout_entry/uniform/skinsuit_selection/New()
	..()
	var/list/skinsuit_selection = list()
	for(var/skinsuit in typesof(/obj/item/clothing/under/skinsuit))
		var/obj/item/clothing/under/skinsuit_type = skinsuit
		skinsuit_selection[initial(skinsuit_type.name)] = skinsuit_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(skinsuit_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/skinsuitfem_selection
	name = "Skinsuit Selection - Female"
	path = /obj/item/clothing/under/skinsuit_fem

/datum/loadout_entry/uniform/skinsuitfem_selection/New()
	..()
	var/list/skinsuitfem_selection = list()
	for(var/skinsuitfem in typesof(/obj/item/clothing/under/skinsuit_fem))
		var/obj/item/clothing/under/skinsuitfem_type = skinsuitfem
		skinsuitfem_selection[initial(skinsuitfem_type.name)] = skinsuitfem_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(skinsuitfem_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/altbodysuit_selection
	name = "Alternate Bodysuit Selection - Male"
	path = /obj/item/clothing/under/bodysuit/alt

/datum/loadout_entry/uniform/altbodysuit_selection/New()
	..()
	var/list/altbodysuit_selection = list()
	for(var/altbodysuit in typesof(/obj/item/clothing/under/bodysuit/alt))
		var/obj/item/clothing/under/altbodysuit_type = altbodysuit
		altbodysuit_selection[initial(altbodysuit_type.name)] = altbodysuit_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(altbodysuit_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/altbodysuitfem_selection
	name = "Alternate Bodysuit Selection - Female"
	path = /obj/item/clothing/under/bodysuit/alt_fem

/datum/loadout_entry/uniform/altbodysuitfem_selection/New()
	..()
	var/list/altbodysuitfem_selection = list()
	for(var/altbodysuitfem in typesof(/obj/item/clothing/under/bodysuit/alt_fem))
		var/obj/item/clothing/under/altbodysuitfem_type = altbodysuitfem
		altbodysuitfem_selection[initial(altbodysuitfem_type.name)] = altbodysuitfem_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(altbodysuitfem_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/ballet
	name = "Antheia Tutu"
	path = /obj/item/clothing/under/ballet

//Tajaran wears

/datum/loadout_entry/uniform/tajaran/summercloths_selection
	name = "Adhomian summerwear"
	path = /obj/item/clothing/under/tajaran/summer

/datum/loadout_entry/uniform/tajaran/summercloths_selection/New()
	..()
	var/list/summercloths_selection = list()
	for(var/summercloths in (typesof(/obj/item/clothing/under/tajaran/summer)))
		var/obj/item/clothing/under/summercloths_type = summercloths
		summercloths_selection[initial(summercloths_type.name)] = summercloths_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(summercloths_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/tajaran/tajara_dress_selection
	name = "Adhomian dresses selection"
	description = "A selection of tajaran native dresses."
	path = /obj/item/clothing/under/dress/tajaran

/datum/loadout_entry/uniform/tajaran/tajara_dress_selection/New()
	..()
	var/list/tajara_dress_selection = list()
	for(var/tajara_dress in (typesof(/obj/item/clothing/under/dress/tajaran)))
		var/obj/item/clothing/under/dress/tajaran/tajara_dress_type = tajara_dress
		tajara_dress_selection[initial(tajara_dress_type.name)] = tajara_dress_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(tajara_dress_selection, /proc/cmp_text_asc))

/datum/loadout_entry/uniform/tajaran/laborer
	name = "Generic Adhomian laborer clothes"
	path = /obj/item/clothing/under/tajaran

/datum/loadout_entry/uniform/tajaran/machinist
	name = "Adhomian machinist uniform"
	path = /obj/item/clothing/under/tajaran/mechanic

/datum/loadout_entry/uniform/tajaran/raakti_shariim
	name = "Raakti shariim uniform"
	path = /obj/item/clothing/under/tajaran/raakti_shariim

/datum/loadout_entry/uniform/tajaran/dpra
	name = "DPRA laborer clothes"
	path = /obj/item/clothing/under/tajaran/dpra

/datum/loadout_entry/uniform/tajaran/dpra/alt
	name = "DPRA laborer clothes, alternate"
	path = /obj/item/clothing/under/tajaran/dpra/alt
