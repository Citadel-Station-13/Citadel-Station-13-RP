//Datums for different companies that can be used by busy_space
/datum/lore/organization
	var/name = ""				// Organization's name
	var/short_name = ""			// Organization's shortname (NanoTrasen for "NanoTrasen Incorporated")
	var/acronym = ""			// Organization's acronym, e.g. 'NT' for NanoTrasen'.
	var/desc = ""				// One or two paragraph description of the organization, but only current stuff.  Currently unused.
	var/history = ""			// Historical discription of the organization's origins  Currently unused.
	var/work = ""				// Short description of their work, eg "an arms manufacturer"
	var/headquarters = ""		// Location of the organization's HQ.  Currently unused.
	var/motto = ""				// A motto/jingle/whatever, if they have one.  Currently unused.

	var/list/ship_prefixes = list()	//Some might have more than one! Like NanoTrasen. Value is the mission they perform, e.g. ("ABC" = "mission desc")
	var/list/flight_types = list(		//operations and flights - we can override this if we want to remove the military-sounding ones or add our own
			"flight",
			"mission",
			"route",
			"operation",
			"assignment"
			)
	var/list/ship_names = list(		//Names of spaceships.  This is a mostly generic list that all the other organizations inherit from if they don't have anything better.
			"Scout",
			"Beacon",
			"Signal",
			"Freedom",
			"Liberty",
			"Enterprise",
			"Glory",
			"Axiom",
			"Eternal",
			"Harmony",
			"Light",
			"Discovery",
			"Endeavour",
			"Explorer",
			"Swift",
			"Dragonfly",
			"Ascendant",
			"Tenacious",
			"Pioneer",
			"Surveyor",
			"Haste",
			"Radiant",
			"Luminous"
			)
	var/list/destination_names = list()	//Names of static holdings that the organization's ships visit regularly.
	var/scan_exempt = FALSE			//Are we exempt from routine inspections? to avoid incidents where SysDef appears to go rogue
	var/autogenerate_destination_names = TRUE //Pad the destination lists with some extra random ones?

/datum/lore/organization/New()
	..()
	if(autogenerate_destination_names) // Lets pad out the destination names.
		var/i = rand(7, 12) //was 6-10, now 7-12, slight increase for flavor, especially in 'starved' lists
		var/list/star_names = list(		
			"in Sol", "in Alpha Centauri", "in Sirius", "in Vega", "in Tau Ceti", "in Altair", "in Zhu Que", "in Oasis", "in Vir", "in Gavel", "in Ganesha", "in Saint Columbia", "in Altair", "in Sidhe", "in New Ohio", "in Parvati", "in Mahi-Mahi", "in Nyx", "in New Seoul", "in Kess-Gendar", "in Raphael", "in Phact", "in Altair", "in El", "in Eutopia", "in Qerr'valis", "in Qerrna-Lakirr", "in Rarkajar", "in Vazzend", "in Thoth", "in Jahan's Post", "in Kauq'xum", "in Silk", "in New Singapore", "in Stove", "in Viola", "in Love", "in Isavau's Gamble", "in Shelf", "in deep space", "on the frontier")
		var/list/owners = list("a government", "a civilian", "a corporate", "a private", "an independent", "a mercenary", "a military")
		var/list/destination_types = list("[pick(owners)] shipyard", "[pick(owners)] dockyard", "[pick(owners)] station", "[pick(owners)] vessel", "a waystation", "[pick(owners)] telecommunications satellite", "a spaceport", "a colony", "[pick(owners)] outpost", "a settlement", "[pick(owners)] research facility", "[pick(owners)] installation", "a freeport", "[pick(owners)] holding", "[pick(owners)] asteroid base", "an orbital refinery", "a classified location", "a trade outpost", "[pick(owners)] supply depot", "[pick(owners)] fuel depot")
		while(i)
			destination_names.Add("[pick(destination_types)] [pick(star_names)]")
			i--
	//refactored slightly to improve flexibility; we can now have different owners for a destination (but only for some destinations), and 'stars' can include other star-like destinations

//////////////////////////////////////////////////////////////////////////////////

// TSCs
/datum/lore/organization/tsc/nanotrasen
	name = "NanoTrasen Incorporated"
	short_name = "NanoTrasen "
	acronym = "NT"
	desc = "NanoTrasen is one of the foremost research and development companies in SolGov space. \
	Originally focused on consumer products, their swift move into the field of Phoron has lead to \
	them being the foremost experts on the substance and its uses. In the modern day, NanoTrasen prides \
	itself on being an early adopter to as many new technologies as possible, often offering the newest \
	products to their employees. In an effort to combat complaints about being 'guinea pigs', Nanotrasen \
	also offers one of the most comprehensive medical plans in SolGov space, up to and including cloning \
	and therapy.\
	<br><br>\
	NT's most well known products are its phoron based creations, especially those used in Cryotherapy. \
	It also boasts an prosthetic line, which is provided to its employees as needed, and is used as an incentive \
	for newly tested posibrains to remain with the company."
	history = "" // To be written someday.
	work = "research giant"
	headquarters = "Luna, Sol"
	motto = ""

	ship_prefixes = list("NSV" = "an exploration", "NTV" = "a hauling", "NDV" = "a patrol", "NRV" = "an emergency response", "NDV" = "an asset protection")
	//Scientist naming scheme
	ship_names = list(
			"Bardeen",
			"Einstein",
			"Feynman",
			"Sagan",
			"Tyson",
			"Galilei",
			"Jans",
			"Fhriede",
			"Franklin",
			"Tesla",
			"Curie",
			"Darwin",
			"Newton",
			"Pasteur",
			"Bell",
			"Mendel",
			"Kepler",
			"Edison",
			"Cavendish",
			"Nye",
			"Hawking",
			"Aristotle",
			"Von Braun",
			"Kaku",
			"Oppenheimer",
			"Renwick",
			"Hubble",
			"Alcubierre",
			"Robineau",
			"Glass"
			)
	// Note that the current station being used will be pruned from this list upon being instantiated
	destination_names = list(
			"NT HQ on Luna",
			"NSS Exodus in Nyx",
			"NCS Northern Star in Vir",
			"NLS Southern Cross in Vir",
			"NAS Vir Central Command",
			"a dockyard orbiting Sif",
			"an asteroid orbiting Kara",
			"an asteroid orbiting Rota",
			"Vir Interstellar Spaceport"
			)

