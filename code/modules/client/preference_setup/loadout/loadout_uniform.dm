// Uniform slot
/datum/gear/uniform/
	display_name = "Blazer - Blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/blazerskirt
	display_name = "Blazer - Skirt "
	path = /obj/item/clothing/under/blazer/skirt

/datum/gear/uniform/cheongsam
	display_name = "Cheongsam Selection"
	description = "Various color variations of an old earth dress style. They are pretty close fitting around the waist."

/datum/gear/uniform/cheongsam/New()
	..()
	var/list/cheongsams = list()
	for(var/cheongsam in typesof(/obj/item/clothing/under/cheongsam))
		var/obj/item/clothing/under/cheongsam/cheongsam_type = cheongsam
		cheongsams[initial(cheongsam_type.name)] = cheongsam_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cheongsams, /proc/cmp_text_asc))

/datum/gear/uniform/cheongsam_male
	display_name = "Cheongsam (Male) - Black"
	path = /obj/item/clothing/under/cheong

/datum/gear/uniform/cheongsam_male/white
	display_name = "Cheongsam (Male) - White"
	path = /obj/item/clothing/under/cheong/white

/datum/gear/uniform/cheongsam_male/red
	display_name = "Cheongsam (Male) - Red"
	path = /obj/item/clothing/under/cheong/red

/datum/gear/uniform/qipao
	display_name = "Qipao"
	path = /obj/item/clothing/under/qipao

/datum/gear/uniform/qipao/white
	display_name = "Qipao - White"
	path = /obj/item/clothing/under/qipao/white

/datum/gear/uniform/qipao/red
	display_name = "Qipao - Red"
	path = /obj/item/clothing/under/qipao/red

/datum/gear/uniform/croptop
	display_name = "Croptop Selection"
	description = "Light shirts which shows the midsection of the wearer."

/datum/gear/uniform/croptop/New()
	..()
	var/list/croptops = list()
	for(var/croptop in typesof(/obj/item/clothing/under/croptop))
		var/obj/item/clothing/under/croptop/croptop_type = croptop
		croptops[initial(croptop_type.name)] = croptop_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(croptops, /proc/cmp_text_asc))

/datum/gear/uniform/kilt
	display_name = "Kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/cuttop
	display_name = "Cut Top - Grey"
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/red
	display_name = "Cut Top - Red"
	path = /obj/item/clothing/under/cuttop/red

/datum/gear/uniform/jumpsuit
	display_name = "Jumpclothes Selection"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/list/jumpclothes = list()
	for(var/jump in typesof(/obj/item/clothing/under/color))
		var/obj/item/clothing/under/color/jumps = jump
		jumpclothes[initial(jumps.name)] = jumps
	gear_tweaks += new/datum/gear_tweak/path(sortTim(jumpclothes, /proc/cmp_text_asc))

/datum/gear/uniform/blueshortskirt
	display_name = "Short Skirt"
	path = /obj/item/clothing/under/blueshortskirt

/datum/gear/uniform/skirt
	display_name = "Skirts Selection"
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
	display_name = "Pants Selection"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(pants, /proc/cmp_text_asc))

/datum/gear/uniform/shorts
	display_name = "Shorts Selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(shorts, /proc/cmp_text_asc))

/datum/gear/uniform/suit/lawyer
	display_name = "Suit One-Piece Selection"
	path = /obj/item/clothing/under/lawyer

/datum/gear/uniform/suit/lawyer/New()
	..()
	var/list/lsuits = list()
	for(var/lsuit in typesof(/obj/item/clothing/under/lawyer))
		var/obj/item/clothing/suit/lsuit_type = lsuit
		lsuits[initial(lsuit_type.name)] = lsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(lsuits, /proc/cmp_text_asc))

/datum/gear/uniform/suit/suit_jacket
	display_name = "Suit Modular Selection"
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
	display_name = "Suit - Amish"
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/gentle
	display_name = "Suit - Gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/gear/uniform/suit/gentleskirt
	display_name = "Suit - Lady"
	path = /obj/item/clothing/under/gentlesuit/skirt

/datum/gear/uniform/suit/white
	display_name = "Suit - White"
	path = /obj/item/clothing/under/scratch

/datum/gear/uniform/suit/whiteskirt
	display_name = "Suit - White Skirt"
	path = /obj/item/clothing/under/scratch/skirt

/datum/gear/uniform/scrub
	display_name = "Scrubs Selection"
	path = /obj/item/clothing/under/rank/medical/scrubs

