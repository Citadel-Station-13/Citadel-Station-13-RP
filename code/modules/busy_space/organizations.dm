//Datums for different companies that can be used by busy_space
/datum/lore/organization
	/// Organization's name
	var/name = ""
	/// Organization's shortname (NanoTrasen for "NanoTrasen Incorporated")
	var/short_name = ""
	/// Organization's acronym, e.g. 'NT' for NanoTrasen'.
	var/acronym = ""
	/// One or two paragraph description of the organization, but only current stuff.  Currently unused.
	var/desc = ""
	/// Historical discription of the organization's origins  Currently unused.
	var/history = ""
	/// Short description of their work, eg "an arms manufacturer"
	var/work = ""
	/// Location of the organization's HQ.  Currently unused.
	var/headquarters = ""
	/// A motto/jingle/whatever, if they have one.  Currently unused.
	var/motto = ""

	/// Some might have more than one! Like NanoTrasen. Value is the mission they perform, e.g. ("ABC" = "mission desc")
	var/list/ship_prefixes = list()
	/// Enables complex task generation
	var/complex_tasks = FALSE

	//how does it work? simple: if you have complex tasks enabled, it goes; PREFIX + TASK_TYPE + FLIGHT_TYPE
	//e.g. NDV = Asset Protection + Patrol + Flight
	//this allows you to use the ship prefix for subfactions (warbands, religions, whatever) within a faction, and define task_types at the faction level
	//task_types are picked from completely at random in air_traffic.dm, much like flight_types, so be careful not to potentially create combos that make no sense!
	var/list/task_types = list(
		"logistics", "patrol", "training",
		"peacekeeping",	"escort", "search and rescue"
		)
	/// Operations and flights - we can override this if we want to remove the military-sounding ones or add our own
	var/list/flight_types = list(
		"flight", "mission", "route", "assignment"
		)
	/// Names of spaceships.  This is a mostly generic list that all the other organizations inherit from if they don't have anything better.
	var/list/ship_names = list(
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
			"Luminous",
			"Calypso",
			"Eclipse",
			"Maverick",
			"Polaris",
			"Orion",
			"Odyssey",
			"Relentless",
			"Valor",
			"Zodiac",
			"Avenger",
			"Defiant",
			"Dauntless",
			"Interceptor",
			"Providence",
			"Thunderchild",
			"Defender",
			"Ranger",
			"River",
			"Jubilee",
			"Gumdrop",
			"Spider",
			"Columbia",
			"Eagle",
			"Intrepid",
			"Odyssey",
			"Aquarius",
			"Kitty Hawk",
			"Antares",
			"Falcon",
			"Casper",
			"Orion",
			"Columbia",
			"Atlantis",
			"Enterprise",
			"Challenger",
			"Pathfinder",
			"Buran",
			"Aldrin",
			"Armstrong",
			"Tranquility",
			"Nostrodamus",
			"Soyuz",
			"Cosmos",
			"Sputnik",
			"Belka",
			"Strelka",
			"Gagarin",
			"Shepard",
			"Tereshkova",
			"Leonov",
			"Vostok",
			"Apollo",
			"Mir",
			"Titan",
			"Serenity",
			"Andiamo",
			"Aurora",
			"Phoenix",
			"Lucky",
			"Raven",
			"Valkyrie",
			"Halcyon",
			"Nakatomi",
			"Cutlass",
			"Unicorn",
			"Sheepdog",
			"Arcadia",
			"Gigantic",
			"Goliath",
			"Pequod",
			"Poseidon",
			"Venture",
			"Evergreen",
			"Natal",
			"Maru",
			"Djinn",
			"Witch",
			"Wolf",
			"Lone Star",
			"Grey Fox",
			"Dutchman",
			"Sultana",
			"Siren",
			"Venus",
			"Anastasia",
			"Rasputin",
			"Stride",
			"Suzaku",
			"Hathor",
			"Dream",
			"Gaia",
			"Ibis",
			"Progress",
			"Olympic",
			"Venture",
			"Brazil",
			"Tiger",
			"Hedgehog",
			"Potemkin",
			"Fountainhead",
			"Sinbad",
			"Esteban",
			"Mumbai",
			"Shanghai",
			"Madagascar",
			"Kampala",
			"Bangkok",
			"Emerald",
			"Guo Hong",
			"Shun Kai",
			"Fu Xing",
			"Zhenyang",
			"Da Qing",
			"Rascal",
			"Flamingo",
			"Jackal",
			"Andromeda",
			"Ferryman",
			"Panchatantra",
			"Nunda",
			"Fortune",
			"New Dawn",
			"Fionn MacCool",
			"Red Bird",
			"Star Rat",
			"Cwn Annwn",
			"Morning Swan",
			"Black Cat",
			"Challenger"
			)
	/// Names of static holdings that the organization's ships visit regularly.
	var/list/destination_names = list()

	/// New org_type flag replaces lawful/hostile/sysdef, valid standard options are neutral (default), corporate, government, system defense, smuggler, pirate, military, retired
	var/org_type = "neutral"

	/// Is this part of the fleet/station makeup? fleet system currently disabled
	var/fleet = FALSE

	/// Pad the destination lists with some extra random ones?
	var/autogenerate_destination_names = TRUE

/datum/lore/organization/New()
	if(autogenerate_destination_names) // Lets pad out the destination names.
		var/i = rand(7, 12) //was 6-10, now 7-12, slight increase for flavor, especially 'starved' lists

		/// known planets and exoplanets, plus fictional ones
		var/list/planets = list(
			"Earth", "Luna", "Mars", "Titan", "Europa", "Sif", "Kara", "Rota",
			"Root", "Toledo, New Ohio", "Meralar", "Adhomai", "Arion", "Arkas",
			"Orbitar", "Galileo", "Brahe", "Janssen", "Harriot", "Aegir",
			"Amateru", "Dagon", "Meztli", "Hypatia", "Dulcinea", "Rocinante",
			"Sancho", "Thestias", "Saffar", "Samh", "Majriti", "Draugr")

		/// existing systems, pruned for duplicates, includes systems that contain suspected or confirmed exoplanets
		var/list/systems = list(
			"Sol", "Alpha Centauri", "Sirius", "Vega", "Tau Ceti", "Zhu Que",
			"Oasis", "Vir", "Gavel", "Ganesha", "Saint Columbia", "Altair",
			"Sidhe", "New Ohio", "Parvati", "Mahi-Mahi", "Nyx", "New Seoul",
			"Kess-Gendar", "Raphael", "Phact", "El", "Eutopia", "Qerr'valis",
			"Qerrna-Lakirr", "Rarkajar", "Vazzend", "Thoth", "Jahan's Post",
			"Kauq'xum", "Silk", "New Singapore", "Stove", "Viola", "Love",
			"Isavau's Gamble", "Shelf", "deep space", "Epsilon Eridani", "Fomalhaut",
			"Mu Arae", "Pollux", "Wolf 359", "Ross 128", "Gliese 1061", "Luyten's Star",
			"Teegarden's Star", "Kapteyn", "Wolf 1061", "Aldebaran", "Proxima Centauri",
			"Kepler-90", "HD 10180", "HR 8832", "TRAPPIST-1", "55 Cancri", "Gliese 876",
			"Upsilon Andromidae", "Mu Arae", "WASP-47", "82 G. Eridani",
			"Rho Coronae Borealis", "Pi Mensae", "Beta Pictoris", "Gamma Librae",
			"Gliese 667 C", "Kapteyn", "LHS 1140", "New Ohio", "Samsara", "Angessa's Pearl")
		var/list/owners = list(
			"a government", "a civilian", "a corporate", "a private",
			"an independent", "a mercenary", "a military", "a contracted")
		var/list/purpose = list(
			"an exploration", "a trade", "a research", "a survey", "a military",
			"a mercenary", "a corporate", "a civilian", "an independent")

		/// unique or special locations
		var/list/unique = list("the Jovian subcluster")

		var/list/orbitals = list(
			"[pick(owners)] shipyard", "[pick(owners)] dockyard", "[pick(owners)] station",
			"[pick(owners)] vessel", "a habitat","[pick(owners)] refinery", "[pick(owners)] research facility",
			"an industrial platform", "[pick(owners)] installation")
		var/list/surface = list(
			"a colony","a settlement", "a trade outpost", "[pick(owners)] supply depot",
			"a fuel depot", "[pick(owners)] installation", "[pick(owners)] research facility")
		var/list/deepspace = list(
			"[pick(owners)] asteroid base", "a freeport", "[pick(owners)] shipyard",
			"[pick(owners)] dockyard", "[pick(owners)] station", "[pick(owners)] vessel",
			"[pick(owners)] orbital habitat", "an orbital refinery", "a colony", "a settlement",
			"a trade outpost", "[pick(owners)] supply depot", "a fuel depot", "[pick(owners)] installation",
			"[pick(owners)] research facility")
		var/list/frontier = list(
			"[pick(purpose)] [pick("ship","vessel","outpost")]",
			"a waystation","an outpost","a settlement","a colony"
			)

		//patterns; orbital ("an x orbiting y"), surface ("an x on y"), deep space ("an x in y"), the frontier ("an x on the frontier")
		//biased towards inhabited space sites
		while(i)
			i--
			destination_names.Add("[pick("[pick(orbitals)] orbiting [pick(planets)]","[pick(surface)] on [pick(planets)]","[pick(deepspace)] in [pick(systems)]",20;"[pick(unique)]",30;"[pick(frontier)] on the frontier")]")

