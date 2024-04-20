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
/obj/item/reagent_containers/spray/pepper = 6, /obj/item/gun/ballistic/olivaw = 5, /obj/item/gun/ballistic/giskard = 5, /obj/item/ammo_magazine/mg/cl32/rubber = 20)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6)
	prices = list(/obj/item/flash = 600,
/obj/item/reagent_containers/spray/pepper = 800,  /obj/item/gun/ballistic/olivaw = 1600, /obj/item/gun/ballistic/giskard = 1200, /obj/item/ammo_magazine/mg/cl32/rubber = 200)
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
