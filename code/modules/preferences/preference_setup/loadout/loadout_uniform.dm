// Uniform slot
/datum/gear/uniform/
	name = "Blazer - Blue"
	path = /obj/item/clothing/under/blazer
	slot = SLOT_ID_UNIFORM
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/blazer_skirt
	name = "Blazer - Skirt "
	path = /obj/item/clothing/under/blazer/skirt

/datum/gear/uniform/cheongsam
	name = "Cheongsam Selection"
	description = "Various color variations of an old earth dress style. They are pretty close fitting around the waist."

/datum/gear/uniform/cheongsam/New()
	..()
	var/list/cheongsams = list()
	for(var/cheongsam in typesof(/obj/item/clothing/under/cheongsam))
		var/obj/item/clothing/under/cheongsam/cheongsam_type = cheongsam
		cheongsams[initial(cheongsam_type.name)] = cheongsam_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(cheongsams, /proc/cmp_text_asc))

/datum/gear/uniform/cheongsam_male
	name = "Cheongsam (Male) - Black"
	path = /obj/item/clothing/under/cheong

/datum/gear/uniform/cheongsam_male/white
	name = "Cheongsam (Male) - White"
	path = /obj/item/clothing/under/cheong/white

/datum/gear/uniform/cheongsam_male/red
	name = "Cheongsam (Male) - Red"
	path = /obj/item/clothing/under/cheong/red

/datum/gear/uniform/qipao
	name = "Qipao"
	path = /obj/item/clothing/under/qipao

/datum/gear/uniform/qipao/white
	name = "Qipao - White"
	path = /obj/item/clothing/under/qipao/white

/datum/gear/uniform/qipao/red
	name = "Qipao - Red"
	path = /obj/item/clothing/under/qipao/red

/datum/gear/uniform/croptop
	name = "Croptop Selection"
	description = "Light shirts which shows the midsection of the wearer."

/datum/gear/uniform/croptop/New()
	..()
	var/list/croptops = list()
	for(var/croptop in typesof(/obj/item/clothing/under/croptop))
		var/obj/item/clothing/under/croptop/croptop_type = croptop
		croptops[initial(croptop_type.name)] = croptop_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(croptops, /proc/cmp_text_asc))

/datum/gear/uniform/kilt
	name = "Kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/cuttop
	name = "Cut Top - Grey"
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/red
	name = "Cut Top - Red"
	path = /obj/item/clothing/under/cuttop/red

/datum/gear/uniform/jumpsuit
	name = "Jumpclothes Selection"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/list/jumpclothes = list()
	for(var/jump in typesof(/obj/item/clothing/under/color))
		var/obj/item/clothing/under/color/jumps = jump
		jumpclothes[initial(jumps.name)] = jumps
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(jumpclothes, /proc/cmp_text_asc))

/datum/gear/uniform/blueshortskirt
	name = "Short Skirt"
	path = /obj/item/clothing/under/blueshortskirt

/datum/gear/uniform/skirt
	name = "Skirts Selection"
	path = /obj/item/clothing/under/skirt

/datum/gear/uniform/skirt/New()
	..()
	var/list/skirts = list()
	for(var/skirt in (typesof(/obj/item/clothing/under/skirt)))
		var/obj/item/clothing/under/skirt/skirt_type = skirt
		skirts[initial(skirt_type.name)] = skirt_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(skirts, /proc/cmp_text_asc))

/datum/gear/uniform/pants
	name = "Pants Selection"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(pants, /proc/cmp_text_asc))

/datum/gear/uniform/shorts
	name = "Shorts Selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(shorts, /proc/cmp_text_asc))

/datum/gear/uniform/suit/lawyer
	name = "Suit One-Piece Selection"
	path = /obj/item/clothing/under/lawyer

/datum/gear/uniform/suit/lawyer/New()
	..()
	var/list/lsuits = list()
	for(var/lsuit in typesof(/obj/item/clothing/under/lawyer))
		var/obj/item/clothing/suit/lsuit_type = lsuit
		lsuits[initial(lsuit_type.name)] = lsuit_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(lsuits, /proc/cmp_text_asc))