/datum/lore/organization/tsc/nanotrasen/New()
	..()
	spawn(1) // BYOND shenanigans means using_map is not initialized yet.  Wait a tick.
		// Get rid of the current map from the list, so ships flying in don't say they're coming to the current map.
		var/string_to_test = "[using_map.station_name] in [using_map.starsys_name]"
		if(string_to_test in destination_names)
			destination_names.Remove(string_to_test)

/datum/lore/organization/tsc/hephaestus
	name = "Hephaestus Industries"
	short_name = "Hephaestus "
	acronym = "HI"
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles in Sol space. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a noted tendency to stay removed \
	from corporate politics. They enforce their neutrality with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. SolGov itself is one of Hephaestus' largest \
	bulk contractors owing to the above factors."
	history = ""
	work = "arms manufacturer"
	headquarters = "Luna, Sol"
	motto = ""

	ship_prefixes = list("HTV" = "a freight", "HLV" = "a munitions resupply", "HDV" = "an asset protection", "HDV" = "a preemptive deployment")
	//War God/Soldier Theme
	ship_names = list(
			"Ares",
			"Athena",
			"Grant",
			"Custer",
			"Puller",
			"Nike",
			"Bellona",
			"Leonides",
			"Bast",
			"Jackson",
			"Lee",
			"Annan",
			"Chi Yu",
			"Shiva",
			"Tyr",
			"Nobunaga",
			"Xerxes",
			"Alexander",
			"McArthur",
			"Samson",
			"Oya",
			"Nemain",
			"Caesar",
			"Augustus",
			"Sekhmet",
			"Ku",
			"Indra",
			"Innana",
			"Ishtar",
			"Qamaits",
			"'Oro",
			)
	destination_names = list(
			"our headquarters on Luna",
			"a SolGov dockyard on Luna",
			"a Fleet outpost in the Almach Rim",
			"a Fleet outpost on the Moghes border"
			)

/datum/lore/organization/tsc/vey_med
	name = "Vey-Medical" //The Wiki displays them as Vey-Medical.
	short_name = "Vey-Med "
	acronym = "VM"
	desc = "Vey-Med is one of the newer TSCs on the block and is notable for being largely owned and opperated by Skrell. \
	Despite the suspicion and prejudice leveled at them for their alien origin, Vey-Med has obtained market dominance in \
	the sale of medical equipment-- from surgical tools to large medical devices to the Oddyseus trauma response mecha \
	and everything in between. Their equipment tends to be top-of-the-line, most obviously shown by their incredibly \
	human-like FBP designs. Vey's rise to stardom came from their introduction of resurrective cloning, although in \
	recent years they've been forced to diversify as their patents expired and NanoTrasen-made medications became \
	essential to modern cloning."
	history = ""
	work = "medical equipment supplier"
	headquarters = "Toledo, New Ohio"
	motto = ""

	ship_prefixes = list("VTV" = "a transportation", "VMV" = "a medical resupply", "VSV" = "a research mission", "VRV" = "an emergency medical support")
	// Diona names
	ship_names = list(
			"Wind That Stirs The Waves",
			"Sustained Note Of Metal",
			"Bright Flash Reflecting Off Glass",
			"Veil Of Mist Concealing The Rock",
			"Thin Threads Intertwined",
			"Clouds Drifting Amid Storm",
			"Loud Note And Breaking",
			"Endless Vistas Expanding Before The Void",
			"Fire Blown Out By Wind",
			"Star That Fades From View",
			"Eyes Which Turn Inwards",
			"Joy Without Which The World Would Come Undone",
			"A Thousand Thousand Planets Dangling From Branches",
			"Light Streaming Through Interminable Branches",
			"Smoke Brought Up From A Terrible Fire",
			"Light of Qerr'Valis",
			"King Xae'uoque",
			"Memory of Kel'xi",
			"Xi'Kroo's Herald"
			)
	destination_names = list(
			"our headquarters on Toledo, New Ohio",
			"a research facility in Samsara",
			"an SDTF near Ue-Orsi",
			"a sapientarian mission in the Almach Rim"
			)

/datum/lore/organization/tsc/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	short_name = "Zeng-Hu "
	acronym = "ZH"
	desc = "Zeng-Hu is an old TSC, based in the Sol system. Until the discovery of Phoron, Zeng-Hu maintained a stranglehold \
	on the market for medications, and many household names are patentted by Zeng-Hu-- Bicaridyne, Dylovene, Tricordrizine, \
	and Dexalin all came from a Zeng-Hu medical laboratory. Zeng-Hu's fortunes have been in decline as Nanotrasen's near monopoly \
	on phoron research cuts into their R&D and Vey-Med's superior medical equipment effectively decimated their own equipment \
	interests. The three-way rivalry between these companies for dominance in the medical field is well-known and a matter of \
	constant economic speculation."
	history = ""
	work = "pharmaceuticals company"
	headquarters = "Earth, Sol"
	motto = ""

	ship_prefixes = list("ZTV" = "a transportation", "ZMV" = "a medical resupply", "ZRV" = "a medical research")
	//ship names: a selection of famous physicians who advanced the cause of medicine
	ship_names = list(
			"Averroes",
			"Avicenna",
			"Banting",
			"Billroth",
			"Blackwell",
			"Blalock",
			"Charaka",
			"Chauliac",
			"Cushing",
			"Domagk",
			"Galen",
			"Fauchard",
			"Favaloro",
			"Fleming",
			"Fracastoro",
			"Goodfellow",
			"Gray",
			"Harvey",
			"Heimlich",
			"Hippocrates",
			"Hunter",
			"Isselbacher",
			"Jenner",
			"Joslin",
			"Kocher",
			"Laennec",
			"Lane-Claypon",
			"Lister",
			"Lower",
			"Madhav",
			"Maimonides",
			"Marshall",
			"Mayo",
			"Meyerhof",
			"Minot",
			"Morton",
			"Needleman",
			"Nicolle",
			"Osler",
			"Penfield",
			"Raichle",
			"Ransohoff",
			"Rhazes",
			"Semmelweis",
			"Starzl",
			"Still",
			"Susruta",
			"Urbani",
			"Vesalius",
			"Vidius",
			"Whipple",
			"White",
			"Worcestor",
			"Yegorov",
			"Xichun"
			)
	destination_names = list(
			"our headquarters on Earth"
			)