//extensive rework for a much greater degree of variety compared to the old system, lists now include known exoplanets and star systems currently suspected or confirmed to have exoplanets

//////////////////////////////////////////////////////////////////////////////////

// TSCs
/datum/lore/organization/tsc/nanotrasen
	name = "NanoTrasen Incorporated"
	short_name = "NanoTrasen "
	acronym = "NT"
	desc = "NanoTrasen is one of the foremost research and development companies in the galaxy. \
	Originally focused on consumer products, their swift move into the field of Phoron has lead to \
	them being the foremost experts on the substance and its uses. In the modern day, NanoTrasen prides \
	itself on being an early adopter to as many new technologies as possible, often offering the newest \
	products to their employees. In an effort to combat complaints about being 'guinea pigs', Nanotrasen \
	also offers one of the most comprehensive medical plans in Frontier space, up to and including cloning, \
	dedicated resleeving, mirror maintenance, and therapy.\
	<br><br>\
	NT's most well known products are its phoron based creations, especially those used in Cryotherapy. \
	It also boasts an prosthetic line, which is provided to its employees as needed, and is used as an incentive \
	for newly tested posibrains to remain with the company."
	work = "research giant"
	headquarters = "Creon, Thebes"
	fleet = TRUE

	org_type = "corporate"

	ship_prefixes = list("NTV" = "a general operations", "NEV" = "an exploration", "NSV" = "a research", "NGV" = "a hauling", "NDV" = "a patrol", "NRV" = "an emergency response", "NDV" = "an asset protection")
	/// Scientist naming scheme
	ship_names = list(
		"Bardeen", "Einstein", "Feynman", "Sagan", "Tyson",	"Galilei",
		"Jans",	"Fhriede", "Franklin", "Tesla", "Curie", "Darwin",
		"Newton", "Pasteur", "Bell", "Mendel", "Kepler", "Edison",
		"Cavendish", "Nye", "Hawking", "Aristotle", "Von Braun", "Kaku",
		"Oppenheimer", "Renwick", "Hubble", "Alcubierre", "Robineau", "Glass",
		"Curiosity", "Voyager", "Perseverance", "Once More With Feeling",
		"Pretty Boy", "Whiskey Ring", "Uranus", "Chappaquiddick", "Dead Ringer",
		"Watershed", "Zeus", "Defiant","Firefly", "Screaming Gale", "Gee Golly",
		"Star Drifter", "Albatross", "Hawk", "Falcon", "Mule", "Caravel", "Galleon",
		"Atlas", "Conestoga", "Endurance", "Donkey", "Grand Duke", "Prince", "Princess")
	/// Note that the current station being used will be pruned from this list upon being instantiated
	destination_names = list(
		"NT HQ", "NSS Exodus in Nyx", "NCS Northern Star in Vir",
		"NLS Southern Cross in Vir", "NAS Vir Central Command",
		"a dockyard orbiting Sif", "an asteroid orbiting Kara",
		"an asteroid orbiting Rota", "Vir Interstellar Spaceport",
		"NSB Adephagia","Ishtar Sector")

/datum/lore/organization/tsc/nanotrasen/New()
	..()
	spawn(1) // BYOND shenanigans means GLOB.using_map is not initialized yet.  Wait a tick.
		// Get rid of the current map from the list, so ships flying in don't say they're coming to the current map.
		var/string_to_test = "[GLOB.using_map.station_name] in [GLOB.using_map.starsys_name]"
		if(string_to_test in destination_names)
			destination_names.Remove(string_to_test)

/datum/lore/organization/tsc/hephaestus
	name = "Hephaestus Industries"
	short_name = "Hephaestus "
	acronym = "HI"
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles on the Frontier. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a notable trade and research pact \
	with NanoTrasen. They otherwise enforce pacts and trade arrangements with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. The Orion Confederation itself is one of Hephaestus' largest \
	non-corporate bulk contractors."
	work = "arms manufacturer"
	headquarters = "Orlov IV, Vitalya"

	org_type = "corporate"

	ship_prefixes = list("HIV" = "a general operations", "HTV" = "a freight", "HLV" = "a munitions resupply", "HDV" = "an asset protection", "HDV" = "a preemptive deployment")
	//War God Theme, updated
	ship_names = list(
		"Anhur", "Bast", "Horus", "Maahes", "Neith", "Pakhet",
		"Sekhmet", "Set", "Sobek", "Maher", "Kokou", "Ogoun",
		"Oya", "Kovas", "Agrona", "Andraste", "Anann", "Badb",
		"Belatucadros",	"Cicolluis", "Macha", "Neit", "Nemain",
		"Rudianos", "Chiyou", "Guan Yu", "Jinzha", "Nezha",
		"Zhao Lang", "Laran", "Menrva", "Tyr", "Woden", "Freya",
		"Odin", "Ullr", "Ares", "Deimos", "Enyo", "Kratos", "Kartikeya",
		"Mangala", "Parvati", "Shiva", "Vishnu", "Shaushka", "Wurrukatte",
		"Hadur", "Futsunushi", "Sarutahiko", "Takemikazuchi", "Neto",
		"Agasaya", "Belus", "Ishtar", "Shala", "Huitzilopochtli",
		"Tlaloc", "Xipe-Totec", "Qamaits", "'Oro", "Rongo", "Ku",
		"Pele", "Maru", "Tumatauenga", "Bellona", "Juno", "Mars",
		"Minerva", "Victoria", "Anat", "Astarte", "Perun", "Cao Lo")
	destination_names = list(
		"our headquarters on Luna",
		"an Orion Confederation dockyard on Luna",
		"a Fleet outpost in the Almach Rim",
		"a Fleet outpost on the Moghes border"
		)

/datum/lore/organization/tsc/vey_med
	name = "Vey-Medical" //The Wiki displays them as Vey-Medical.
	short_name = "Vey-Med "
	acronym = "VM"
	desc = "Vey-Medical, often referred to simply as Vey-Med is notable for being largely owned and opperated by Skrell. \
	Despite their alien origin, Vey-Med has obtained market dominance on the Frontier due to the quality and reliability \
	of their medical equipment-- from surgical tools to large medical devices to the Oddyseus trauma response mecha \
	and everything in between. Their equipment tends to be top-of-the-line, most obviously shown by their incredibly \
	human-like FBP designs. Vey's rise to stardom came from their introduction of cosmetic resleeving, although in \
	recent years they've been forced to diversify as their patents expired and NanoTrasen-made medications became \
	essential to modern sleeving. Vey-Medical possesses a number of trade agreements and research pacts with NanoTrasen, \
	resulting in what is functionally considered an alliance."
	work = "medical equipment supplier"
	headquarters = "Toledo, New Ohio"

	org_type = "corporate"

	ship_prefixes = list("VMV" = "a general operations", "VTV" = "a transportation", "VHV" = "a medical resupply", "VSV" = "a research", "VRV" = "an emergency medical support")
	// Diona names
	ship_names = list(
		"Wind That Stirs The Waves", "Sustained Note Of Metal",
		"Bright Flash Reflecting Off Glass", "Veil Of Mist Concealing The Rock",
		"Thin Threads Intertwined", "Clouds Drifting Amid Storm",
		"Loud Note And Breaking", "Endless Vistas Expanding Before The Void",
		"Fire Blown Out By Wind", "Star That Fades From View",
		"Eyes Which Turn Inwards", "Joy Without Which The World Would Come Undone",
		"A Thousand Thousand Planets Dangling From Branches",
		"Light Streaming Through Interminable Branches",
		"Smoke Brought Up From A Terrible Fire", "Light of Qerr'Valis",
		"King Xae'uoque", "Memory of Kel'xi", "Xi'Kroo's Herald")
	destination_names = list(
		"our headquarters on Toledo, New Ohio",
		"a research facility in Samsara",
		"a sapientarian mission in the Almach Rim"
		)