/datum/gear/uniform/suit/suit_jacket
	name = "Suit Modular Selection"
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/suit/suit_jacket/New()
	..()
	var/list/msuits = list()
	for(var/msuit in typesof(/obj/item/clothing/under/suit_jacket))
		var/obj/item/clothing/suit/msuit_type = msuit
		msuits[initial(msuit_type.name)] = msuit_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(msuits, /proc/cmp_text_asc))

/datum/gear/uniform/suit/amish
	name = "Suit - Amish"
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/gentle
	name = "Suit - Gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/gear/uniform/suit/gentleskirt
	name = "Suit - Lady"
	path = /obj/item/clothing/under/gentlesuit/skirt

/datum/gear/uniform/suit/white
	name = "Suit - White"
	path = /obj/item/clothing/under/scratch

/datum/gear/uniform/suit/whiteskirt
	name = "Suit - White Skirt"
	path = /obj/item/clothing/under/scratch/skirt

/datum/gear/uniform/scrub
	name = "Scrubs Selection"
	path = /obj/item/clothing/under/rank/medical/scrubs

/datum/gear/uniform/scrub/New()
	..()
	var/list/scrubs = list()
	for(var/scrub in typesof(/obj/item/clothing/under/rank/medical/scrubs))
		var/obj/item/clothing/under/rank/medical/scrubs/scrub_type = scrub
		scrubs[initial(scrub_type.name)] = scrub_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(scrubs, /proc/cmp_text_asc))

/datum/gear/uniform/scrub_fem
	name = "Scrubs Selection - Female"
	path = /obj/item/clothing/under/rank/medical/scrubs_fem

/datum/gear/uniform/scrub_fem/New()
	..()
	var/list/scrubs_fem = list()
	for(var/scrub_fem in typesof(/obj/item/clothing/under/rank/medical/scrubs_fem))
		var/obj/item/clothing/under/rank/medical/scrubs_fem/scrub_type = scrub_fem
		scrubs_fem[initial(scrub_type.name)] = scrub_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(scrubs_fem, /proc/cmp_text_asc))

/datum/gear/uniform/oldwoman
	name = "Old Woman Attire"
	path = /obj/item/clothing/under/oldwoman

/datum/gear/uniform/sundress
	name = "Sundress"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/sundress/white
	name = "Sundress - White"
	path = /obj/item/clothing/under/sundress_white

/datum/gear/uniform/turtlebaggy_selection
	name = "Baggy Turtleneck Selection"
	path = /obj/item/clothing/under/turtlebaggy

/datum/gear/uniform/turtlebaggy_selection/New()
	..()
	var/list/turtlebaggy_selection = list()
	for(var/turtlebaggy in typesof(/obj/item/clothing/under/turtlebaggy))
		var/obj/item/clothing/under/turtlebaggy_type = turtlebaggy
		turtlebaggy_selection[initial(turtlebaggy_type.name)] = turtlebaggy_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(turtlebaggy_selection, /proc/cmp_text_asc))

/datum/gear/uniform/pentagramdress
	name = "Pentagram Dress"
	path = /obj/item/clothing/under/pentagramdress

/datum/gear/uniform/dress_fire
	name = "Flame Dress"
	path = /obj/item/clothing/under/dress/dress_fire

/datum/gear/uniform/whitedress
	name = "White Wedding Dress"
	path = /obj/item/clothing/under/dress/white

/datum/gear/uniform/longdress
	name = "Long Dress"
	path = /obj/item/clothing/under/dress/white2

/datum/gear/uniform/longdress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/shortplaindress
	name = "Plain Dress"
	path = /obj/item/clothing/under/dress/white3

/datum/gear/uniform/shortplaindress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/longwidedress
	name = "Long Wide Dress"
	path = /obj/item/clothing/under/dress/white4

/datum/gear/uniform/longwidedress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/reddress
	name = "Red Dress - Belted"
	path = /obj/item/clothing/under/dress/darkred

/datum/gear/uniform/wedding
	name = "Wedding Dress Selection"
	path = /obj/item/clothing/under/wedding

/datum/gear/uniform/wedding/New()
	..()
	var/list/weddings = list()
	for(var/wedding in typesof(/obj/item/clothing/under/wedding))
		var/obj/item/clothing/under/wedding/wedding_type = wedding
		weddings[initial(wedding_type.name)] = wedding_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(weddings, /proc/cmp_text_asc))


