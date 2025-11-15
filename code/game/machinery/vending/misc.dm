/obj/machinery/vending/assist
	products = list(
		/obj/item/assembly/prox_sensor = 5,
		/obj/item/assembly/igniter = 3,
		/obj/item/assembly/signaler = 4,
		/obj/item/tool/wirecutters = 1,
		/obj/item/cartridge/signal = 4,
	)
	contraband = list(
		/obj/item/flashlight = 5,
		/obj/item/assembly/timer = 2,
	)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"

/obj/machinery/vending/cart
	name = "PTech"
	desc = "Cartridges for PDAs."
	product_slogans = "Carts to go!"
	icon_state = "cart"
	icon_deny = "cart-deny"
	req_access = list(ACCESS_COMMAND_HOP)
	products = list(
		/obj/item/cartridge/medical = 10,
		/obj/item/cartridge/engineering = 10,
		/obj/item/cartridge/security = 10,
		/obj/item/cartridge/janitor = 10,
		/obj/item/cartridge/signal/science = 10,
		/obj/item/pda/heads = 10,
		/obj/item/cartridge/captain = 3,
		/obj/item/cartridge/quartermaster = 10,
	)
	req_log_access = ACCESS_COMMAND_HOP
	has_logs = 1

/obj/machinery/vending/cigarette
	name = "cigarette machine"
	desc = "If you want to get cancer, might as well do it in style!"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	product_ads = "Probably not bad for you!;Don't believe the scientists!;It's good for you!;Don't quit, buy more!;Smoke!;Nicotine heaven.;Best cigarettes since 2150.;Award-winning cigs.;Feeling temperamental? Try a Temperamento!;Carcinoma Angels - go fuck yerself!;Don't be so hard on yourself, kid. Smoke a Lucky Star!"
	vend_delay = 34
	icon_state = "cigs"
	products = list(
		/obj/item/storage/fancy/cigarettes = 5,
		/obj/item/storage/fancy/cigarettes/dromedaryco = 5,
		/obj/item/storage/fancy/cigarettes/killthroat = 5,
		/obj/item/storage/fancy/cigarettes/luckystars = 5,
		/obj/item/storage/fancy/cigarettes/jerichos = 5,
		/obj/item/storage/fancy/cigarettes/menthols = 5,
		/obj/item/storage/fancy/cigarettes/kingsilvers = 2,
		/obj/item/storage/fancy/cigarettes/subrosas = 2,
		/obj/item/storage/rollingpapers = 5,
		/obj/item/storage/rollingblunts = 5,
		/obj/item/storage/box/matches = 10,
		/obj/item/flame/lighter/random = 4,
	)
	contraband = list(
		/obj/item/flame/lighter/zippo = 4,
	)
	premium = list(
		/obj/item/storage/fancy/cigar = 5,
		/obj/item/storage/fancy/cigarettes/carcinomas = 5,
		/obj/item/storage/fancy/cigarettes/professionals = 5,
		/obj/item/storage/fancy/cigarettes/blackstars = 5,
	)
	prices = list(
		/obj/item/storage/fancy/cigarettes = 12,
		/obj/item/storage/fancy/cigarettes/dromedaryco = 15,
		/obj/item/storage/fancy/cigarettes/killthroat = 17,
		/obj/item/storage/fancy/cigarettes/luckystars = 17,
		/obj/item/storage/fancy/cigarettes/jerichos = 22,
		/obj/item/storage/fancy/cigarettes/menthols = 18,
		/obj/item/storage/fancy/cigarettes/kingsilvers = 27,
		/obj/item/storage/fancy/cigarettes/subrosas = 22,
		/obj/item/storage/rollingpapers = 15,
		/obj/item/storage/rollingblunts = 25,
		/obj/item/storage/box/matches = 3,
		/obj/item/flame/lighter/random = 5,
	)

/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_ads = "FJKLFJSD;AJKFLBJAKL;1234 LOONIES LOL!;>MFW;Kill them fuckers!;GET DAT FUKKEN DISK;HONK!;EI NATH;Destroy the station!;Admin conspiracies since forever!;Space-time bending hardware!"
	products = list(
		/obj/item/clothing/head/wizard = 1,
		/obj/item/clothing/suit/wizrobe = 1,
		/obj/item/clothing/head/wizard/red = 1,
		/obj/item/clothing/suit/wizrobe/red = 1,
		/obj/item/clothing/shoes/sandal = 1,
		/obj/item/staff = 2,
	)

