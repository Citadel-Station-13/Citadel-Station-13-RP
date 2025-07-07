//Hats & Headwear
/datum/loadout_entry/head
	name = "Bandana - Pirate-Red"
	path = /obj/item/clothing/head/bandana
	slot = SLOT_ID_HEAD
	category = LOADOUT_CATEGORY_HATS

/datum/loadout_entry/head/bandana_green
	name = "Bandana - Green"
	path = /obj/item/clothing/head/greenbandana

/datum/loadout_entry/head/bandana_orange
	name = "Bandana - Orange"
	path = /obj/item/clothing/head/orangebandana

/datum/loadout_entry/head/beret
	name = "Beret - Red"
	path = /obj/item/clothing/head/beret

/datum/loadout_entry/head/beret/med
	name = "Beret - Medical"
	path = /obj/item/clothing/head/beret/medical

/datum/loadout_entry/head/cap
	name = "Cap - Black"
	path = /obj/item/clothing/head/soft/black

/datum/loadout_entry/head/cap/blue
	name = "Cap - Blue"
	path = /obj/item/clothing/head/soft/blue

/datum/loadout_entry/head/cap/mailman
	name = "Cap - Blue Station"
	path = /obj/item/clothing/head/mailman

/datum/loadout_entry/head/cap/flat
	name = "Cap - Brown-Flat"
	path = /obj/item/clothing/head/flatcap

/datum/loadout_entry/head/cap/green
	name = "Cap - Green"
	path = /obj/item/clothing/head/soft/green

/datum/loadout_entry/head/cap/grey
	name = "Cap - Grey"
	path = /obj/item/clothing/head/soft/grey

/datum/loadout_entry/head/cap/orange
	name = "Cap - Orange"
	path = /obj/item/clothing/head/soft/orange

/datum/loadout_entry/head/cap/purple
	name = "Cap - Purple"
	path = /obj/item/clothing/head/soft/purple

/datum/loadout_entry/head/cap/rainbow
	name = "Cap - Rainbow"
	path = /obj/item/clothing/head/soft/rainbow

/datum/loadout_entry/head/cap/red
	name = "Cap - Red"
	path = /obj/item/clothing/head/soft/red

/datum/loadout_entry/head/cap/yellow
	name = "Cap - Yellow"
	path = /obj/item/clothing/head/soft/yellow

/datum/loadout_entry/head/cap/white
	name = "Cap (Colorable)"
	path = /obj/item/clothing/head/soft/mime

/datum/loadout_entry/head/cap/mbill
	name = "Cap - Bill"
	path = /obj/item/clothing/head/soft/mbill

/*/datum/loadout_entry/head/cap/sol
	name = "Cap - Sol"
	path = /obj/item/clothing/head/soft/sol

/datum/loadout_entry/head/cap/expdition
	name = "Cap - Expedition"
	path = /obj/item/clothing/head/soft/sol/expedition

/datum/loadout_entry/head/cap/fleet
	name = "Cap - Fleet"
	path = /obj/item/clothing/head/soft/sol/fleet*/

/datum/loadout_entry/head/cowboy
	name = "Cowboy Hat - Rodeo"
	path = /obj/item/clothing/head/cowboy_hat

/datum/loadout_entry/head/cowboy/black
	name = "Cowboy Hat - Black"
	path = /obj/item/clothing/head/cowboy_hat/black

/datum/loadout_entry/head/cowboy/pink
	name = "Cowboy Hat - Pink"
	path = /obj/item/clothing/head/cowboy_hat/pink

/datum/loadout_entry/head/cowboy/wide
	name = "Cowboy Hat - Wide"
	path = /obj/item/clothing/head/cowboy_hat/wide

/datum/loadout_entry/head/fedora
	name = "Fedora - Brown"
	path = /obj/item/clothing/head/fedora/brown

/datum/loadout_entry/head/fedora/grey
	name = "Fedora - Grey"
	path = /obj/item/clothing/head/fedora/grey

/datum/loadout_entry/head/fedora/floppy
	name = "Wide Brimmed Hat"
	path = /obj/item/clothing/head/fedora/floppy

/datum/loadout_entry/head/hairflower
	name = "Hair Flower Pin (Colorable)"
	path = /obj/item/clothing/head/pin/flower/white

/datum/loadout_entry/head/pin
	name = "Pin Selection"
	path = /obj/item/clothing/head/pin

