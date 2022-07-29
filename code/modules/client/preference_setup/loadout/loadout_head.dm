//Hats & Headwear
/datum/gear/head
	name = "Bandana - Pirate-Red"
	path = /obj/item/clothing/head/bandana
	slot = SLOT_ID_HEAD
	sort_category = "Hats and Headwear"

/datum/gear/head/bandana_green
	name = "Bandana - Green"
	path = /obj/item/clothing/head/greenbandana

/datum/gear/head/bandana_orange
	name = "Bandana - Orange"
	path = /obj/item/clothing/head/orangebandana

/datum/gear/head/beret
	name = "Beret - Red"
	path = /obj/item/clothing/head/beret

/datum/gear/head/cap
	name = "Cap - Black"
	path = /obj/item/clothing/head/soft/black

/datum/gear/head/cap/blue
	name = "Cap - Blue"
	path = /obj/item/clothing/head/soft/blue

/datum/gear/head/cap/mailman
	name = "Cap - Blue Station"
	path = /obj/item/clothing/head/mailman

/datum/gear/head/cap/flat
	name = "Cap - Brown-Flat"
	path = /obj/item/clothing/head/flatcap

/datum/gear/head/cap/green
	name = "Cap - Green"
	path = /obj/item/clothing/head/soft/green

/datum/gear/head/cap/grey
	name = "Cap - Grey"
	path = /obj/item/clothing/head/soft/grey

/datum/gear/head/cap/orange
	name = "Cap - Orange"
	path = /obj/item/clothing/head/soft/orange

/datum/gear/head/cap/purple
	name = "Cap - Purple"
	path = /obj/item/clothing/head/soft/purple

/datum/gear/head/cap/rainbow
	name = "Cap - Rainbow"
	path = /obj/item/clothing/head/soft/rainbow

/datum/gear/head/cap/red
	name = "Cap - Red"
	path = /obj/item/clothing/head/soft/red

/datum/gear/head/cap/yellow
	name = "Cap - Yellow"
	path = /obj/item/clothing/head/soft/yellow

/datum/gear/head/cap/white
	name = "Cap (Colorable)"
	path = /obj/item/clothing/head/soft/mime

/datum/gear/head/cap/white/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/cap/mbill
	name = "Cap - Bill"
	path = /obj/item/clothing/head/soft/mbill

/*/datum/gear/head/cap/sol
	name = "Cap - Sol"
	path = /obj/item/clothing/head/soft/sol

/datum/gear/head/cap/expdition
	name = "Cap - Expedition"
	path = /obj/item/clothing/head/soft/sol/expedition

/datum/gear/head/cap/fleet
	name = "Cap - Fleet"
	path = /obj/item/clothing/head/soft/sol/fleet*/

/datum/gear/head/cowboy
	name = "Cowboy Hat - Rodeo"
	path = /obj/item/clothing/head/cowboy_hat

/datum/gear/head/cowboy/black
	name = "Cowboy Hat - Black"
	path = /obj/item/clothing/head/cowboy_hat/black

/datum/gear/head/cowboy/pink
	name = "Cowboy Hat - Pink"
	path = /obj/item/clothing/head/cowboy_hat/pink

/datum/gear/head/cowboy/wide
	name = "Cowboy Hat - Wide"
	path = /obj/item/clothing/head/cowboy_hat/wide

/datum/gear/head/fedora
	name = "Fedora - Brown"
	path = /obj/item/clothing/head/fedora/brown

/datum/gear/head/fedora/grey
	name = "Fedora - Grey"
	path = /obj/item/clothing/head/fedora/grey

/datum/gear/head/fedora/floppy
	name = "Wide Brimmed Hat"
	path = /obj/item/clothing/head/fedora/floppy

/datum/gear/head/hairflower
	name = "Hair Flower Pin (Colorable)"
	path = /obj/item/clothing/head/pin/flower/white

/datum/gear/head/hairflower/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/pin
	name = "Pin Selection"
	path = /obj/item/clothing/head/pin

/datum/gear/head/pin/New()
	..()
	var/list/pins = list()
	for(var/pin in typesof(/obj/item/clothing/head/pin))
		var/obj/item/clothing/head/pin/pin_type = pin
		pins[initial(pin_type.name)] = pin_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(pins, /proc/cmp_text_asc))

/datum/gear/head/hardhat
	name = "Hardhat Selection"
	path = /obj/item/clothing/head/hardhat
	cost = 2

/datum/gear/head/hardhat/New()
	..()
	var/list/hardhats = list()
	for(var/hardhat in typesof(/obj/item/clothing/head/hardhat))
		var/obj/item/clothing/head/hardhat/hardhat_type = hardhat
		hardhats[initial(hardhat_type.name)] = hardhat_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(hardhats, /proc/cmp_text_asc))

/datum/gear/head/boater
	name = "Hat, Boatsman"
	path = /obj/item/clothing/head/boaterhat

/datum/gear/head/bowler
	name = "Hat, Bowler"
	path = /obj/item/clothing/head/bowler

/datum/gear/head/fez
	name = "Hat, Fez"
	path = /obj/item/clothing/head/fez

/datum/gear/head/rice
	name = "Hat, Rice"
	path = /obj/item/clothing/head/rice

/datum/gear/head/tophat
	name = "Hat, Tophat"
	path = /obj/item/clothing/head/that

/datum/gear/head/wig/philosopher
	name = "Natural Philosopher's Wig"
	path = /obj/item/clothing/head/philosopher_wig

/datum/gear/head/wig
	name = "Powdered Wig"
	path = /obj/item/clothing/head/powdered_wig

/datum/gear/head/ushanka
	name = "Ushanka"
	path = /obj/item/clothing/head/ushanka