/obj/machinery/vending/giftvendor
	name = "AlliCo Baubles and Confectionaries"
	desc = "For that special someone!"
	icon_state = "giftvendor"
	vend_delay = 15
	products = list(
		/obj/item/storage/fancy/heartbox = 5,
		/obj/item/toy/bouquet = 5,
		/obj/item/toy/bouquet/fake = 4,
		/obj/item/paper/card/smile = 3,
		/obj/item/paper/card/heart = 3,
		/obj/item/paper/card/cat = 3,
		/obj/item/paper/card/flower = 3,
		/obj/item/clothing/accessory/bracelet/friendship = 5,
		/obj/item/toy/plushie/therapy/red = 2,
		/obj/item/toy/plushie/therapy/purple = 2,
		/obj/item/toy/plushie/therapy/blue = 2,
		/obj/item/toy/plushie/therapy/yellow = 2,
		/obj/item/toy/plushie/therapy/orange = 2,
		/obj/item/toy/plushie/therapy/green = 2,
		/obj/item/toy/plushie/nymph = 2,
		/obj/item/toy/plushie/mouse = 2,
		/obj/item/toy/plushie/kitten = 2,
		/obj/item/toy/plushie/lizard = 2,
		/obj/item/toy/plushie/spider = 2,
		/obj/item/toy/plushie/farwa = 2,
		/obj/item/toy/plushie/corgi = 1,
		/obj/item/toy/plushie/octopus = 1,
		/obj/item/toy/plushie/face_hugger = 1,
		/obj/item/toy/plushie/voxie = 1,
		/obj/item/toy/plushie/carp = 1,
		/obj/item/toy/plushie/deer = 1,
		/obj/item/toy/plushie/tabby_cat = 1,
		/obj/item/toy/plushie/cyancowgirl = 1,
		/obj/item/toy/plushie/bear_grizzly = 2,
		/obj/item/toy/plushie/bear_polar = 2,
		/obj/item/toy/plushie/bear_panda = 2,
		/obj/item/toy/plushie/bear_soda = 2,
		/obj/item/toy/plushie/bear_bloody = 2,
		/obj/item/toy/plushie/bear_space = 1,
		/obj/item/toy/plushie/doll = 3,
		/obj/item/storage/daki = 10,
		/obj/item/toy/gnome = 4,
		/obj/item/toy/axi = 3,
		/obj/item/toy/snek = 3,
		/obj/item/toy/pan = 3,
		/obj/item/toy/bun = 3,
		/obj/item/toy/demon = 3,
		/obj/item/toy/jay = 3
	)
	premium = list(
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 1,
		/obj/item/storage/trinketbox = 2,
	)
	prices = list(
		/obj/item/storage/fancy/heartbox = 25,
		/obj/item/toy/bouquet = 25,
		/obj/item/toy/bouquet/fake = 15,
		/obj/item/paper/card/smile = 1,
		/obj/item/paper/card/heart = 1,
		/obj/item/paper/card/cat = 1,
		/obj/item/paper/card/flower = 1,
		/obj/item/clothing/accessory/bracelet/friendship = 10,
		/obj/item/toy/plushie/therapy/red = 20,
		/obj/item/toy/plushie/therapy/purple = 20,
		/obj/item/toy/plushie/therapy/blue = 20,
		/obj/item/toy/plushie/therapy/yellow = 20,
		/obj/item/toy/plushie/therapy/orange = 20,
		/obj/item/toy/plushie/therapy/green = 20,
		/obj/item/toy/plushie/nymph = 35,
		/obj/item/toy/plushie/mouse = 35,
		/obj/item/toy/plushie/kitten = 35,
		/obj/item/toy/plushie/lizard = 35,
		/obj/item/toy/plushie/spider = 35,
		/obj/item/toy/plushie/farwa = 35,
		/obj/item/toy/plushie/corgi = 50,
		/obj/item/toy/plushie/octopus = 50,
		/obj/item/toy/plushie/face_hugger = 50,
		/obj/item/toy/plushie/voxie = 50,
		/obj/item/toy/plushie/carp = 50,
		/obj/item/toy/plushie/deer = 50,
		/obj/item/toy/plushie/tabby_cat = 50,
		/obj/item/toy/plushie/cyancowgirl = 50,
		/obj/item/toy/plushie/bear_grizzly = 20,
		/obj/item/toy/plushie/bear_polar = 20,
		/obj/item/toy/plushie/bear_panda = 20,
		/obj/item/toy/plushie/bear_soda = 35,
		/obj/item/toy/plushie/bear_bloody = 35,
		/obj/item/toy/plushie/bear_space = 50,
		/obj/item/toy/plushie/doll = 50,
		/obj/item/storage/daki = 100,
		/obj/item/toy/gnome = 20,
		/obj/item/toy/axi = 30,
		/obj/item/toy/snek = 30,
		/obj/item/toy/pan = 30,
		/obj/item/toy/bun = 25,
		/obj/item/toy/demon = 15,
		/obj/item/toy/jay = 10
	)