/datum/lore/organization/tsc/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	short_name = "Zeng-Hu "
	acronym = "ZH"
	desc = "Zeng-Hu is an old TSC, based close to Confederation space. Until the discovery of Phoron, Zeng-Hu maintained a stranglehold \
	on the market for medications, and many household names are patentted by Zeng-Hu-- Bicaridyne, Dylovene, Tricordrizine, \
	and Dexalin all came from a Zeng-Hu medical laboratory. Zeng-Hu's fortunes have been in decline as Nanotrasen's near monopoly \
	on phoron research cuts into their R&D and Vey-Med's superior medical equipment effectively decimated their own equipment \
	interests. The three-way rivalry between these companies for dominance in the medical field is well-known and a matter of \
	constant economic speculation."
	work = "pharmaceuticals company"
	headquarters = "Bashe, Shang-Yang"

	org_type = "corporate"

	ship_prefixes = list("ZHV" = "a general operations", "ZTV" = "a transportation", "ZMV" = "a medical resupply", "ZRV" = "a medical research")
	//ship names: a selection of famous physicians who advanced the cause of medicine
	ship_names = list(
		"Averroes", "Avicenna", "Banting", "Billroth", "Blackwell",	"Blalock",
		"Charaka", "Chauliac", "Cushing", "Domagk", "Galen", "Fauchard", "Favaloro",
		"Fleming", "Fracastoro", "Goodfellow", "Gray", "Harvey", "Heimlich",
		"Hippocrates", "Hunter", "Isselbacher", "Jenner", "Joslin", "Kocher", "Laennec",
		"Lane-Claypon", "Lister", "Lower", "Madhav", "Maimonides", "Marshall", "Mayo",
		"Meyerhof", "Minot", "Morton", "Needleman", "Nicolle", "Osler", "Penfield",
		"Raichle", "Ransohoff", "Rhazes", "Semmelweis", "Starzl", "Still", "Susruta",
		"Urbani", "Vesalius", "Vidius", "Whipple", "White", "Worcestor", "Yegorov", "Xichun")
	destination_names = list("our headquarters on Bashe")

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
	work = "electronics manufacturer"
	headquarters = "KT-985, Ridley Minor"

	org_type = "corporate"

	ship_prefixes = list("WTV" = "a general operations", "WTFV" = "a freight", "WTGV" = "a transport", "WTDV" = "an asset protection")
	ship_names = list(
		"Comet", "Meteor", "Heliosphere", "Bolide", "Aurora", "Nova",
		"Supernova", "Nebula", "Galaxy", "Starburst", "Constellation",
		"Pulsar", "Quark", "Void", "Asteroid", "Wormhole", "Sunspot",
		"Supercluster", "Supergiant", "Protostar", "Magnetar", "Moon",
		"Supermoon", "Anomaly", "Drift", "Stream", "Rift", "Curtain",
		"Planetar", "Quasar", "Binary")
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
	Positronic Rights Group. Following a series of disastrous investments in advanced sleeving tech, Bishop was acquired by \
	their long time competitor Vey-Medical."
	work = "cybernetics and augmentation manufacturer"

	org_type = "corporate"

	ship_prefixes = list("BCV" = "a general operations", "BCTV" = "a transportation", "BCSV" = "a research exchange")
	//famous mechanical engineers
	ship_names = list(
		"Al-Jazari", "Al-Muradi", "Al-Zarqali", "Archimedes", "Arkwright",
		"Armstrong", "Babbage", "Barsanti", "Benz", "Bessemer", "Bramah",
		"Brunel", "Cardano", "Cartwright", "Cayley", "Clement", "Leonardo da Vinci",
		"Diesel", "Drebbel", "Fairbairn", "Fontana", "Fourneyron", "Fulton",
		"Fung", "Gantt", "Garay", "Hackworth", "Harrison", "Hornblower",
		"Jacquard", "Jendrassik", "Leibniz", "Ma Jun", "Maudslay", "Metzger",
		"Murdoch", "Nasmyth", "Parsons", "Rankine", "Reynolds", "Roberts",
		"Scheutz", "Sikorsky", "Somerset", "Stephenson", "Stirling", "Tesla",
		"Vaucanson", "Vishweswarayya", "Wankel", "Watt", "Wiberg")
	destination_names = list("a medical facility in Angessa's Pearl")

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

	org_type = "corporate"

	ship_prefixes = list("MCV" = "a general operations", "MTV" = "a freight", "MDV" = "a market protection", "MSV" = "an outreach")
	//periodic elements; something 'unusual' for the posibrain TSC without being full on 'quirky' culture ship names (much as I love them, they're done to death)
	ship_names = list(
		"Hydrogen",	"Helium", "Lithium", "Beryllium", "Boron", "Carbon", "Nitrogen",
		"Oxygen", "Fluorine", "Neon", "Sodium", "Magnesium", "Aluminium", "Silicon",
		"Phosphorus", "Sulfur", "Chlorine", "Argon", "Potassium", "Calcium", "Scandium",
		"Titanium", "Vanadium", "Chromium", "Manganese", "Iron", "Cobalt", "Nickel",
		"Copper", "Zinc", "Gallium", "Germanium", "Arsenic", "Selenium", "Bromine",
		"Krypton", "Rubidium", "Strontium", "Yttrium", "Zirconium", "Niobium", "Molybdenum",
		"Technetium", "Ruthenium", "Rhodium", "Palladium", "Silver", "Cadmium", "Indium",
		"Tin", "Antimony", "Tellurium", "Iodine", "Xenon", "Caesium", "Barium")
	//some hebrew alphabet destinations for a little extra unusualness
	destination_names = list(
		"our headquarters in Shelf",
		"a trade outpost in Shelf",
		"one of our factory complexes on Root",
		"research outpost Aleph",
		"logistics depot Dalet",
		"research installation Zayin",
		"research base Tsadi",
		"manufacturing facility Samekh")

/datum/lore/organization/tsc/xion
	name = "Xion Manufacturing Group"
	short_name = "Xion "
	acronym = "XMG"
	desc = "Xion, quietly, controls most of the market for industrial equipment. Their portfolio includes mining exosuits, \
	factory equipment, rugged positronic chassis, and other pieces of equipment vital to the function of the economy. Xion \
	keeps its control of the market by leasing, not selling, their equipment, and through infamous and bloody patent protection \
	lawsuits. Xion are noted to be a favorite contractor for Orion Confederation engineers, owing to their low cost and rugged design. \
	Two years ago, Xion was subjected to a hostile merger by Aether Atmospherics and Recycling, and is now considered an AAR subsidiary."
	history = ""
	work = "industrial equipment manufacturer"
	headquarters = ""
	motto = ""

	org_type = "corporate"

	ship_prefixes = list("XMV" = "a general operations", "XTV" = "a hauling", "XFV" = "a bulk transport", "XIV" = "a resupply")
	//martian mountains
	ship_names = list(
		"Olympus Mons", "Ascraeus Mons", "Arsia Mons", "Pavonis Mons",
		"Elysium Mons", "Hecates Tholus", "Albor Tholus", "Tharsis Tholus",
		"Biblis Tholus", "Alba Mons", "Ulysses Tholus", "Mount Sharp",
		"Uranius Mons", "Anseris Mons", "Hadriacus Mons", "Euripus Mons",
		"Tyrrhenus Mons", "Promethei Mons", "Chronius Mons", "Apollinaris Mons",
		"Gonnus Mons", "Syrtis Major Planum", "Amphitrites Patera", "Nili Patera",
		"Pityusa Patera", "Malea Patera", "Peneus Patera", "Labeatis Mons",
		"Issidon Paterae","Pindus Mons", "Meroe Patera", "Orcus Patera", "Oceanidum Mons",
		"Horarum Mons", "Peraea Mons", "Octantis Mons", "Galaxius Mons", "Hellas Planitia")
	destination_names = list()

//Keek&Allakai&Peesh's new TSC
/datum/lore/organization/tsc/antares
	name = "Antares Robotics Group"
	short_name = "Antares "
	acronym = "ARG"
	desc = "A former competitor of Xion Manufacturing Group in the field of industrial mining, the Antares Robotics Group \
	recently annouced their ARU (Antares Robotics Unit), which they claimed would be the first step towards creating a heavy frame \
	synthetic capable of withstanding harsher punishment than any other company. After publishing suspiciously successful studies \
	regarding the resilience of their models, Antares Robotics quickly secured production contracts from other Corporate manufactories \
	to produce their reliable and hardy prosthetics."
	history = ""
	work = "cybernetics manufacturer"
	headquarters = ""
	motto = ""

	org_type = "corporate"

	ship_prefixes = list("AGV" = "a general operations", "ATV" = "a transport", "ARV" = "a research", "ADV" = "a routine patrol", "AEV" = "a raw materials acquisition")
	//ship names: blank, because we get some autogenned for us
	ship_names = list()
	destination_names = list()

/datum/lore/organization/tsc/antares/New()
	..()
	var/i = 20 //give us twenty random names, antares has snowflake rng-ids
	var/list/numbers = list(
		"One", "Two", "Three",
		"Four", "Five", "Six",
		"Seven", "Eight", "Nine", "Zero")
	while(i)
		ship_names.Add("[pick(numbers)] [pick(numbers)] [pick(numbers)] [pick(numbers)]")
		i--

/datum/lore/organization/tsc/ftu
	name = "Free Trade Union"
	short_name = "Trade Union "
	acronym = "FTU"
	desc = "The Free Trade Union is different from other tran-stellars in that they are not just a company, but also a large conglomerate \
	of various traders and merchants from all over the galaxy. They control a sizable fleet of vessels of various classes, which maintain autonomy \
	from the centralized FTU to engage in free trade. They also host a fleet of combat vessels responsible for defending traders when necessary. They \
	control of many large scale trade stations across the galaxy, even in non-human space. Generally, their multi-purpose stations keep local sectors \
	filled with duty-free shops and wares. Almost anything is sold at FTU markets, including products that are forbidden or have insanely high taxes in \
	government or Corporate space. The FTU are the originators of the Tradeband language, created specially to serve as the lingua franca for Merchants \
	across the Galaxy, to ensure members may understand each other regardless of native language or nationality."
	history = "The Free Trade Union was created in 2410 by Issac Adler, a merchant, economist, and owner of a small fleet of ships. \
	At this time the \"Free Merchants\" were in decay because of the high taxes and tariffs that were generally applied on the products \
	that they tried to import or export. Another issue was that big trans-stellar corporations were constantly blocking their products to \
	prospective buyers in order to form their monopolies. Issac decided to organize the \"Free Merchants\" into a legitimate organization \
	to lobby and protest against the unfair practices of the major corporations and the governments that were in their pocket. \
	At the same time, they wanted to organize and sell their things at better prices. The organization started relatively small but by 2450 \
	it had become one of the biggest non-corporate conglomerates, with a significant amount of the merchants of the galaxy professing membership \
	in the FTU. At the same time, the Free Trade Union started to popularize tradeband in the galaxy as the language of business. Around 2500, \
	the majority of independent merchants were part of the FTU with significant influence on the galactic scale. They have started to invest in \
	colonization efforts in order to take early claim of the frontier systems as the best choice for frontier traders."

	org_type = "corporate"

	ship_prefixes = list("FTV" = "a general operations", "FTRP" = "a trade protection", "FTRR" = "a piracy suppression", "FTLV" = "a logistical support", "FTTV" = "a mercantile", "FTDV" = "a market establishment")
	//famous merchants and traders, taken from Civ6's Great Merchants, plus the TSC's founder
	ship_names = list(
		"Isaac Adler", "Colaeus", "Marcus Licinius Crassus", "Zhang Qian",
		"Irene of Athens", "Marco Polo", "Piero de' Bardi", "Giovanni de' Medici",
		"Jakob Fugger", "Raja Todar Mal", "Adam Smith", "John Jacob Astor",
		"John Spilsbury", "John Rockefeller", "Sarah Breedlove", "Mary Katherine Goddard",
		"Helena Rubenstein", "Levi Strauss", "Melitta Bentz", "Estee Lauder",
		"Jamsetji Tata", "Masaru Ibuka",)
	destination_names = list("a Free Trade Union office", "FTU HQ", "an FTU freeport")