/datum/lore/organization/tsc/ward_takahashi
	name = "Ward-Takahashi General Manufacturing Conglomerate"
	short_name = "Ward-Takahashi "
	acronym = "WT"
	desc = "Ward-Takahashi focuses on the sale of small consumer electronics, with its computers, communicators, \
	and even mid-class automobiles a fixture of many households. Less famously, Ward-Takahashi also supplies most \
	of the AI cores on which vital control systems are mounted, and it is this branch of their industry that has \
	led to their tertiary interest in the development and sale of high-grade AI systems. Ward-Takahashi's economies \
	of scale frequently steal market share from Nanotrasen's high-price products, leading to a bitter rivalry in the \
	consumer electronics market."
	history = ""
	work = "electronics manufacturer"
	headquarters = ""
	motto = ""

	ship_prefixes = list("WFV" = "a freight", "WTV" = "a transport", "WDV" = "an asset protection")
	ship_names = list(
			"Comet",
			"Meteor",
			"Heliosphere",
			"Bolide",
			"Aurora",
			"Nova",
			"Supernova",
			"Nebula",
			"Galaxy",
			"Starburst",
			"Constellation",
			"Pulsar",
			"Quark",
			"Void",
			"Asteroid",
			"Wormhole",
			"Sunspot",
			"Supercluster",
			"Supergiant",
			"Protostar",
			"Magnetar",
			"Moon",
			"Supermoon",
			"Anomaly",
			"Drift",
			"Stream",
			"Rift",
			"Curtain",
			"Planetar",
			"Quasar",
			"Binary"
			)
	destination_names = list()

/datum/lore/organization/tsc/bishop
	name = "Bishop Cybernetics"
	short_name = "Bishop "
	acronym = "BC"
	desc = "Bishop's focus is on high-class, stylish cybernetics. A favorite among transhumanists (and a bête noire for \
	bioconservatives), Bishop manufactures not only prostheses but also brain augmentation, synthetic organ replacements, \
	and odds and ends like implanted wrist-watches. Their business model tends towards smaller, boutique operations, giving \
	it a reputation for high price and luxury, with Bishop cyberware often rivalling Vey-Med's for cost. Bishop's reputation \
	for catering towards the interests of human augmentation enthusiasts instead of positronics have earned it ire from the \
	Positronic Rights Group and puts it in ideological (but not economic) comptetition with Morpheus Cyberkinetics."
	history = ""
	work = "cybernetics and augmentation manufacturer"
	headquarters = ""
	motto = ""

	ship_prefixes = list("BCTV" = "a transportation", "BCSV" = "a research exchange")
	//famous mechanical engineers
	ship_names = list(
			"Al-Jazari",
			"Al-Muradi",
			"Al-Zarqali",
			"Archimedes",
			"Arkwright",
			"Armstrong",
			"Babbage",
			"Barsanti",
			"Benz",
			"Bessemer",
			"Bramah",
			"Brunel",
			"Cardano",
			"Cartwright",
			"Cayley",
			"Clement",
			"Leonardo da Vinci",
			"Diesel",
			"Drebbel",
			"Fairbairn",
			"Fontana",
			"Fourneyron",
			"Fulton",
			"Fung",
			"Gantt",
			"Garay",
			"Hackworth",
			"Harrison",
			"Hornblower",
			"Jacquard",
			"Jendrassik",
			"Leibniz",
			"Ma Jun",
			"Maudslay",
			"Metzger",
			"Murdoch",
			"Nasmyth",
			"Parsons",
			"Rankine",
			"Reynolds",
			"Roberts",
			"Scheutz",
			"Sikorsky",
			"Somerset",
			"Stephenson",
			"Stirling",
			"Tesla",
			"Vaucanson",
			"Vishweswarayya",
			"Wankel",
			"Watt",
			"Wiberg"
			)
	destination_names = list(
			"a medical facility in Angessa's Pearl"
			)

/datum/lore/organization/tsc/morpheus
	name = "Morpheus Cyberkinetics"
	short_name = "Morpheus "
	acronym = "MC"
	desc = "The only large corporation run by positronic intelligences, Morpheus caters almost exclusively to their sensibilities \
	and needs. A product of the synthetic colony of Shelf, Morpheus eschews traditional advertising to keep their prices low and \
	relied on word of mouth among positronics to reach their current economic dominance. Morpheus in exchange lobbies heavily for \
	positronic rights, sponsors positronics through their Jans-Fhriede test, and tends to other positronic concerns to earn them \
	the good-will of the positronics, and the ire of those who wish to exploit them."
	history = ""
	work = "cybernetics manufacturer"
	headquarters = "Shelf"
	motto = ""

	ship_prefixes = list("MTV" = "a freight", "MDV" = "a market protection", "MSV" = "an outreach")
	//periodic elements; something 'unusual' for the posibrain TSC without being full on 'quirky' culture ship names (much as I love them, they're done to death)
	ship_names = list(
			"Hydrogen",
			"Helium",
			"Lithium",
			"Beryllium",
			"Boron",
			"Carbon",
			"Nitrogen",
			"Oxygen",
			"Fluorine",
			"Neon",
			"Sodium",
			"Magnesium",
			"Aluminium",
			"Silicon",
			"Phosphorus",
			"Sulfur",
			"Chlorine",
			"Argon",
			"Potassium",
			"Calcium",
			"Scandium",
			"Titanium",
			"Vanadium",
			"Chromium",
			"Manganese",
			"Iron",
			"Cobalt",
			"Nickel",
			"Copper",
			"Zinc",
			"Gallium",
			"Germanium",
			"Arsenic",
			"Selenium",
			"Bromine",
			"Krypton",
			"Rubidium",
			"Strontium",
			"Yttrium",
			"Zirconium",
			"Niobium",
			"Molybdenum",
			"Technetium",
			"Ruthenium",
			"Rhodium",
			"Palladium",
			"Silver",
			"Cadmium",
			"Indium",
			"Tin",
			"Antimony",
			"Tellurium",
			"Iodine",
			"Xenon",
			"Caesium",
			"Barium"
			)
	//some hebrew alphabet destinations for a little extra unusualness
	destination_names = list(
			"our headquarters in Shelf",
			"a trade outpost in Shelf",
			"one of our factory complexes on Root",
			"research outpost Aleph",
			"logistics depot Dalet",
			"research installation Zayin",
			"research base Tsadi",
			"manufacturing facility Samekh"
		)