//Custom vendors

/* For later, then
/obj/machinery/vending/weapon_machine
	name = "Frozen Star Guns&Ammo"
	desc = "A self-defense equipment vending machine. When you need to take care of that clown."
	product_slogans = "The best defense is good offense!;Buy for your whole family today!;Nobody can outsmart bullet!;God created man - Frozen Star made them EQUAL!;Nobody can outsmart bullet!;Stupidity can be cured! By LEAD.;Dead kids can't bully your children!"
	product_ads = "Stunning!;Take justice in your own hands!;LEADearship!"
	icon_state = "weapon"
	products = list(/obj/item/flash = 6,
/obj/item/reagent_containers/spray/pepper = 6, /obj/item/gun/projectile/ballistic/olivaw = 5, /obj/item/gun/projectile/ballistic/giskard = 5, /obj/item/ammo_magazine/mg/cl32/rubber = 20)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6)
	prices = list(/obj/item/flash = 600,
/obj/item/reagent_containers/spray/pepper = 800,  /obj/item/gun/projectile/ballistic/olivaw = 1600, /obj/item/gun/projectile/ballistic/giskard = 1200, /obj/item/ammo_magazine/mg/cl32/rubber = 200)
*/

/obj/machinery/vending/glukoz
	name = "Glukoz Pharmavenda"
	desc = "An illicit injector vendor stocked and maintained by the allegedly defunct pharmaceuticals company Glukoz Ltd."
	icon = 'icons/obj/vending.dmi'
	icon_state = "rxvendor"
	icon_vend = "rxvendor"
	product_slogans = "Glukoz Pharmavenda, voted top street pharmaceuticals vendor, 2519!"
	product_ads = "Back so soon?;The hits keep comin'!;If you can afford it, it's only a habit!;Who's gonna know?;In a pinch? It's just a pinch!;Remove the cap!;You'll be back!"
	products = list(
		/obj/item/reagent_containers/hypospray/glukoz = 10,
		/obj/item/reagent_containers/hypospray/glukoz/certaphil = 10,
		/obj/item/reagent_containers/hypospray/glukoz/downer = 10,
		/obj/item/reagent_containers/hypospray/glukoz/fuckit = 10,
		/obj/item/reagent_containers/hypospray/glukoz/hangup = 10,
		/obj/item/reagent_containers/hypospray/glukoz/hypnogamma = 10,
		/obj/item/reagent_containers/hypospray/glukoz/medcon = 10,
		/obj/item/reagent_containers/hypospray/glukoz/multibuzz = 10,
		/obj/item/reagent_containers/hypospray/glukoz/numplus = 10,
		/obj/item/reagent_containers/hypospray/glukoz/oxyduo = 10,
		/obj/item/reagent_containers/hypospray/glukoz/pyrholidon = 10,
		/obj/item/reagent_containers/hypospray/glukoz/viraplus = 10,
	)
	prices = list(
		/obj/item/reagent_containers/hypospray/glukoz = 15,
		/obj/item/reagent_containers/hypospray/glukoz/certaphil = 25,
		/obj/item/reagent_containers/hypospray/glukoz/downer = 25,
		/obj/item/reagent_containers/hypospray/glukoz/fuckit = 50,
		/obj/item/reagent_containers/hypospray/glukoz/hangup = 50,
		/obj/item/reagent_containers/hypospray/glukoz/hypnogamma = 50,
		/obj/item/reagent_containers/hypospray/glukoz/medcon = 75,
		/obj/item/reagent_containers/hypospray/glukoz/multibuzz = 50,
		/obj/item/reagent_containers/hypospray/glukoz/numplus = 50,
		/obj/item/reagent_containers/hypospray/glukoz/oxyduo = 75,
		/obj/item/reagent_containers/hypospray/glukoz/pyrholidon = 50,
		/obj/item/reagent_containers/hypospray/glukoz/viraplus = 25,
	)