//has to be disabled entirely or else the system will runtime any time MBT comes up
/datum/lore/organization/tsc/mbt
	name = "Major Bill's Transportation"
	short_name = "Major Bill's "
	acronym = "MBT"
	desc = "Formerly a popular courier service and starliner, Major Bill's was an unassuming corporation whose greatest asset was their low cost \
	 and brand recognition. Major Bill's was known, perhaps unfavorably, for its mascot, Major Bill, a cartoonish military figure that spouted \
	 quotable slogans. Their motto: \"With Major Bill's, you won't pay major bills!\", was an earworm much of the galaxy has since forgotten. \
	 Their ships, named after some of Earth's greatest rivers, now drift in scrapyards across the Frontier. An early casualty of the Bluespace Race \
	 and NanoTrasen's emergent dominance on the Galactic Plane, Major Bill's made a valiant effort to compete, before they ultimately dissolved in \
	 April of 2436."
	history = ""
	work = "courier and passenger transit"
	headquarters = "Defunct"
	motto = "With Major Bill's, you won't pay major bills!"

	org_type = "retired"

	// Retained for lore purposes.
	ship_prefixes = list("TTV" = "a general operations", "TTV" = "a transport", "TTV" = "a luxury transit", "TTV" = "a priority transit", "TTV" = "a secure data courier")
	//ship names: big rivers
	ship_names = list (
		"Nile", "Kagera", "Nyabarongo", "Mwogo", "Rukarara", "Amazon", "Ucayali",
		"Tambo", "Ene", "Mantaro", "Yangtze", "Mississippi", "Missouri", "Jefferson",
		"Beaverhead", "Red Rock", "Hell Roaring", "Yenisei", "Angara", "Yelenge",
		"Ider", "Ob", "Irtysh", "Rio de la Plata", "Parana", "Rio Grande", "Congo",
		"Chambeshi", "Amur", "Argun", "Kherlen", "Lena", "Mekong", "Mackenzie",
		"Peace", "Finlay", "Niger", "Brahmaputra", "Tsangpo", "Murray", "Darling",
		"Culgoa", "Balonne", "Condamine", "Tocantins", "Araguaia", "Volga")
	destination_names = list(
		"Major Bill's Transportation HQ on Mars",
		"a Major Bill's warehouse",
		"a Major Bill's distribution center",
		"a Major Bill's supply depot" )

/datum/lore/organization/tsc/grayson
	name = "Grayson Manufactories Ltd."
	short_name = "Grayson "
	acronym = "GM"
	desc = "Grayson Manufactories Ltd. is one of the oldest surviving TSCs, having been in 'the biz' almost since mankind began to colonize the \
	Sol system. Where many other corporations chose to go into the high end markets, however, Grayson makes their money by providing foundations \
	for other businesses; they run some of the largest mining and refining operations in all of human-inhabited space. Ore is hauled out of Grayson-owned \
	mines, transported on Grayson-owned ships, and processed in Grayson-owned refineries, then sold by Grayson-licensed vendors to other industries. \
	Several of their relatively newer ventures include heavy industrial equipment, which has earned a reputation for being surprisingly reliable. \
	<br><br>Grayson may maintain a neutral stance towards their fellow TSCs, but can be quite aggressive in the markets that it already holds. A steady stream \
	of rumors suggests they're not shy about engaging in industrial sabotage or calling in strikebreakers, either."
	headquarters = "Mars, Sol"

	org_type = "corporate"

	ship_prefixes = list("GMV" = "a general operations", "GMT" = "a transport", "GMR" = "a resourcing", "GMS" = "a surveying", "GMH" = "a bulk transit")
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
	desc = "Aether Atmospherics and Recycling is the prime maintainer and provider of atmospherics systems across both the many ships that navigate the \
	vast expanses of space, and the life support on current and future Human colonies. The byproducts from the filtration of atmospheres across the galaxy \
	are then resold for a variety of uses to those willing to buy. With the nature of their services, most work they do is contracted for construction of \
	these systems, or staffing to maintain them for colonies across human space. Recently, Aether executed a shockingly effective set of hostile acquisitions, \
	purchasing Focal Point Energistics and the Xion Manufacturing Group."
	history = ""
	work = ""
	headquarters = ""
	motto = "Dum spiro spero"

	org_type = "corporate"

	ship_prefixes = list("AARV" = "a general operations", "AARE" = "a resource extraction", "AARG" = "a gas transport", "AART" = "a transport")
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
	desc = "Focal Point Energistics is an electrical engineering solutions firm originally formed as a conglomerate of Earth power companies and affiliates. \
	Focal Point manufactures and distributes vital components in modern power grids, such as TEGs, PSUs and their specialty product, the SMES. The company is \
	often consulted and contracted by larger organisations due to their expertise in their field. They were recently bought by Aether Atmospherics and Recyclables, \
	although this has not seemed to have disrupted their industry. Many speculate that FPE is benefitting from the enhanced manufacturing support."
	history = ""
	work = ""
	headquarters = ""
	motto = ""

	org_type = "corporate"

	ship_prefixes = list("FPV" = "a general operations", "FPH" = "a transport", "FPC" = "an energy relay", "FPT" = "a fuel transport")
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
	desc = "Founded in 2437 by Astara Junea, StarFlight Incorporated is now one of the biggest passenger liner businesses in human-occupied space and has even begun \
	breaking into alien markets - all despite a rocky start, and several high-profile ship disappearances and shipjackings. With space traffic at an all-time high, \
	it's a depressing reality that SFI's incidents are just a tiny drop in the bucket compared to everything else going on."
	history = ""
	work = "luxury, business, and economy passenger flights"
	headquarters = "Spin Aerostat, Jupiter"
	motto = "Sic itur ad astra"

	org_type = "corporate"

	ship_prefixes = list("SFI-X" = "a VIP liner", "SFI-L" = "a luxury liner", "SFI-B" = "a business liner", "SFI-E" = "an economy liner", "SFI-M" = "a mixed class liner", "SFI-S" = "a sightseeing", "SFI-M" = "a wedding", "SFI-O" = "a marketing", "SFI-S" = "a safari", "SFI-A" = "an aquatic adventure")
	flight_types = list(		//no military-sounding ones here
			"flight",
			"route",
			"tour"
			)
	ship_names = list(	//birbs
			"Rhea",
			"Ostrich",
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
			"a ski-resort world",
			"an ocean resort planet",
			"a desert resort world",
			"an arctic retreat"
			)

/datum/lore/organization/tsc/oculum
	name = "Oculum Broadcasting Network"
	short_name = "Oculus "
	acronym = "OBN"
	desc = "Oculum owns approximately 30% of Frontier-wide news networks, including microblogging aggregate sites, network and comedy news, and even \
	old-fashioned newspapers. Staunchly apolitical, they specialize in delivering the most popular news available- which means telling people what they \
	already want to hear. Oculum is a specialist in branding, and most people don't know that the reactionary Daedalus Dispatch newsletter and the radically \
	transhuman Liquid Steel webcrawler are controlled by the same organization."
	history = ""
	work = "news media"
	headquarters = ""
	motto = "News from all across the spectrum"

	org_type = "corporate"
	ship_prefixes = list("OBV" = "an investigation", "OBV" = "a distribution", "OBV" = "a journalism", "OBV" = "a general operations")
	destination_names = list(
			"Oculus HQ"
			)

/datum/lore/organization/tsc/centauriprovisions
	name = "Centauri Provisions"
	short_name = "Centauri "
	acronym = "ACP"
	desc = "Headquartered in Alpha Centauri, Centauri Provisions made a name in the snack-food industry primarily by being the first to focus on colonial holdings. \
	The various brands of Centauri snackfoods are now household names, from SkrellSnax to Space Mountain Wind to the ubiquitous and dubiously-edible Bread Tube, \
	and they are well known for targeting as many species as possible with each brand (which, some will argue, is at fault for some of those brands being rather bland \
	in taste and texture). Their staying power is legendary, and many spacers have grown up on a mix of their cheap crap and protein shakes."
	history = ""
	work = "catering, food, drinks"
	headquarters = "Alpha Centauri"
	motto = "The largest brands of food and drink - most of them are Centauri."

	org_type = "corporate"
	ship_prefixes = list("CPTV" = "a transport", "CPCV" = "a catering", "CPRV" = "a resupply", "CPV" = "a general operations")
	destination_names = list(
			"Centauri Provisions HQ",
			"a Centauri Provisions depot",
			"a Centauri Provisions warehouse"
			)