/datum/gear/uniform/suit/reallyblack
	name = "Executive Suit"
	path = /obj/item/clothing/under/suit_jacket/really_black

/datum/gear/uniform/skirts
	name = "Executive Skirt"
	path = /obj/item/clothing/under/suit_jacket/female/skirt

/datum/gear/uniform/dresses
	name = "Sailor Dress"
	path = /obj/item/clothing/under/dress/sailordress

/datum/gear/uniform/dresses/eveninggown
	name = "Red Evening Gown"
	path = /obj/item/clothing/under/dress/redeveninggown

/datum/gear/uniform/dresses/maid
	name = "Maid Uniform Selection"
	path = /obj/item/clothing/under/dress/maid

/datum/gear/uniform/dresses/maid/New()
	..()
	var/list/maids = list()
	for(var/maid in typesof(/obj/item/clothing/under/dress/maid))
		var/obj/item/clothing/under/dress/maid/maid_type = maid
		maids[initial(maid_type.name)] = maid_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(maids, /proc/cmp_text_asc))

/datum/gear/uniform/utility
	name = "Utility - Black"
	path = /obj/item/clothing/under/utility

/datum/gear/uniform/utility/blue
	name = "Utility - Blue"
	path = /obj/item/clothing/under/utility/blue

/datum/gear/uniform/utility/grey
	name = "Utility - Grey"
	path = /obj/item/clothing/under/utility/grey

/datum/gear/uniform/sweater
	name = "Sweater - Grey"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater

/datum/gear/uniform/brandjumpsuit_selection
	name = "Branded Jumpsuit Selection"
	path = /obj/item/clothing/under/brandjumpsuit/aether

/datum/gear/uniform/brandjumpsuit_selection/New()
	..()
	var/list/brandjumpsuit_selection = list()
	for(var/brandjumpsuit in typesof(/obj/item/clothing/under/brandjumpsuit))
		var/obj/item/clothing/under/brandjumpsuit_type = brandjumpsuit
		brandjumpsuit_selection[initial(brandjumpsuit_type.name)] = brandjumpsuit_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(brandjumpsuit_selection, /proc/cmp_text_asc))

/datum/gear/uniform/yogapants
	name = "Yoga Pants"
	path = /obj/item/clothing/under/pants/yogapants

/datum/gear/uniform/yogapants/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/black_corset
	name = "Black Corset"
	path = /obj/item/clothing/under/dress/black_corset

/datum/gear/uniform/flower_dress
	name = "Flower Dress"
	path = /obj/item/clothing/under/dress/flower_dress

/datum/gear/uniform/red_swept_dress
	name = "Red Swept Dress"
	path = /obj/item/clothing/under/dress/red_swept_dress

/datum/gear/uniform/bathrobe
	name = "Bathrobe"
	path = /obj/item/clothing/under/bathrobe

/datum/gear/uniform/flamenco
	name = "Flamenco Dress"
	path = /obj/item/clothing/under/dress/flamenco

/datum/gear/uniform/westernbustle
	name = "Western Bustle"
	path = /obj/item/clothing/under/dress/westernbustle

/datum/gear/uniform/circuitry
	name = "Jumpsuit - Circuitry"
	path = /obj/item/clothing/under/circuitry

/datum/gear/uniform/sysguard
	name = "Uniform - Crew"
	path = /obj/item/clothing/under/oricon/utility/sysguard/crew

/datum/gear/uniform/marine/green
	name = "Uniform - Green Fatigues"
	path = /obj/item/clothing/under/oricon/utility/marine/green

/datum/gear/uniform/marine/tan
	name = "Uniform - Tan Fatigues"
	path = /obj/item/clothing/under/oricon/utility/marine/tan

/datum/gear/uniform/overalls
	name = "Overalls"
	path = /obj/item/clothing/under/overalls

/datum/gear/uniform/overalls_fem
	name = "Overalls - Female"
	path = /obj/item/clothing/under/overalls_fem

/datum/gear/uniform/sleekoverall
	name = "Overalls - Sleek"
	path = /obj/item/clothing/under/overalls/sleek

/datum/gear/uniform/sleekoverall_fem
	name = "Overalls - Sleek - Female"
	path = /obj/item/clothing/under/overalls/sleek_fem