/datum/lore/organization/tsc/xion
	name = "Xion Manufacturing Group"
	short_name = "Xion "
	acronym = "XMG"
	desc = "Xion, quietly, controls most of the market for industrial equipment. Their portfolio includes mining exosuits, \
	factory equipment, rugged positronic chassis, and other pieces of equipment vital to the function of the economy. Xion \
	keeps its control of the market by leasing, not selling, their equipment, and through infamous and bloody patent protection \
	lawsuits. Xion are noted to be a favorite contractor for SolGov engineers, owing to their low cost and rugged design."
	history = ""
	work = "industrial equipment manufacturer"
	headquarters = ""
	motto = ""

	ship_prefixes = list("XTV" = "a hauling", "XFV" = "a bulk transport", "XIV" = "a resupply")
	//martian mountains
	ship_names = list(
			"Olympus Mons",
			"Ascraeus Mons",
			"Arsia Mons",
			"Pavonis Mons",
			"Elysium Mons",
			"Hecates Tholus",
			"Albor Tholus",
			"Tharsis Tholus",
			"Biblis Tholus",
			"Alba Mons",
			"Ulysses Tholus",
			"Mount Sharp",
			"Uranius Mons",
			"Anseris Mons",
			"Hadriacus Mons",
			"Euripus Mons",
			"Tyrrhenus Mons",
			"Promethei Mons",
			"Chronius Mons",
			"Apollinaris Mons",
			"Gonnus Mons",
			"Syrtis Major Planum",
			"Amphitrites Patera",
			"Nili Patera",
			"Pityusa Patera",
			"Malea Patera",
			"Peneus Patera",
			"Labeatis Mons",
			"Issidon Paterae",
			"Pindus Mons",
			"Meroe Patera",
			"Orcus Patera",
			"Oceanidum Mons",
			"Horarum Mons",
			"Peraea Mons",
			"Octantis Mons",
			"Galaxius Mons",
			"Hellas Planitia",
			)
	destination_names = list()

//Keek&Allakai&Peesh's new TSC
/datum/lore/organization/tsc/antares
	name = "Antares Robotics Group"
	short_name = "Antares "
	acronym = "ARG"
	desc = "A heavy competitor in the mining industries to Hephaestus Industries, Antares Robotics sets its vision grand.<br><br>The ARU (Antares Robotics Unit) was the first step to creating a heavy frame synthetic that can take even the harshest of punishment from any foreign origin!<br><br>After rigorous studies (all of which successful of course!) Antares Robotics paired with several outsourced help took its first step into Prosthetics for those that need a reliable limb that can take and give a punch!"
	history = ""
	work = "cybernetics manufacturer"
	headquarters = ""
	motto = ""

	ship_prefixes = list("ATV" = "a transport", "ARV" = "a research", "ADV" = "a routine patrol", "AEV" = "a raw materials acquisition")
	//ship names: blank, because we get some autogenned for us
	ship_names = list()
	destination_names = list()

/datum/lore/organization/tsc/antares/New()
	..()
	var/i = 20 //give us twenty random names, antares has snowflake rng-ids
	var/list/numbers = list(
			"One",
			"Two",
			"Three",
			"Four",
			"Five",
			"Six",
			"Seven",
			"Eight",
			"Nine",
			"Zero"
			)
	while(i)
		ship_names.Add("[pick(numbers)] [pick(numbers)] [pick(numbers)] [pick(numbers)]")
		i--

/datum/lore/organization/tsc/ftu
	name = "Free Trade Union"
	short_name = "Trade Union "
	acronym = "FTU"
	desc = "The Free Trade Union is different from other tran-stellars in that they are not just a company, but they are a big conglomerate of various traders and merchants from all over the galaxy. They control a sizable fleet of vessels of various sizes which are given autonomy from the central command to engage in trading. They also host a fleet of combat vessels which respond directly to the central command for defending traders when necessary. They are in control of many large scale trade stations across the known galaxy, even in non-human space. Generally, they are multi-purpose stations but they always keep areas filled with duty-free shops. Almost anything is sold there and products that are forbidden or have insanely high taxes in other places are generally sold in the duty-free shops at very cheap and low prices.<br><br>They are the creators of the Tradeband language, created specially for being a lingua franca where every merchant can understand each other independent of language or nationality."
	history = "The Free Trade Union was created in 2410 by Issac Adler, a merchant, economist, and owner of a small fleet of ships. At this time the \"Free Merchants\" were in decay because of the high taxes and tariffs that were generally applied on the products that they tried to import or export. Another issue was that big trans-stellar corporations were constantly blocking their products to prospective buyers in order to form their monopolies. Issac decided to organize the \"Free Merchants\" into a legitimate organization to lobby and protest against the unfair practices of the major corporations and the governments that were in their pocket. At the same time, they wanted to organize and sell their things at better prices. The organization started relatively small but by 2450 it became one of the biggest conglomerates with a significant amount of the merchants of the galaxy being a part of the FTU. At the same time, the Free Trade Union started to popularize tradeband in the galaxy as the language of business. Around 2500, the majority of independent merchants were part of the FTU with significant influence on the galactic scale. They have started to invest in colonization efforts in order to take early claim of the frontier systems as the best choice for frontier traders."
	work = ""
	headquarters = ""
	motto = ""
	
	ship_prefixes = list("FTRP" = "a route protection", "FTRR" = "a piracy suppression", "FTLV" = "a logistical support", "FTTV" = "a mercantile", "FTDV" = "a market establishment")
	//famous merchants and traders, taken from Civ6's Great Merchants
	ship_names = list(
			"Isaac Adler",
			"Colaeus",
			"Marcus Licinius Crassus",
			"Zhang Qian",
			"Irene of Athens",
			"Marco Polo",
			"Piero de' Bardi",
			"Giovanni de' Medici",
			"Jakob Fugger",
			"Raja Todar Mal",
			"Adam Smith",
			"John Jacob Astor",
			"John Spilsbury",
			"John Rockefeller",
			"Sarah Breedlove",
			"Mary Katherine Goddard",
			"Helena Rubenstein",
			"Levi Strauss",
			"Melitta Bentz",
			"Estee Lauder",
			"Jamsetji Tata",
			"Masaru Ibuka",
			)
	destination_names = list(
			"a Free Trade Union office",
			"FTU HQ"
			)