/datum/lore/organization/tsc/einstein
	name = "Einstein Engines"
	short_name = "Einstein "
	acronym = "EEN"
	desc = "Einstein is an old company that has survived through rampant respecialization. In the age of phoron-powered exotic engines and ubiquitous solar power, \
	Einstein makes its living through the sale of engine designs for power sources it has no access to, and emergency fission or hydrocarbon power supplies. \
	Accusations of corporate espionage against research-heavy corporations like NanoTrasen and its former rival Focal Point are probably unfounded."
	history = ""
	work = "catering, food, drinks"
	headquarters = ""
	motto = "Engine designs, emergency generators, and old memories"

	org_type = "corporate"
	ship_prefixes = list("EETV" = "a transport", "EERV" = "a research", "EEV" = "a general operations")
	destination_names = list(
			"Einstein HQ"
			)
/datum/lore/organization/tsc/wulf
	name = "Wulf Aeronautics"
	short_name = "Wulf Aero "
	acronym = "WUFA"
	desc = "Wulf Aeronautics is the chief producer of transport and hauling spacecraft. A favorite contractor of the Confederation, Wulf manufactures most of their \
	diplomatic and logistics craft, and does a brisk business with most other TSCs. The quiet reliance of the economy on their craft has kept them out of \
	the spotlight and uninvolved in other corporations' back-room dealings; nobody is willing to try to undermine Wulf Aerospace in case it bites them in \
	the ass, and everyone knows that trying to buy out the company would start a bidding war from which nobody would escape the PR fallout."
	history = ""
	work = "starship construction"
	headquarters = ""
	motto = "We build it - you fly it"

	org_type = "corporate"
	ship_prefixes = list("WATV" = "a transport", "WARV" = "a repair", "WAV" = "a general operations")
	destination_names = list(
			"Wulf Aeronautics HQ",
			"a Wulf Aeronautics supply depot",
			"a Wulf Aeronautics Shipyard"
			)

/datum/lore/organization/tsc/gilthari
	name = "Gilthari Exports"
	short_name = "Gilthari "
	acronym = "GEX"
	desc = "Gilthari is Sol's premier supplier of luxury goods, specializing in extracting money from the rich and successful that aren't already their own \
	shareholders. Their largest holdings are in gambling, but they maintain subsidiaries in everything from VR equipment to luxury watches. Their holdings in \
	mass media are a smaller but still important part of their empire. Gilthari is known for treating its positronic employees very well, sparking a number of \
	conspiracy theories. The gorgeous FBP model that Gilthari provides them is a symbol of the corporation's wealth and reach ludicrous prices when available on \
	the black market, with legal ownership of the chassis limited, by contract, to employees. \
	<br><br>In fitting with their heritage, Gilthari ships are named after precious stones."
	history = ""
	work = "luxury goods"
	headquarters = ""
	motto = ""

	org_type = "corporate"
	ship_prefixes = list("GETV" = "a transport", "GECV" = "a luxury catering", "GEV" = "a general operations")
	//precious stones
	ship_names = list(
			"Afghanite",
			"Agate",
			"Alexandrite",
			"Amazonite",
			"Amber",
			"Amethyst",
			"Ametrine",
			"Andalusite",
			"Aquamarine",
			"Azurite",
			"Benitoite",
			"Beryl",
			"Carnelian",
			"Chalcedony",
			"Chrysoberyl",
			"Chrysoprase",
			"Citrine",
			"Coral",
			"Danburite",
			"Diamond",
			"Emerald",
			"Fluorite",
			"Garnet",
			"Heliodor",
			"Iolite",
			"Jade",
			"Jasper",
			"Lapis Lazuli",
			"Malachite",
			"Moldavite",
			"Moonstone",
			"Obsidian",
			"Onyx",
			"Orthoclase",
			"Pearl",
			"Peridot",
			"Quartz",
			"Ruby",
			"Sapphire",
			"Scapolite",
			"Selenite",
			"Serpentine",
			"Sphalerite",
			"Sphene",
			"Spinel",
			"Sunstone",
			"Tanzanite",
			"Topaz",
			"Tourmaline",
			"Turquoise",
			"Zircon"
			)
	destination_names = list(
			"Gilthari HQ",
			"a GE supply depot",
			"a GE warehouse",
			"a GE-owned luxury resort"
			)

/datum/lore/organization/tsc/coyotecorp
	name = "Coyote Salvage Corp."
	short_name = "Coyote "
	acronym = "CSC"
	desc = "The threat of Kessler Syndrome ever looms in this age of spaceflight, and it's only thanks to the dedication and hard work of unionized salvage groups \
	like the Coyote Salvage Corporation that the spacelanes are kept clear and free of wrecks and debris. Painted in that distinctive industrial yellow, their fleets \
	of roaming scrappers are contracted throughout civilized space and the frontier alike to clean up space debris. Some may look down on them for handling what would \
	be seen as garbage and discarded scraps, but as far as the CSC is concerned everything would grind to a halt (or more accurately, rapidly expand in a cloud of \
	red-hot scrap metal) without their tender care and watchful eyes. \
	<br><br> Many spacers turn to join the ranks of the Salvage Corps when times are lean, or when they need a quick buck. The work is dangerous and the hours are long, \
	but the benefits are generous and you're paid by what you salvage so if you've an eye for appraising scrap you can turn a good profit. For those who dedicate their \
	lives to the work, they can become kings of the scrapheap and live like royalty. CSC Contractors are no strangers to conflict either, often having to deal with \
	claimjumpers and illegal salvage operations - or worse, the Vox."
	history = ""
	work = "salvage and shipbreaking"
	headquarters = "N/A"
	motto = "one man's trash is another man's treasure"

	org_type = "corporate"
	ship_prefixes = list("CSV" = "a salvage", "CRV" = "a recovery", "CTV" = "a transport", "CSV" = "a shipbreaking", "CHV" = "a towing")
	//mostly-original, maybe some references, and more than a few puns
	ship_names = list(
			"Road Hog",
			"Mine, Not Yours",
			"Legal Salvage",
			"Barely Legal",
			"One Man's Trash",
			"Held Together By Tape And Dreams",
			"Ventilated Vagrant",
			"Half A Wing And A Prayer",
			"Scrap King",
			"Make Or Break",
			"Lead Into Gold",
			"Under New Management",
			"Pride of Centauri",
			"Long Haul",
			"Argonaut",
			"Desert Nomad",
			"Non-Prophet Organization",
			"Rest In Pieces",
			"Sweep Dreams",
			"Home Sweep Home",
			"Atomic Broom",
			"Ship Broken",
			"Rarely Sober",
			"Barely Coherent",
			"Piece Of Mind",
			"War And Pieces",
			"Bits 'n' Bobs",
			"Home Wrecker",
			"T-Wrecks",
			"Dust Bunny",
			"No Gears No Glory",
			"Three Drinks In",
			"The Almighty Janitor",
			"Wreckless Endangerment",
			"Scarab"
			)
	//remove a couple types, add the more down-to-earth 'job' to reflect some personality
	flight_types = list(
			"job",
			"op",
			"operation",
			"assignment",
			"contract"
			)
	destination_names = list (
			"a frontier scrapyard",
			"a trashbelt",
			"a local salvage yard",
			"a nearby system"
			)

/datum/lore/organization/tsc/chimera
	name = "Chimera Genetics Corp."
	short_name = "Chimera "
	acronym = "CGC"
	desc = "With the rise of personal body modification, companies specializing in this field were bound to spring up as well. The Chimera Genetics Corporation, \
	or CGC, is one of the largest and most successful competitors in this ever-evolving and ever-adapting field. They originally made a foothold in the market through \
	designer flora and fauna such as \"factory plants\" and \"fabricowtors\"; imagine growing high-strength carbon nanotubes on vines, or goats that can be milked for a \
	substance with the tensile strength of spider silk. Once they had more funding Chimera aggressively expanded into high-end designer bodies, both vat-grown-from-scratch \
	and modification of existing bodies via extensive therapy procedures. Their best-known designer critter is the <i>Drake</i> line; hardy, cold-tolerant 'furred lizards' \
	that are unflinchingly loyal to their contract-holders. Drakes find easy work in heavy industries and bodyguard roles, despite constant lobbying from bioconservatives to, \
	quote, \"keep these \"meat drones\" from taking jobs away from regular people.\" Some things never change. \
	<br><br> Unsurprisingly, Chimera names their ships after mythological creatures."
	history = ""
	work = "designer bodies and bioforms"
	headquarters = "Moreau III, Jiang Shie"
	motto = "the whole is greater than the sum of its parts"

	org_type = "corporate"
	ship_prefixes = list("CGV" = "a general operations", "CGT" = "a transport", "CGT" = "a delivery", "CGH" = "a medical")
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
			SPECIES_GOLEM,
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
	destination_names = list (
			"Chimera HQ, Moreau III",
			"a Chimera research lab"
			)

/datum/lore/organization/tsc/independent
	name = "Independent Pilots Association"
	short_name = "" //using the same whitespace hack as JSDF
	acronym = "IPA"
	desc = "Though less common now than they were in the decades before the Bluespace Race, independent traders remain an important part of the galactic economy, \
	owing in no small part to protective tariffs established by the Free Trade Union in the late twenty-fourth century. Further out on the frontier, independent pilots \
	are often the only people keeping freight and supplies moving."
	history = ""
	work = "everything under the sun"
	headquarters = "N/A"
	motto = "N/A"

	ship_prefixes = list("ISV" = "a general", "IEV" = "a prospecting", "IEC" = "a prospecting", "IFV" = "a bulk freight", "ITV" = "a passenger transport", "ITC" = "a just-in-time delivery", "IPV" = "a patrol", "IHV" = "a bounty hunting", "ICC" = "an escort")
	flight_types = list(
			"flight",
			"mission",
			"route",
			"operation",
			"assignment",
			"contract"
			)
	destination_names = list() //we have no hqs or facilities of our own
	//ship names: blank, because we use the universal list

