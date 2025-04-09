/obj/item/reagent_containers/food/drinks/cans
	name = "empty can"
	desc = "You feel like there should be something to drink in here."
	icon_state = "empty"
	volume = 40 //just over one and a half cups
	amount_per_transfer_from_this = 5
	atom_flags = NONE //starts closed
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'
	var/modified_type = /obj/item/trash/punctured_can

/obj/item/reagent_containers/food/drinks/cans/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/tool/screwdriver))
		if(!reagents || reagents.total_volume == 0)
			to_chat(user, "<span class='warning'>You pierce the [src] with the screwdriver.</span>")
			var/turf/T = get_turf(src)
			new modified_type(T)
			qdel(src)

/obj/item/reagent_containers/food/drinks/cans/empty
	name = "sealable can"
	desc = "A special can that can be filled then sealed. For when you want to make your own canned drinks."

//DRINKS

/obj/item/reagent_containers/food/drinks/cans/cola
	name = "\improper Space Cola"
	desc = "Cola. In space."
	icon_state = "cola"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/cola/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cola", 30)

/obj/item/reagent_containers/food/drinks/cans/cola_cherry
	name = "\improper Space Cola Cherry"
	desc = "Cherry cola. In space!"
	icon_state = "cherrycola"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/cola_cherry/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cherrycola", 30)

/obj/item/reagent_containers/food/drinks/cans/cola_coffee
	name = "\improper Space Cola Coffee"
	desc = "Coffee cola. In space!"
	icon_state = "coffeecola"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/cola_coffee/Initialize(mapload)
	. = ..()
	reagents.add_reagent("coffeecola", 30)

/obj/item/reagent_containers/food/drinks/cans/waterbottle
	name = "bottled water"
	desc = "Introduced to the vending machines by Skrellian request, this water probably came from some icy comet in deep space!"
	icon_state = "waterbottle"
	center_of_mass = list("x"=15, "y"=8)
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'

/obj/item/reagent_containers/food/drinks/cans/waterbottle/Initialize(mapload)
	. = ..()
	reagents.add_reagent("water", 30)
/obj/item/reagent_containers/food/drinks/cans/battery
	name = "Battery"
	desc = "A very tall energy drink can with a large green battery icon on the front."
	icon_state = "battry"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/battery/Initialize(mapload)
	. = ..()
	reagents.add_reagent("battery", 60)