/datum/lore/organization/tsc/mbt
	name = "Major Bill's Transportation"
	short_name = "Major Bill's "
	acronym = "MBT"
	desc = "The most popular courier service and starliner, Major Bill's is an unassuming corporation whose greatest asset is their low cost and brand recognition. Major Bill's is known, perhaps unfavorably, for its mascot, Major Bill, a cartoonish military figure that spouts quotable slogans. Their motto is \"With Major Bill's, you won't pay major bills!\", an earworm much of the galaxy longs to forget. Their ships are named after some of Earth's greatest rivers."
	history = ""
	work = "courier and passenger transit"
	headquarters = "Mars, Sol"
	motto = "With Major Bill's, you won't pay major bills!"

	ship_prefixes = list("TTV" = "a transport", "TTV" = "a luxury transit", "TTV" = "a priority transit", "TTV" = "a secure data courier")
	//ship names: big rivers
	ship_names = list (
			"Nile",
			"Kagera",
			"Nyabarongo",
			"Mwogo",
			"Rukarara",
			"Amazon",
			"Ucayali",
			"Tambo",
			"Ene",
			"Mantaro",
			"Yangtze",
			"Mississippi",
			"Missouri",
			"Jefferson",
			"Beaverhead",
			"Red Rock",
			"Hell Roaring",
			"Yenisei",
			"Angara",
			"Yelenge",
			"Ider",
			"Ob",
			"Irtysh",
			"Rio de la Plata",
			"Parana",
			"Rio Grande",
			"Congo",
			"Chambeshi",
			"Amur",
			"Argun",
			"Kherlen",
			"Lena",
			"Mekong",
			"Mackenzie",
			"Peace",
			"Finlay",
			"Niger",
			"Brahmaputra",
			"Tsangpo",
			"Murray",
			"Darling",
			"Culgoa",
			"Balonne",
			"Condamine",
			"Tocantins",
			"Araguaia",
			"Volga"
			)
	destination_names = list(
			"Major Bill's Transportation HQ on Mars",
			"a Major Bill's warehouse",
			"a Major Bill's distribution center",
			"a Major Bill's supply deplot"
			)

/datum/lore/organization/tsc/grayson
	name = "Grayson Manufactories Ltd."
	short_name = "Grayson "
	acronym = "GM"
	desc = "Grayson Manufactories Ltd., true to its name, mines, refines, and produces iron, steel, aluminum, and other metals for use in casing and other production before selling them. They are also known for reviving their old traditions of supplying general materials ready for assembly for construction projects. These parts are interchangeable and considered somewhat cheap, but have proven to be generally and consecutively reliable.<br><br>As of current, Grayson Manufactories has a fairly neutral stance on the other major corporations, though has a history of maintaining a monopoly on specific trades through heavy competition and even rumors of industrial sabotage and use of strikebreakers."
	history = ""
	work = ""
	headquarters = "Mars"
	motto = ""
	
	ship_prefixes = list("GMT" = "a transport", "GMR" = "a resourcing", "GMS" = "a surveying", "GMH" = "a bulk transit")
	//rocks
	ship_names = list(
			"Adakite",
			"Andesite",
			"Basalt",
			"Basanite",
			"Diorite",
			"Dunite",
			"Gabbro",
			"Granite",
			"Harzburgite",
			"Ignimbrite",
			"Kimberlite",
			"Komatiite",
			"Norite",
			"Obsidian",
			"Pegmatite",
			"Picrite",
			"Pumice",
			"Rhyolite",
			"Scoria",
			"Syenite",
			"Tachylyte",
			"Wehrlite",
			"Arkose",
			"Chert",
			"Dolomite",
			"Flint",
			"Laterite",
			"Marl",
			"Oolite",
			"Sandstone",
			"Shale",
			"Anthracite",
			"Gneiss",
			"Granulite",
			"Mylonite",
			"Schist",
			"Skarn",
			"Slate"
			)
	destination_names = list(
			"our headquarters on Mars",
			"one of our manufacturing complexes",
			"one of our mining installations"
			)

/datum/lore/organization/tsc/aether
	name = "Aether Atmospherics & Recycling"
	short_name = "Aether "
	acronym = "AAR"
	desc = "Aether Atmospherics and Recycling is the prime maintainer and provider of atmospherics systems across both the many ships that navigate the vast expanses of space, and the life support on current and future Human colonies. The byproducts from the filtration of atmospheres across the galaxy are then resold for a variety of uses to those willing to buy. With the nature of their services, most work they do is contracted for construction of these systems, or staffing to maintain them for colonies across human space."
	history = ""
	work = ""
	headquarters = ""
	motto = ""
	
	ship_prefixes = list("AARE" = "a resource extraction", "AARG" = "a gas transport", "AART" = "a transport")
	//weather systems/patterns
	ship_names = list (
			"Cloud",
			"Nimbus",
			"Fog",
			"Vapor",
			"Haze",
			"Smoke",
			"Thunderhead",
			"Veil",
			"Steam",
			"Mist",
			"Noctilucent",
			"Nacreous",
			"Cirrus",
			"Cirrostratus",
			"Cirrocumulus",
			"Aviaticus",
			"Altostratus",
			"Altocumulus",
			"Stratus",
			"Stratocumulus",
			"Cumulus",
			"Fractus",
			"Asperitas",
			"Nimbostratus",
			"Cumulonimbus",
			"Pileus",
			"Arcus"
			)
	destination_names = list(
			"Aether HQ",
			"a gas mining orbital",
			"a liquid extraction plant"
			)