// Other

//SPACE LAW
/datum/lore/organization/other/sysdef
	name = "System Defense Force"
	short_name = "" //whitespace hack again
	acronym = "SDF"
	desc = "Localized militias are used to secure systems throughout inhabited space, but are especially common on the frontier. By levying and maintaining these local \
	militia forces, governments can use their fleets for more important matters. System Defense Forces tend to be fairly poorly trained and modestly equipped compared to \
	genuine military fleets, but are more than capable of contending with small-time pirates and can generally stall greater threats long enough for reinforcements to arrive. \
	They're also typically responsible for most search-and-rescue operations in their system."
	history = ""
	work = "local security"
	headquarters = ""
	motto = "Serve, Protect, Survive"
	autogenerate_destination_names = FALSE

	org_type = "system defense"

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
			"Waypoint Omega",
			"an SDF correctional facility",
			"an SDF processing center",
			"an SDF outpost"
			)

//basically just a dummy/placeholder 'org' for smuggler events
/datum/lore/organization/other/smugglers
	name = "Smugglers"
	short_name = "" //whitespace hack again
	acronym = "ISC"
	desc = "Where there's a market, there need to be merchants, and where there are buyers, there need to be suppliers. Most of all, wherever there's governments, \
	there'll be somebody trying to control what people are and aren't allowed to do with their bodies. For those seeking goods deemed illegal (for good reasons or otherwise) \
	they need to turn to smugglers and the fine art of sneaking things past the authorities. The most common goods smuggled throughout space are narcotics, firearms, \
	and occasionally slaves; whilst firearm ownership laws vary from location to location, most governments also take fairly hard stances on hard drugs, and slavery is \
	consistently outlawed and punished viciously throughout the vast majority of civilized space.\
	<br><br> Still, contrary to many conceptions, not all smuggling is nefarious. Entertainment media within human territories loves to paint romantic images of heroic \
	smugglers sneaking aid supplies to refugees or even helping oppressed minorities escape the grasp of xenophobic regimes."
	history = ""
	work = ""
	headquarters = ""
	motto = ""
	autogenerate_destination_names = TRUE //the events we get called for don't fire a destination, but we need entries to avoid runtimes.

	org_type = "smugglers"

	ship_prefixes = list ("suspected smuggler" = "an illegal smuggling", "possible smuggler" = "an illegal smuggling", "suspected bootlegger" = "a contraband smuggling") //as assigned by control, second part shouldn't even come up
	//blank out our shipnames for redesignation
	ship_names = list(
			"Morally Bankrupt",
			"Bucket of Bolts",
			"Wallet Inspector",
			"Laughing Stock",
			"Wayward Son",
			"Wide Load",
			"No Refunds",
			"Ugly Stick",
			"Poetic Justice",
			"Foreign Object",
			"Why Me",
			"Last Straw",
			"Designated Driver",
			"Slapped Together",
			"Lowest Bidder",
			"Harsh Language",
			"Public Servant",
			"Class Act",
			"Deviant Citizen",
			"Diminishing Returns",
			"Calculated Risk",
			"Logistical Nightmare",
			"Gross Negligence",
			"Holier Than Thou",
			"Open Wide",
			"Red Dread",
			"Missing Link",
			"Duct Taped",
			"Robber Baron",
			"Affront to Nature",
			"Total Loss",
			"Depth Perception",
			"This Way",
			"Mysterious Rash",
			"Jolly Roger",
			"Victim of Circumstance",
			"Product of Society",
			"Under Evaluation",
			"Flying Coffin",
			"Gilded Cage",
			"Disgruntled Worker",
			"Of Sound Mind",
			"Ivory Tower",
			"Bastard Son",
			"Scarlet Tentacle",
			"Down In Front",
			"Learning Experience",
			"Desperate Pauper",
			"Born Lucky",
			"Base Instincts",
			"Check Please",
			"Infinite Loop",
			"Lazy Morning",
			"Runtime Error",
			"Pointless Platitude",
			"Grey Matter",
			"Conscientious Objector",
			"Unexplained Itch",
			"Out of Control",
			"Unexpected Obstacle",
			"Toxic Behavior",
			"Controlled Explosion",
			"Happy Camper",
			"Unfortunate Ending",
			"Criminally Insane",
			"Not Guilty",
			"Double Jeopardy",
			"Perfect Pitch",
			"Dark Forecast",
			"Apologies in Advance",
			"Reduced To This",
			"Surprise Encounter",
			"Meat Locker",
			"Cardiac Arrest",
			"Piece of Junk",
			"Bottom Line",
			"With Abandon",
			"Unsound Methods",
			"Beast of Burden",
			"Red Claw",
			"No Laughing Matter",
			"Nothing Personal",
			"Great Experiment",
			"Looks Like Trouble",
			"Turning Point",
			"Murderous Intent",
			"If Looks Could Kill",
			"Liquid Courage",
			"Attention Seeker",
			"Juvenile Delinquent",
			"Mystery Meat",
			"Slippery Slope",
			"Empty Gesture",
			"Annoying Pest",
			"Killing Implement",
			"Blunt Object",
			"Blockade Runner",
			"Innocent Bystander",
			"Lacking Purpose",
			"Beyond Salvation",
			"This Too Shall Pass",
			"Guilty Pleasure",
			"Exploratory Surgery",
			"Inelegant Solution",
			"Under New Ownership",
			"Festering Wound",
			"Red Smile",
			"Mysterious Stranger",
			"Process of Elimination",
			"Prone to Hysteria",
			"Star Beggar",
			"Dream Shatterer",
			"Do The Math",
			"Big Boy",
			"Teacher's Pet",
			"Hell's Bells",
			"Critical Mass",
			"Star Wench",
			"Double Standard",
			"Blind Fury",
			"Carrion Eater",
			"Pound of Flesh",
			"Short Fuse",
			"Road Agent",
			"Deceiving Looks",
			"An Arrow in Flight",
			"Gun-to-Head",
			"Petty Theft",
			"Grand Larceny",
			"Pop Up",
			"A Promise Kept",
			"Frag Machine",
			"Unrepentant Camper",
			"Impersonal Space",
			"Fallen Pillar",
			"Motion Tabled",
			"Outrageous Fortune",
			"Pyrrhic and Proud",
			"Wiggling Bait",
			"Shoot for Loot",
			"Tone Deaf Siren",
			"The Worst Thing",
			"Violence-Liker",
			"Illegal Repercussions",
			"Shameless Plagiarist",
			"Dove & Crow",
			"Barnacle Jim",
			"Charles in Charge",
			"Strange Aeons",
			"Red Queen",
			"Eat Hot Chip & Lie"
			)
	/*
	destination_names = list(
			)
	*/