/datum/gear/uniform/sarired
	name = "Sari - Red"
	path = /obj/item/clothing/under/dress/sari

/datum/gear/uniform/sarigreen
	name = "Sari - Green"
	path = /obj/item/clothing/under/dress/sari/green

/datum/gear/uniform/kamishimo
	name = "Kamishimo"
	path = /obj/item/clothing/under/kamishimo

/datum/gear/uniform/kimono
	name = "Kimono - Plain"
	path = /obj/item/clothing/under/kimono

/datum/gear/uniform/kimono_black
	name = "Kimono - Black"
	path = /obj/item/clothing/under/kimono_black

/datum/gear/uniform/kimono_sakura
	name = "Kimono - Sakura"
	path = /obj/item/clothing/under/kimono_sakura

/datum/gear/uniform/kimono_fancy
	name = "Kimono - Festival"
	path = /obj/item/clothing/under/kimono_fancy

/datum/gear/uniform/kimono_selection
	name = "Kimono Selection"
	description = "Colorful variants of the basic kimono. Stylish and comfy!"

/datum/gear/uniform/kimono_selection/New()
	..()
	var/list/kimonos = list()
	for(var/kimono in typesof(/obj/item/clothing/under/kimono))
		var/obj/item/clothing/under/kimono/kimono_type = kimono
		kimonos[initial(kimono_type.name)] = kimono_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(kimonos, /proc/cmp_text_asc))

/datum/gear/uniform/pyjamas_red
	name = "Pyjamas - Red"
	path = /obj/item/clothing/under/redpyjamas

/datum/gear/uniform/pyjamas_blue
	name = "Pyjamas - Blue"
	path = /obj/item/clothing/under/bluepyjamas

/datum/gear/uniform/pyjamas_red_fem
	name = "Pyjamas - Red - Female"
	path = /obj/item/clothing/under/redpyjamas_fem

/datum/gear/uniform/pyjamas_blue_fem
	name = "Pyjamas - Blue - Female"
	path = /obj/item/clothing/under/bluepyjamas_fem

/datum/gear/uniform/wrappedcoat
	name = "Modern Wrapped Coat"
	path = /obj/item/clothing/under/moderncoat

/datum/gear/uniform/ascetic
	name = "Plain Ascetic Garb"
	path = /obj/item/clothing/under/ascetic

/datum/gear/uniform/ascetic_fem
	name = "Plain Ascetic Garb - Female"
	path = /obj/item/clothing/under/ascetic_fem

/datum/gear/uniform/pleated
	name = "Pleated Skirt"
	path = /obj/item/clothing/under/skirt/pleated

/datum/gear/uniform/pleated/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/lilacdress
	name = "Lilac Dress"
	path = /obj/item/clothing/under/dress/lilacdress

/datum/gear/uniform/stripeddress
	name = "Striped Dress"
	path = /obj/item/clothing/under/dress/stripeddress

/datum/gear/uniform/festivedress
	name = "Festive Dress"
	path = /obj/item/clothing/under/festivedress

/datum/gear/uniform/haltertop
	name = "Halter Top"
	path = /obj/item/clothing/under/haltertop

/datum/gear/uniform/littleblackdress
	name = "Little Black Dress"
	path = /obj/item/clothing/under/littleblackdress

/datum/gear/uniform/dutchsuit
	name = "Western Suit"
	path = /obj/item/clothing/under/dutchuniform

/datum/gear/uniform/victorianredshirt
	name = "Red Shirted Victorian Suit"
	path = /obj/item/clothing/under/victorianblred

/datum/gear/uniform/victorianredshirt/female
	name = "Red Shirted Victorian Suit - Female"
	path = /obj/item/clothing/under/fem_victorianblred

/datum/gear/uniform/victorianredvest
	name = "Red Vested Victorian Suit"
	path = /obj/item/clothing/under/victorianredvest

/datum/gear/uniform/victorianredvest/female
	name = "Red Vested Victorian Suit - Female"
	path = /obj/item/clothing/under/fem_victorianredvest

/datum/gear/uniform/victoriansuit
	name = "Victorian Suit"
	path = /obj/item/clothing/under/victorianvest

/datum/gear/uniform/victoriansuit/female
	name = "Victorian Suit - Female"
	path = /obj/item/clothing/under/fem_victorianvest