/datum/gear/head/santahat
	name = "Santa Hat"
	path = /obj/item/clothing/head/santa
	cost = 2

/datum/gear/head/santahat/New()
	..()
	var/list/santahats = list()
	for(var/santahat in typesof(/obj/item/clothing/head/santa))
		var/obj/item/clothing/head/santa/santahat_type = santahat
		santahats[initial(santahat_type.name)] = santahat_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(santahats, /proc/cmp_text_asc))

/datum/gear/head/hijab
	name = "Hijab (Colorable)"
	path = /obj/item/clothing/head/hijab

/datum/gear/head/hijab/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/kippa
	name = "Kippa (Colorable)"
	path = /obj/item/clothing/head/kippa

/datum/gear/head/kippa/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/turban
	name = "Turban (Colorable)"
	path = /obj/item/clothing/head/turban

/datum/gear/head/turban/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/taqiyah
	name = "Taqiyah (Colorable)"
	path = /obj/item/clothing/head/taqiyah

/datum/gear/head/taqiyah/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/kitty
	name = "Kitty Ears"
	path = /obj/item/clothing/head/kitty

/datum/gear/head/rabbit
	name = "Rabbit Ears"
	path = /obj/item/clothing/head/rabbitears

/datum/gear/head/maid_band
	name = "Maid Headband"
	path = /obj/item/clothing/head/headband/maid

/datum/gear/head/beanie
	name = "Beanie (Colorable)"
	path = /obj/item/clothing/head/beanie

/datum/gear/head/beanie/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/loose_beanie
	name = "Loose Beanie (Colorable)"
	path = /obj/item/clothing/head/beanie_loose

/datum/gear/head/loose_beanie/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/beretg
	name = "Beret (Colorable)"
	path = /obj/item/clothing/head/beretg

/datum/gear/head/beretg/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/sombrero
	name = "Sombrero"
	path = /obj/item/clothing/head/sombrero

/datum/gear/head/flatCapg
	name = "Flat Cap"
	path = /obj/item/clothing/head/flatcap/grey

/datum/gear/head/flatCapg/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/bow/small
	name = "Hair Bow, Small (Colorable)"
	path = /obj/item/clothing/head/pin/bow

/datum/gear/head/bow/small/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/traveller
	name = "Traveller Hat (Colorable)"
	path = /obj/item/clothing/head/traveller

/datum/gear/head/traveller/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/slime
	name = "Slime hat"
	path = /obj/item/clothing/head/collectable/slime

/datum/gear/head/beret/orion
	name = "Orion Beret Selection"
	path = /obj/item/clothing/head/beret/orion

/datum/gear/head/beret/orion/New()
	..()
	var/list/orions = list()
	for(var/orion_style in typesof(/obj/item/clothing/head/beret/orion))
		var/obj/item/clothing/head/beret/orion/orion = orion_style
		orions[initial(orion.name)] = orion
	gear_tweaks += new/datum/gear_tweak/path(sortTim(orions, /proc/cmp_text_asc))

/datum/gear/head/surgery
	name = "Surgical Cap Selection"
	description = "Choose from a number of rings of different Caps."
	path = /obj/item/clothing/head/surgery

/datum/gear/head/surgery/New()
	..()
	var/Cap_type = list()
	Cap_type["Purple Cap"] = /obj/item/clothing/head/surgery/purple
	Cap_type["Blue Cap"] = /obj/item/clothing/head/surgery/blue
	Cap_type["Green Cap"] = /obj/item/clothing/head/surgery/green
	Cap_type["Black Cap"] = /obj/item/clothing/head/surgery/black
	Cap_type["Navy Cap"] = /obj/item/clothing/head/surgery/navyblue
	gear_tweaks += new/datum/gear_tweak/path(Cap_type)

/datum/gear/head/circuitry
	name = "Headwear, Circuitry (Empty)"
	path = /obj/item/clothing/head/circuitry

/datum/gear/head/maangtikka
	name = "Maang Tikka"
	path = /obj/item/clothing/head/maangtikka

/datum/gear/head/jingasa
	name = "Jingasa"
	path = /obj/item/clothing/head/jingasa

/*/datum/gear/head/cap/sol
	name = "Cap - sol"
	path = /obj/item/clothing/head/soft/sol*/

/datum/gear/head/headbando
	name = "Basic Headband (Colorable)"
	path = /obj/item/clothing/head/fluff/headbando

/datum/gear/head/headbando/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

// happy valentine's day
/datum/gear/head/woodcirclet
	name = "Wooden Circlet"
	path = /obj/item/clothing/head/woodcirclet

/datum/gear/head/rose_crown
	name = "Flower Crown (Rose)"
	path = /obj/item/clothing/head/rose_crown

/datum/gear/head/sunflower_crown
	name = "Flower Crown (Sunflower)"
	path = /obj/item/clothing/head/sunflower_crown

/datum/gear/head/lavender_crown
	name = "Flower Crown (Lavender)"
	path = /obj/item/clothing/head/lavender_crown

/datum/gear/head/harebell_crown
	display_name = "Flower Crown (Harebell)"
	path = /obj/item/clothing/head/harebell_crown

/datum/gear/head/poppy_crown
	name = "Flower Crown (Poppy)"
	path = /obj/item/clothing/head/poppy_crown

/datum/gear/head/nettle_crown
	display_name = "Flower Crown (Thorns)"
	path = /obj/item/clothing/head/nettle_crown
/datum/gear/head/samurai
	name = "Replica Kabuto (Colorable)"
	path = /obj/item/clothing/head/samurai_replica

/datum/gear/head/samurai/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