/datum/lore/organization/other/pirates
	name = "Pirates"
	short_name = "" //whitespace hack again
	acronym = "IPG"
	desc = "Where there's prey, predators are sure to follow. In space, the prey are civilian merchants, and the predators are opportunistic pirates. This is about where \
	the analogy breaks down, but the basic concept remains the same; civilian ships are usually full of valuable goods or important people, which can be sold on black markets \
	or ransomed back for a healthy sum. Pirates seek to seize the assets of others to get rich, rather than make an honest thaler themselves. \
	<br><br> In contrast to the colorful Ue-Katish and sneaky Vox, common pirates tend to be rough, practical, and brutally efficient in their work. System Defense units \
	practice rapid response drills, and in most systems it's only a matter of minutes before The Law arrives unless the pirate is able to isolate their target and prevent \
	them from sending a distress signal. Complicating matters is the infrequent use of privateers by various minor colonial governments, mercenaries turning to piracy during \
	hard times, and illegal salvage operations."
	history = ""
	work = ""
	headquarters = ""
	motto = "What\'s yours is mine."
	autogenerate_destination_names = TRUE //the events we get called for don't fire a destination, but we need entries to avoid runtimes.

	org_type = "pirate"

	ship_prefixes = list ("known pirate" = "a piracy", "suspected pirate" = "a piracy", "rogue privateer" = "a piracy", "Cartel enforcer" = "a piracy", "known outlaw" = "a piracy", "bandit" = "a piracy", "roving corsair" = "a piracy", "illegal salvager" = "an illegal salvage", "rogue mercenary" = "a mercenary") //as assigned by control, second part shouldn't even come up, but it exists to avoid hiccups/weirdness just in case
	ship_names = list(
			"Morally Bankrupt",
			"Bucket of Bolts",
			"Wallet Inspector",
			"Laughing Stock",
			"Wayward Son",
			"Wide Load",
			"No Refunds",
			"Ugly Stick",
			"Poetic Justice",
			"Foreign Object",
			"Why Me",
			"Last Straw",
			"Designated Driver",
			"Slapped Together",
			"Lowest Bidder",
			"Harsh Language",
			"Public Servant",
			"Class Act",
			"Deviant Citizen",
			"Diminishing Returns",
			"Calculated Risk",
			"Logistical Nightmare",
			"Gross Negligence",
			"Holier Than Thou",
			"Open Wide",
			"Red Dread",
			"Missing Link",
			"Duct Taped",
			"Robber Baron",
			"Affront to Nature",
			"Total Loss",
			"Depth Perception",
			"This Way",
			"Mysterious Rash",
			"Jolly Roger",
			"Victim of Circumstance",
			"Product of Society",
			"Under Evaluation",
			"Flying Coffin",
			"Gilded Cage",
			"Disgruntled Worker",
			"Of Sound Mind",
			"Ivory Tower",
			"Bastard Son",
			"Scarlet Tentacle",
			"Down In Front",
			"Learning Experience",
			"Desperate Pauper",
			"Born Lucky",
			"Base Instincts",
			"Check Please",
			"Infinite Loop",
			"Lazy Morning",
			"Runtime Error",
			"Pointless Platitude",
			"Grey Matter",
			"Conscientious Objector",
			"Unexplained Itch",
			"Out of Control",
			"Unexpected Obstacle",
			"Toxic Behavior",
			"Controlled Explosion",
			"Happy Camper",
			"Unfortunate Ending",
			"Criminally Insane",
			"Not Guilty",
			"Double Jeopardy",
			"Perfect Pitch",
			"Dark Forecast",
			"Apologies in Advance",
			"Reduced To This",
			"Surprise Encounter",
			"Meat Locker",
			"Cardiac Arrest",
			"Piece of Junk",
			"Bottom Line",
			"With Abandon",
			"Unsound Methods",
			"Beast of Burden",
			"Red Claw",
			"No Laughing Matter",
			"Nothing Personal",
			"Great Experiment",
			"Looks Like Trouble",
			"Turning Point",
			"Murderous Intent",
			"If Looks Could Kill",
			"Liquid Courage",
			"Attention Seeker",
			"Juvenile Delinquent",
			"Mystery Meat",
			"Slippery Slope",
			"Empty Gesture",
			"Annoying Pest",
			"Killing Implement",
			"Blunt Object",
			"Blockade Runner",
			"Innocent Bystander",
			"Lacking Purpose",
			"Beyond Salvation",
			"This Too Shall Pass",
			"Guilty Pleasure",
			"Exploratory Surgery",
			"Inelegant Solution",
			"Under New Ownership",
			"Festering Wound",
			"Red Smile",
			"Mysterious Stranger",
			"Process of Elimination",
			"Prone to Hysteria",
			"Star Beggar",
			"Dream Shatterer",
			"Do The Math",
			"Big Boy",
			"Teacher's Pet",
			"Hell's Bells",
			"Critical Mass",
			"Star Wench",
			"Double Standard",
			"Blind Fury",
			"Carrion Eater",
			"Pound of Flesh",
			"Short Fuse",
			"Road Agent",
			"Deceiving Looks",
			"An Arrow in Flight",
			"Gun-to-Head",
			"Petty Theft",
			"Grand Larceny",
			"Pop Up",
			"A Promise Kept",
			"Frag Machine",
			"Unrepentant Camper",
			"Impersonal Space",
			"Fallen Pillar",
			"Motion Tabled",
			"Outrageous Fortune",
			"Pyrrhic and Proud",
			"Wiggling Bait",
			"Shoot for Loot",
			"Tone Deaf Siren",
			"The Worst Thing",
			"Violence-Liker",
			"Illegal Repercussions",
			"Shameless Plagiarist",
			"Dove & Crow",
			"Barnacle Jim",
			"Charles in Charge",
			"Strange Aeons",
			"Red Queen"
			)
	/*
	destination_names = list(
			)
	*/

/datum/lore/organization/other/uekatish
	name = "Ue-Katish Pirates"
	short_name = ""
	acronym = "UEK"
	desc = "Contrasting with the Qerr-Glia is a vibrant community of Ue-Katish pirates, who live in cargo flotillas on the edge of Skrellian space \
	(especially on the Human-Skrell border). Ue-Katish ships have no caste system even for the truecaste Skrell and aliens who live there, although they are regimented \
	by rank and role in the ship's functioning. Ue-Katish ships are floating black markets where everything is available for the right price, including some of the galaxy's \
	most well-connected information brokers and most skilled guns-for-hire. The Ue-Katish present the greatest Skrellian counterculture and feature heavily in romanticized \
	human media, although at their hearts they are still bandits and criminals, and the black markets are filled with goods plundered from human and Skrellian trade ships. \
	Many of the Ue-Katish ships themselves bear the scars of the battle that brought them under the pirate flag.\
	<br><br> \
	Ue-Katish pirate culture is somewhat similar to many human countercultures, gleefully reclaiming slurs and subverting expectations for the sheer shock value. \
	Nonetheless, Ue-Katish are still Skrell, and still organize in neat hierarchies under each ship's Captain. The Captain's word is absolute, and unlike the Qerr-Katish \
	they lack any sort of anti-corruption institutions."
	history = ""
	work = ""
	motto = ""
	autogenerate_destination_names = TRUE

	org_type = "pirate"

	ship_prefixes = list("Ue-Katish pirate" = "a raiding", "Ue-Katish bandit" = "a raiding", "Ue-Katish raider" = "a raiding", "Ue-Katish enforcer" = "an enforcement", "Ue-Katish corsair" = "a raiding")
	ship_names = list(
			"Keqxuer'xeu's Prize",
			"Xaeker'qux' Bounty",
			"Teq'ker'qerr's Mercy",
			"Ke'teq's Thunder",
			"Xumxerr's Compass",
			"Xue'qux' Greed",
			"Xaexuer's Slave",
			"Xue'taq's Dagger",
			"Teqxae's Madness",
			"Taeqtaq'kea's Pride",
			"Keqxae'xeu's Saber",
			"Xueaeq's Disgrace",
			"Xum'taq'qux' Star",
			"Ke'xae'xe's Scream",
			"Keq'keax' Blade"
			)

/datum/lore/organization/other/marauders
	name = "Vox Marauders"
	short_name = "" //whitespace hack again
	acronym = "VOX"
	desc = "Whilst rarely as directly threatening as 'common' pirates, the phoron-breathing vox nevertheless pose a constant nuisance for shipping; as far as vox are concerned, \
	only vox and vox matters matter, and everyone else is a 'treeless dusthuffer'. Unlike sometimes over-confident pirates, the vox rarely engage in direct, open combat, \
	preferring to make their profits by either stealth or gunboat diplomacy that tends to be more bluster than true brute force: vox raiders will only commit to an attack if \
	they're confident that they can quickly overwhelm and subdue their victims, then get away with the spoils before any reinforcements can arrive.\
	<br><br>\
	As Vox ship names are generally impossible for the vast majority of other species to pronounce, System Defense tends to tag marauders with a designation based on the \
	ancient NATO Phonetic Alphabet."
	history = "Unknown"
	work = "Looting and raiding"
	headquarters = "Nowhere"
	motto = "(unintelligible screeching)"
	autogenerate_destination_names = TRUE //the events we get called for don't fire a destination, but we need *some* entries to avoid runtimes.

	org_type = "pirate"

	ship_prefixes = list("vox marauder" = "a marauding", "vox raider" = "a raiding", "vox ravager" = "a raiding", "vox corsair" = "a raiding") //as assigned by control, second part shouldn't even come up
	//blank out our shipnames for redesignation
	ship_names = list(
			)
	/*
	destination_names = list(
			)
	*/

/datum/lore/organization/other/marauders/New()
	..()
	var/i = 20 //give us twenty random names, marauders get tactical designations from SDF
	var/list/letters = list(
			"Alpha",
			"Bravo",
			"Charlie",
			"Delta",
			"Echo",
			"Foxtrot",
			"Golf",
			"Hotel",
			"India",
			"Juliett",
			"Kilo",
			"Lima",
			"Mike",
			"November",
			"Oscar",
			"Papa",
			"Quebec",
			"Romeo",
			"Sierra",
			"Tango",
			"Uniform",
			"Victor",
			"Whiskey",
			"X-Ray",
			"Yankee",
			"Zulu"
			)
	var/list/numbers = list(
			"Zero",
			"One",
			"Two",
			"Three",
			"Four",
			"Five",
			"Six",
			"Seven",
			"Eight",
			"Nine"
			)
	while(i)
		ship_names.Add("[pick(letters)]-[pick(numbers)]")
		i--

// Governments

/datum/lore/organization/gov/theorionconfederation
	name = "Orion Confederation"
	short_name = "OriCon "
	acronym = "TOC"
	desc = "The Orion Confederation is a decentralized confederation of human governmental entities based on Luna, Sol, which defines top-level law for their member states. \
	Member states receive various benefits such as defensive pacts, trade agreements, social support and funding, and being able to participate in the Colonial Assembly. \
	The majority, but not all human territories are members of The Orion Confederation.  As such, The Orion Confederation is a major power and defacto represents humanity \
	on the galactic stage. Military flight operations fall under the banner of the JSDF."
	history = "" // Todo
	work = "governing polity of humanity's Confederation"
	headquarters = "Luna, Sol"
	motto = "Nil Mortalibus Ardui Est" // Latin, because latin.  Says 'Nothing is too steep for mortals'
	autogenerate_destination_names = TRUE

	org_type = "government"

	ship_prefixes = list("TOC-A" = "an administrative", "TOC-T" = "a transportation", "TOC-D" = "a diplomatic", "TOC-F" = "a freight", "TOC-J" = "a prisoner transfer")
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
			"a Confederation embassy",
			"a classified location"
			)
			// autogen will add a lot of other places as well.

