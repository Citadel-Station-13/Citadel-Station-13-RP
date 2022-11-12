//This File contains the recipes for drinks
//Seperation of Drink Recipes and other chemicals


/datum/chemical_reaction/drinks/coffee
	name = "Coffee"
	id = "coffee"
	result = "coffee"
	required_reagents = list("water" = 5, "coffeepowder" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/tea
	name = "Black tea"
	id = "tea"
	result = "tea"
	required_reagents = list("water" = 5, "teapowder" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/greentea
	name = "Green Tea"
	id = "greentea"
	result = "greentea"
	required_reagents = list("water" = 5, "matchapowder" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/hot_coco
	name = "Hot Coco"
	id = "hot_coco"
	result = "hot_coco"
	required_reagents = list("milk" = 5, "coco" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/grapejuice
	name = "Grape Juice"
	id = "grapejuice"
	result = "grapejuice"
	required_reagents = list("water" = 3, "instantgrape" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/orangejuice
	name = "Orange Juice"
	id = "orangejuice"
	result = "orangejuice"
	required_reagents = list("water" = 3, "instantorange" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/watermelonjuice
	name = "Watermelon Juice"
	id = "watermelonjuice"
	result = "watermelonjuice"
	required_reagents = list("water" = 3, "instantwatermelon" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/applejuice
	name = "Apple Juice"
	id = "applejuice"
	result = "applejuice"
	required_reagents = list("water" = 3, "instantapple" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	result = "goldschlager"
	required_reagents = list("vodka" = 10, MAT_GOLD = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/patron
	name = "Patron"
	id = "patron"
	result = "patron"
	required_reagents = list("tequila" = 10, MAT_SILVER = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/bilk
	name = "Bilk"
	id = "bilk"
	result = "bilk"
	required_reagents = list("milk" = 1, "beer" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/icetea
	name = "Iced Tea"
	id = "icetea"
	result = "icetea"
	required_reagents = list("ice" = 1, "tea" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	result = "icecoffee"
	required_reagents = list("ice" = 1, "coffee" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/nuka_cola
	name = "Nuclear Cola"
	id = "nuka_cola"
	result = "nuka_cola"
	required_reagents = list(MAT_URANIUM = 1, "cola" = 5)
	result_amount = 5

/datum/chemical_reaction/drinks/moonshine
	name = "Moonshine"
	id = "moonshine"
	result = "moonshine"
	required_reagents = list("nutriment" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	result = "grenadine"
	required_reagents = list("berryjuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/wine
	name = "Wine"
	id = "wine"
	result = "wine"
	required_reagents = list("grapejuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/pwine
	name = "Poison Wine"
	id = "pwine"
	result = "pwine"
	required_reagents = list("poisonberryjuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	result = "melonliquor"
	required_reagents = list("watermelonjuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	result = "bluecuracao"
	required_reagents = list("orangejuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/spacebeer
	name = "Space Beer"
	id = "spacebeer"
	result = "beer"
	required_reagents = list("cornoil" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/vodka
	name = "Vodka"
	id = "vodka"
	result = "vodka"
	required_reagents = list("potatojuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/cider
	name = "Cider"
	id = "cider"
	result = "cider"
	required_reagents = list("applejuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10


/datum/chemical_reaction/drinks/sake
	name = "Sake"
	id = "sake"
	result = "sake"
	required_reagents = list("rice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/kahlua
	name = "Kahlua"
	id = "kahlua"
	result = "kahlua"
	required_reagents = list("coffee" = 5, "sugar" = 5)
	catalysts = list("enzyme" = 5)
	result_amount = 5

/datum/chemical_reaction/drinks/gin_tonic
	name = "Gin and Tonic"
	id = "gintonic"
	result = "gintonic"
	required_reagents = list("gin" = 1, "tonic" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	result = "cubalibre"
	required_reagents = list("rum" = 1, "cola" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/negroni
	name = "Negroni"
	id = "negroni"
	result = "negroni"
	required_reagents = list("gin" = 1, "bitters" = 1, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/martini
	name = "Classic Martini"
	id = "martini"
	result = "martini"
	required_reagents = list("gin" = 2, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	result = "vodkamartini"
	required_reagents = list("vodka" = 2, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/white_russian
	name = "White Russian"
	id = "whiterussian"
	result = "whiterussian"
	required_reagents = list("blackrussian" = 2, "cream" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	result = "whiskeycola"
	required_reagents = list("whiskey" = 1, "cola" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/screwdriver
	name = "Screwdriver"
	id = "screwdrivercocktail"
	result = "screwdrivercocktail"
	required_reagents = list("vodka" = 1, "orangejuice" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	result = "bloodymary"
	required_reagents = list("vodka" = 1, "tomatojuice" = 4, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	result = "gargleblaster"
	required_reagents = list("vodka" = 2, "gin" = 1, "whiskey" = 1, "cognac" = 1, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	result = "bravebull"
	required_reagents = list("tequila" = 2, "kahlua" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/tequila_sunrise
	name = "Tequila Sunrise"
	id = "tequilasunrise"
	result = "tequilasunrise"
	required_reagents = list("tequila" = 1, "orangejuice" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/phoron_special
	name = "Toxins Special"
	id = "phoronspecial"
	result = "phoronspecial"
	required_reagents = list("rum" = 2, "vermouth" = 2, MAT_PHORON = 2)
	result_amount = 6

/datum/chemical_reaction/drinks/beepsky_smash
	name = "Beepksy Smash"
	id = "beepksysmash"
	result = "beepskysmash"
	required_reagents = list("limejuice" = 1, "whiskey" = 1, MAT_IRON = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/doctor_delight
	name = "The Doctor's Delight"
	id = "doctordelight"
	result = "doctorsdelight"
	required_reagents = list("limejuice" = 1, "tomatojuice" = 1, "orangejuice" = 1, "cream" = 2, "tricordrazine" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	result = "irishcream"
	required_reagents = list("whiskey" = 2, "cream" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	result = "manlydorf"
	required_reagents = list ("beer" = 1, "ale" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/hooch
	name = "Hooch"
	id = "hooch"
	result = "hooch"
	required_reagents = list ("sugar" = 1, "ethanol" = 2, "fuel" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/irish_coffee
	name = "Irish Coffee"
	id = "irishcoffee"
	result = "irishcoffee"
	required_reagents = list("irishcream" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/b52
	name = "B-52"
	id = "b52"
	result = "b52"
	required_reagents = list("irishcream" = 1, "kahlua" = 1, "cognac" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	result = "atomicbomb"
	required_reagents = list("b52" = 10, MAT_URANIUM = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/margarita
	name = "Margarita"
	id = "margarita"
	result = "margarita"
	required_reagents = list("tequila" = 1, "limejuice" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = "longislandicedtea"
	required_reagents = list("vodka" = 1, "gin" = 1, "tequila" = 1, "cubalibre" = 3)
	result_amount = 6

/datum/chemical_reaction/drinks/icedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = "longislandicedtea"
	required_reagents = list("vodka" = 1, "gin" = 1, "tequila" = 1, "cubalibre" = 3)
	result_amount = 6

/datum/chemical_reaction/drinks/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	result = "threemileisland"
	required_reagents = list("longislandicedtea" = 10, MAT_URANIUM = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	result = "whiskeysoda"
	required_reagents = list("whiskey" = 1, "sodawater" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/black_russian
	name = "Black Russian"
	id = "blackrussian"
	result = "blackrussian"
	required_reagents = list("vodka" = 2, "kahlua" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/manhattan
	name = "Manhattan"
	id = "manhattan"
	result = "manhattan"
	required_reagents = list("whiskey" = 2, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	result = "manhattan_proj"
	required_reagents = list("manhattan" = 10, MAT_URANIUM = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/vodka_tonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	result = "vodkatonic"
	required_reagents = list("vodka" = 1, "tonic" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/gin_fizz
	name = "Gin Fizz"
	id = "ginfizz"
	result = "ginfizz"
	required_reagents = list("gin" = 1, "sodawater" = 1, "limejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	result = "bahama_mama"
	required_reagents = list("rum" = 1, "orangejuice" = 2, "limejuice" = 2, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/singulo
	name = "Singulo"
	id = "singulo"
	result = "singulo"
	required_reagents = list("vodka" = 5, "radium" = 1, "wine" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	result = "alliescocktail"
	required_reagents = list("martini" = 1, "vodka" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/booger
	name = "Booger"
	id = "booger"
	result = "booger"
	required_reagents = list("cream" = 2, "banana" = 1, "rum" = 1, "watermelonjuice" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	result = "antifreeze"
	required_reagents = list("vodka" = 1, "cream" = 1, "ice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/barefoot
	name = "Barefoot"
	id = "barefoot"
	result = "barefoot"
	required_reagents = list("berryjuice" = 1, "cream" = 1, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	result = "grapesoda"
	required_reagents = list("grapejuice" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/astral_wind
	name = "Astral Wind"
	id = "astral_wind"
	result = "astral_wind"
	required_reagents = list("spacemountainwind" = 2, "space_up" = 2, "spacespice" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/solar_wind
	name = "Solar Wind"
	id = "solar_wind"
	result = "solar_wind"
	required_reagents = list("astral_wind" = 1, "capsaicin" = 1)
	result_amount = 1

/datum/chemical_reaction/drinks/vortex_chill
	name = "Vortex Chill"
	id = "vortex_chill"
	result = "vortex_chill"
	required_reagents = list("astral_wind" = 1, "mint" = 1)
	result_amount = 1

/datum/chemical_reaction/drinks/nebula_riptide
	name = "Nebula Riptide"
	id = "nebula_riptide"
	result = "nebula_riptide"
	required_reagents = list("vortex_chill" = 1, "solar_wind" = 1)
	result_amount = 1

/datum/chemical_reaction/drinks/sbiten
	name = "Sbiten"
	id = "sbiten"
	result = "sbiten"
	required_reagents = list("vodka" = 10, "capsaicin" = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/mead
	name = "Mead"
	id = "mead"
	result = "mead"
	required_reagents = list("honey" = 1, "water" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 2

/datum/chemical_reaction/drinks/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	result = "iced_beer"
	required_reagents = list("beer" = 10, "frostoil" = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/iced_beer2
	name = "Iced Beer"
	id = "iced_beer"
	result = "iced_beer"
	required_reagents = list("beer" = 5, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/grog
	name = "Grog"
	id = "grog"
	result = "grog"
	required_reagents = list("rum" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	result = "soy_latte"
	required_reagents = list("coffee" = 1, "soymilk" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	result = "cafe_latte"
	required_reagents = list("coffee" = 1, "milk" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/acidspit
	name = "Acid Spit"
	id = "acidspit"
	result = "acidspit"
	required_reagents = list("sacid" = 1, "wine" = 5)
	result_amount = 6

/datum/chemical_reaction/drinks/amasec
	name = "Amasec"
	id = "amasec"
	result = "amasec"
	required_reagents = list(MAT_IRON = 1, "wine" = 5, "vodka" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	result = "changelingsting"
	required_reagents = list("screwdrivercocktail" = 1, "limejuice" = 1, "lemonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/aloe
	name = "Aloe"
	id = "aloe"
	result = "aloe"
	required_reagents = list("cream" = 1, "whiskey" = 1, "watermelonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/andalusia
	name = "Andalusia"
	id = "andalusia"
	result = "andalusia"
	required_reagents = list("rum" = 1, "whiskey" = 1, "lemonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/snowwhite
	name = "Snow White"
	id = "snowwhite"
	result = "snowwhite"
	required_reagents = list("beer" = 1, "lemon_lime" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	result = "irishcarbomb"
	required_reagents = list("ale" = 1, "irishcream" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	result = "syndicatebomb"
	required_reagents = list("beer" = 1, "whiskeycola" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	result = "erikasurprise"
	required_reagents = list("ale" = 2, "limejuice" = 1, "whiskey" = 1, "banana" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/hippiesdelight
	name = "Hippies Delight"
	id = "hippiesdelight"
	result = "hippiesdelight"
	required_reagents = list("psilocybin" = 1, "gargleblaster" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/bananahonk
	name = "Banana Honk"
	id = "bananahonk"
	result = "bananahonk"
	required_reagents = list("banana" = 1, "cream" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/silencer
	name = "Silencer"
	id = "silencer"
	result = "silencer"
	required_reagents = list("nothing" = 1, "cream" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	result = "driestmartini"
	required_reagents = list("nothing" = 1, "gin" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/lemonade
	name = "Lemonade"
	id = "lemonade"
	result = "lemonade"
	required_reagents = list("lemonjuice" = 1, "sugar" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/melonade
	name = "Melonade"
	id = "melonade"
	result = "melonade"
	required_reagents = list("watermelonjuice" = 1, "sugar" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/appleade
	name = "Appleade"
	id = "appleade"
	result = "appleade"
	required_reagents = list("applejuice" = 1, "sugar" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/pineappleade
	name = "Pineappleade"
	id = "pineappleade"
	result = "pineappleade"
	required_reagents = list("pineapplejuice" = 2, "limejuice" = 1, "sodawater" = 2, "honey" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/driverspunch
	name = "Driver`s Punch"
	id = "driverspunch"
	result = "driverspunch"
	required_reagents = list("appleade" = 2, "orangejuice" = 1, "mint" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/mintapplesparkle
	name = "Mint Apple Sparkle"
	id = "mintapplesparkle"
	result = "mintapplesparkle"
	required_reagents = list("appleade" = 2, "mint" = 1)
	inhibitors = list("sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/berrycordial
	name = "Berry Cordial"
	id = "berrycordial"
	result = "berrycordial"
	required_reagents = list("berryjuice" = 4, "sugar" = 1, "lemonjuice" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/tropicalfizz
	name = "Tropical Fizz"
	id = "tropicalfizz"
	result = "tropicalfizz"
	required_reagents = list("sodawater" = 6, "berryjuice" = 1, "mint" = 1, "limejuice" = 1, "lemonjuice" = 1, "pineapplejuice" = 1)
	inhibitors = list("sugar" = 1)
	result_amount = 8

/datum/chemical_reaction/drinks/melonspritzer
	name = "Melon Spritzer"
	id = "melonspritzer"
	result = "melonspritzer"
	required_reagents = list("watermelonjuice" = 2, "wine" = 2, "applejuice" = 1, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/fauxfizz
	name = "Faux Fizz"
	id = "fauxfizz"
	result = "fauxfizz"
	required_reagents = list("sodawater" = 2, "berryjuice" = 1, "applejuice" = 1, "limejuice" = 1, "honey" = 1)
	inhibitors = list("sugar" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/firepunch
	name = "Fire Punch"
	id = "firepunch"
	result = "firepunch"
	required_reagents = list("sugar" = 2, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/kiraspecial
	name = "Kira Special"
	id = "kiraspecial"
	result = "kiraspecial"
	required_reagents = list("orangejuice" = 1, "limejuice" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/brownstar
	name = "Brown Star"
	id = "brownstar"
	result = "brownstar"
	required_reagents = list("orangejuice" = 2, "cola" = 1)
	result_amount = 3


/datum/chemical_reaction/drinks/orangeale
	name = "Orange Ale"
	id = "orangeale"
	result = "orangeale"
	required_reagents = list("orangejuice" = 1, "gingerale" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/milkshake
	name = "Milkshake"
	id = "milkshake"
	result = "milkshake"
	required_reagents = list("cream" = 1, "ice" = 2, "milk" = 2)
	result_amount = 5

/datum/chemical_reaction/drinks/peanutmilkshake
	name = "Peanutbutter Milkshake"
	id = "peanutmilkshake"
	result = "peanutmilkshake"
	required_reagents = list("milkshake" = 2, "peanutbutter" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/rewriter
	name = "Rewriter"
	id = "rewriter"
	result = "rewriter"
	required_reagents = list("spacemountainwind" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/suidream
	name = "Sui Dream"
	id = "suidream"
	result = "suidream"
	required_reagents = list("space_up" = 1, "bluecuracao" = 1, "melonliquor" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/shirleytemple
	name = "Shirley Temple"
	id = "shirley_temple"
	result = "shirley_temple"
	required_reagents = list("gingerale" = 4, "grenadine" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/royrogers
	name = "Roy Rogers"
	id = "roy_rogers"
	result = "roy_rogers"
	required_reagents = list("shirley_temple" = 5, "lemon_lime" = 2)
	result_amount = 7

/datum/chemical_reaction/drinks/collinsmix
	name = "Collins Mix"
	id = "collins_mix"
	result = "collins_mix"
	required_reagents = list("lemon_lime" = 3, "sodawater" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/arnoldpalmer
	name = "Arnold Palmer"
	id = "arnold_palmer"
	result = "arnold_palmer"
	required_reagents = list("icetea" = 1, "lemonade" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/minttea
	name = "Mint Tea"
	id = "minttea"
	result = "minttea"
	required_reagents = list("tea" = 5, "mint" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/lemontea
	name = "Lemon Tea"
	id = "lemontea"
	result = "lemontea"
	required_reagents = list("tea" = 5, "lemonjuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/limetea
	name = "Lime Tea"
	id = "limetea"
	result = "limetea"
	required_reagents = list("tea" = 5, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/orangetea
	name = "Orange Tea"
	id = "orangetea"
	result = "orangetea"
	required_reagents = list("tea" = 5, "orangejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/berrytea
	name = "Berry Tea"
	id = "berrytea"
	result = "berrytea"
	required_reagents = list("tea" = 5, "berryjuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/sakebomb
	name = "Sake Bomb"
	id = "sakebomb"
	result = "sakebomb"
	required_reagents = list("beer" = 2, "sake" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/tamagozake
	name = "Tamagozake"
	id = "tamagozake"
	result = "tamagozake"
	required_reagents = list("sake" = 10, "sugar" = 5, "egg" = 3)
	result_amount = 15

/datum/chemical_reaction/drinks/ginzamary
	name = "Ginza Mary"
	id = "ginzamary"
	result = "ginzamary"
	required_reagents = list("sake" = 2, "vodka" = 2, "tomatojuice" = 2)
	result_amount = 6

/datum/chemical_reaction/drinks/tokyorose
	name = "Tokyo Rose"
	id = "tokyorose"
	result = "tokyorose"
	required_reagents = list("sake" = 1, "berryjuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/saketini
	name = "Saketini"
	id = "saketini"
	result = "saketini"
	required_reagents = list("sake" = 1, "gin" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/elysiumfacepunch
	name = "Elysium Facepunch"
	id = "elysiumfacepunch"
	result = "elysiumfacepunch"
	required_reagents = list("kahlua" = 1, "lemonjuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/erebusmoonrise
	name = "Erebus Moonrise"
	id = "erebusmoonrise"
	result = "erebusmoonrise"
	required_reagents = list("whiskey" = 1, "vodka" = 1, "tequila" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/balloon
	name = "Balloon"
	id = "balloon"
	result = "balloon"
	required_reagents = list("cream" = 1, "bluecuracao" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/natunabrandy
	name = "Natuna Brandy"
	id = "natunabrandy"
	result = "natunabrandy"
	required_reagents = list("beer" = 1, "sodawater" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/euphoria
	name = "Euphoria"
	id = "euphoria"
	result = "euphoria"
	required_reagents = list("specialwhiskey" = 1, "cognac" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/xanaducannon
	name = "Xanadu Cannon"
	id = "xanaducannon"
	result = "xanaducannon"
	required_reagents = list("ale" = 1, "dr_gibb" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/debugger
	name = "Debugger"
	id = "debugger"
	result = "debugger"
	required_reagents = list("fuel" = 1, "sugar" = 2, "cornoil" = 2)
	result_amount = 5

/datum/chemical_reaction/drinks/spacersbrew
	name = "Spacer's Brew"
	id = "spacersbrew"
	result = "spacersbrew"
	required_reagents = list("brownstar" = 4, "ethanol" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/binmanbliss
	name = "Binman Bliss"
	id = "binmanbliss"
	result = "binmanbliss"
	required_reagents = list("sake" = 1, "tequila" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/chrysanthemum
	name = "Chrysanthemum"
	id = "chrysanthemum"
	result = "chrysanthemum"
	required_reagents = list("sake" = 1, "melonliquor" = 1)
	result_amount = 2

/datum/chemical_reaction/bitters
	name = "Bitters"
	id = "bitters"
	result = "bitters"
	required_reagents = list("mint" = 5)
	catalysts = list("enzyme" = 5)
	result_amount = 5

/datum/chemical_reaction/drinks/soemmerfire
	name = "Soemmer Fire"
	id = "soemmerfire"
	result = "soemmerfire"
	required_reagents = list("manhattan" = 2, "condensedcapsaicin" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/winebrandy
    name = "Wine brandy"
    id = "winebrandy"
    result = "winebrandy"
    required_reagents = list("wine" = 10)
    catalysts = list("enzyme" = 10) //10u enzyme so it requires more than is usually added. Stops overlap with wine recipe
    result_amount = 5

/datum/chemical_reaction/drinks/lovepotion
	name = "Love Potion"
	id = "lovepotion"
	result = "lovepotion"
	required_reagents = list("cream" = 1, "berryjuice" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/morningafter
	name = "Morning After"
	id = "morningafter"
	result = "morningafter"
	required_reagents = list("sbiten" = 1, "coffee" = 5)
	result_amount = 6

/datum/chemical_reaction/drinks/vesper
	name = "Vesper"
	id = "vesper"
	result = "vesper"
	required_reagents = list("gin" = 3, "vodka" = 1, "wine" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/rotgut
	name = "Rotgut Fever Dream"
	id = "rotgut"
	result = "rotgut"
	required_reagents = list("vodka" = 3, "rum" = 1, "whiskey" = 1, "cola" = 3)
	result_amount = 8

/datum/chemical_reaction/drinks/entdraught
	name = "Ent's Draught"
	id = "entdraught"
	result = "entdraught"
	required_reagents = list("tonic" = 1, "holywater" = 1, "honey" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/voxdelight
	name = "Vox's Delight"
	id = "voxdelight"
	result = "voxdelight"
	required_reagents = list(MAT_PHORON = 3, "fuel" = 1, "water" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/screamingviking
	name = "Screaming Viking"
	id = "screamingviking"
	result = "screamingviking"
	required_reagents = list("martini" = 2, "vodkatonic" = 2, "limejuice" = 1, "rum" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/vilelemon
	name = "Vile Lemon"
	id = "vilelemon"
	result = "vilelemon"
	required_reagents = list("lemonade" = 5, "spacemountainwind" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/dreamcream
	name = "Dream Cream"
	id = "dreamcream"
	result = "dreamcream"
	required_reagents = list("milk" = 2, "cream" = 1, "honey" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/robustin
	name = "Robustin"
	id = "robustin"
	result = "robustin"
	required_reagents = list("antifreeze" = 1, MAT_PHORON = 1, "fuel" = 1, "vodka" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/virginsip
	name = "Virgin Sip"
	id = "virginsip"
	result = "virginsip"
	required_reagents = list("driestmartini" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/chocoshake
	name = "Chocolate Milkshake"
	id = "chocoshake"
	result = "chocoshake"
	required_reagents = list("milkshake" = 1, "coco" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/berryshake
	name = "Berry Milkshake"
	id = "berryshake"
	result = "berryshake"
	required_reagents = list("milkshake" = 1, "berryjuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/coffeeshake
	name = "Coffee Milkshake"
	id = "coffeeshake"
	result = "coffeeshake"
	required_reagents = list("milkshake" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/jellyshot
	name = "Jelly Shot"
	id = "jellyshot"
	result = "jellyshot"
	required_reagents = list("cherryjelly" = 4, "vodka" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/slimeshot
	name = "Named Bullet"
	id = "slimeshot"
	result = "slimeshot"
	required_reagents = list("slimejelly" = 4, "vodka" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/cloverclub
	name = "Clover Club"
	id = "cloverclub"
	result = "cloverclub"
	required_reagents = list("berryjuice" = 2, "lemonjuice" = 2, "gin" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/oldfashioned
	name = "Old Fashioned"
	id = "oldfashioned"
	result = "oldfashioned"
	required_reagents = list("whiskey" = 1, "bitters" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/whiskeysour
	name = "Whiskey Sour"
	id = "whiskeysour"
	result = "whiskeysour"
	required_reagents = list("whiskey" = 2, "lemonjuice" = 1, "sugar" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/daiquiri
	name = "Daiquiri"
	id = "daiquiri"
	result = "daiquiri"
	required_reagents = list("rum" = 3, "limejuice" = 2, "sugar" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/paloma
	name = "Paloma"
	id = "paloma"
	result = "paloma"
	required_reagents = list("orangejuice" = 1, "sodawater" = 1, "tequila" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/mojito
	name = "Mojito"
	id = "mojito"
	result = "mojito"
	required_reagents = list("rum" = 1, "limejuice" = 2, "mint" = 2)
	result_amount = 5

/datum/chemical_reaction/drinks/virginmojito
	name = "Mojito"
	id = "virginmojito"
	result = "virginmojito"
	required_reagents = list("sodawater" = 1, "limejuice" = 2, "mint" = 1, "sugar" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/piscosour
	name = "Pisco Sour"
	id = "piscosour"
	result = "piscosour"
	required_reagents = list("winebrandy" = 1, "lemonjuice" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/coldfront
	name = "Cold Front"
	id = "coldfront"
	result = "coldfront"
	required_reagents = list("icecoffee" = 1, "whiskey" = 1, "mint" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/godsake
	name = "Gods Sake"
	id = "godsake"
	result = "godsake"
	required_reagents = list("sake" = 2, "holywater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/godka //Why you would put this in your body, I don't know.
	name = "Godka"
	id = "godka"
	result = "godka"
	required_reagents = list("vodka" = 1, "holywater" = 1, "ethanol" = 1, "carthatoline" = 1)
	catalysts = list("enzyme" = 5, "holywater" = 5)
	result_amount = 1

/datum/chemical_reaction/drinks/holywine
	name = "Angel Ichor"
	id = "holywine"
	result = "holywine"
	required_reagents = list("grapejuice" = 5, MAT_GOLD = 5)
	catalysts = list("holywater" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/holy_mary
	name = "Holy Mary"
	id = "holymary"
	result = "holymary"
	required_reagents = list("vodka" = 2, "holywine" = 3, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/angelskiss
	name = "Angels Kiss"
	id = "angelskiss"
	result = "angelskiss"
	required_reagents = list("holywine" = 1, "kahlua" = 1, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/angelswrath
	name = "Angels Wrath"
	id = "angelswrath"
	result = "angelswrath"
	required_reagents = list("rum" = 1, "spacemountainwind" = 2, "holywine" = 1, "dr_gibb" = 2)
	result_amount = 6

/datum/chemical_reaction/drinks/ichor_mead
	name = "Ichor Mead"
	id = "ichor_mead"
	result = "ichor_mead"
	required_reagents = list("holywine" = 1, "mead" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/oilslick
	name = "Oil Slick"
	id = "oilslick"
	result = "oilslick"
	required_reagents = list("cornoil" = 2, "honey" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/slimeslam
	name = "Slick Slime Slammer"
	id = "slimeslammer"
	result = "slimeslammer"
	required_reagents = list("cornoil" = 2, "peanutbutter" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/virginsexonthebeach
	name = "Virgin Sex On The Beach"
	id = "virginsexonthebeach"
	result = "virginsexonthebeach"
	required_reagents = list("orangejuice" = 3, "grenadine" = 3)
	result_amount = 6

/datum/chemical_reaction/drinks/sexonthebeach
	name = "Sex On The Beach"
	id = "sexonthebeach"
	result = "sexonthebeach"
	required_reagents = list("screwdrivercocktail" = 3, "grenadine" = 3)
	result_amount = 6

/datum/chemical_reaction/drinks/eggnog
	name = "Eggnog"
	id = "eggnog"
	result = "eggnog"
	required_reagents = list("milk" = 5, "cream" = 5, "sugar" = 5, "egg" = 3)
	result_amount = 15

/datum/chemical_reaction/drinks/nuclearwaste_radium
	name = "Nuclear Waste"
	id = "nuclearwasterad"
	result = "nuclearwaste"
	required_reagents = list("oilslick" = 1, "radium" = 1, "limejuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/nuclearwaste_uranium
	name = "Nuclear Waste"
	id = "nuclearwasteuran"
	result = "nuclearwaste"
	required_reagents = list("oilslick" = 2, MAT_URANIUM = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/sodaoil
	name = "Soda Oil"
	id = "sodaoil"
	result = "sodaoil"
	required_reagents = list("cornoil" = 4, "sodawater" = 1, MAT_CARBON = 1, "tricordrazine" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/fusionnaire
	name = "Fusionnaire"
	id = "fusionnaire"
	result = "fusionnaire"
	required_reagents = list("lemonjuice" = 3, "vodka" = 2, "schnapps_pep" = 1, "schnapps_lem" = 1, "rum" = 1, "ice" = 1)
	result_amount = 9

/datum/chemical_reaction/drinks/gibbfloat
	name = "Gibbfloat"
	id = "gibbfloat"
	result = "gibbfloat"
	required_reagents = list("ice" = 1, "cream" = 1, "dr_gibb" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/mintjulep
	name = "Mint Julep"
	id = "mintjulep"
	result = "mintjulep"
	required_reagents = list("water" = 1, "whiskey" = 1, "ice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/planterspunch
	name = "Planters Punch"
	id = "planterspunch"
	result = "planterspunch"
	required_reagents = list("rum" = 2, "orangejuice" = 2, "grenadine" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/olympusmons
	name = "Olympus Mons"
	id = "olympusmons"
	result = "olympusmons"
	required_reagents = list("blackrussian" = 1, "whiskey" = 1, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/sazerac
	name = "Sazerac"
	id = "sazerac"
	result = "sazerac"
	required_reagents = list("cognac" = 2, "absinthe" = 1, "sugar" = 1, "bitters" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/junglejuice
	name = "Jungle Juice"
	id = "junglejuice"
	result = "junglejuice"
	required_reagents = list("lemonjuice" = 1, "orangejuice" = 1, "lemon_lime" = 1, "vodka" = 1, "rum" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/gimlet
	name = "Gimlet"
	id = "gimlet"
	result = "gimlet"
	required_reagents = list("gin" = 1, "limejuice" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/firepunch
	name = "Fire Punch"
	id = "firepunch"
	result = "firepunch"
	required_reagents = list("sugar" = 2, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/newsheriff
	name = "New Sheriff"
	id = "newsheriff"
	result = "newsheriff"
	required_reagents = list("sassafras" = 1, "whiskey" = 1, "cognac" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/thehuckleberry
	name = "The Huckleberry"
	id = "thehuckleberry"
	result = "thehuckleberry"
	required_reagents = list("sarsaparilla" = 1, "berryjuice" = 1, "whiskey" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/quickdraw
	name = "Quickdraw"
	id = "quickdraw"
	result = "quickdraw"
	required_reagents = list("sarsaparilla" = 1, "rum" = 1, "bitters" = 1)
	reaction_sound = "sound/weapons/gunshot/gunshot.ogg"
	result_amount = 3

/datum/chemical_reaction/drinks/dmhand
	name = "Dead Man's Hand"
	id = "dmhand"
	result = "dmhand"
	required_reagents = list("sassafras" = 3, "whiskey" = 1, "rum" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/snakeoil
	name = "Snake Oil"
	id = "snakeoil"
	result = "snakeoil"
	required_reagents = list("sarsaparilla" = 1, "grenadine" = 1, "absinthe" = 1, MAT_PHORON = 1, "fuel" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/highnoon
	name = "High Noon"
	id = "highnoon"
	result = "highnoon"
	required_reagents = list("sassafras" = 2, MAT_GOLD = 2, "whiskey" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/theoutlaw
	name = "The Outlaw"
	id = "theoutlaw"
	result = "theoutlaw"
	required_reagents = list("vodka" = 1, MAT_GOLD = 1, "bitters" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/thelawman
	name = "The Lawman"
	id = "thelawman"
	result = "thelawman"
	required_reagents = list("whiskey" = 1, "coffee" = 2, "mint" = 2)
	result_amount = 5

/datum/chemical_reaction/drinks/hangmansnoose
	name = "Hangman's Noose"
	id = "hangmansnoose"
	result = "hangmansnoose"
	required_reagents = list("rotgut" = 1, "carpotoxin" = 1, "spidertoxin" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/bigiron
	name = "Big Iron"
	id = "bigiron"
	result = "bigiron"
	required_reagents = list("rum" = 2, MAT_IRON = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/lastcactus
	name = "Last Cactus"
	id = "lastcactus"
	result = "lastcactus"
	required_reagents = list("vodka" = 1, "mint" = 2, "sugar" = 1, "ice" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/rootbeerfloat
	name = "Root Beer Float"
	id = "rootbeerfloat"
	result = "rootbeerfloat"
	required_reagents = list("sassafras" = 1, "ice" = 1, "cream" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/thebestboy
	name = "The Best Boy"
	id = "thebestboy"
	result = "thebestboy"
	required_reagents = list("screwdrivercocktail" = 3, "ice" = 1, "cream" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/grubshake
	name = "Grub protein drink"
	id = "grubshake"
	result = "grubshake"
	required_reagents = list("shockchem" = 5, "water" = 25)
	result_amount = 30

/datum/chemical_reaction/drinks/deathbell
	name = "Deathbell"
	id = "deathbell"
	result = "deathbell"
	required_reagents = list("antifreeze" = 1, "gargleblaster" = 1, "syndicatebomb" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/monstertamer
	name = "Monster Tamer"
	id = "monstertamer"
	result = "monstertamer"
	required_reagents = list("whiskey" = 1, "protein" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/phobos
	name = "Phobos"
	id = "phobos"
	result = "phobos"
	required_reagents = list("hooch" = 1, "erebusmoonrise" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/greenstuff
	name = "Green Stuff"
	id = "greenstuff"
	result = "greenstuff"
	required_reagents = list("manlydorf" = 3, "absinthe" = 2)
	result_amount = 5

/datum/chemical_reaction/drinks/galacticpanic
	name = "Galactic Panic Attack"
	id = "galacticpanic"
	result = "galacticpanic"
	required_reagents = list("gargleblaster" = 1, "singulo" = 1, "phoronspecial" =1, "neurotoxin" = 1, "atomicbomb" = 1, "hippiesdelight" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/lotus
	name = "Lotus"
	id = "lotus"
	result = "lotus"
	required_reagents = list("sbagliato" = 1, "sugarrush" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/sugarrush
	name = "Sweet Rush"
	id = "sugarrush"
	result = "sugarrush"
	required_reagents = list("sugar" = 1, "sodawater" = 1, "grenadine" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/sbagliato
	name = "Negroni Sbagliato"
	id = "sbagliato"
	result = "sbagliato"
	required_reagents = list("wine" = 1, "vermouth" = 1, "sodawater" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/scsatw
	name = "Slow Comfortable Screw Against the Wall"
	id = "scsatw"
	result = "scsatw"
	required_reagents = list("screwdrivercocktail" = 3, "rum" =1, "whiskey" =1, "gin" =1)
	result_amount = 6

/datum/chemical_reaction/drinks/honeyshot
	name = "Honey Shot"
	id = "honeyshot"
	result = "honeyshot"
	required_reagents = list("honey" = 1, "vodka" = 1, "grenadine" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/shroomjuice
	name = "Dumb Shroom Juice"
	id = "shroomjuice"
	result = "shroomjuice"
	required_reagents = list("psilocybin" = 1, "applejuice" = 1, "limejuice" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/italiancrisis
	name = "Italian Crisis"
	id = "italiancrisis"
	result = "italiancrisis"
	required_reagents = list("bulldog" = 1, "sbagliato" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/unsweettea
	name = "Unsweetened Tea"
	id = "unsweettea"
	result = "unsweettea"
	required_reagents = list("sweettea" = 3, MAT_PHORON = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/sweettea
	name = "Sweetened Tea"
	id = "sweettea"
	result = "sweettea"
	required_reagents = list("icetea" = 2, "sugar" = 1,)
	result_amount = 3

/datum/chemical_reaction/drinks/originalsin
	name = "Original Sin"
	id = "originalsin"
	result = "originalsin"
	required_reagents = list("holywine" = 1)
	catalysts = list("applejuice" = 1)
	result_amount = 1

/datum/chemical_reaction/drinks/bulldog
	name = "Space Bulldog"
	id = "bulldog"
	result = "bulldog"
	required_reagents = list("whiterussian" = 4, "cola" =1)
	result_amount = 4

/datum/chemical_reaction/drinks/lovemaker
	name = "The Love Maker"
	id = "lovemaker"
	result = "lovemaker"
	required_reagents = list("honey" = 1, "sexonthebeach" = 5)
	result_amount = 6

/datum/chemical_reaction/drink/messa_mead
	name = "Messa's Mead"
	id = "messa_mead"
	result = "messa_mead"
	required_reagents = list("ethanol" = 1, "eroot" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/winter_offensive
	name = "Winter Offensive"
	id = "winter_offensive"
	result = "winter_offensive"
	required_reagents = list("ice" = 1, "victory_gin" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/internationale
	name = "Internationale"
	id = "internationale"
	result = "internationale"
	required_reagents = list("victory_gin" = 1, "vodka" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/peacetreaty
	name = "Peace Treaty"
	id = "peacetreaty"
	result = "peacetreaty"
	required_reagents = list("victory_gin" = 1, "messa_mead" = 1, "lemonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/russianbastard
	name = "Russian Bastard"
	id = "russianbastard"
	result = "russianbastard"
	required_reagents = list("milk" = 1, "vodka" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/willtolive
	name = "A Will to Live"
	id = "willtolive"
	result = "willtolive"
	required_reagents = list("cognac" = 1, "kahlua" = 3, "melonliquor" = 3, "ice" = 1, "cream" = 1)
	result_amount = 9

/datum/chemical_reaction/drink/desiretodie
	name = "A Desire to Die"
	id = "desiretodie"
	result = "desiretodie"
	required_reagents = list("deathbell" = 1, "nuclearwaste" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/raspberrybeesknees
	name = "Raspberry Bee's Knees"
	id = "raspberrybeesknees"
	result = "raspberrybeesknees"
	required_reagents = list("water" = 2, "lemonjuice" = 1, "honey" = 1, "berryjuice" = 2)
	result_amount = 6

/datum/chemical_reaction/drink/sidecar
	name = "Sidecar"
	id = "sidecar"
	result = "sidecar"
	required_reagents = list("cognac" = 5, "lemonjuice" = 2, "orangejuice" = 2)
	result_amount = 9

/datum/chemical_reaction/drink/french75
	name = "French 75"
	id = "french75"
	result = "french75"
	required_reagents = list("lemonjuice" = 1, "gin" = 2, "champagne" = 4, "sugar" = 1)
	result_amount = 8

/datum/chemical_reaction/drink/french76
	name = "French 76"
	id = "french76"
	result = "french76"
	required_reagents = list("lemonjuice" = 1, "vodka" = 2, "champagne" = 4, "sugar" = 1)
	result_amount = 8

/datum/chemical_reaction/drink/lastword
	name = "Last Word"
	id = "lastword"
	result = "lastword"
	required_reagents = list("limejuice" = 1, "gin" = 1, "berryjuice" = 2)
	result_amount = 4

/datum/chemical_reaction/drink/watermelonsmoothie
	name = "Watermelon Smoothie"
	id = "watermelonsmoothie"
	result = "watermelonsmoothie"
	required_reagents = list("watermelonjuice" = 2, "ice" = 1, "milk" = 1, "cream" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/orangesmoothie
	name = "Orange Smoothie"
	id = "orangesmoothie"
	result = "orangesmoothie"
	required_reagents = list("orangejuice" = 2, "ice" = 1, "milk" = 1, "cream" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/limesmoothie
	name = "Lime Smoothie"
	id = "limesmoothie"
	result = "limesmoothie"
	required_reagents = list("limejuice" = 2, "ice" = 1, "milk" = 1, "cream" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/lemonsmoothie
	name = "Lemon Smoothie"
	id = "lemonsmoothie"
	result = "lemonsmoothie"
	required_reagents = list("lemonjuice" = 2, "ice" = 1, "milk" = 1, "cream" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/berrysmoothie
	name = "Berry Smoothie"
	id = "berrysmoothie"
	result = "berrysmoothie"
	required_reagents = list("berryjuice" = 2, "ice" = 1, "milk" = 1, "cream" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/applesmoothie
	name = "Apple Smoothie"
	id = "applesmoothie"
	result = "applesmoothie"
	required_reagents = list("applejuice" = 2, "ice" = 1, "milk" = 1, "cream" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/grapesmoothie
	name = "Grape Smoothie"
	id = "grapesmoothie"
	result = "grapesmoothie"
	required_reagents = list("grapejuice" = 2, "ice" = 1, "milk" = 1, "cream" = 1)
	result_amount = 5 // fuck linters

/datum/chemical_reaction/drinks/goliath
	name = "Goliath Spit"
	id = "goliathspit"
	result = "goliathspit"
	required_reagents = list("whiskey" = 1, "cider" = 1, "tonic" = 1, "ice" = 1, "honey" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/royaljelly
	name = "Royal Jelly"
	id = "royaljelly"
	result = "royaljelly"
	required_reagents = list("winebrandy" = 2, "honey" = 3)
	result_amount = 5

/datum/chemical_reaction/drinks/coquito
	name = "Coquito"
	id = "coquito"
	result = "coquito"
	required_reagents = list("firepunch" = 2, "coconutmilk" = 3)
	result_amount = 5

/datum/chemical_reaction/drinks/horchata
	name = "Horchata"
	id = "horchata"
	result = "horchata"
	required_reagents = list("sugar" = 2, "coconutmilk" = 3)
	catalysts = list("rice" = 5)	//The rice isn't used up in horchata. The leftover rice is often reused in other dishes, typically stuff that pairs well with its coconut/cinnamon flavors like rice pudding.
	result_amount = 5

/datum/chemical_reaction/drinks/milktea
	name = "Milk Tea"
	id = "milktea"
	result = "milktea"
	required_reagents = list("milk" = 2, "sweettea" = 3)
	result_amount = 5

/datum/chemical_reaction/drinks/honeybubbletea
	name = "Honey Bubble Tea"
	id = "honeybubbletea"
	result = "honeybubbletea"
	required_reagents = list("milktea" = 5, "honey" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/matchabubbletea
	name = "Matcha Bubble Tea"
	id = "matchabubbletea"
	result = "matchabubbletea"
	required_reagents = list("milktea" = 5, "matchapowder" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/tarobubbletea
	name = "Taro Bubble Tea"
	id = "tarobubbletea"
	result = "tarobubbletea"
	required_reagents = list("milktea" = 5, "taropowder" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/cocoabubbletea
	name = "Chocolate Bubble Tea"
	id = "cocoabubbletea"
	result = "cocoabubbletea"
	required_reagents = list("milktea" = 5, "coco" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/mochabubbletea
	name = "Mocha Bubble Tea"
	id = "mochaabubbletea"
	result = "mochabubbletea"
	required_reagents = list("chocobubbletea" = 5, "coffee" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/pinacolada
	name = "Piña Colada"
	id = "pinacolada"
	result = "pinacolada"
	required_reagents = list("rum" = 1, "pineapplejuice" = 1, "coconutmilk" = 1, "ice" = 1)
	result_amount = 3


//Blud-based Cocktails
//All of these drinks should contain some level of blood_content in their reagent code

/datum/chemical_reaction/drinks/nightsdelight
	name = "Night's Delight"
	id = "nightsdelight"
	result = "nightsdelight"
	required_reagents = list("specialwhiskey" = 1, "blud" = 1, "absinthe" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/bludsfizz
	name = "Blud's Fizz"
	id = "bludsfizz"
	result = "bludsfizz"
	required_reagents = list("champagne" = 1, "orangejuice" = 1, "blud" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/wronghat
	name = "Wrong Hat"
	id = "wronghat"
	result = "wronghat"
	required_reagents = list("wine" = 1, "blud" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/braindrain
	name = "Brain Drain"
	id = "braindrain"
	result = "braindrain"
	required_reagents = list("blud" = 1, "vodka" = 1, "kahlua" = 1)
	result_amount = 3\

//Blood-based Cocktails
//All of these drinks should contain some level of blood_content in their reagent code

/datum/chemical_reaction/drinks/bloodmeridian
	name = "Blood Meridian"
	id = "bloodmeridian"
	result = "bloodmeridian"
	required_reagents = list("sassafras" = 1, "vodkatonic" = 1, "blood" = 3, "egg" = 1, "bluecuracao" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	result = "demonsblood"
	required_reagents = list("rum" = 3, "spacemountainwind" = 1, "blood" = 1, "dr_gibb" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	result = "devilskiss"
	required_reagents = list("blood" = 1, "kahlua" = 1, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/maryonacross
	name = "Mary On a Cross"
	id = "maryonacross"
	result = "maryonacross"
	required_reagents = list("bloodymary" = 2, "blood" = 1, "holywater" = 1, "vodka" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/narsian
	name = "Nar'Sian"
	id = "narsian"
	result = "narsian"
	required_reagents = list("narsour" = 1, "thebestboy" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/narsour
	name = "Nar'Sour"
	id = "narsour"
	result = "narsour"
	required_reagents = list("blood" = 1, "demonsblood" = 1, "lemonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/red_mead
	name = "Red Mead"
	id = "red_mead"
	result = "red_mead"
	required_reagents = list("blood" = 1, "mead" = 1)
	result_amount = 2

// Unathi drinks

/datum/chemical_reaction/skrianhi
	name = "Skrianhi Tea"
	id = "skrianhitea"
	result = "skrianhitea"
	required_reagents = list("unathijuice" = 2, "water" = 1)
	result_amount = 3
	mix_message = "The tea turns a bitter black."

/datum/chemical_reaction/mumbaksting
	name = "Mumbak Sting"
	id = "mumbaksting"
	result = "mumbaksting"
	required_reagents = list("unathijuice" = 2, "toxin" = 1)
	result_amount = 3
	mix_message = "The toxins mix with the juice to create a dark red substance."

/datum/chemical_reaction/wasgaelhi
	name = "Wasgaelhi"
	id = "wasgaelhi"
	result = "wasgaelhi"
	required_reagents = list("unathijuice" = 2, "wine" = 1)
	result_amount = 3
	mix_message = "The mixture turns a dull purple."

/datum/chemical_reaction/kzkzaa
	name = "Kzkzaa"
	id = "kzkzaa"
	result = "kzkzaa"
	required_reagents = list("unathijuice" = 2, "protein" = 1)
	result_amount = 3
	mix_message = "The mixture turns a deep orange."