/datum/lore/organization/tsc/focalpoint
	name = "Focal Point Energistics"
	short_name = "Focal "
	acronym = "FPE"
	desc = "Focal Point Energistics is an electrical engineering solutions firm originally formed as a conglomerate of Earth power companies and affiliates. Focal Point manufactures and distributes vital components in modern power grids, such as TEGs, PSUs and their specialty product, the SMES. The company is often consulted and contracted by larger organisations due to their expertise in their field."
	history = ""
	work = ""
	headquarters = ""
	motto = ""
	
	ship_prefixes = list("FPH" = "a transport", "FPC" = "an energy relay", "FPT" = "a fuel transport")
	//famous electrical engineers
	ship_names = list (
			"Erlang",
			"Blumlein",
			"Taylor",
			"Bell",
			"Reeves",
			"Bennett",
			"Volta",
			"Blondel",
			"Beckman",
			"Hirst",
			"Lamme",
			"Bright",
			"Armstrong",
			"Ayrton",
			"Bardeen",
			"Fuller",
			"Boucherot",
			"Brown",
			"Brush",
			"Burgess",
			"Camras",
			"Crompton",
			"Deprez",
			"Elwell",
			"Entz",
			"Faraday",
			"Halas",
			"Hounsfield",
			"Immink",
			"Laithwaite",
			"McKenzie",
			"Moog",
			"Moore",
			"Pierce",
			"Ronalds",
			"Shallenberger",
			"Siemens",
			"Spencer",
			"Tesla",
			"Yablochkov",
			)
	destination_names = list(
			"Focal Point HQ"
			)
			
/datum/lore/organization/tsc/starlanes
	name = "StarFlight Inc."
	short_name = "StarFlight "
	acronym = "SFI"
	desc = "Founded in 2437 by Astara Junea, StarFlight Incorporated is now one of the biggest passenger liner businesses in human-occupied space and has even begun breaking into alien markets -  all despite a rocky start, and several high-profile ship disappearances and shipjackings. With space traffic at an all-time high, it's a depressing reality that SFI's incidents are just a tiny drop in the bucket compared to everything else going on."
	history = ""
	work = "luxury, business, and economy passenger flights"
	headquarters = "Spin Aerostat, Jupiter"
	motto = "Sic itur ad astra"
	scan_exempt = TRUE
	
	ship_prefixes = list("SFI-X" = "a VIP liner", "SFI-L" = "a luxury liner", "SFI-B" = "a business liner", "SFI-E" = "an economy liner", "SFI-M" = "a mixed class liner", "SFI-S" = "a sightseeing")
	flight_types = list(		//no military-sounding ones here	
			"flight",
			"route",
			"tour"
			)
	ship_names = list(
			"Rhea",
			"Ostritch",
			"Cassowary",
			"Emu",
			"Kiwi",
			"Duck",
			"Swan",
			"Chachalaca",
			"Curassow",
			"Guan",
			"Guineafowl",
			"Pheasant",
			"Turkey",
			"Francolin",
			"Loon",
			"Penguin",
			"Grebe",
			"Flamingo",
			"Stork",
			"Ibis",
			"Heron",
			"Pelican",
			"Spoonbill",
			"Shoebill",
			"Gannet",
			"Cormorant",
			"Osprey",
			"Kite",
			"Hawk",
			"Falcon",
			"Caracara"
			)
	destination_names = list(
			"a resort planet",
			"a beautiful ring system",
			"a ski-resort world"
			)

/datum/lore/organization/tsc/independent
	name = "Independent Pilots Association"
	short_name = "Independent "
	acronym = "IPA"
	desc = "Though less common now than they were in the decades before the Sol Economic Organization took power, independent traders remain an important part of the galactic economy, owing in no small part to protective tariffs established by the Free Trade Union in the late twenty-fourth century. Further out on the frontier, independent pilots are often the only people keeping freight and supplies moving."
	history = ""
	work = "trade and transit"
	headquarters = "N/A"
	motto = "N/A"

	ship_prefixes = list("IEV" = "a prospecting", "IEC" = "a prospecting", "IFV" = "a bulk freight", "ITV" = "a passenger transport", "ITC" = "a just-in-time delivery", "IPV" = "a patrol", "IHV" = "a bounty hunting", "ICC" = "an escort")
	flight_types = list(		
			"flight",
			"mission",
			"route",
			"operation",
			"assignment",
			"contract"
			)
	destination_names = list() //we have no hqs or facilities of our own

// Other

//SPACE LAW
/datum/lore/organization/other/sysdef
	name = "System Defense Force"
	short_name = "SysDef "
	acronym = "SDF"
	desc = "Localized militias are used to secure systems throughout inhabited space. By levying and maintaining these local militia forces, governments can use their fleets for more important matters. System Defense Forces tend to be fairly poorly trained and modestly equipped compared to genuine military fleets, but are more than capable of contending with small-time pirates, and can generally stall greater threats long enough for reinforcements to arrive. They're also typically responsible for space-based SAR operations in their system."
	history = ""
	work = "local security"
	headquarters = ""
	motto = ""
	scan_exempt = TRUE //we're the laaaaaw, we don't impersonate people and stuff
	autogenerate_destination_names = FALSE

	ship_prefixes = list ("SDB" = "a patrol", "SDF" = "a patrol", "SDV" = "a patrol", "SDB" = "an escort", "SDF" = "an escort", "SDV" = "an escort", "SAR" = "a search and rescue", "SDT" = "a logistics", "SDT" = "a resupply", "SDJ" = "a prisoner transport") //b = boat, f = fleet, v = vessel, t = tender
	//ship names: weapons
	ship_names = list(
			"Sword",
			"Saber",
			"Cutlass",
			"Broadsword",
			"Katar",
			"Shamshir",
			"Shashka",
			"Epee",
			"Estoc",
			"Longsword",
			"Katana",
			"Baselard",
			"Gladius",
			"Kukri",
			"Pick",
			"Mattock",
			"Hatchet",
			"Machete",
			"Axe",
			"Tomahawk",
			"Dirk",
			"Dagger",
			"Maul",
			"Mace",
			"Flail",
			"Morningstar",
			"Shillelagh",
			"Cudgel",
			"Truncheon",
			"Hammer",
			"Arbalest",
			"Catapult",
			"Trebuchet",
			"Longbow",
			"Pike",
			"Glaive",
			"Halberd",
			"Scythe",
			"Spear"
			)
	destination_names = list(
			"the outer system",
			"the inner system",
			"Waypoint Alpha",
			"Waypoint Beta",
			"Waypoint Gamma",
			"Waypoint Delta",
			"Waypoint Epsilon",
			"Waypoint Zeta",
			"Waypoint Eta",
			"Waypoint Theta",
			"Waypoint Iota",
			"Waypoint Kappa",
			"Waypoint Lambda",
			"Waypoint Mu",
			"Waypoint Nu",
			"Waypoint Xi",
			"Waypoint Omicron",
			"Waypoint Pi",
			"Waypoint Rho",
			"Waypoint Sigma",
			"Waypoint Tau",
			"Waypoint Upsilon",
			"Waypoint Phi",
			"Waypoint Chi",
			"Waypoint Psi",
			"Waypoint Omega"
			)