/datum/lore/organization/gov/teshari
	name = "Teshari Expeditionary Fleet"
	short_name = "Teshari Expeditionary "
	acronym = "TEF"
	desc = "Though nominally a client state of the skrell, the teshari nevertheless maintain their own navy in the form of the Teshari Expeditionary Fleet. \
	The TEF are as much civil and combat engineers as a competent space force, as they are the tip of the spear when it comes to locating and surveying new worlds \
	suitable for teshari habitation, and in the establishment of full colonies. That isn't to say there aren't independent teshari colonies out there, but those that \
	are founded under the wings of the TEF tend to be the largest and most prosperous. They're also responsible for maintaining the security of these colonies and \
	protecting trade ships. Like the JSDF (and unlike most other governmental fleets), TEF vessels almost universally sport the 'TEF' designator rather than specific terms. \
	<br><br> The TEF's ships are named after famous teshari pioneers and explorers and the events surrounding those individuals."
	history = ""
	work = "teshari colonization and infrastructure maintenance"
	headquarters = "Qerr'balak, Qerr'valis"
	motto = ""
	autogenerate_destination_names = TRUE //big list of own holdings to come

	org_type = "government"

	//the tesh expeditionary fleet's closest analogue in modern terms would be the US Army Corps of Engineers, just with added combat personnel as well
	ship_prefixes = list("TEF" = "a diplomatic", "TEF" = "a peacekeeping", "TEF" = "an escort", "TEF" = "an exploration", "TEF" = "a survey", "TEF" = "an expeditionary", "TEF" = "a pioneering")
	//TODO: better ship names? I just took a bunch of random teshnames from the Random Name button and added a word.
	ship_names = list(
			"Leniri's Hope",
			"Tatani's Venture",
			"Ninai's Voyage",
			"Miiescha's Claw",
			"Ishena's Talons",
			"Lili's Fang",
			"Taalische's Wing",
			"Cami's Pride",
			"Schemisa's Glory",
			"Shilirashi's Wit",
			"Sanene's Insight",
			"Aeimi's Wisdom",
			"Ischica's Mind",
			"Recite's Cry",
			"Leseca's Howl",
			"Iisi's Fury",
			"Simascha's Revenge",
			"Lisascheca's Vengeance"
			)
	destination_names = list(
			"an Expeditionary Fleet RV point",
			"an Expeditionary Fleet Resupply Ship",
			"an Expeditionary Fleet Supply Depot",
			"a newly-founded Teshari colony",
			"a prospective Teshari colony site",
			"a potential Teshari colony site",
			"Expeditionary Fleet HQ"
			)

// Military
// Used for Para-Military groups right now! Pair of placeholder-ish PMCs.

/datum/lore/organization/mil/jsdf
	name = "Joint System Defense Force"
	short_name = "" //Doesn't cause whitespace any more, with a little sneaky low-effort workaround
	acronym = "JSDF"
	desc = "The JSDF is the dedicated military force of The Orion Confederation, originally formed by the United Nations. It is the dominant superpower of the Orion Spur, \
	and is able to project its influence well into parts of the Perseus and Sagittarius arms of the galaxy. However, regions beyond that are too far for the JSDF to be a \
	major player."
	history = ""
	work = "peacekeeping and piracy suppression"
	headquarters = "Paris, Earth"
	motto = "Si Vis Pacem Para Bellum"
	autogenerate_destination_names = TRUE

	org_type = "military"

	ship_prefixes = list ("JSDF" = "a logistical", "JSDF" = "a training", "JSDF" = "a patrol", "JSDF" = "a piracy suppression", "JSDF" = "a peacekeeping", "JSDF" = "a relief", "JSDF" = "an escort", "JSDF" = "a search and rescue", "JSDF" = "a classified")
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
			"Styx"
			)
	destination_names = list(
			"JSDF HQ",
			"a JSDF staging facility on the edge of The Orion Confederation territory",
			"a JSDF resupply depot",
			"a JSDF shipyard in Sol",
			"a classified location"
			)

/datum/lore/organization/mil/pcrc
	name = "Proxima Centauri Risk Control"
	short_name = "Proxima Centauri "
	acronym = "PCRC"
	desc = "Not a whole lot is known about the private security company known as PCRC, but it is known that they're irregularly contracted by the larger TSCs for certain \
	delicate matters. Much of the company's inner workings are shrouded in mystery, and most citizens have never even heard of them."
	history = ""
	work = "risk control and private security"
	headquarters = "Proxima Centauri"
	motto = ""
	autogenerate_destination_names = TRUE

	org_type = "military"

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
			"Sergeant"
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
	desc = "HIVE Security is a merging of several much smaller freelance companies, and operates throughout civilized space. Unlike some companies, it operates no planetside \
	facilities whatsoever, opting instead for larger flotillas that are serviced by innumerable smallcraft. As with any PMC there's no small amount of controversy surrounding \
	them, but they try to keep their operations cleaner than their competitors. They're fairly well known for running 'mercy' operations, which are low-cost no-strings-attached \
	contracts for those in dire need."
	history = ""
	work = "mercenary contractors"
	headquarters = ""
	motto = "Strength in Numbers"
	autogenerate_destination_names = TRUE

	org_type = "military"

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
			"the HIVE Command fleet",
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
	desc = "Shrouded in mystery and controversy, Blackstar Legion is said to have its roots in pre-FTL Sol private military contractors. Their reputation means that most \
	upstanding corporations and governments are hesitant to call upon them, whilst their prices put them out of the reach of most private individuals. As a result, they're \
	mostly seen as the hired thugs of frontier governments that don't (or won't) answer to The Orion Confederation."
	history = ""
	work = "mercenary contractors"
	headquarters = ""
	motto = "Neca Ne Necaris"
	autogenerate_destination_names = TRUE

	org_type = "military"

	ship_prefixes = list("BSF" = "a secure freight", "BST" = "a training", "BSS" = "a logistics", "BSV" = "a patrol", "BSH" = "a security", "BSX" = "an experimental", "BSC" = "a command", "BSK" = "a classified")
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
			SPECIES_GOLEM,
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

/datum/lore/organization/other/pmd
	name = "Paracausal Monitoring Division"
	short_name = ""
	acronym = "PMD"
	desc = "A formerly defunct wing of Central Command, the recent resurgence of supernatural activity in the galaxy has necessitated the return of the Paracausal Monitoring \
	Divison. Unlike their cousins, the DDO, the PMD is a formally recognized member of the CentCom organizational structure. However, the vast majority of PMD operations are \
	considered classified. Spotting local PMD vessels in transit is considered a bad omen, as they are likely laden with anomalous cargo, or en route to collect more. \
	It is always hoped that they pass your destination by."
	history = ""
	work = "supernatural suppression"
	headquarters = "PMD Austerlitz, Dark Frontier"
	motto = "Many Eyes, One Vision"
	autogenerate_destination_names = TRUE

	ship_prefixes = list ("PMD" = "an observation", "PDP" = "a patrol", "PDE" = "an escort", "PDC" = "a containment", "PDR" = "a response", "PDL" = "a logistics", "PDF" = "a freight", "PDJ" = "a prisoner transport")
	flight_types = list(
			"flight",
			"mission",
			"response",
			"operation",
			"interception"
			)
	//ship names: Freeform, inspired by phrases or names in music.
	ship_names = list(
			"Wicked Dickie",
			"Naughty Nanny",
			"Miriam's Alibi",
			"Quitter's Halo",
			"Darkened Dancer",
			"Mayor's Income",
			"Mischevious Angel",
			"Argent Martian",
			"Dancing Pig",
			"A Light Extinguished",
			"Jesse's Dynamite",
			"Oceans of Time",
			"Olde Headboard",
			"Fletcher Christian",
			"Forgetful Kennedy",
			"Bloody Laredo",
			"Cornerhouse Jacknife",
			"Sign of the Cross",
			"Der Kommissar",
			"Room of Chain and Glass",
			"Carol's Last Ride",
			"Scattered Like Crows",
			"Where The Black Stars Hang",
			"Dreams of Being Snow",
			"Yours Truly, The Whale",
			"Sigh Hawaii",
			"Half Day Closing",
			"Renholder's Opus",
			"Tannhauser Bow",
			"Silver Lake",
			"Mozambique Vampire",
			"Edith's Checkerspot Butterfly",
			"A Retinue of Moons"
			)
	destination_names = list(
			"unidentified sensor reading",
			"PMD Pitcairn",
			"a PMD containment facility",
			"a PMD research center",
			"active distress signal",
			"an active incident site"
			)

//Cheeses
/datum/lore/organization/gov/naramadi_ascendancy
    name = "The Naramadi Ascendancy"
    short_name = "Naramadi Ascendancy"
    acronym = "NA"
    desc = "The Naramadi Ascendancy is a member-state of the Moghes Hegemony, though operating largely independant in matters of diplomacy and Trade, often sending Traders and Diplomats out to establish relations."
    history = ""
    work = "trade and diplmacy"
    headquarters = "Verkihar Minor"
    motto = ""
    org_type = "government"

    ship_prefixes = list("NA-DV" = "a diplomatic", "NA-RV" = "a quick response", "NA-TV" = "a trade", "NA-CV" = "a cargo", "NA-HV" = "a hunting")
    ship_names = list(
            "Seat of Power",
            "Tools of Trade",
            "Knowledge of Elders",
            "Return what is taken",
            "High and Mighty",
            "Moral High Ground",
            "Voice that speaks",
            "Map that guides",
            "Hand that strikes",
            "Hand that feeds",
            "Of Artificers aplenty",
            )
    destination_names = list(
            "the Moghes Hegemony",
            "the Vikara Combine",
            "Verkihar Major",
            "Onkhera Synthetic Solutions production site",
            "a distress beacon"
            )