/datum/gear/uniform/victorianbluesuit
	name = "Blue Shirted Victorian Suit"
	path = /obj/item/clothing/under/victorianlightfire

/datum/gear/uniform/victorianbluesuit/female
	name = "Blue Shirted Victorian Suit - Female"
	path = /obj/item/clothing/under/fem_victorianlightfire

/datum/gear/uniform/victorianreddress
	name = "Victorian Red Dress"
	path = /obj/item/clothing/under/victorianreddress

/datum/gear/uniform/victorianblackdress
	name = "Victorian Black Dress"
	path = /obj/item/clothing/under/victorianblackdress

/datum/gear/uniform/fiendsuit
	name = "Fiendish Suit"
	path = /obj/item/clothing/under/fiendsuit

/datum/gear/uniform/fienddress
	name = "Fiendish Dress"
	path = /obj/item/clothing/under/fienddress

/datum/gear/uniform/leotard
	name = "Black Leotard"
	path = /obj/item/clothing/under/leotard

/datum/gear/uniform/leotardcolor
	name = "Colored Leotard"
	path = /obj/item/clothing/under/leotardcolor

/datum/gear/uniform/leotardcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/verglasdress
	name = "Verglas Dress"
	path = /obj/item/clothing/under/verglasdress

/datum/gear/uniform/fashionminiskirt
	name = "Fashionable Miniskirt"
	path = /obj/item/clothing/under/fashionminiskirt

/datum/gear/uniform/fashionminiskirt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/bodysuit
	name = "Standard Bodysuit"
	path = /obj/item/clothing/under/bodysuit

/datum/gear/uniform/bodysuit_fem
	name = "Standard Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit_fem

/datum/gear/uniform/bodysuiteva
	name = "EVA Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuiteva

/datum/gear/uniform/bodysuiteva_fem
	name = "EVA Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuiteva_fem

/datum/gear/uniform/future_fashion_selection
	name = "Futuristic Striped Jumpsuit Selection"
	path = /obj/item/clothing/under/future_fashion

/datum/gear/uniform/future_fashion_selection/New()
	..()
	var/list/future_fashion_selection = list()
	for(var/future_fashion in typesof(/obj/item/clothing/under/future_fashion))
		var/obj/item/clothing/under/future_fashion/future_fashion_type = future_fashion
		future_fashion_selection[initial(future_fashion_type.name)] = future_fashion_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(future_fashion_selection, /proc/cmp_text_asc))

/datum/gear/uniform/suit/permit
	name = "Nudity Permit"
	path = /obj/item/clothing/under/permit


/*
Swimsuits
*/

/datum/gear/uniform/swimsuits
	name = "Swimsuit Selection"
	path = /obj/item/clothing/under/swimsuit

/datum/gear/uniform/swimsuits/New()
	..()
	var/list/swimsuits = list()
	for(var/swimsuit in typesof(/obj/item/clothing/under/swimsuit))
		var/obj/item/clothing/under/swimsuit/swimsuit_type = swimsuit
		swimsuits[initial(swimsuit_type.name)] = swimsuit_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(swimsuits, /proc/cmp_text_asc))

/datum/gear/uniform/suit/gnshorts
	name = "GN Shorts"
	path = /obj/item/clothing/under/fluff/gnshorts

// Latex maid dress
/datum/gear/uniform/latexmaid
	name = "Latex Maid Dress"
	path = /obj/item/clothing/under/fluff/latexmaid

//Tron Siren outfit
/datum/gear/uniform/siren
	name = "Jumpsuit - Siren"
	path = /obj/item/clothing/under/fluff/siren

/datum/gear/uniform/suit/v_nanovest
	name = "Varmacorp Nanovest"
	path = /obj/item/clothing/under/fluff/v_nanovest

/datum/gear/uniform/greyskirt_female
	name = "Grey Skirt"
	path = /obj/item/clothing/under/greyskirt_female

/datum/gear/uniform/highwayman_clothes
	name = "Highwayman Outfit"
	path = /obj/item/clothing/under/highwayman_clothes

/datum/gear/uniform/highwayman_clothes_fem
	name = "Highwayman Outfit - Female"
	path = /obj/item/clothing/under/highwayman_clothes_fem