/obj/machinery/vending/gaia
	name = "Happy Trails Resort Pass Booth"
	desc = "Automated seller of day passes for the Happy Trails Resort Company."
	icon = 'icons/obj/vending.dmi'
	icon_state = "gaia"
	icon_vend = "gaia-vend"
	product_slogans = "A paradise for every species: Brought to you by Happy Trails!"
	product_ads = "The weather can't be better!; Climates for every species!; Try our VIP Pass!; The sun never sets in paradise!"

	products = list(
		/obj/item/card/id/external/gaia = 30,
		/obj/item/card/id/external/gaia/vip = 15,
	)

	contraband = list(
		/obj/item/card/id/external/gaia/staff = 4,
	)

	prices = list(
		/obj/item/card/id/external/gaia = 150,
		/obj/item/card/id/external/gaia/vip = 250,
	)

/obj/machinery/vending/farmer
	name = "Miaphus Farm vendor"
	desc = "A vending machine put here by some farmers from Miaphus."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	icon_deny = "generic-deny"
	icon_vend = "generic-vend"
	product_slogans = "Its always fresh when it comes out from the ground !"
	product_ads = "Buy my fruits and Vegetable !; Milk, eggs, You should totaly buy some !; Buy or else ill get mad !; No negociations !"

	products = list(
		/obj/item/reagent_containers/food/condiment/flour = 10,
		/obj/item/reagent_containers/food/drinks/bottle/milk = 10,
		/obj/item/storage/fancy/egg_box = 10,
		/obj/item/reagent_containers/food/drinks/bottle/tomatojuice = 5,
		/obj/item/reagent_containers/food/snacks/tomatomeat = 15,
		/obj/item/reagent_containers/food/condiment/enzyme = 10,
		/obj/item/farmbot_arm_assembly = 1,
		/obj/item/seeds/tomatoseed = 10,
		/obj/item/seeds/potatoseed = 15,
		/obj/item/seeds/wheatseed = 15,
	)

	contraband = list(
		/obj/item/gun/projectile/ballistic/shotgun/doublebarrel = 2,
		/obj/item/storage/box/shotgunshells = 2,
	)

	prices = list(
	/obj/item/reagent_containers/food/condiment/flour = 5,
		/obj/item/reagent_containers/food/drinks/bottle/milk = 5,
		/obj/item/storage/fancy/egg_box = 5,
		/obj/item/reagent_containers/food/drinks/bottle/tomatojuice = 4,
		/obj/item/reagent_containers/food/snacks/tomatomeat = 3,
		/obj/item/reagent_containers/food/condiment/enzyme = 8,
		/obj/item/farmbot_arm_assembly = 50,
		/obj/item/seeds/tomatoseed = 2,
		/obj/item/seeds/potatoseed = 1,
		/obj/item/seeds/wheatseed = 1,
	)