/obj/item/reagent_containers/food/drinks/cans/ochamidori
	name = "Ocha Midori"
	desc = "A small bottle of green tea with japanese text written along the wrapper."
	icon_state = "greentea"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/ochamidori/Initialize(mapload)
	. = ..()
	reagents.add_reagent("greentea", 30)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind/Initialize(mapload)
	. = ..()
	reagents.add_reagent("spacemountainwind", 30)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko
	name = "\improper Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko/Initialize(mapload)
	. = ..()
	reagents.add_reagent("thirteenloko", 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	center_of_mass = list("x"=16, "y"=10)


/obj/item/reagent_containers/food/drinks/cans/dr_gibb/Initialize(mapload)
	. = ..()
	reagents.add_reagent("dr_gibb", 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb_cherry
	name = "\improper Dr. Gibb Cherry"
	desc = "A delicious blend of 42 different flavors, but mostly cherry."
	icon_state = "dr_gibbcherry"
	center_of_mass = list("x"=16, "y"=10)


/obj/item/reagent_containers/food/drinks/cans/dr_gibb_cherry/Initialize(mapload)
	. = ..()
	reagents.add_reagent("dr_gibbcherry", 30)

/obj/item/reagent_containers/food/drinks/cans/crystalgibb
	name = "Crystal Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors, now crystal clear!"
	icon_state = "crystalgibb"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/crystalgibb/Initialize(mapload)
	. = ..()
	reagents.add_reagent("crystalgibb", 30)

/obj/item/reagent_containers/food/drinks/cans/ramune
	name = "Ramone"
	desc = "A soda bottle with a large glass ball inside that rattles around when shook."
	icon_state = "ramune"
	center_of_mass = list("x"=16, "y"=10)
	drop_sound = "sound/items/drop/ramunedrop.ogg"

/obj/item/reagent_containers/food/drinks/cans/ramune/Initialize(mapload)
	. = ..()
	reagents.add_reagent("ramune", 30)

/obj/item/reagent_containers/food/drinks/cans/starkist
	name = "\improper Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/starkist/Initialize(mapload)
	. = ..()
	reagents.add_reagent("brownstar", 30)

/obj/item/reagent_containers/food/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/space_up/Initialize(mapload)
	. = ..()
	reagents.add_reagent("space_up", 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime/Initialize(mapload)
	. = ..()
	reagents.add_reagent("lemon_lime", 30)

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/iced_tea/Initialize(mapload)
	. = ..()
	reagents.add_reagent("icetea", 30)

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/grape_juice/Initialize(mapload)
	. = ..()
	reagents.add_reagent("grapejuice", 30)

/obj/item/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/tonic/Initialize(mapload)
	. = ..()
	reagents.add_reagent("tonic", 50)

/obj/item/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/sodawater/Initialize(mapload)
	. = ..()
	reagents.add_reagent("sodawater", 50)

/obj/item/reagent_containers/food/drinks/cans/gingerale
	name = "\improper Classic Ginger Ale"
	desc = "For when you need to be more retro than Nanotrasen already pays you for."
	icon_state = "gingerale"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/gingerale/Initialize(mapload)
	. = ..()
	reagents.add_reagent("gingerale", 30)

/obj/item/reagent_containers/food/drinks/cans/dumbjuice
	name = "DUMB BITCH JUICE!"
	desc = "A tall can of...what one could assume to be a type of soda? There's a very confused looking female vulp on the front."
	icon_state = "dumbjuice"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/dumbjuice/Initialize(mapload)
	. = ..()
	reagents.add_reagent("dumbjuice", 30)

/obj/item/reagent_containers/food/drinks/cans/gondola_energy
	name = "Gondola Energy"
	desc = "Gets you going!"
	icon_state = "gondola_energy"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/gondola_energy/Initialize(mapload)
	. = ..()
	reagents.add_reagent("battery", 20)
	reagents.add_reagent("rewriter", 10)

/obj/item/reagent_containers/food/drinks/cans/geometer
	name = "Geometer Energy"
	desc = "This popular energy drink was banned by Nanotrasen shortly after the Galactic Awakening, although no statement has ever been issued to explain why."
	icon_state = "geometer"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/geometer/Initialize(mapload)
	. = ..()
	reagents.add_reagent("battery", 20)
	reagents.add_reagent("blood", 10)

/obj/item/reagent_containers/food/drinks/cans/coconutwater
	name = "Coconut Water"
	desc = "A bottle of NutClarity brand coconut water."
	icon_state = "tallwaterbottle"
	center_of_mass = list("x"=16, "y"=10)
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'

/obj/item/reagent_containers/food/drinks/cans/coconutwater/Initialize(mapload)
	. = ..()
	reagents.add_reagent("coconutwater", 30)

/obj/item/reagent_containers/food/drinks/cans/kyocola
	name = "\improper KyoCola Classic"
	desc = "A can of crisp KyoCola, imported directly from Osaka IV."
	icon_state = "kyocola"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/kyocola/Initialize(mapload)
	. = ..()
	reagents.add_reagent("kyocola", 30)

/obj/item/reagent_containers/food/drinks/cans/kyocola_fire
	name = "\improper KyoCola Fire"
	desc = "A can of crisp KyoCola, spiked with flaming hot spices."
	icon_state = "kyocolafire"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/kyocola_fire/Initialize(mapload)
	. = ..()
	reagents.add_reagent("kyocolafire", 30)

/obj/item/reagent_containers/food/drinks/cans/kyocola_sakura
	name = "\improper KyoCola Sakura"
	desc = "A can of crisp KyoCola, subtly flavored with cherry blossoms."
	icon_state = "kyocolasakura"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/kyocola_sakura/Initialize(mapload)
	. = ..()
	reagents.add_reagent("kyocolacherry", 30)

/obj/item/reagent_containers/food/drinks/cans/kyocola_blue
	name = "\improper KyoCola Blue"
	desc = "A limited edition can of crisp KyoCola, paired with a mellow violet flavor."
	icon_state = "kyocolablue"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/kyocola_blue/Initialize(mapload)
	. = ..()
	reagents.add_reagent("kyocolablue", 30)

/obj/item/reagent_containers/food/drinks/cans/robustexpress
	name = "\improper Robust Express"
	desc = "Delicious caffeine awaits inside. It's pleasantly warm to the touch."
	icon_state = "robustexpress"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/robustexpress/Initialize(mapload)
	. = ..()
	reagents.add_reagent("coffee", 30)

/obj/item/reagent_containers/food/drinks/cans/robustexpressiced
	name = "\improper Robust Express Iced"
	desc = "Delicious caffeine awaits inside. It's refreshingly cool to the touch."
	icon_state = "robustexpressiced"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/robustexpressiced/Initialize(mapload)
	. = ..()
	reagents.add_reagent("icecoffee", 30)

/obj/item/reagent_containers/food/drinks/cans/robustexpresslatte
	name = "\improper Robust Express Latte"
	desc = "Delicious caffeine awaits inside, now with milk! It's pleasantly warm to the touch."
	icon_state = "robustexpresslatte"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/robustexpresslatte/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cafe_latte", 30)

//Alraune Drink Import
/obj/item/reagent_containers/food/drinks/cans/alraune
	name = "Loam Nutri-Juice"
	desc = "A mixture of springwater, natural fertilizers, and minerals. Enjoyed by Diona and Alraune. Hated by everyone else."
	icon_state = "alraunedrink"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/alraune/Initialize(mapload)
	. = ..()
	reagents.add_reagent("diethylamine", 20)
	reagents.add_reagent("water", 10)

//Tajara Drinks
/obj/item/reagent_containers/food/drinks/cans/evapmilk
	name = "Evaporated Milk"
	desc = "Milk that has been boiled to make it more shelf stable. A common practice among poorer and less advanced regions of space."
	icon_state = "evapmilk"

/obj/item/reagent_containers/food/drinks/cans/evapmilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent("evapmilk", 30)

/obj/item/reagent_containers/food/drinks/cans/kompot_taj
	name = "Ashomarr'darr"
	desc = "A traditional Tajara beverage similar to Kompot. It is made by boiling Ashomarr berries in water."
	icon_state = "kompot_taj"

/obj/item/reagent_containers/food/drinks/cans/kompot_taj/Initialize(mapload)
	. = ..()
	reagents.add_reagent("kompot_taj", 30)

/obj/item/reagent_containers/food/drinks/cans/watercan
	name = "Can of Water"
	desc = "Probably contains less microplastics then bottled water."
	icon_state = "watercan"

/obj/item/reagent_containers/food/drinks/cans/watercan/Initialize(mapload)
	. = ..()
	reagents.add_reagent("water", 40) //Important for Crafting Recipes Also means Colonists don't need station/hotsprings for water.