// Governments

/datum/lore/organization/gov/solgov
	name = "Solar Confederate Government"
	short_name = "SolGov "
	acronym = "SCG"
	desc = "SolGov is a decentralized confederation of human governmental entities based on Luna, Sol, which defines top-level law for their member states.  \
	Member states receive various benefits such as defensive pacts, trade agreements, social support and funding, and being able to participate \
	in the Colonial Assembly.  The majority, but not all human territories are members of SolGov.  As such, SolGov is a major power and \
	defacto represents humanity on the galactic stage."
	history = "" // Todo
	work = "governing polity of humanity's Confederation"
	headquarters = "Luna, Sol"
	motto = "Nil Mortalibus Ardui Est" // Latin, because latin.  Says 'Nothing is too steep for mortals'.
	scan_exempt = TRUE //it would look pretty weird if the SCG were caught impersonating other people
	autogenerate_destination_names = TRUE

	ship_prefixes = list("SCG-T" = "a transportation", "SCG-D" = "a diplomatic", "SCG-F" = "a freight", "SCG-J" = "a prisoner transfer")
	//earth's biggest impact craters
	ship_names = list(
			"Wabar",
			"Kaali",
			"Campo del Cielo",
			"Henbury",
			"Morasko",
			"Boxhole",
			"Macha",
			"Rio Cuarto",
			"Ilumetsa",
			"Tenoumer",
			"Xiuyan",
			"Lonar",
			"Agoudal",
			"Tswaing",
			"Zhamanshin",
			"Bosumtwi",
			"Elgygytgyn",
			"Bigach",
			"Karla",
			"Karakul",
			"Vredefort",
			"Chicxulub",
			"Sudbury",
			"Popigai",
			"Manicougan",
			"Acraman",
			"Morokweng",
			"Kara",
			"Beaverhead",
			"Tookoonooka",
			"Charlevoix",
			"Siljan Ring",
			"Montagnais",
			"Araguinha",
			"Chesapeake",
			"Mjolnir",
			"Puchezh-Katunki",
			"Saint Martin",
			"Woodleigh",
			"Carswell",
			"Clearwater West",
			"Clearwater East",
			"Manson",
			"Slate",
			"Yarrabubba",
			"Keurusselka",
			"Shoemaker",
			"Mistastin",
			"Kamensk",
			"Steen",
			"Strangways",
			"Tunnunik",
			"Boltysh",
			"Nordlinger Ries",
			"Presqu'ile",
			"Haughton",
			"Lappajarvi",
			"Rochechouart",
			"Gosses Bluff",
			"Amelia Creek",
			"Logancha",
			"Obolon'",
			"Nastapoka",
			"Ishim",
			"Bedout"
			)
	destination_names = list(
			"Venus",
			"Earth",
			"Luna",
			"Mars",
			"Titan",
			"Europa",
			"the Jovian subcluster",
			"a SolGov embassy"
			)
			// autogen will add a lot of other places as well.


// Military
// Used for Para-Military groups right now! Pair of placeholder-ish PMCs.

/datum/lore/organization/mil/usdf
	name = "United Sol Defense Force"
	short_name = "" //Doesn't cause whitespace any more, with a little sneaky low-effort workaround
	acronym = "USDF"
	desc = "The USDF is the dedicated military force of SolGov, originally formed by the United Nations. It is the dominant superpower of the Orion Spur, and is able to project its influence well into parts of the Perseus and Sagittarius arms of the galaxy. However, regions beyond that are too far for the USDF to be a major player."
	history = ""
	work = "peacekeeping and piracy suppression"
	headquarters = "Paris, Earth"
	motto = ""
	scan_exempt = TRUE
	autogenerate_destination_names = TRUE
	
	ship_prefixes = list ("USDF" = "a logistical", "USDF" = "a training", "USDF" = "a patrol", "USDF" = "a piracy suppression", "USDF" = "a peacekeeping", "USDF" = "a relief", "USDF" = "an escort", "USDF" = "a search and rescue")
	ship_names = list(
			"Aphrodite",
			"Apollo",
			"Ares",
			"Artemis",
			"Athena",
			"Demeter",
			"Dionysus",
			"Hades",
			"Hephaestus",
			"Hera",
			"Hermes",
			"Hestia",
			"Poseidon",
			"Zeus",
			"Achlys",
			"Aether",
			"Aion",
			"Ananke",
			"Chaos",
			"Chronos",
			"Erebus",
			"Eros",
			"Gaia",
			"Hemera",
			"Hypnos",
			"Nemesis",
			"Nyx",
			"Phanes",
			"Pontus",
			"Tartarus",
			"Thalassa",
			"Thanatos",
			"Uranus",
			"Coeus",
			"Crius",
			"Cronus",
			"Hyperion",
			"Iapetus",
			"Mnemosyne",
			"Oceanus",
			"Phoebe",
			"Rhea",
			"Tethys",
			"Theia",
			"Themis",
			"Asteria",
			"Astraeus",
			"Atlas",
			"Aura",
			"Clymene",
			"Dione",
			"Helios",
			"Selene",
			"Eos",
			"Epimetheus",
			"Eurybia",
			"Eurynome",
			"Lelantos",
			"Leto",
			"Menoetius",
			"Metis",
			"Ophion",
			"Pallas",
			"Perses",
			"Prometheus",
			"Styx",
			)
	destination_names = list(
			"USDF HQ",
			"a USDF staging facility on the edge of SolGov territory",
			"a USDF resupply depot",
			"a USDF shipyard in Sol"
			)