/datum/gear/uniform/businessskirt
	name = "Business Skirt"
	path = /obj/item/clothing/under/businessskirt_female

/datum/gear/uniform/simpledress
	name = "Simple Dress"
	path = /obj/item/clothing/under/simpledress

/datum/gear/uniform/formalredcoat
	name = "Formal Coat - Red"
	path = /obj/item/clothing/under/redcoatformal

/datum/gear/uniform/vice
	name = "Vice Officer's Jumpsuit"
	path = /obj/item/clothing/under/rank/vice

/datum/gear/uniform/saare
	name = "SAARE Uniform"
	path = /obj/item/clothing/under/saare

/datum/gear/uniform/saare_fem
	name = "SAARE Uniform - Female"
	path = /obj/item/clothing/under/saare_fem

/datum/gear/uniform/hawaiianpink
	name = "Suit - Pink Hawaiian"
	path = /obj/item/clothing/under/hawaiian

/datum/gear/uniform/geisha
	name = "Geisha Outfit"
	path = /obj/item/clothing/under/geisha

/datum/gear/uniform/blueshift
	name = "Suit - Light Blue"
	path = /obj/item/clothing/under/blueshift

/datum/gear/uniform/office_worker
	name = "Suit - Office Worker"
	path = /obj/item/clothing/under/office_worker

/datum/gear/uniform/tracksuit_blue
	name = "Tracksuit - Blue"
	path = /obj/item/clothing/under/tracksuit_blue

/datum/gear/uniform/tribal_tunic
	name = "Tunic - Simple"
	path = /obj/item/clothing/under/tribal_tunic

/datum/gear/uniform/tribal_tunic_fem
	name = "Tunic - Simple - Female"
	path = /obj/item/clothing/under/tribal_tunic_fem

/datum/gear/uniform/druidic_gown
	name = "Tunic - Flowered"
	path = /obj/item/clothing/under/druidic_gown

/datum/gear/uniform/druidic_gown_fem
	name = "Tunic - Flowered - Female"
	path = /obj/item/clothing/under/druidic_gown_fem

/datum/gear/uniform/laconic
	name = "Laconic Field Suit"
	path = /obj/item/clothing/under/laconic

/datum/gear/uniform/bountyskin
	name = "Bounty Hunter's Skinsuit"
	path = /obj/item/clothing/under/bountyskin

/datum/gear/uniform/navy_jumpsuit
	name = "Navy Gray Jumpsuit"
	path = /obj/item/clothing/under/navy_gray

/datum/gear/uniform/gray_smooth
	name = "Gray Smooth Jumpsuit"
	path = /obj/item/clothing/under/smooth_gray

/datum/gear/uniform/chiming_dress
	name = "Chiming Dress"
	path = /obj/item/clothing/under/chiming_dress

/datum/gear/uniform/waiter
	name = "Waiter's Outfit"
	path = /obj/item/clothing/under/waiter

/datum/gear/uniform/waiter_fem
	name = "Waiter's Outfit - Female"
	path = /obj/item/clothing/under/waiter_fem

/datum/gear/uniform/assistantformal
	name = "Assistant's Formal Uniform"
	path = /obj/item/clothing/under/assistantformal

/datum/gear/uniform/assistantformal_fem
	name = "Assistant's Formal Uniform - Female"
	path = /obj/item/clothing/under/assistantformal_fem

/datum/gear/uniform/cropdress
	name = "Cropped Dress"
	path = /obj/item/clothing/under/dress/cropdress

/datum/gear/uniform/twistdress
	name = "Twisted Dress"
	path = /obj/item/clothing/under/dress/twistdress

/datum/gear/uniform/antediluvian
	name = "Antediluvian Corset"
	path = /obj/item/clothing/under/antediluvian

/datum/gear/uniform/hasie
	name = "Hasie Designer Skirt/Vest"
	path = /obj/item/clothing/under/hasie

/datum/gear/uniform/utility_fur_pants
	name = "Utility Fur Pants"
	path = /obj/item/clothing/under/utility_fur_pants

/datum/gear/uniform/sitri
	name = "Sitri Striped Sweater"
	path = /obj/item/clothing/under/sitri

/datum/gear/uniform/halfmoon
	name = "Half Moon Outfit"
	path = /obj/item/clothing/under/half_moon