/datum/loadout_entry/head/pin/New()
	..()
	var/list/pins = list()
	for(var/pin in typesof(/obj/item/clothing/head/pin))
		var/obj/item/clothing/head/pin/pin_type = pin
		pins[initial(pin_type.name)] = pin_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(pins, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/head/hardhat
	name = "Hardhat Selection"
	path = /obj/item/clothing/head/hardhat
	cost = 2

/datum/loadout_entry/head/hardhat/New()
	..()
	var/list/hardhats = list()
	for(var/hardhat in typesof(/obj/item/clothing/head/hardhat))
		var/obj/item/clothing/head/hardhat/hardhat_type = hardhat
		hardhats[initial(hardhat_type.name)] = hardhat_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(hardhats, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/head/boater
	name = "Hat, Boatsman"
	path = /obj/item/clothing/head/boaterhat

/datum/loadout_entry/head/bowler
	name = "Hat, Bowler"
	path = /obj/item/clothing/head/bowler

/datum/loadout_entry/head/fez
	name = "Hat, Fez"
	path = /obj/item/clothing/head/fez

/datum/loadout_entry/head/rice
	name = "Hat, Rice"
	path = /obj/item/clothing/head/rice

/datum/loadout_entry/head/tophat
	name = "Hat, Tophat"
	path = /obj/item/clothing/head/that

/datum/loadout_entry/head/wig/philosopher
	name = "Natural Philosopher's Wig"
	path = /obj/item/clothing/head/philosopher_wig

/datum/loadout_entry/head/wig
	name = "Powdered Wig"
	path = /obj/item/clothing/head/powdered_wig

/datum/loadout_entry/head/ushanka
	name = "Ushanka"
	path = /obj/item/clothing/head/ushanka

/datum/loadout_entry/head/santahat
	name = "Santa Hat"
	path = /obj/item/clothing/head/santa
	cost = 2

/datum/loadout_entry/head/santahat/New()
	..()
	var/list/santahats = list()
	for(var/santahat in typesof(/obj/item/clothing/head/santa))
		var/obj/item/clothing/head/santa/santahat_type = santahat
		santahats[initial(santahat_type.name)] = santahat_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(santahats, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/head/hijab
	name = "Hijab (Colorable)"
	path = /obj/item/clothing/head/hijab

/datum/loadout_entry/head/kippa
	name = "Kippa (Colorable)"
	path = /obj/item/clothing/head/kippa

/datum/loadout_entry/head/turban
	name = "Turban (Colorable)"
	path = /obj/item/clothing/head/turban

/datum/loadout_entry/head/taqiyah
	name = "Taqiyah (Colorable)"
	path = /obj/item/clothing/head/taqiyah

/datum/loadout_entry/head/kitty
	name = "Kitty Ears"
	path = /obj/item/clothing/head/kitty

/datum/loadout_entry/head/rabbit
	name = "Rabbit Ears"
	path = /obj/item/clothing/head/rabbitears

/datum/loadout_entry/head/maid_band
	name = "Maid Headband"
	path = /obj/item/clothing/head/headband/maid

/datum/loadout_entry/head/beanie
	name = "Beanie (Colorable)"
	path = /obj/item/clothing/head/beanie

/datum/loadout_entry/head/loose_beanie
	name = "Loose Beanie (Colorable)"
	path = /obj/item/clothing/head/beanie_loose

/datum/loadout_entry/head/beretg
	name = "Beret (Colorable)"
	path = /obj/item/clothing/head/beretg

/datum/loadout_entry/head/beretbs
	name = "Blueshield Beret"
	path = /obj/item/clothing/head/beret/sec/corporate/blueshield

/datum/loadout_entry/head/sombrero
	name = "Sombrero"
	path = /obj/item/clothing/head/sombrero

/datum/loadout_entry/head/flatCapg
	name = "Flat Cap"
	path = /obj/item/clothing/head/flatcap/grey

/datum/loadout_entry/head/bow/small
	name = "Hair Bow, Small (Colorable)"
	path = /obj/item/clothing/head/pin/bow

/datum/loadout_entry/head/traveller
	name = "Traveller Hat (Colorable)"
	path = /obj/item/clothing/head/traveller

/datum/loadout_entry/head/slime
	name = "Slime hat"
	path = /obj/item/clothing/head/collectable/slime

/datum/loadout_entry/head/beret/orion
	name = "Orion Beret Selection"
	path = /obj/item/clothing/head/beret/orion

/datum/loadout_entry/head/beret/orion/New()
	..()
	var/list/orions = list()
	for(var/orion_style in typesof(/obj/item/clothing/head/beret/orion))
		var/obj/item/clothing/head/beret/orion/orion = orion_style
		orions[initial(orion.name)] = orion
	tweaks += new/datum/loadout_tweak/path(tim_sort(orions, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/head/onestar
	name = "One Star Cap"
	path = /obj/item/clothing/head/onestar

/datum/loadout_entry/head/surgery
	name = "Surgical Cap Selection"
	description = "Choose from a number of rings of different Caps."
	path = /obj/item/clothing/head/surgery

/datum/loadout_entry/head/surgery/New()
	..()
	var/Cap_type = list()
	Cap_type["Purple Cap"] = /obj/item/clothing/head/surgery/purple
	Cap_type["Blue Cap"] = /obj/item/clothing/head/surgery/blue
	Cap_type["Green Cap"] = /obj/item/clothing/head/surgery/green
	Cap_type["Black Cap"] = /obj/item/clothing/head/surgery/black
	Cap_type["Navy Cap"] = /obj/item/clothing/head/surgery/navyblue
	tweaks += new/datum/loadout_tweak/path(Cap_type)

/datum/loadout_entry/head/circuitry
	name = "Headwear, Circuitry (Empty)"
	path = /obj/item/clothing/head/circuitry

/datum/loadout_entry/head/maangtikka
	name = "Maang Tikka"
	path = /obj/item/clothing/head/maangtikka

/datum/loadout_entry/head/jingasa
	name = "Jingasa"
	path = /obj/item/clothing/head/jingasa

/*/datum/loadout_entry/head/cap/sol
	name = "Cap - sol"
	path = /obj/item/clothing/head/soft/sol*/

/datum/loadout_entry/head/headbando
	name = "Basic Headband (Colorable)"
	path = /obj/item/clothing/head/fluff/headbando

/datum/loadout_entry/head/eulrhat
	name = "Sleek side cap"
	path = /obj/item/clothing/head/eulrhat

// happy valentine's day
/datum/loadout_entry/head/woodcirclet
	name = "Wooden Circlet"
	path = /obj/item/clothing/head/woodcirclet

/datum/loadout_entry/head/rose_crown
	name = "Flower Crown (Rose)"
	path = /obj/item/clothing/head/rose_crown

/datum/loadout_entry/head/sunflower_crown
	name = "Flower Crown (Sunflower)"
	path = /obj/item/clothing/head/sunflower_crown

/datum/loadout_entry/head/lavender_crown
	name = "Flower Crown (Lavender)"
	path = /obj/item/clothing/head/lavender_crown

/datum/loadout_entry/head/harebell_crown
	display_name = "Flower Crown (Harebell)"
	path = /obj/item/clothing/head/harebell_crown

/datum/loadout_entry/head/poppy_crown
	name = "Flower Crown (Poppy)"
	path = /obj/item/clothing/head/poppy_crown

/datum/loadout_entry/head/nettle_crown
	display_name = "Flower Crown (Thorns)"
	path = /obj/item/clothing/head/nettle_crown
/datum/loadout_entry/head/samurai
	name = "Replica Kabuto (Colorable)"
	path = /obj/item/clothing/head/samurai_replica

/datum/loadout_entry/head/half_pint
	name = "Half-Pint Headband"
	path = /obj/item/clothing/head/half_pint

/datum/loadout_entry/head/bard
	name = "Audacious Wide Brimmed Hat"
	path = /obj/item/clothing/head/bard

/datum/loadout_entry/head/aureate_hood
	name = "Aureate Hood"
	path = /obj/item/clothing/head/hood/aureate

/datum/loadout_entry/head/aureate_hood_dark
	name = "Aureate Dark Hood"
	path = /obj/item/clothing/head/hood/aureate/dark


//Tajaran head wears

/datum/loadout_entry/head/furhat
	name = "Adhomian fur hat"
	path = /obj/item/clothing/head/tajaran/fur

/datum/loadout_entry/head/beret/tajaran
	name = "Adhomian beret selection"
	description = "A selection of Adhomian berets."
	path = /obj/item/clothing/head/beret/tajaran

/datum/loadout_entry/head/beret/tajaran/New()
	..()
	var/list/tberets = list()
	for(var/tberet in (typesof(/obj/item/clothing/head/beret/tajaran)))
		var/obj/item/clothing/head/beret/tajaran/tberet_type = tberet
		tberets[initial(tberet_type.name)] = tberet_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(tberets, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/head/tajaran/circlet
	name = "Adhomian circlet selection"
	description = "A selection of Adhomian circlet."
	path = /obj/item/clothing/head/tajaran/circlet

/datum/loadout_entry/head/tajaran/circlet/New()
	..()
	var/list/tcirclets = list()
	for(var/tcirclet in (typesof(/obj/item/clothing/head/tajaran/circlet)))
		var/obj/item/clothing/head/tajaran/circlet/tcirclet_type = tcirclet
		tcirclets[initial(tcirclet_type.name)] = tcirclet_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(tcirclets, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/head/widestraw
	name = "wide-brimmed straw hat selection"
	path = /obj/item/clothing/head/widestraw

/datum/loadout_entry/head/widestraw/New()
	..()
	var/list/hats = list()
	for(var/hat in typesof(/obj/item/clothing/head/widestraw))
		var/obj/item/clothing/head/hat_path = hat
		hats[initial(hat_path.name)] = hat_path
	tweaks += new/datum/loadout_tweak/path(tim_sort(hats, GLOBAL_PROC_REF(cmp_text_asc)))
