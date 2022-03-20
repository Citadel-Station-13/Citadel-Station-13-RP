/obj/item/reagent_containers/food/drinks/metaglass
	name = "metamorphic glass"
	desc = "This glass changes shape and form depending on the drink inside... fancy!"
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	unacidable = 1 //glass
	center_of_mass = list("x"=16, "y"=10)
	matter = list("glass" = 500)
	icon = 'icons/obj/drinks.dmi'

/obj/item/reagent_containers/food/drinks/metaglass/on_reagent_change()
	if (reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()

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

		if(R.glass_center_of_mass)
			center_of_mass = R.glass_center_of_mass
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
		return


/*
Drinks Data
*/

/datum/reagent
	var/glass_icon_state = null
	var/glass_center_of_mass = null

/datum/reagent/adminordrazine
	glass_icon_state = "golden_cup"

/datum/reagent/chloralhydrate/beer2
	glass_icon_state = "beerglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/blood
	glass_icon_state = "glass_red"

/datum/reagent/water
	glass_icon_state = "glass_clear"

/datum/reagent/fuel
	glass_icon_state = "dr_gibb_glass"

/datum/reagent/ethanol
	glass_icon_state = "glass_clear"

/datum/reagent/sugar
	glass_icon_state = "iceglass"

/datum/reagent/drink/juice/banana
	glass_icon_state = "banana"

/datum/reagent/drink/juice/berry
	glass_icon_state = "berryjuice"

/datum/reagent/drink/juice/carrot
	glass_icon_state = "carrotjuice"

/datum/reagent/drink/juice/
	glass_icon_state = "grapejuice"

/datum/reagent/drink/juice/lemon
	glass_icon_state = "lemonjuice"

/datum/reagent/drink/juice/apple
	glass_icon_state = "applejuice"

/datum/reagent/drink/juice/lime
	glass_icon_state = "glass_green"

/datum/reagent/drink/juice/orange
	glass_icon_state = "glass_orange"

/datum/reagent/toxin/poisonberryjuice
	glass_icon_state = "poisonberryjuice"

/datum/reagent/drink/juice/potato
	glass_icon_state = "glass_brown"

/datum/reagent/drink/juice/tomato
	glass_icon_state = "glass_red"

/datum/reagent/drink/juice/watermelon
	glass_icon_state = "glass_red"

/datum/reagent/drink/milk
	glass_icon_state = "glass_white"

/datum/reagent/drink/chocolate
	glass_icon_state = "glass_brown"

/datum/reagent/drink/tea
	glass_icon_state = "bigteacup"

/datum/reagent/drink/tea/icetea
	glass_icon_state = "icedteaglass"
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/drink/coffee
	glass_icon_state = "hot_coffee"

/datum/reagent/drink/icecoffee
	glass_icon_state = "icedcoffeeglass"

/datum/reagent/drink/soy_latte
	glass_icon_state = "soy_latte"
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/cafe_latte
	glass_icon_state = "cafe_latte"
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/hot_coco
	glass_icon_state = "chocolateglass"

/datum/reagent/drink/soda/sodawater
	glass_icon_state = "glass_clear"

/datum/reagent/drink/soda/grapesoda
	glass_icon_state = "gsodaglass"

/datum/reagent/drink/soda/tonic
	glass_icon_state = "glass_clear"

/datum/reagent/drink/soda/lemonade
	glass_icon_state = "lemonadeglass"

/datum/reagent/drink/soda/kiraspecial
	glass_icon_state = "kiraspecial"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/drink/soda/brownstar
	glass_icon_state = "brownstar"

/datum/reagent/drink/milkshake
	glass_icon_state = "milkshake"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/rewriter
	glass_icon_state = "rewriter"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/drink/soda/nuka_cola
	glass_icon_state = "nuka_colaglass"
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/drink/grenadine
	glass_icon_state = "grenadineglass"
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/drink/soda/space_cola
	glass_icon_state = "glass_brown"

/datum/reagent/drink/soda/spacemountainwind
	glass_icon_state = "Space_mountain_wind_glass"

/datum/reagent/drink/soda/dr_gibb
	glass_icon_state = "dr_gibb_glass"

/datum/reagent/drink/soda/space_up
	glass_icon_state = "space-up_glass"

/datum/reagent/drink/soda/lemon_lime
	glass_icon_state = "lemonlime"

/datum/reagent/drink/doctor_delight
	glass_icon_state = "doctorsdelightglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/ice
	glass_icon_state = "iceglass"

/datum/reagent/drink/nothing
	glass_icon_state = "nothing"

/datum/reagent/drink/oilslick
	glass_icon_state = "jar_oil"
	glass_center_of_mass = list("x"=15, "y"=12)

/datum/reagent/drink/nuclearwaste
	glass_icon_state = "jar_rad"
	glass_center_of_mass = list("x"=15, "y"=12)

/datum/reagent/drink/sodaoil
	glass_icon_state = "jar_water"
	glass_center_of_mass = list("x"=15, "y"=12)

/datum/reagent/ethanol/absinthe
	glass_icon_state = "absintheglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/ale
	glass_icon_state = "aleglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/arnold_palmer
	glass_icon_state = "arnoldpalmer"
	glass_center_of_mass = list("x"=16, "y"=4)

/datum/reagent/drink/soda/appleade
	glass_icon_state = "appleade"
	glass_center_of_mass = list("x"=16, "y"=4)

/datum/reagent/drink/soda/melonade
	glass_icon_state = "melonade"
	glass_center_of_mass = list("x"=16, "y"=4)

/datum/reagent/drink/soda/pineappleade
	glass_icon_state = "pineappleade"
	glass_center_of_mass = list("x"=16, "y"=4)

/datum/reagent/ethanol/balloon
	glass_icon_state = "balloon"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/berrycordial
	glass_icon_state = "berrycordial"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/binmanbliss
	glass_icon_state = "binmanbliss"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/cloverclub
	glass_icon_state = "cloverclub"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/collins_mix
	glass_icon_state = "collinsmix"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/dreamcream
	glass_icon_state = "dreamcream"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/driverspunch
	glass_icon_state = "driverspunch"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/ginzamary
	glass_icon_state = "ginzamary"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/coffee/elysiumfacepunch
	glass_icon_state = "elysiumfacepunch"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/erebusmoonrise
	glass_icon_state = "erebusmoonrise2"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/soda/mintapplesparkle
	glass_icon_state = "mintapplesparkle"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/deathbell
	glass_icon_state = "deathbell"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/milkshake/chocoshake
	glass_icon_state = "chmilkshake"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/milkshake/peanutshake
	glass_icon_state = "pbmilkshake"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/lovepotion
	glass_icon_state = "lovepotionglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/debugger
	glass_icon_state = "debugger"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/spacersbrew
	glass_icon_state = "spacersbrewglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/tropicalfizz
	glass_icon_state = "spacersbrewglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/galacticpanic
	glass_icon_state = "galacticpanicglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/shirley_temple
	glass_icon_state = "shirleytemple"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/sakebomb
	glass_icon_state = "sakebomb"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/saketini
	glass_icon_state = "saketini"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/slimeslammer
	glass_icon_state = "slickslimeslammer"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/soemmerfire
	glass_icon_state = "soemmerfire"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/tamagozake
	glass_icon_state = "tamagozake"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/tokyorose
	glass_icon_state = "tokyorose3"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/vesper
	glass_icon_state = "vesper"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/winebrandy
	glass_icon_state = "winebrandy2"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/whiskeysour
	glass_icon_state = "whiskeysour"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/natunabrandy
	glass_icon_state = "natunabrandy"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/negroni
	glass_icon_state = "negroni"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/roy_rogers
	glass_icon_state = "royrogers"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/soda/vilelemon
	glass_icon_state = "vilelemon"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/virginsip
	glass_icon_state = "virginsip"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/tropicalfizz
	glass_icon_state = "tropicalfizz"

/datum/reagent/ethanol/robustin
	glass_icon_state = "robustin"
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/rotgut
	glass_icon_state = "rotgut"
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/melonspritzer
	glass_icon_state = "melonspritzer"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/morningafter
	glass_icon_state = "morningafter"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/sugarrush
	glass_icon_state = "sugarrushglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/lotus
	glass_icon_state = "lotusglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/sbagliato
	glass_icon_state = "sbagliatoglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/fusionnaire
	glass_icon_state = "fusionnair3"

/datum/reagent/ethanol/xanaducannon
	glass_icon_state = "xanaducannon"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/bulldog
	glass_icon_state = "bulldogglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/italiancrisis
	glass_icon_state = "italiancrisisglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/shroomjuice
	glass_icon_state = "shroomjuiceglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/honeyshot
	glass_icon_state = "honeyshotglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/scsatw
	glass_icon_state = "slowcomfortablescrewagainstthewallglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/unsweettea
	glass_icon_state = "unsweetteaglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/sweettea
	glass_icon_state = "sweetteaglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/originalsin
	glass_icon_state = "originalsinglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/lovemaker
	glass_icon_state = "lovemaker2"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/soda/orangeale
	glass_icon_state = "orangeale"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/slimeshot
	glass_icon_state = "namedbullet"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/beer
	glass_icon_state = "beerglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/bluecuracao
	glass_icon_state = "curacaoglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/cognac
	glass_icon_state = "cognacglass"
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/ethanol/deadrum
	glass_icon_state = "rumglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/gin
	glass_icon_state = "ginvodkaglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/coffee/kahlua
	glass_icon_state = "kahluaglass"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/melonliquor
	glass_icon_state = "emeraldglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/rum
	glass_icon_state = "rumglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/sake
	glass_icon_state = "sakecup"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/godsake
	glass_icon_state = "sakeporcelain"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/tequila
	glass_icon_state = "tequillaglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/thirteenloko
	glass_icon_state = "thirteen_loko_glass"

/datum/reagent/ethanol/vermouth
	glass_icon_state = "vermouthglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/vodka
	glass_icon_state = "ginvodkaglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/whiskey
	glass_icon_state = "whiskeyglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/wine
	glass_icon_state = "redwineglass"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/whitewine
	glass_icon_state = "whitewineglass"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/acid_spit
	glass_icon_state = "acidspitglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/alliescocktail
	glass_icon_state = "alliescocktail"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/aloe
	glass_icon_state = "aloe"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/amasec
	glass_icon_state = "amasecglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/andalusia
	glass_icon_state = "andalusia"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/antifreeze
	glass_icon_state = "antifreeze"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/atomicbomb
	glass_icon_state = "atomicbombglass"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/coffee/b52
	glass_icon_state = "b52glass"

/datum/reagent/ethanol/bahama_mama
	glass_icon_state = "bahama_mama"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/bananahonk
	glass_icon_state = "bananahonkglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/barefoot
	glass_icon_state = "b&p"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/beepsky_smash
	glass_icon_state = "beepskysmashglass"
	glass_center_of_mass = list("x"=18, "y"=10)

/datum/reagent/ethanol/bilk
	glass_icon_state = "glass_brown"

/datum/reagent/ethanol/black_russian
	glass_icon_state = "blackrussianglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/bloody_mary
	glass_icon_state = "bloodymaryglass"

/datum/reagent/ethanol/booger
	glass_icon_state = "booger"

/datum/reagent/ethanol/coffee/brave_bull
	glass_icon_state = "bravebullglass"
	glass_center_of_mass = list("x"=15, "y"=8)

/datum/reagent/ethanol/changelingsting
	glass_icon_state = "changelingsting"

/datum/reagent/ethanol/martini
	glass_icon_state = "martiniglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/cuba_libre
	glass_icon_state = "cubalibreglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/demonsblood
	glass_icon_state = "demonsblood"
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/devilskiss
	glass_icon_state = "devilskiss"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/driestmartini
	glass_icon_state = "driestmartiniglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/ginfizz
	glass_icon_state = "ginfizzglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/grog
	glass_icon_state = "grogglass"

/datum/reagent/ethanol/erikasurprise
	glass_icon_state = "erikasurprise"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/gargle_blaster
	glass_icon_state = "gargleblasterglass"
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/ethanol/gintonic
	glass_icon_state = "gintonicglass"

/datum/reagent/ethanol/goldschlager
	glass_icon_state = "goldschlagerglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/hippies_delight
	glass_icon_state = "hippiesdelightglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/hooch
	glass_icon_state = "glass_brown2"

/datum/reagent/ethanol/iced_beer
	glass_icon_state = "iced_beerglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/irishcarbomb
	glass_icon_state = "irishcarbomb"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/coffee/irishcoffee
	glass_icon_state = "irishcoffeeglass"
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/ethanol/irish_cream
	glass_icon_state = "irishcreamglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/longislandicedtea
	glass_icon_state = "longislandicedteaglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/manhattan
	glass_icon_state = "manhattanglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/manhattan_proj
	glass_icon_state = "proj_manhattanglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/manly_dorf
	glass_icon_state = "manlydorfglass"

/datum/reagent/ethanol/margarita
	glass_icon_state = "margaritaglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/mead
	glass_icon_state = "meadglass"
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/ethanol/moonshine
	glass_icon_state = "glass_clear"

/datum/reagent/ethanol/neurotoxin
	glass_icon_state = "neurotoxinglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/patron
	glass_icon_state = "patronglass"
	glass_center_of_mass = list("x"=7, "y"=8)

/datum/reagent/ethanol/pwine
	glass_icon_state = "pwineglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/red_mead
	glass_icon_state = "red_meadglass"
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/ethanol/sbiten
	glass_icon_state = "sbitenglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/screwdrivercocktail
	glass_icon_state = "screwdriverglass"
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/ethanol/silencer
	glass_icon_state = "silencerglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/singulo
	glass_icon_state = "singulo"
	glass_center_of_mass = list("x"=17, "y"=4)

/datum/reagent/ethanol/snowwhite
	glass_icon_state = "snowwhite"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/suidream
	glass_icon_state = "sdreamglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/syndicatebomb
	glass_icon_state = "syndicatebomb"
	glass_center_of_mass = list("x"=16, "y"=4)

/datum/reagent/ethanol/tequilla_sunrise
	glass_icon_state = "tequillasunriseglass"

/datum/reagent/ethanol/threemileisland
	glass_icon_state = "threemileislandglass"
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/toxins_special
	glass_icon_state = "toxinsspecialglass"

/datum/reagent/ethanol/vodkamartini
	glass_icon_state = "martiniglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/vodkatonic
	glass_icon_state = "vodkatonicglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/white_russian
	glass_icon_state = "whiterussianglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/whiskey_cola
	glass_icon_state = "whiskeycolaglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/whiskeysoda
	glass_icon_state = "whiskeysodaglass2"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/specialwhiskey
	glass_icon_state = "whiskeyglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/godka
	glass_icon_state = "godkabottle"
	glass_center_of_mass = list("x"=17, "y"=15)

/datum/reagent/ethanol/holywine
	glass_icon_state = "holywineglass"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/holy_mary
	glass_icon_state = "holymaryglass"

/datum/reagent/ethanol/angelswrath
	glass_icon_state = "angelswrath"
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/angelskiss
	glass_icon_state = "angelskiss"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/ichor_mead
	glass_icon_state = "ichor_meadglass"
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/drink/eggnog
	glass_icon_state = "eggnog"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/cider
	glass_icon_state = "ciderglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/gibbfloat
	glass_icon_state = "gibbfloats"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/mintjulep
	glass_icon_state = "mintjulep"
	glass_center_of_mass = list("x"=16, "y"=16)

/datum/reagent/ethanol/oldfashioned
	glass_icon_state = "oldfashioned"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/bitters
	glass_icon_state = "bittersglass"

/datum/reagent/ethanol/planterspunch
	glass_icon_state = "planterspunch"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/olympusmons
	glass_icon_state = "olympusmons"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/sazerac
	glass_icon_state = "sazerac"
	glass_center_of_mass = list("x"=16, "y"=16)

/datum/reagent/ethanol/junglejuice
	glass_icon_state = "junglejuice"

/datum/reagent/ethanol/gimlet
	glass_icon_state = "gimlet"
	glass_center_of_mass = list("x"=16, "y"=16)

/datum/reagent/ethanol/chrysanthemum
	glass_icon_state = "chrysanthemum"

/datum/reagent/ethanol/voxdelight
	glass_icon_state = "voxdelight"

/datum/reagent/ethanol/daiquiri
	glass_icon_state = "daiquiri"

/datum/reagent/ethanol/firepunch
	glass_icon_state = "firepunch"

/datum/reagent/ethanol/screamingviking
	glass_icon_state = "screamingviking"

/datum/reagent/ethanol/paloma
	glass_icon_state = "paloma"

/datum/reagent/ethanol/euphoria
	glass_icon_state = "euphoria"
	glass_center_of_mass = list("x"=16, "y"=16)

/datum/reagent/ethanol/wine/champagnejericho
	glass_icon_state = "champagneglass"

/datum/reagent/ethanol/wine/champagne
	glass_icon_state = "champagneglass"

/datum/reagent/ethanol/newsheriff
	glass_icon_state = "newsheriff"

/datum/reagent/ethanol/thehuckleberry
	glass_icon_state = "thehuckleberry"

/datum/reagent/ethanol/quickdraw
	glass_icon_state = "quickdraw"

/datum/reagent/ethanol/dmhand
	glass_icon_state = "dmhand"

/datum/reagent/ethanol/snakeoil
	glass_icon_state = "snakeoil"

/datum/reagent/ethanol/highnoon
	glass_icon_state = "highnoon"

/datum/reagent/ethanol/bloodmeridian
	glass_icon_state = "bloodmeridian"

/datum/reagent/ethanol/theoutlaw
	glass_icon_state = "theoutlaw"

/datum/reagent/ethanol/thelawman
	glass_icon_state = "thelawman"

/datum/reagent/ethanol/hangmansnoose
	glass_icon_state = "hangmansnoose"

/datum/reagent/ethanol/bigiron
	glass_icon_state = "bigiron"

/datum/reagent/ethanol/lastcactus
	glass_icon_state = "lastcactus"

/datum/reagent/ethanol/rootbeerfloat
	glass_icon_state = "rootbeerfloat"

/datum/reagent/ethanol/thebestboy
	glass_icon_state = "thebestboy"

/datum/reagent/drink/soda/astral_wind
	glass_icon_state = "astral_wind"

/datum/reagent/drink/soda/solar_wind
	glass_icon_state = "solar_wind"

/datum/reagent/drink/soda/vortex_chill
	glass_icon_state = "vortex_chill"

/datum/reagent/ethanol/nebula_riptide
	glass_icon_state = "nebula_riptide"

/datum/reagent/ethanol/sexonthebeach
	glass_icon_state = "sexonthebeachglass"

/datum/reagent/drink/virginsexonthebeach
	glass_icon_state = "virginsexonthebeachglass"

/datum/reagent/ethanol/phobos
	glass_icon_state = "phobos"

/datum/reagent/ethanol/greenstuff
	glass_icon_state = "greenstuff"

/datum/reagent/ethanol/russianbastard
	glass_icon_state = "ginvodkaglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/willtolive
	glass_icon_state = "willtolive"

/datum/reagent/ethanol/desiretodie
	glass_icon_state = "desiretodie"

/datum/reagent/drink/raspberrybeesknees
	glass_icon_state = "raspberrybeesknees"

/datum/reagent/drink/sidecar
	glass_icon_state = "sidecar"

/datum/reagent/drink/french75
	glass_icon_state = "french75"

/datum/reagent/drink/french76
	glass_icon_state = "french75"

/datum/reagent/drink/lastword
	glass_icon_state = "lastword"

/datum/reagent/drink/watermelonsmoothie
	glass_icon_state = "watermelonsmoothie"

/datum/reagent/drink/orangesmoothie
	glass_icon_state = "orangesmoothie"

/datum/reagent/drink/limesmoothie
	glass_icon_state = "limesmoothie"

/datum/reagent/drink/lemonsmoothie
	glass_icon_state = "lemonsmoothie"

/datum/reagent/drink/berrysmoothie
	glass_icon_state = "berrysmoothie"

/datum/reagent/drink/applesmoothie
	glass_icon_state = "applesmoothie"

/datum/reagent/drink/grapesmoothie
	glass_icon_state = "grapesmoothie" // fuck linters

/datum/reagent/ethanol/goliathspit
	glass_icon_state = "goliathspit"