/datum/gear/uniform/scrub/New()
	..()
	var/list/scrubs = list()
	for(var/scrub in typesof(/obj/item/clothing/under/rank/medical/scrubs))
		var/obj/item/clothing/under/rank/medical/scrubs/scrub_type = scrub
		scrubs[initial(scrub_type.name)] = scrub_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(scrubs, /proc/cmp_text_asc))

/datum/gear/uniform/oldwoman
	display_name = "Old Woman Attire"
	path = /obj/item/clothing/under/oldwoman

/datum/gear/uniform/sundress
	display_name = "Sundress"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/sundress/white
	display_name = "Sundress - White"
	path = /obj/item/clothing/under/sundress_white

/datum/gear/uniform/turtlebaggy
	display_name = "Baggy Turtleneck - Cream"
	path = /obj/item/clothing/under/turtlebaggy

/datum/gear/uniform/turtlebaggy/purple
	display_name = "Baggy Turtleneck - Purple"
	path = /obj/item/clothing/under/turtlebaggy/purple

/datum/gear/uniform/turtlebaggy/red
	display_name = "Baggy Turtleneck - Red"
	path = /obj/item/clothing/under/turtlebaggy/red

/datum/gear/uniform/turtlebaggy/blue
	display_name = "Baggy Turtleneck - Blue"
	path = /obj/item/clothing/under/turtlebaggy/blue

/datum/gear/uniform/turtlebaggy/green
	display_name = "Baggy Turtleneck - Green"
	path = /obj/item/clothing/under/turtlebaggy/green

/datum/gear/uniform/turtlebaggy/black
	display_name = "Baggy Turtleneck - Black"
	path = /obj/item/clothing/under/turtlebaggy/black

/datum/gear/uniform/pentagramdress
	display_name = "Pentagram Dress"
	path = /obj/item/clothing/under/pentagramdress

/datum/gear/uniform/dress_fire
	display_name = "Flame Dress"
	path = /obj/item/clothing/under/dress/dress_fire

/datum/gear/uniform/whitedress
	display_name = "White Wedding Dress"
	path = /obj/item/clothing/under/dress/white

/datum/gear/uniform/longdress
	display_name = "Long Dress"
	path = /obj/item/clothing/under/dress/white2

/datum/gear/uniform/longdress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/shortplaindress
	display_name = "Plain Dress"
	path = /obj/item/clothing/under/dress/white3

/datum/gear/uniform/shortplaindress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/longwidedress
	display_name = "Long Wide Dress"
	path = /obj/item/clothing/under/dress/white4

/datum/gear/uniform/longwidedress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/reddress
	display_name = "Red Dress - Belted"
	path = /obj/item/clothing/under/dress/darkred

/datum/gear/uniform/wedding
	display_name = "Wedding Dress Selection"
	path = /obj/item/clothing/under/wedding

/datum/gear/uniform/wedding/New()
	..()
	var/list/weddings = list()
	for(var/wedding in typesof(/obj/item/clothing/under/wedding))
		var/obj/item/clothing/under/wedding/wedding_type = wedding
		weddings[initial(wedding_type.name)] = wedding_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(weddings, /proc/cmp_text_asc))


/datum/gear/uniform/suit/reallyblack
	display_name = "Executive Suit"
	path = /obj/item/clothing/under/suit_jacket/really_black

/datum/gear/uniform/skirts
	display_name = "Executive Skirt"
	path = /obj/item/clothing/under/suit_jacket/female/skirt

/datum/gear/uniform/dresses
	display_name = "Sailor Dress"
	path = /obj/item/clothing/under/dress/sailordress

/datum/gear/uniform/dresses/eveninggown
	display_name = "Red Evening Gown"
	path = /obj/item/clothing/under/dress/redeveninggown

/datum/gear/uniform/dresses/maid
	display_name = "Maid Uniform Selection"
	path = /obj/item/clothing/under/dress/maid

/datum/gear/uniform/dresses/maid/New()
	..()
	var/list/maids = list()
	for(var/maid in typesof(/obj/item/clothing/under/dress/maid))
		var/obj/item/clothing/under/dress/maid/maid_type = maid
		maids[initial(maid_type.name)] = maid_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(maids, /proc/cmp_text_asc))

/datum/gear/uniform/utility
	display_name = "Utility - Black"
	path = /obj/item/clothing/under/utility