/obj/machinery/vending/voidsuit
	name = "Spacesuit Vendor"
	desc = "A vending machine selling spacesuits."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	icon_deny = "generic-deny"
	icon_vend = "generic-vend"
	product_slogans = "My suits will protect you from space !"
	product_ads = "Please buy my suits !; I just wanted this orange one, but I had to buy the full bundle ! Help me !; Look ! Those voidsuit are Fleeexible !"

	products = list(
		/obj/item/clothing/suit/space/emergency = 5,
		/obj/item/clothing/head/helmet/space/emergency = 5,
		/obj/item/clothing/suit/space/traveler = 2,
		/obj/item/clothing/suit/space/traveler/blue = 2,
		/obj/item/clothing/suit/space/traveler/green/dark = 2,
		/obj/item/clothing/suit/space/traveler/green = 2,
		/obj/item/clothing/suit/space/traveler/black = 2,
		/obj/item/clothing/head/helmet/space/traveler = 2,
		/obj/item/clothing/head/helmet/space/traveler/blue = 2,
		/obj/item/clothing/head/helmet/space/traveler/green/dark = 2,
		/obj/item/clothing/head/helmet/space/traveler/green = 2,
		/obj/item/clothing/head/helmet/space/traveler/black = 2,
		/obj/item/clothing/head/helmet/space/void/explorer = 3,
		/obj/item/clothing/suit/space/void/explorer = 3,
		/obj/item/tank/emergency/oxygen = 10,
		/obj/item/tank/emergency/oxygen/double = 2,
		/obj/item/clothing/mask/gas/clear = 10,
	)

	prices = list(
		/obj/item/clothing/suit/space/emergency = 10,
		/obj/item/clothing/head/helmet/space/emergency = 10,
		/obj/item/clothing/suit/space/traveler = 150,
		/obj/item/clothing/suit/space/traveler/blue = 150,
		/obj/item/clothing/suit/space/traveler/green/dark = 150,
		/obj/item/clothing/suit/space/traveler/green = 150,
		/obj/item/clothing/suit/space/traveler/black = 150,
		/obj/item/clothing/head/helmet/space/traveler = 150,
		/obj/item/clothing/head/helmet/space/traveler/blue = 150,
		/obj/item/clothing/head/helmet/space/traveler/green/dark = 150,
		/obj/item/clothing/head/helmet/space/traveler/green = 150,
		/obj/item/clothing/head/helmet/space/traveler/black = 150,
		/obj/item/clothing/head/helmet/space/void/explorer = 125,
		/obj/item/clothing/suit/space/void/explorer = 125,
		/obj/item/tank/emergency/oxygen = 5,
		/obj/item/tank/emergency/oxygen/double = 30,
		/obj/item/clothing/mask/gas/clear = 5,
	)

/obj/machinery/vending/winter
	name = "Wintergear Vendor"
	desc = "A vending machine selling coats and winter gear."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	icon_deny = "generic-deny"
	icon_vend = "generic-vend"
	product_slogans = "snif... Lots of... Place here are ... Freezing... This will heat you up..."
	product_ads = "2 ... Cold worlds here.; ATCHOOO !; ATCHOOO- snif; Snif-..."

	products = list(
		/obj/item/clothing/mask/warmer = 10,
		/obj/item/clothing/suit/storage/hooded/wintercoat = 10,
		/obj/item/clothing/shoes/boots/winter = 10,
		/obj/item/clothing/suit/storage/hooded/wintercoat/olive = 5,
		/obj/machinery/space_heater = 4
	)

	prices = list(
		/obj/item/clothing/mask/warmer = 10,
		/obj/item/clothing/suit/storage/hooded/wintercoat = 15,
		/obj/item/clothing/shoes/boots/winter = 10,
		/obj/item/clothing/suit/storage/hooded/wintercoat/olive = 15,
		/obj/machinery/space_heater = 90,
	)

