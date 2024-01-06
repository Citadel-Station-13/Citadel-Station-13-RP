/obj/item/reagent_containers/food/drinks/metaglass
	name = "metamorphic glass"
	desc = "This glass changes shape and form depending on the drink inside... fancy!"
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	integrity_flags = INTEGRITY_ACIDPROOF
	center_of_mass = list("x"=16, "y"=10)
	materials_base = list(MAT_GLASS = 500)
	icon = 'icons/obj/drinks.dmi'

	var/static/list/lookup = create_lookup()

/obj/item/reagent_containers/food/drinks/metaglass/on_reagent_change()
	if (reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		var/list/data = lookup[R.type]
		if(R.glass_icon_state)
			icon_state = R.glass_icon_state
		else
			icon_state = "glass_brown"
		if(R.glass_name)
			name = R.glass_name
		else
			name = "Glass of.. what?"
		if(R.glass_desc)
			desc = R.glass_desc
		else
			desc = "You can't really tell what this is."
		if(D["center_of_mass"])
			center_of_mass = D["center_of_mass"]
		else
			center_of_mass = list("x"=16, "y"=10)
		if(R.price_tag)
			price_tag = R.price_tag
		else
			price_tag = null
	else
		icon_state = "glass_empty"
		name = "metamorphic glass"
		desc = "This glass changes shape and form depending on the drink inside... fancy!"
		center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/metaglass/proc/create_lookup()
	return list(
		/datum/reagent/adminordrazine = list(
			"icon_state" = "golden_cup",
		),
		/datum/reagent/chloralhydrate/beer2 = list(
			"icon_state" = "beerglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/blood = list(
			"icon_state" = "glass_red",
		),
		/datum/reagent/water = list(
			"icon_state" = "glass_clear",
		),
		/datum/reagent/fuel = list(
			"icon_state" = "dr_gibb_glass",
		),
		/datum/reagent/ethanol = list(
			"icon_state" = "glass_clear",
		),
		/datum/reagent/sugar = list(
			"icon_state" = "iceglass",
		),
		/datum/reagent/drink/juice/banana = list(
			"icon_state" = "banana",
		),
		/datum/reagent/drink/juice/berry = list(
			"icon_state" = "berryjuice",
		),
		/datum/reagent/drink/juice/carrot = list(
			"icon_state" = "carrotjuice",
		),
		/datum/reagent/drink/juice/ = list(
			"icon_state" = "grapejuice",
		),
		/datum/reagent/drink/juice/lemon = list(
			"icon_state" = "lemonjuice",
		),
		/datum/reagent/drink/juice/apple = list(
			"icon_state" = "applejuice",
		),
		/datum/reagent/drink/juice/lime = list(
			"icon_state" = "glass_green",
		),
		/datum/reagent/drink/juice/orange = list(
			"icon_state" = "glass_orange",
		),
		/datum/reagent/toxin/poisonberryjuice = list(
			"icon_state" = "poisonberryjuice",
		),
		/datum/reagent/drink/juice/potato = list(
			"icon_state" = "glass_brown",
		),
		/datum/reagent/drink/juice/tomato = list(
			"icon_state" = "glass_red",
		),
		/datum/reagent/drink/juice/watermelon = list(
			"icon_state" = "glass_red",
		),
		/datum/reagent/drink/milk = list(
			"icon_state" = "glass_white",
		),
		/datum/reagent/drink/milk/pilk = list(
			"icon_state" = "glass_lightbrown",
		),
		/datum/reagent/drink/milk/chocolate = list(
			"icon_state" = "glass_brown",
		),
		/datum/reagent/drink/tea = list(
			"icon_state" = "bigteacup",
		),
		/datum/reagent/drink/tea/icetea = list(
			"icon_state" = "icedteaglass",
			"center_of_mass" = list("x"=15, "y"=10),
		),
		/datum/reagent/drink/coffee = list(
			"icon_state" = "hot_coffee",
		),
		/datum/reagent/drink/coffee/icecoffee = list(
			"icon_state" = "icedcoffeeglass",
		),
		/datum/reagent/drink/coffee/soy_latte = list(
			"icon_state" = "soy_latte",
			"center_of_mass" = list("x"=15, "y"=9),
		),
		/datum/reagent/drink/coffee/cafe_latte = list(
			"icon_state" = "cafe_latte",
			"center_of_mass" = list("x"=15, "y"=9),
		),
		/datum/reagent/drink/hot_coco = list(
			"icon_state" = "chocolateglass",
		),
		/datum/reagent/drink/soda/sodawater = list(
			"icon_state" = "glass_clear",
		),
		/datum/reagent/drink/soda/grapesoda = list(
			"icon_state" = "gsodaglass",
		),
		/datum/reagent/drink/soda/tonic = list(
			"icon_state" = "glass_clear",
		),
		/datum/reagent/drink/soda/lemonade = list(
			"icon_state" = "lemonadeglass",
		),
		/datum/reagent/drink/soda/kiraspecial = list(
			"icon_state" = "kiraspecial",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/drink/soda/brownstar = list(
			"icon_state" = "brownstar",
		),
		/datum/reagent/drink/milkshake = list(
			"icon_state" = "milkshake",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/drink/rewriter = list(
			"icon_state" = "rewriter",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/drink/soda/nuka_cola = list(
			"icon_state" = "nuka_colaglass",
			"center_of_mass" = list("x"=16, "y"=6),
		),
		/datum/reagent/drink/grenadine = list(
			"icon_state" = "grenadineglass",
			"center_of_mass" = list("x"=17, "y"=6),
		),
		/datum/reagent/drink/soda = list(
			"icon_state" = "glass_brown",
		),
		/datum/reagent/drink/soda/spacemountainwind = list(
			"icon_state" = "Space_mountain_wind_glass",
		),
		/datum/reagent/drink/soda/dr_gibb = list(
			"icon_state" = "dr_gibb_glass",
		),
		/datum/reagent/drink/soda/space_up = list(
			"icon_state" = "space-up_glass",
		),
		/datum/reagent/drink/soda/lemon_lime = list(
			"icon_state" = "lemonlime",
		),
		/datum/reagent/drink/doctor_delight = list(
			"icon_state" = "doctorsdelightglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/ice = list(
			"icon_state" = "iceglass",
		),
		/datum/reagent/drink/nothing = list(
			"icon_state" = "nothing",
		),
		/datum/reagent/drink/oilslick = list(
			"icon_state" = "jar_oil",
			"center_of_mass" = list("x"=15, "y"=12),
		),
		/datum/reagent/drink/nuclearwaste = list(
			"icon_state" = "jar_rad",
			"center_of_mass" = list("x"=15, "y"=12),
		),
		/datum/reagent/drink/sodaoil = list(
			"icon_state" = "jar_water",
			"center_of_mass" = list("x"=15, "y"=12),
		),
		/datum/reagent/ethanol/absinthe = list(
			"icon_state" = "absintheglass",
			"center_of_mass" = list("x"=16, "y"=5),
		),
		/datum/reagent/ethanol/ale = list(
			"icon_state" = "aleglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/arnold_palmer = list(
			"icon_state" = "arnoldpalmer",
			"center_of_mass" = list("x"=16, "y"=4),
		),
		/datum/reagent/drink/soda/appleade = list(
			"icon_state" = "appleade",
			"center_of_mass" = list("x"=16, "y"=4),
		),
		/datum/reagent/drink/soda/melonade = list(
			"icon_state" = "melonade",
			"center_of_mass" = list("x"=16, "y"=4),
		),
		/datum/reagent/drink/soda/pineappleade = list(
			"icon_state" = "pineappleade",
			"center_of_mass" = list("x"=16, "y"=4),
		),
		/datum/reagent/ethanol/balloon = list(
			"icon_state" = "balloon",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/berrycordial = list(
			"icon_state" = "berrycordial",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/binmanbliss = list(
			"icon_state" = "binmanbliss",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/cloverclub = list(
			"icon_state" = "cloverclub",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/collins_mix = list(
			"icon_state" = "collinsmix",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/dreamcream = list(
			"icon_state" = "dreamcream",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/driverspunch = list(
			"icon_state" = "driverspunch",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/ginzamary = list(
			"icon_state" = "ginzamary",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/coffee = list(
			"icon_state" = "glass_brown",
		),
		/datum/reagent/ethanol/coffee/elysiumfacepunch = list(
			"icon_state" = "elysiumfacepunch",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/erebusmoonrise = list(
			"icon_state" = "erebusmoonrise2",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/soda/mintapplesparkle = list(
			"icon_state" = "mintapplesparkle",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/deathbell = list(
			"icon_state" = "deathbell",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/milkshake/chocoshake = list(
			"icon_state" = "chmilkshake",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/drink/milkshake/peanutshake = list(
			"icon_state" = "pbmilkshake",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/drink/lovepotion = list(
			"icon_state" = "lovepotionglass",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/debugger = list(
			"icon_state" = "debugger",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/spacersbrew = list(
			"icon_state" = "spacersbrewglass",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/drink/tropicalfizz = list(
			"icon_state" = "spacersbrewglass",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/galacticpanic = list(
			"icon_state" = "galacticpanicglass",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/drink/shirley_temple = list(
			"icon_state" = "shirleytemple",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/sakebomb = list(
			"icon_state" = "sakebomb",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/saketini = list(
			"icon_state" = "saketini",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/drink/slimeslammer = list(
			"icon_state" = "slickslimeslammer",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/soemmerfire = list(
			"icon_state" = "soemmerfire",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/tamagozake = list(
			"icon_state" = "tamagozake",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/tokyorose = list(
			"icon_state" = "tokyorose3",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/vesper = list(
			"icon_state" = "vesper",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/winebrandy = list(
			"icon_state" = "winebrandy2",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/whiskeysour = list(
			"icon_state" = "whiskeysour",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/natunabrandy = list(
			"icon_state" = "natunabrandy",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/negroni = list(
			"icon_state" = "negroni",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/drink/roy_rogers = list(
			"icon_state" = "royrogers",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/drink/soda/vilelemon = list(
			"icon_state" = "vilelemon",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/virginsip = list(
			"icon_state" = "virginsip",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/drink/tropicalfizz = list(
			"icon_state" = "tropicalfizz",
		),
		/datum/reagent/ethanol/robustin = list(
			"icon_state" = "robustin",
			"center_of_mass" = list("x"=16, "y"=2),
		),
		/datum/reagent/ethanol/rotgut = list(
			"icon_state" = "rotgut",
			"center_of_mass" = list("x"=16, "y"=2),
		),
		/datum/reagent/ethanol/melonspritzer = list(
			"icon_state" = "melonspritzer",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/morningafter = list(
			"icon_state" = "morningafter",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/lotus = list(
			"icon_state" = "lotusglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/sbagliato = list(
			"icon_state" = "sbagliatoglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/fusionnaire = list(
			"icon_state" = "fusionnair3",
		),
		/datum/reagent/ethanol/xanaducannon = list(
			"icon_state" = "xanaducannon",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/bulldog = list(
			"icon_state" = "bulldogglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/italiancrisis = list(
			"icon_state" = "italiancrisisglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/shroomjuice = list(
			"icon_state" = "shroomjuiceglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/honeyshot = list(
			"icon_state" = "honeyshotglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/scsatw = list(
			"icon_state" = "slowcomfortablescrewagainstthewallglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/unsweettea = list(
			"icon_state" = "unsweetteaglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/sweettea = list(
			"icon_state" = "sweetteaglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/originalsin = list(
			"icon_state" = "originalsinglass",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/lovemaker = list(
			"icon_state" = "lovemaker2",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/soda/orangeale = list(
			"icon_state" = "orangeale",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/slimeshot = list(
			"icon_state" = "namedbullet",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/beer = list(
			"icon_state" = "beerglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/bluecuracao = list(
			"icon_state" = "curacaoglass",
			"center_of_mass" = list("x"=16, "y"=5),
		),
		/datum/reagent/ethanol/cognac = list(
			"icon_state" = "cognacglass",
			"center_of_mass" = list("x"=16, "y"=6),
		),
		/datum/reagent/ethanol/deadrum = list(
			"icon_state" = "rumglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/gin = list(
			"icon_state" = "ginvodkaglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/coffee/kahlua = list(
			"icon_state" = "kahluaglass",
			"center_of_mass" = list("x"=15, "y"=7),
		),
		/datum/reagent/ethanol/melonliquor = list(
			"icon_state" = "emeraldglass",
			"center_of_mass" = list("x"=16, "y"=5),
		),
		/datum/reagent/ethanol/rum = list(
			"icon_state" = "rumglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/sake = list(
			"icon_state" = "sakecup",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/godsake = list(
			"icon_state" = "sakeporcelain",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/tequila = list(
			"icon_state" = "tequilaglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/thirteenloko = list(
			"icon_state" = "thirteen_loko_glass",
		),
		/datum/reagent/ethanol/vermouth = list(
			"icon_state" = "vermouthglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/vodka = list(
			"icon_state" = "ginvodkaglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/whiskey = list(
			"icon_state" = "whiskeyglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/wine = list(
			"icon_state" = "redwineglass",
			"center_of_mass" = list("x"=15, "y"=7),
		),
		/datum/reagent/ethanol/whitewine = list(
			"icon_state" = "whitewineglass",
			"center_of_mass" = list("x"=15, "y"=7),
		),
		/datum/reagent/ethanol/acid_spit = list(
			"icon_state" = "acidspitglass",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/alliescocktail = list(
			"icon_state" = "alliescocktail",
			"center_of_mass" = list("x"=17, "y"=8),
		),
		/datum/reagent/ethanol/aloe = list(
			"icon_state" = "aloe",
			"center_of_mass" = list("x"=17, "y"=8),
		),
		/datum/reagent/ethanol/amasec = list(
			"icon_state" = "amasecglass",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/andalusia = list(
			"icon_state" = "andalusia",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/antifreeze = list(
			"icon_state" = "antifreeze",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/atomicbomb = list(
			"icon_state" = "atomicbombglass",
			"center_of_mass" = list("x"=15, "y"=7),
		),
		/datum/reagent/ethanol/coffee/b52 = list(
			"icon_state" = "b52glass",
		),
		/datum/reagent/ethanol/bahama_mama = list(
			"icon_state" = "bahama_mama",
			"center_of_mass" = list("x"=16, "y"=5),
		),
		/datum/reagent/drink/bananahonk = list(
			"icon_state" = "bananahonkglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/barefoot = list(
			"icon_state" = "b&p",
			"center_of_mass" = list("x"=17, "y"=8),
		),
		/datum/reagent/ethanol/beepsky_smash = list(
			"icon_state" = "beepskysmashglass",
			"center_of_mass" = list("x"=18, "y"=10),
		),
		/datum/reagent/ethanol/bilk = list(
			"icon_state" = "glass_brown",
		),
		/datum/reagent/ethanol/black_russian = list(
			"icon_state" = "blackrussianglass",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/bloody_mary = list(
			"icon_state" = "bloodymaryglass",
		),
		/datum/reagent/ethanol/booger = list(
			"icon_state" = "booger",
		),
		/datum/reagent/ethanol/coffee/brave_bull = list(
			"icon_state" = "bravebullglass",
			"center_of_mass" = list("x"=15, "y"=8),
		),
		/datum/reagent/ethanol/changelingsting = list(
			"icon_state" = "changelingsting",
		),
		/datum/reagent/ethanol/martini = list(
			"icon_state" = "martiniglass",
			"center_of_mass" = list("x"=17, "y"=8),
		),
		/datum/reagent/ethanol/cuba_libre = list(
			"icon_state" = "cubalibreglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/demonsblood = list(
			"icon_state" = "demonsblood",
			"center_of_mass" = list("x"=16, "y"=2),
		),
		/datum/reagent/ethanol/devilskiss = list(
			"icon_state" = "devilskiss",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/narsour = list(
			"icon_state" = "narsour",
			"center_of_mass" = list("x"=15, "y"=10),
		),
		/datum/reagent/ethanol/narsian = list(
			"icon_state" = "narsian",
		),
		/datum/reagent/ethanol/driestmartini = list(
			"icon_state" = "driestmartiniglass",
			"center_of_mass" = list("x"=17, "y"=8),
		),
		/datum/reagent/ethanol/ginfizz = list(
			"icon_state" = "ginfizzglass",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/grog = list(
			"icon_state" = "grogglass",
		),
		/datum/reagent/ethanol/erikasurprise = list(
			"icon_state" = "erikasurprise",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/gargle_blaster = list(
			"icon_state" = "gargleblasterglass",
			"center_of_mass" = list("x"=17, "y"=6),
		),
		/datum/reagent/ethanol/gintonic = list(
			"icon_state" = "gintonicglass",
		),
		/datum/reagent/ethanol/goldschlager = list(
			"icon_state" = "goldschlagerglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/hippies_delight = list(
			"icon_state" = "hippiesdelightglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/hooch = list(
			"icon_state" = "glass_brown2",
		),
		/datum/reagent/ethanol/iced_beer = list(
			"icon_state" = "iced_beerglass",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/irishcarbomb = list(
			"icon_state" = "irishcarbomb",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/coffee/irishcoffee = list(
			"icon_state" = "irishcoffeeglass",
			"center_of_mass" = list("x"=15, "y"=10),
		),
		/datum/reagent/ethanol/irish_cream = list(
			"icon_state" = "irishcreamglass",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/longislandicedtea = list(
			"icon_state" = "longislandicedteaglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/manhattan = list(
			"icon_state" = "manhattanglass",
			"center_of_mass" = list("x"=17, "y"=8),
		),
		/datum/reagent/ethanol/manhattan_proj = list(
			"icon_state" = "proj_manhattanglass",
			"center_of_mass" = list("x"=17, "y"=8),
		),
		/datum/reagent/ethanol/manly_dorf = list(
			"icon_state" = "manlydorfglass",
		),
		/datum/reagent/ethanol/margarita = list(
			"icon_state" = "margaritaglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/mead = list(
			"icon_state" = "meadglass",
			"center_of_mass" = list("x"=17, "y"=10),
		),
		/datum/reagent/ethanol/moonshine = list(
			"icon_state" = "glass_clear",
		),
		/datum/reagent/ethanol/neurotoxin = list(
			"icon_state" = "neurotoxinglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/patron = list(
			"icon_state" = "patronglass",
			"center_of_mass" = list("x"=7, "y"=8),
		),
		/datum/reagent/ethanol/pwine = list(
			"icon_state" = "pwineglass",
			"center_of_mass" = list("x"=16, "y"=5),
		),
		/datum/reagent/ethanol/red_mead = list(
			"icon_state" = "red_meadglass",
			"center_of_mass" = list("x"=17, "y"=10),
		),
		/datum/reagent/ethanol/sbiten = list(
			"icon_state" = "sbitenglass",
			"center_of_mass" = list("x"=17, "y"=8),
		),
		/datum/reagent/ethanol/screwdrivercocktail = list(
			"icon_state" = "screwdriverglass",
			"center_of_mass" = list("x"=15, "y"=10),
		),
		/datum/reagent/drink/silencer = list(
			"icon_state" = "silencerglass",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/singulo = list(
			"icon_state" = "singulo",
			"center_of_mass" = list("x"=17, "y"=4),
		),
		/datum/reagent/ethanol/snowwhite = list(
			"icon_state" = "snowwhite",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/suidream = list(
			"icon_state" = "sdreamglass",
			"center_of_mass" = list("x"=16, "y"=5),
		),
		/datum/reagent/ethanol/syndicatebomb = list(
			"icon_state" = "syndicatebomb",
			"center_of_mass" = list("x"=16, "y"=4),
		),
		/datum/reagent/ethanol/tequila_sunrise = list(
			"icon_state" = "tequilasunriseglass",
		),
		/datum/reagent/ethanol/threemileisland = list(
			"icon_state" = "threemileislandglass",
			"center_of_mass" = list("x"=16, "y"=2),
		),
		/datum/reagent/ethanol/toxins_special = list(
			"icon_state" = "toxinsspecialglass",
		),
		/datum/reagent/ethanol/vodkamartini = list(
			"icon_state" = "martiniglass",
			"center_of_mass" = list("x"=17, "y"=8),
		),
		/datum/reagent/ethanol/vodkatonic = list(
			"icon_state" = "vodkatonicglass",
			"center_of_mass" = list("x"=16, "y"=7),
		),
		/datum/reagent/ethanol/white_russian = list(
			"icon_state" = "whiterussianglass",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/whiskey_cola = list(
			"icon_state" = "whiskeycolaglass",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/whiskeysoda = list(
			"icon_state" = "whiskeysodaglass2",
			"center_of_mass" = list("x"=16, "y"=9),
		),
		/datum/reagent/ethanol/specialwhiskey = list(
			"icon_state" = "whiskeyglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/godka = list(
			"icon_state" = "godkabottle",
			"center_of_mass" = list("x"=17, "y"=15),
		),
		/datum/reagent/ethanol/holywine = list(
			"icon_state" = "holywineglass",
			"center_of_mass" = list("x"=15, "y"=7),
		),
		/datum/reagent/ethanol/holy_mary = list(
			"icon_state" = "holymaryglass",
		),
		/datum/reagent/ethanol/angelswrath = list(
			"icon_state" = "angelswrath",
			"center_of_mass" = list("x"=16, "y"=2),
		),
		/datum/reagent/ethanol/angelskiss = list(
			"icon_state" = "angelskiss",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/ichor_mead = list(
			"icon_state" = "ichor_meadglass",
			"center_of_mass" = list("x"=17, "y"=10),
		),
		/datum/reagent/drink/eggnog = list(
			"icon_state" = "eggnog",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/cider = list(
			"icon_state" = "ciderglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/drink/soda/gibbfloat = list(
			"icon_state" = "gibbfloats",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/mintjulep = list(
			"icon_state" = "mintjulep",
			"center_of_mass" = list("x"=16, "y"=16),
		),
		/datum/reagent/ethanol/oldfashioned = list(
			"icon_state" = "oldfashioned",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/bitters = list(
			"icon_state" = "bittersglass",
		),
		/datum/reagent/ethanol/planterspunch = list(
			"icon_state" = "planterspunch",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/olympusmons = list(
			"icon_state" = "olympusmons",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/sazerac = list(
			"icon_state" = "sazerac",
			"center_of_mass" = list("x"=16, "y"=16),
		),
		/datum/reagent/ethanol/junglejuice = list(
			"icon_state" = "junglejuice",
		),
		/datum/reagent/ethanol/gimlet = list(
			"icon_state" = "gimlet",
			"center_of_mass" = list("x"=16, "y"=16),
		),
		/datum/reagent/ethanol/chrysanthemum = list(
			"icon_state" = "chrysanthemum",
		),
		/datum/reagent/ethanol/voxdelight = list(
			"icon_state" = "voxdelight",
		),
		/datum/reagent/ethanol/daiquiri = list(
			"icon_state" = "daiquiri",
		),
		/datum/reagent/ethanol/firepunch = list(
			"icon_state" = "firepunch",
		),
		/datum/reagent/ethanol/screamingviking = list(
			"icon_state" = "screamingviking",
		),
		/datum/reagent/ethanol/paloma = list(
			"icon_state" = "paloma",
		),
		/datum/reagent/ethanol/euphoria = list(
			"icon_state" = "euphoria",
			"center_of_mass" = list("x"=16, "y"=16),
		),
		/datum/reagent/ethanol/wine/champagnejericho = list(
			"icon_state" = "champagneglass",
		),
		/datum/reagent/ethanol/wine/champagne = list(
			"icon_state" = "champagneglass",
		),
		/datum/reagent/ethanol/newsheriff = list(
			"icon_state" = "newsheriff",
		),
		/datum/reagent/ethanol/thehuckleberry = list(
			"icon_state" = "thehuckleberry",
		),
		/datum/reagent/ethanol/quickdraw = list(
			"icon_state" = "quickdraw",
		),
		/datum/reagent/ethanol/dmhand = list(
			"icon_state" = "dmhand",
		),
		/datum/reagent/ethanol/snakeoil = list(
			"icon_state" = "snakeoil",
		),
		/datum/reagent/ethanol/highnoon = list(
			"icon_state" = "highnoon",
		),
		/datum/reagent/ethanol/bloodmeridian = list(
			"icon_state" = "bloodmeridian",
		),
		/datum/reagent/ethanol/theoutlaw = list(
			"icon_state" = "theoutlaw",
		),
		/datum/reagent/ethanol/thelawman = list(
			"icon_state" = "thelawman",
		),
		/datum/reagent/ethanol/hangmansnoose = list(
			"icon_state" = "hangmansnoose",
		),
		/datum/reagent/ethanol/bigiron = list(
			"icon_state" = "bigiron",
		),
		/datum/reagent/ethanol/lastcactus = list(
			"icon_state" = "lastcactus",
		),
		/datum/reagent/drink/soda/rootbeerfloat = list(
			"icon_state" = "rootbeerfloat",
		),
		/datum/reagent/ethanol/thebestboy = list(
			"icon_state" = "thebestboy",
		),
		/datum/reagent/drink/soda/astral_wind = list(
			"icon_state" = "astral_wind",
		),
		/datum/reagent/drink/soda/solar_wind = list(
			"icon_state" = "solar_wind",
		),
		/datum/reagent/drink/soda/vortex_chill = list(
			"icon_state" = "vortex_chill",
		),
		/datum/reagent/drink/soda/nebula_riptide = list(
			"icon_state" = "nebula_riptide",
		),
		/datum/reagent/ethanol/sexonthebeach = list(
			"icon_state" = "sexonthebeachglass",
		),
		/datum/reagent/drink/virginsexonthebeach = list(
			"icon_state" = "virginsexonthebeachglass",
		),
		/datum/reagent/drink/sugarrush = list(
			"icon_state" = "sugarrushglass",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/phobos = list(
			"icon_state" = "phobos",
		),
		/datum/reagent/ethanol/greenstuff = list(
			"icon_state" = "greenstuff",
		),
		/datum/reagent/ethanol/russianbastard = list(
			"icon_state" = "ginvodkaglass",
			"center_of_mass" = list("x"=16, "y"=12),
		),
		/datum/reagent/ethanol/willtolive = list(
			"icon_state" = "willtolive",
		),
		/datum/reagent/ethanol/desiretodie = list(
			"icon_state" = "desiretodie",
		),
		/datum/reagent/drink/raspberrybeesknees = list(
			"icon_state" = "raspberrybeesknees",
		),
		/datum/reagent/ethanol/sidecar = list(
			"icon_state" = "sidecar",
		),
		/datum/reagent/ethanol/french75 = list(
			"icon_state" = "french75",
		),
		/datum/reagent/ethanol/french76 = list(
			"icon_state" = "french75",
		),
		/datum/reagent/ethanol/lastword = list(
			"icon_state" = "lastword",
		),
		/datum/reagent/drink/watermelonsmoothie = list(
			"icon_state" = "watermelonsmoothie",
		),
		/datum/reagent/drink/orangesmoothie = list(
			"icon_state" = "orangesmoothie",
		),
		/datum/reagent/drink/limesmoothie = list(
			"icon_state" = "limesmoothie",
		),
		/datum/reagent/drink/lemonsmoothie = list(
			"icon_state" = "lemonsmoothie",
		),
		/datum/reagent/drink/berrysmoothie = list(
			"icon_state" = "berrysmoothie",
		),
		/datum/reagent/drink/applesmoothie = list(
			"icon_state" = "applesmoothie",
		),
		/datum/reagent/drink/grapesmoothie = list(
			"icon_state" = "grapesmoothie",
		),
		/datum/reagent/ethanol/goliathspit = list(
			"icon_state" = "goliathspit",
		),
		/datum/reagent/ethanol/maryonacross = list(
			"icon_state" = "maryonacross",
		),
		/datum/reagent/ethanol/royaljelly = list(
			"icon_state" = "royaljelly",
		),
		/datum/reagent/drink/tea/icetea/milktea/matchabubbletea = list(
			"icon_state" = "bubbleteamatcha",
		),
		/datum/reagent/drink/tea/icetea/milktea/tarobubbletea = list(
			"icon_state" = "bubbleteataro",
		),
		/datum/reagent/ethanol/coquito = list(
			"icon_state" = "coconut",
		),
		/datum/reagent/ethanol/bludsfizz = list(
			"icon_state" = "blud_orange",
		),
		/datum/reagent/ethanol/nightsdelight = list(
			"icon_state" = "nightsdelight",
		),
		/datum/reagent/ethanol/wronghat = list(
			"icon_state" = "wronghat",
		),
		/datum/reagent/ethanol/braindrain = list(
			"icon_state" = "braindrain",
		),
		/datum/reagent/ethanol/holygrail = list(
			"icon_state" = "holygrail",
		),
		//Never Fade Away
		/datum/reagent/ethanol/silverhand = list(
			"icon_state" = "silverhand",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/welles = list(
			"icon_state" = "welles",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/martinez = list(
			"icon_state" = "martinez",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/mimosa = list(
			"icon_state" = "mimosa",
			"center_of_mass" = list("x"=16, "y"=8),
		),
		/datum/reagent/ethanol/internationale = list(
			"icon_state" = "internationaleglass",
			"center_of_mass" = list("x" = 16, "y" = 9),
		)
	)