/datum/lore/organization/mil/pcrc
	name = "Proxima Centauri Risk Control"
	short_name = "Proxima Centauri "
	acronym = "PCRC"
	desc = "Not a whole lot is known about the private security company known as PCRC, but it is known that they're irregularly contracted by the larger TSCs for certain delicate matters. Much of the company's inner workings are shrouded in mystery, and most citizens have never even heard of them."
	history = ""
	work = "risk control and private security"
	headquarters = "Proxima Centauri"
	motto = ""
	scan_exempt = TRUE //we're not the best guys, but we're not actually shady
	autogenerate_destination_names = TRUE
	
	ship_prefixes = list("PCRC" = "a risk control", "PCRC" = "a private security")
	flight_types = list(		
			"flight",
			"mission",
			"route",
			"operation",
			"assignment",
			"contract"
			)
	//law/protection terms
	ship_names = list(
			"Detective",
			"Constable",
			"Judge",
			"Adjudicator",
			"Magistrate",
			"Marshal",
			"Warden",
			"Peacemaker",
			"Arbiter",
			"Justice",
			"Order",
			"Jury",
			"Inspector",
			"Bluecoat",
			"Gendarme",
			"Gumshoe",
			"Patrolman",
			"Sentinel",
			"Shield",
			"Aegis",
			"Auditor",
			"Monitor",
			"Investigator",
			"Agent",
			"Prosecutor",
			"Sergeant",
			)
			
	destination_names = list(
			"PCRC HQ, in Proxima Centauri",
			"a PCRC training installation",
			"a PCRC supply depot"
			)

//I'm covered in beeeeeeees!
/datum/lore/organization/mil/hive
	name = "HIVE Security"
	short_name = "HIVE "
	acronym = "HVS"
	desc = "HIVE Security is a merging of several much smaller freelance companies, and operates throughout civilized space. Unlike some companies, it operates no planetside facilities whatsoever, opting instead for larger flotillas that are serviced by innumerable smallcraft. As with any PMC there's no small amount of controversy surrounding them, but they try to keep their operations cleaner than their competitors. They're fairly well known for running 'mercy' operations, which are low-cost no-strings-attached contracts for those in dire need."
	history = ""
	work = "mercenary contractors"
	headquarters = ""
	motto = "Strength in Numbers"
	scan_exempt = TRUE //we're technically kinda-good guys, so we don't do shady stuff
	autogenerate_destination_names = TRUE

	ship_prefixes = list("HPF" = "a secure freight", "HPT" = "a training", "HPS" = "a logistics", "HPV" = "a patrol", "HPH" = "a bounty hunting", "HPX" = "an experimental", "HPC" = "a command", "HPI" = "a mercy")
	flight_types = list(		
			"flight",
			"mission",
			"route",
			"operation",
			"assignment",
			"contract"
			)
	//animals, preferably predators, all factual/extant critters
	ship_names = list(
			"Wolf",
			"Bear",
			"Eagle",
			"Condor",
			"Falcon",
			"Hawk",
			"Kestrel",
			"Shark",
			"Fox",
			"Weasel",
			"Mongoose",
			"Bloodhound",
			"Rhino",
			"Tiger",
			"Leopard",
			"Panther",
			"Cheetah",
			"Lion",
			"Vulture",
			"Piranha",
			"Crocodile",
			"Alligator",
			"Recluse",
			"Tarantula",
			"Scorpion",
			"Orca",
			"Coyote",
			"Jackal",
			"Hyena",
			"Hornet",
			"Wasp",
			"Sealion",
			"Viper",
			"Cobra",
			"Sidewinder",
			"Asp",
			"Python",
			"Anaconda",
			"Krait",
			"Diamondback",
			"Mamba",
			"Fer de Lance",
			"Keelback",
			"Adder",
			"Constrictor",
			"Boa",
			"Moray",
			"Taipan",
			"Rattlesnake"
			)
	destination_names = list(
			"HIVE Command",
			"a HIVE patrol fleet",
			"a HIVE flotilla",
			"a HIVE training fleet",
			"a HIVE logistics fleet",
			"a contract location"
			)
			//some basics, padded with autogen

//intentionally edgy a.f.
/datum/lore/organization/mil/blackstar
	name = "Blackstar Legion"
	short_name = "Blackstar "
	acronym = "BSL"
	desc = "Shrouded in mystery and controversy, Blackstar Legion is said to have its roots in pre-FTL Sol private military contractors. Their reputation means that most upstanding corporations and governments are hesitant to call upon them, whilst their prices put them out of the reach of most private individuals. As a result, they're mostly seen as the hired thugs of frontier governments that don't (or won't) answer to SolGov."
	history = ""
	work = "mercenary contractors"
	headquarters = ""
	motto = ""
	autogenerate_destination_names = TRUE

	ship_prefixes = list("BSF" = "a secure freight", "BST" = "a training", "BSS" = "a logistics", "BSV" = "a patrol", "BSH" = "a security", "BSX" = "an experimental", "BSC" = "a command")
	flight_types = list(		
			"flight",
			"mission",
			"route",
			"operation",
			"assignment",
			"contract"
			)
	//edgy mythological critters!
	ship_names = list(
			"Dragon",
			"Chimera",
			"Titan",
			"Hekatonchires",
			"Gorgon",
			"Scylla",
			"Minotaur",
			"Banshee",
			"Basilisk",
			"Black Dog",
			"Centaur",
			"Cerberus",
			"Charybdis",
			"Cyclops",
			"Cynocephalus",
			"Demon",
			"Daemon",
			"Echidna",
			"Goblin",
			"Golem",
			"Griffin",
			"Hobgoblin",
			"Hydra",
			"Imp",
			"Ladon",
			"Manticore",
			"Medusa",
			"Ogre",
			"Pegasus",
			"Sasquatch",
			"Shade",
			"Siren",
			"Sphinx",
			"Typhon",
			"Valkyrie",
			"Vampir",
			"Wendigo",
			"Werewolf",
			"Wraith"
			)
	destination_names = list(
			"Blackstar Command",
			"a Blackstar training site",
			"a Blackstar logistical depot",
			"a Blackstar-held shipyard",
			"a contract location"
			)