/datum/gear/uniform/toga
	name = "Toga"
	path = /obj/item/clothing/under/toga

/datum/gear/uniform/countess
	name = "Countess Dress"
	path = /obj/item/clothing/under/countess

/datum/gear/uniform/baroness
	name = "Baroness Dress"
	path = /obj/item/clothing/under/baroness

/datum/gear/uniform/yoko
	name = "Scavenging Sniper Set"
	path = /obj/item/clothing/under/yoko

/datum/gear/uniform/kamina
	name = "Spiral Hero Outfit"
	path = /obj/item/clothing/under/kamina

/datum/gear/uniform/tape
	name = "Body Tape Wrapping"
	path = /obj/item/clothing/under/tape

/datum/gear/uniform/revealing
	name = "Revealing Cocktail Dress"
	path = /obj/item/clothing/under/revealing

/datum/gear/uniform/belial
	name = "Belial Striped Shirt and Shorts"
	path = /obj/item/clothing/under/belial

/datum/gear/uniform/lilin
	name = "Lilin Sash Dress"
	path = /obj/item/clothing/under/lilin

/datum/gear/uniform/asmodai
	name = "Asmodai Laced Blouse"
	path = /obj/item/clothing/under/asmodai

/datum/gear/uniform/summerdress_selection
	name = "Summer Dress Selection"
	path = /obj/item/clothing/under/dress/summer

/datum/gear/uniform/summerdress_selection/New()
	..()
	var/list/summerdress_selection = list()
	for(var/summerdress in typesof(/obj/item/clothing/under/dress/summer))
		var/obj/item/clothing/under/summerdress_type = summerdress
		summerdress_selection[initial(summerdress_type.name)] = summerdress_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(summerdress_selection, /proc/cmp_text_asc))

/datum/gear/uniform/skinsuit_selection
	name = "Skinsuit Selection - Male"
	path = /obj/item/clothing/under/skinsuit

/datum/gear/uniform/skinsuit_selection/New()
	..()
	var/list/skinsuit_selection = list()
	for(var/skinsuit in typesof(/obj/item/clothing/under/skinsuit))
		var/obj/item/clothing/under/skinsuit_type = skinsuit
		skinsuit_selection[initial(skinsuit_type.name)] = skinsuit_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(skinsuit_selection, /proc/cmp_text_asc))

/datum/gear/uniform/skinsuitfem_selection
	name = "Skinsuit Selection - Female"
	path = /obj/item/clothing/under/skinsuit_fem

/datum/gear/uniform/skinsuitfem_selection/New()
	..()
	var/list/skinsuitfem_selection = list()
	for(var/skinsuitfem in typesof(/obj/item/clothing/under/skinsuit_fem))
		var/obj/item/clothing/under/skinsuitfem_type = skinsuitfem
		skinsuitfem_selection[initial(skinsuitfem_type.name)] = skinsuitfem_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(skinsuitfem_selection, /proc/cmp_text_asc))

/datum/gear/uniform/altbodysuit_selection
	name = "Alternate Bodysuit Selection - Male"
	path = /obj/item/clothing/under/bodysuit/alt

/datum/gear/uniform/altbodysuit_selection/New()
	..()
	var/list/altbodysuit_selection = list()
	for(var/altbodysuit in typesof(/obj/item/clothing/under/bodysuit/alt))
		var/obj/item/clothing/under/altbodysuit_type = altbodysuit
		altbodysuit_selection[initial(altbodysuit_type.name)] = altbodysuit_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(altbodysuit_selection, /proc/cmp_text_asc))

/datum/gear/uniform/altbodysuitfem_selection
	name = "Alternate Bodysuit Selection - Female"
	path = /obj/item/clothing/under/bodysuit/alt_fem

/datum/gear/uniform/altbodysuitfem_selection/New()
	..()
	var/list/altbodysuitfem_selection = list()
	for(var/altbodysuitfem in typesof(/obj/item/clothing/under/bodysuit/alt_fem))
		var/obj/item/clothing/under/altbodysuitfem_type = altbodysuitfem
		altbodysuitfem_selection[initial(altbodysuitfem_type.name)] = altbodysuitfem_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(altbodysuitfem_selection, /proc/cmp_text_asc))