/datum/gear/uniform/utility/blue
	display_name = "Utility - Blue"
	path = /obj/item/clothing/under/utility/blue

/datum/gear/uniform/utility/grey
	display_name = "Utility - Grey"
	path = /obj/item/clothing/under/utility/grey

/datum/gear/uniform/sweater
	display_name = "Sweater - Grey"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater

/datum/gear/uniform/brandsuit/aether
	display_name = "Jumpsuit - Aether"
	path = /obj/item/clothing/under/aether

/datum/gear/uniform/brandsuit/focal
	display_name = "Jumpsuit - Focal"
	path = /obj/item/clothing/under/focal

/datum/gear/uniform/mbill
	display_name = "Outfit - Major Bill's"
	path = /obj/item/clothing/under/mbill

/datum/gear/uniform/brandsuit/grayson
	display_name = "Outfit - Grayson"
	path = /obj/item/clothing/under/grayson

/datum/gear/uniform/brandsuit/wardt
	display_name = "Jumpsuit - Ward-Takahashi"
	path = /obj/item/clothing/under/wardt

/datum/gear/uniform/frontier
	display_name = "Outfit - Frontier"
	path = 	/obj/item/clothing/under/frontier

/datum/gear/uniform/brandsuit/hephaestus
	display_name = "Jumpsuit - Hephaestus"
	path = 	/obj/item/clothing/under/hephaestus

/datum/gear/uniform/yogapants
	display_name = "Yoga Pants"
	path = /obj/item/clothing/under/pants/yogapants

/datum/gear/uniform/yogapants/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/black_corset
	display_name = "Black Corset"
	path = /obj/item/clothing/under/dress/black_corset

/datum/gear/uniform/flower_dress
	display_name = "Flower Dress"
	path = /obj/item/clothing/under/dress/flower_dress

/datum/gear/uniform/red_swept_dress
	display_name = "Red Swept Dress"
	path = /obj/item/clothing/under/dress/red_swept_dress

/datum/gear/uniform/bathrobe
	display_name = "Bathrobe"
	path = /obj/item/clothing/under/bathrobe

/datum/gear/uniform/flamenco
	display_name = "Flamenco Dress"
	path = /obj/item/clothing/under/dress/flamenco

/datum/gear/uniform/westernbustle
	display_name = "Western Bustle"
	path = /obj/item/clothing/under/dress/westernbustle

/datum/gear/uniform/circuitry
	display_name = "Jumpsuit - Circuitry"
	path = /obj/item/clothing/under/circuitry

/datum/gear/uniform/sifguard
	display_name = "Uniform - Crew"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew

/datum/gear/uniform/marine/green
	display_name = "Uniform - Green Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/green

/datum/gear/uniform/marine/tan
	display_name = "Uniform - Tan Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/tan
/datum/gear/uniform/sleekoverall
	display_name = "Overalls - Sleek"
	path = /obj/item/clothing/under/overalls/sleek

/datum/gear/uniform/sarired
	display_name = "Sari - Red"
	path = /obj/item/clothing/under/dress/sari

/datum/gear/uniform/sarigreen
	display_name = "Sari - Green"
	path = /obj/item/clothing/under/dress/sari/green

/datum/gear/uniform/kamishimo
	display_name = "Kamishimo"
	path = /obj/item/clothing/under/kamishimo

/datum/gear/uniform/kimono
	display_name = "Kimono - Plain"
	path = /obj/item/clothing/under/kimono

/datum/gear/uniform/kimono_black
	display_name = "Kimono - Black"
	path = /obj/item/clothing/under/kimono_black

/datum/gear/uniform/kimono_sakura
	display_name = "Kimono - Sakura"
	path = /obj/item/clothing/under/kimono_sakura

/datum/gear/uniform/kimono_fancy
	display_name = "Kimono - Festival"
	path = /obj/item/clothing/under/kimono_fancy

/datum/gear/uniform/kimono_selection
	display_name = "Kimono Selection"
	description = "Colorful variants of the basic kimono. Stylish and comfy!"

/datum/gear/uniform/kimono_selection/New()
	..()
	var/list/kimonos = list()
	for(var/kimono in typesof(/obj/item/clothing/under/kimono))
		var/obj/item/clothing/under/kimono/kimono_type = kimono
		kimonos[initial(kimono_type.name)] = kimono_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(kimonos, /proc/cmp_text_asc))

/datum/gear/uniform/wrappedcoat
	display_name = "Modern Wrapped Coat"
	path = /obj/item/clothing/under/moderncoat