/obj/machinery/vending/survivalist
	name = "SDF Surplus Gear Vendor"
	desc = "A vending machine put here by the System Defence Force, because of the rising ammount of pirates and danger in the sector."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	icon_deny = "generic-deny"
	icon_vend = "generic-vend"
	product_slogans = "Barely used only for 40 years !"
	product_ads = "The SDF needs more funds !; By buying here you defend the system !; Better than a donation !;20 years of services..."

	products = list(
		/obj/item/storage/box/survival_knife = 6,
		/obj/item/storage/toolbox/lunchbox/survival = 4,
		/obj/item/survivalcapsule = 2,
		/obj/item/gps/survival = 10,
		/obj/item/gun/projectile/ballistic/shotgun/flare = 8,
		/obj/item/clothing/accessory/holster/machete/occupied = 2,
		/obj/item/clothing/accessory/holster/machete/occupied/deluxe = 1,
		/obj/item/material/knife/machete/hatchet = 4,
		/obj/item/gun/projectile/ballistic/pistol = 4,
		/obj/item/storage/box/flare = 10,
		/obj/item/storage/box/handcuffs = 5,
		/obj/item/storage/box/beanbags = 6,
		/obj/item/storage/box/flashshells = 10,
		/obj/item/storage/box/stunshells = 6,
		/obj/item/storage/box/shotgunshells = 5,
		/obj/item/ammo_magazine/a9mm/compact/rubber = 15,
		/obj/item/ammo_magazine/a9mm/compact = 10,
		/obj/item/storage/single_use/mre/random = 15,
		/obj/item/clothing/suit/storage/vest/heavy = 1,
		/obj/item/clothing/suit/storage/vest/press = 2,
		/obj/item/clothing/suit/armor/vest = 4,
	)

	prices = list(
		/obj/item/storage/box/survival_knife = 80,
		/obj/item/storage/toolbox/lunchbox/survival = 5,
		/obj/item/survivalcapsule = 100,
		/obj/item/gps/survival = 10,
		/obj/item/gun/projectile/ballistic/shotgun/flare = 100,
		/obj/item/clothing/accessory/holster/machete/occupied = 100,
		/obj/item/clothing/accessory/holster/machete/occupied/deluxe = 150,
		/obj/item/material/knife/machete/hatchet = 120,
		/obj/item/gun/projectile/ballistic/pistol = 300,
		/obj/item/storage/box/flare = 50,
		/obj/item/storage/box/handcuffs = 80,
		/obj/item/storage/box/beanbags = 80,
		/obj/item/storage/box/flashshells = 60,
		/obj/item/storage/box/stunshells = 100,
		/obj/item/storage/box/shotgunshells = 100,
		/obj/item/ammo_magazine/a9mm/compact/rubber = 90,
		/obj/item/ammo_magazine/a9mm/compact = 100,
		/obj/item/storage/single_use/mre/random = 40,
		/obj/item/clothing/suit/storage/vest/heavy = 350,
		/obj/item/clothing/suit/storage/vest/press = 150,
		/obj/item/clothing/suit/armor/vest = 150,
	)

/obj/machinery/vending/motel
	name = "Nebula Motel Vendor"
	desc = "A vending machine selling the Keycards to the rooms on Nebula."
	icon = 'icons/obj/vending.dmi'
	icon_state = "laptop"
	icon_deny = "laptop-deny"
	icon_vend = "laptop-vend"
	product_slogans = "A place to rest after a long journey !"
	product_ads = "The VIP Room has a cool shuttle bundled in !; You can maybe see the zoo with Room 5 to 8 !; We clean regulary !; Pretty cheap !"

	products = list(
		/obj/item/card/id/external/nebula/room1 = 1,
		/obj/item/card/id/external/nebula/room2 = 1,
		/obj/item/card/id/external/nebula/room3 = 1,
		/obj/item/card/id/external/nebula/room4 = 1,
		/obj/item/card/id/external/nebula/room5 = 1,
		/obj/item/card/id/external/nebula/room6 = 1,
		/obj/item/card/id/external/nebula/room7 = 1,
		/obj/item/card/id/external/nebula/room8 = 1,
		/obj/item/card/id/external/nebula/room9 = 1,

	)

	prices = list(
		/obj/item/card/id/external/nebula/room1 = 30,
		/obj/item/card/id/external/nebula/room2 = 30,
		/obj/item/card/id/external/nebula/room3 = 30,
		/obj/item/card/id/external/nebula/room4 = 30,
		/obj/item/card/id/external/nebula/room5 = 15,
		/obj/item/card/id/external/nebula/room6 = 15,
		/obj/item/card/id/external/nebula/room7 = 15,
		/obj/item/card/id/external/nebula/room8 = 15,
		/obj/item/card/id/external/nebula/room9 = 80,
	)