/datum/gear/uniform/ascetic
	display_name = "Plain Ascetic Garb"
	path = /obj/item/clothing/under/ascetic

/datum/gear/uniform/pleated
	display_name = "Pleated Skirt"
	path = /obj/item/clothing/under/skirt/pleated

/datum/gear/uniform/pleated/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/lilacdress
	display_name = "Lilac Dress"
	path = /obj/item/clothing/under/dress/lilacdress

/datum/gear/uniform/stripeddress
	display_name = "Striped Dress"
	path = /obj/item/clothing/under/dress/stripeddress

/datum/gear/uniform/festivedress
	display_name = "Festive Dress"
	path = /obj/item/clothing/under/festivedress

/datum/gear/uniform/haltertop
	display_name = "Halter Top"
	path = /obj/item/clothing/under/haltertop

/datum/gear/uniform/littleblackdress
	display_name = "Little Black Dress"
	path = /obj/item/clothing/under/littleblackdress

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

datum/gear/uniform/fiendsuit
	display_name = "Fiendish Suit"
	path = /obj/item/clothing/under/fiendsuit

datum/gear/uniform/fienddress
	display_name = "Fiendish Dress"
	path = /obj/item/clothing/under/fienddress

datum/gear/uniform/leotard
	display_name = "Black Leotard"
	path = /obj/item/clothing/under/leotard

datum/gear/uniform/leotardcolor
	display_name = "Colored Leotard"
	path = /obj/item/clothing/under/leotardcolor

/datum/gear/uniform/leotardcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

datum/gear/uniform/verglasdress
	display_name = "Verglas Dress"
	path = /obj/item/clothing/under/verglasdress

datum/gear/uniform/fashionminiskirt
	display_name = "Fashionable Miniskirt"
	path = /obj/item/clothing/under/fashionminiskirt

/datum/gear/uniform/fashionminiskirt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

datum/gear/uniform/bodysuit
	display_name = "Standard Bodysuit"
	path = /obj/item/clothing/under/bodysuit

datum/gear/uniform/bodysuiteva
	display_name = "EVA Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuiteva

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
	display_name = "Nudity Permit"
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
	display_name = "GN Shorts"
	path = /obj/item/clothing/under/fluff/gnshorts

// Latex maid dress
/datum/gear/uniform/latexmaid
	display_name = "Latex Maid Dress"
	path = /obj/item/clothing/under/fluff/latexmaid

//Tron Siren outfit
/datum/gear/uniform/siren
	display_name = "Jumpsuit - Siren"
	path = /obj/item/clothing/under/fluff/siren

/datum/gear/uniform/suit/v_nanovest
	display_name = "Varmacorp Nanovest"
	path = /obj/item/clothing/under/fluff/v_nanovest

/datum/gear/uniform/greyskirt_female
	display_name = "Grey Skirt"
	path = /obj/item/clothing/under/greyskirt_female

/datum/gear/uniform/highwayman_clothes
	display_name = "Highwayman Outfit"
	path = /obj/item/clothing/under/highwayman_clothes

/datum/gear/uniform/businessskirt
	display_name = "Business Skirt"
	path = /obj/item/clothing/under/businessskirt_female

/datum/gear/uniform/simpledress
	display_name = "Simple Dress"
	path = /obj/item/clothing/under/simpledress

/datum/gear/uniform/formalredcoat
	display_name = "Formal Coat - Red"
	path = /obj/item/clothing/under/redcoatformal

/datum/gear/uniform/vice
	display_name = "Vice Officer's Jumpsuit"
	path = /obj/item/clothing/under/rank/vice

/datum/gear/uniform/saare
	display_name = "SAARE Uniform"
	path = /obj/item/clothing/under/saare

/datum/gear/uniform/hawaiianpink
	display_name = "Suit - Pink Hawaiian"
	path = /obj/item/clothing/under/hawaiian

/datum/gear/uniform/geisha
	display_name = "Geisha Outfit"
	path = /obj/item/clothing/under/geisha

/datum/gear/uniform/blueshift
	display_name = "Suit - Light Blue"
	path = /obj/item/clothing/under/blueshift

/datum/gear/uniform/office_worker
	display_name = "Suit - Office Worker"
	path = /obj/item/clothing/under/office_worker

/datum/gear/uniform/tracksuit_blue
	display_name = "Tracksuit - Blue"
	path = /obj/item/clothing/under/tracksuit_blue
