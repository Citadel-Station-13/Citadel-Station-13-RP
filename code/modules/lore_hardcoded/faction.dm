/datum/lore/character_background/faction
	abstract_type = /datum/lore/character_background/faction
	/// station job types you can play as under this - **typepaths** e.g. /datum/job/station/security_officer, etc
	/// if null, you can play as everything
	var/list/job_whitelist = list()
	/// job blacklist
	var/list/job_blacklist
	/// where 'desc' is the corporation description, this is what a player should know if they're a contractor
	var/contractor_info
	/// list of origins that can select this
	/// if null, all can select
	var/list/origin_whitelist
	/// list of citizenships that can select this
	/// if null, all can select
	var/list/citizenship_whitelist

/datum/lore/character_background/faction/New()
	// job whitelist cache
	for(var/i in job_whitelist)
		job_whitelist[i] = TRUE
	return ..()

/datum/lore/character_background/faction/check_character_species(datum/character_species/S)
	if(S.species_fluff_flags & SPECIES_FLUFF_PICKY_FACTION)
		. = (S.uid in allow_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in allow_species))
		if(!.)
			return
	return ..()

/datum/lore/character_background/faction/proc/check_job_id(id)
	if(job_blacklist && job_blacklist[id])
		return FALSE
	return job_whitelist? (job_whitelist[id]) : TRUE

/datum/lore/character_background/faction/nanotrasen
	name = "Nanotrasen"
	id = "nanotrasen"
	desc = "Formally established in 2274, NanoTrasen is one of the foremost research and development companies in the galaxy. \
	Originally focused on logistics and consumer product manufacturing, their swift move into the field of Phoron has lead to \
	them becoming the foremost experts on the substance and its uses. In the modern day, NanoTrasen prides \
	itself on being an early adopter to as many new technologies as possible, often offering the newest \
	products to their employees. In an effort to combat complaints about being 'guinea pigs', Nanotrasen \
	also offers one of the most comprehensive medical plans in Frontier space, up to and including cloning, \
	dedicated resleeving, mirror maintenance, and therapy.\
	<br><br>\
	NT's most well known products are its phoron based creations; especially those used in Cryotherapy. \
	It also boasts an prosthetic line, which is provided to its employees as needed, and is used as an incentive \
	for newly tested posibrains to remain with the company. NanoTrasen's corporate headquarters is based out of \
	the NTS Creon in the privateyl owned Thebes system."
	contractor_info = "You are an employee working for NanoTrasen. You are not a contractor, <i>you belong here.</i>"
	job_whitelist = null
	job_blacklist = list(JOB_ID_TRADER)

/datum/lore/character_background/faction/aether
	name = "Aether Atmos & Recycling"
	id = "aether"
	desc = "Aether Atmospherics and Recycling is the prime maintainer and provider of atmospherics systems to both the many ships that navigate the \
	vast expanses of space, and the life support on current and future Human colonies. The byproducts from the filtration of atmospheres across the galaxy \
	are then resold for a variety of uses to those willing to buy. With the nature of their services, most work they do is contracted for the construction of \
	these systems, or staffing to maintain them for colonies across human space. Recently, Aether executed a shockingly effective set of hostile acquisitions, \
	purchasing Focal Point Energistics and the Xion Manufacturing Group."
	contractor_info = "You're used to being contracted out to maintain systems for other corporations. This assignment is probably routine to you."
	job_whitelist = list(
		JOB_ID_QUARTERMASTER,
		JOB_ID_CARGO_TECHNICIAN,
		JOB_ID_STATION_ENGINEER,
		JOB_ID_ATMOSPHERIC_TECHNICIAN,
		JOB_ID_BOTANIST,
		JOB_ID_JANITOR,
		JOB_ID_ASSISTANT,
		JOB_ID_OFFDUTY_CIVILLIAN,
		JOB_ID_OFFDUTY_CARGO,
		JOB_ID_OFFDUTY_ENGINEER
		)

/datum/lore/character_background/faction/centauri
	name = "Centauri Provisions"
	id = "centauri"
	desc = "Headquartered in Alpha Centauri, Centauri Provisions made a name in the snack-food industry primarily by being the first to focus on colonial holdings. \
	The various brands of Centauri snackfoods are now household names, from SkrellSnax and Space Mountain Wind to the ubiquitous and allegedly edible Bread Tube. \
	They are well known for targeting as many species as possible with each brand - which, some will argue, is due to some of those brands being rather bland \
	in taste and texture. Their staying power is legendary, and many spacers have grown up on a mix of their cheap snacks and protein shakes."
	contractor_info = "Although the occasional marketing trip isn't unheard of, it's meant to be rare. It may seem strange to be assigned to a different Corporate outpost, but it's a good marketing opportunity regardless, and the bosses are watching!"
	job_whitelist = list(
		JOB_ID_QUARTERMASTER,
		JOB_ID_CARGO_TECHNICIAN,
		JOB_ID_BARTENDER,
		JOB_ID_BOTANIST,
		JOB_ID_CHEF,
		JOB_ID_JANITOR,
		JOB_ID_ENTERTAINER,
		JOB_ID_ASSISTANT,
		JOB_ID_CLOWN,
		JOB_ID_MIME,
		JOB_ID_OFFDUTY_CIVILLIAN,
		JOB_ID_OFFDUTY_CARGO
		)

/datum/lore/character_background/faction/freetradeunion
	name = "Free Trade Union"
	id = "ftu"
	desc = "The Free Trade Union is different from other tran-stellars in that they are not just a company, but also a large conglomerate \
	of various traders and merchants from across the galaxy. They control a sizable fleet of vessels of various classes, all of which maintain autonomy \
	from the centralized FTU to engage in free trade. They also host a fleet of combat vessels responsible for defending traders when necessary. They \
	control many large scale trade stations across the galaxy - even in non-human space. Generally, their multi-purpose stations keep local sectors \
	filled with duty-free shops and wares. Almost anything is sold at FTU markets, including products that are forbidden or have insanely high taxes in \
	government or Corporate space. The FTU are the originators of the Tradeband language, created specially to serve as the lingua franca for Merchants \
	across the Galaxy, to ensure members may understand each other regardless of native language or nationality."
	contractor_info = "Working under a Corporation feels strange. You're used to exercising your autonomy, or perhaps you're used to the more strict maritime environment of your former vessel. Being surrounded by Corporate employees reminds you of why you're with the FTU."
	job_whitelist = list(
		JOB_ID_QUARTERMASTER,
		JOB_ID_CARGO_TECHNICIAN,
		JOB_ID_PATHFINDER,
		JOB_ID_EXPLORER,
		JOB_ID_FIELD_MEDIC,
		JOB_ID_STATION_ENGINEER,
		JOB_ID_PARAMEDIC,
		JOB_ID_PILOT,
		JOB_ID_BOTANIST,
		JOB_ID_CHEF,
		JOB_ID_JANITOR,
		JOB_ID_ENTERTAINER,
		JOB_ID_ASSISTANT,
		JOB_ID_CLOWN,
		JOB_ID_MIME,
		JOB_ID_OFFDUTY_CIVILLIAN,
		JOB_ID_OFFDUTY_EXPLORER,
		JOB_ID_OFFDUTY_MEDBAY,
		JOB_ID_OFFDUTY_CARGO,
		JOB_ID_OFFDUTY_ENGINEER,
		JOB_ID_TRADER
		)
	innate_languages = list(
		/datum/language/trader
		)

/datum/lore/character_background/faction/gilthari
	name = "Gilthari Exports"
	id = "gilthari"
	desc = "Gilthari started as Sol's premier supplier of luxury goods, specializing in extracting money from the rich and successful that weren't already shareholders. \
	Their largest holdings are in gambling, but they maintain subsidiaries in everything from VR equipment to luxury watches. Their holdings in \
	mass media are a smaller but still important part of their empire. Gilthari is known for treating its positronic employees very well, sparking a number of \
	conspiracy theories. The gorgeous FBP model that Gilthari provides them is a symbol of the corporation's wealth and is known to reach ludicrous prices when \
	available on the black market, with legal ownership of the chassis limited, by contract, to employees."
	contractor_info = "The drab atmosphere of this assignment is frustrating. Hardly any thought is put into how the environment might be made more elegant and pleasing to the senses. On the bright side, Corporate employees tend to have plenty of disposable income."
	job_whitelist = list(
		JOB_ID_QUARTERMASTER,
		JOB_ID_CARGO_TECHNICIAN,
		JOB_ID_SHAFT_MINER,
		JOB_ID_PATHFINDER,
		JOB_ID_EXPLORER,
		JOB_ID_BARTENDER,
		JOB_ID_CHEF,
		JOB_ID_ENTERTAINER,
		JOB_ID_CHAPLAIN,
		JOB_ID_LIBRARIAN,
		JOB_ID_ASSISTANT,
		JOB_ID_OFFDUTY_CIVILLIAN,
		JOB_ID_OFFDUTY_EXPLORER,
		JOB_ID_OFFDUTY_CARGO
		)

/datum/lore/character_background/faction/hephaestus
	name = "Hephaestus Industries"
	id = "hephaestus"
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles on the Frontier. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a notable trade and research pact \
	with NanoTrasen. They otherwise enforce pacts and trade arrangements with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. The Orion Confederation itself is one of Hephaestus' largest \
	non-corporate bulk contractors."
	contractor_info = "NanoTrasen and Hephaestus have a long and beneficial working relationship. Your employers would not like it if you strained that relationship in any way, and therefore, neither would you."
	job_whitelist = list(
		JOB_ID_QUARTERMASTER,
		JOB_ID_CARGO_TECHNICIAN,
		JOB_ID_SHAFT_MINER,
		JOB_ID_STATION_ENGINEER,
		JOB_ID_ATMOSPHERIC_TECHNICIAN,
		JOB_ID_ASSISTANT,
		JOB_ID_OFFDUTY_CIVILLIAN,
		JOB_ID_OFFDUTY_CARGO,
		JOB_ID_OFFDUTY_ENGINEER
		)

/datum/lore/character_background/faction/oculum
	name = "Oculum News Network"
	id = "oculum"
	desc = "Oculum owns approximately 30% of Frontier-wide news networks, including microblogging aggregate sites, network and comedy news, and even \
	old-fashioned newspapers. Staunchly apolitical, they specialize in delivering the most popular news available - which means telling people what they \
	already want to hear. Oculum is a specialist in branding, and most people don't know that the reactionary Daedalus Dispatch newsletter and the radically \
	transhuman Liquid Steel webcrawler are in fact both controlled by the same organization."
	contractor_info = "You're no stranger to working in a variety of Corporate environments. However you conduct your business, you're always chasing the story, even if that brings you into conflict with whoever's contracting you at the time."
	job_whitelist = list(
		JOB_ID_BARTENDER,
		JOB_ID_ENTERTAINER,
		JOB_ID_LIBRARIAN,
		JOB_ID_ASSISTANT,
		JOB_ID_OFFDUTY_CIVILLIAN
		)

/datum/lore/character_background/faction/veymed
	name = "Vey-Med"
	id = "veymed"
	desc = "Vey-Med is a medical supply and research company notable for being largely owned and opperated by Skrell. \
	Despite their alien origin, Vey-Med has obtained market dominance on the Frontier due to the quality and reliability \
	of their medical equipment - from surgical tools and industrial medical devices to the Oddyseus trauma response mecha \
	and everything in between. Their equipment tends to be top-of-the-line, most obviously shown by their incredibly \
	human-like FBP designs. Vey's rise to stardom came from their introduction of cosmetic resleeving, although in \
	recent years they've been forced to diversify as their patents expired and NanoTrasen-made medications became \
	essential to modern sleeving techniques. Vey-Medical possesses a number of trade agreements and research pacts with NanoTrasen, \
	resulting in what is functionally considered an alliance."
	contractor_info = "Working with NanoTrasen has become a fact of life for Vey-Med employees over the years. You're no stranger to these types of environments, although you have seen better medical facilities before."
	job_whitelist = list(
		JOB_ID_FIELD_MEDIC,
		JOB_ID_MEDICAL_DOCTOR,
		JOB_ID_PARAMEDIC,
		JOB_ID_CHEMIST,
		JOB_ID_PSYCHIATRIST,
		JOB_ID_PILOT,
		JOB_ID_ASSISTANT,
		JOB_ID_OFFDUTY_CIVILLIAN,
		JOB_ID_OFFDUTY_EXPLORER,
		JOB_ID_OFFDUTY_MEDBAY
		)

/datum/lore/character_background/faction/wardtakahashi
	name = "Ward-Takahashi"
	id = "wardtakashi"
	desc = "Ward-Takahashi focuses on the sale of small consumer electronics, with its computers, communicators, \
	and mid-class automobiles a fixture of many households. Less famously, Ward-Takahashi also supplies most \
	of the AI cores on which vital control systems are mounted, and it is this branch of their industry that has \
	led to their tertiary interest in the development and sale of high-grade AI systems. Ward-Takahashi's economies \
	of scale frequently steal market share from Nanotrasen's high-price products, leading to a bitter rivalry in the \
	consumer electronics market."
	contractor_info = "Being allowed to work on a NanoTrasen facility is atypical. In fact, being employed here at all has made you suspicious. You're probably being watched. But Headquarters would love to hear about anything strange that you find."
	job_whitelist = list(
		JOB_ID_QUARTERMASTER,
		JOB_ID_CARGO_TECHNICIAN,
		JOB_ID_SHAFT_MINER,
		JOB_ID_STATION_ENGINEER,
		JOB_ID_ATMOSPHERIC_TECHNICIAN,
		JOB_ID_JANITOR,
		JOB_ID_ASSISTANT,
		JOB_ID_OFFDUTY_CIVILLIAN,,
		JOB_ID_OFFDUTY_CARGO,
		JOB_ID_OFFDUTY_ENGINEER
		)

/datum/lore/character_background/faction/zenghu
	name = "Zeng-Hu Pharmaceuticals"
	id = "zenghu"
	desc = "Zeng-Hu is an old corporation, based close to Confederation space. Until the discovery of Phoron, Zeng-Hu maintained a stranglehold \
	on the market for medications, and many household names are patentted by Zeng-Hu-- Bicaridine, Dylovene, Tricordrizine, \
	and Dexalin all came from a Zeng-Hu medical laboratory. Zeng-Hu's fortunes have been in decline as Nanotrasen's near monopoly \
	on phoron research cut into their R&D capabilities and Vey-Med's superior medical equipment effectively decimated their own equipment \
	interests. The three-way rivalry between these companies for dominance in the medical field is well-known and a matter of \
	constant economic speculation."
	contractor_info = "You dislike working under NanoTrasen. Zeng Hu saw fit to assign you to this post as part of a work exchange program. Although you were not explicitly told, you are presumably here to keep an eye on NanoTrasen's medical research."
	job_whitelist = list(
		JOB_ID_FIELD_MEDIC,
		JOB_ID_MEDICAL_DOCTOR,
		JOB_ID_PARAMEDIC,
		JOB_ID_CHEMIST,
		JOB_ID_PSYCHIATRIST,
		JOB_ID_BOTANIST,
		JOB_ID_ASSISTANT,
		JOB_ID_OFFDUTY_CIVILLIAN,
		JOB_ID_OFFDUTY_EXPLORER,
		JOB_ID_OFFDUTY_MEDBAY
		)

/datum/lore/character_background/faction/naramadiguilds
	name = "Naramadi Guilds"
	id = "narguild"
	desc = "Within the Naramadi Ascendancy, every piece of land, equipment and technology is owned by either a House or a person. \
	To work around issues attached to repairing important infrastructure, and to upkeep the Ascendancy as a whole, a set of guilds \
	was created right after the unification of Naramadi People. \
	Offering both education and work, the guilds do not encompass the all possible fields of work; however offering education and experience \
	in the more practical fields. An example being various Engineering fields. The three Guilds currently operating within the ascendancy are: \
	Artificers, Logistici and Legionnarum"
	contractor_info = "Your presence here is both a curse and a blessing for the Guild. Being contracted to work for a Human megacorporation presents various opportunities to learn technology unavalible in the Ascendancy."
	job_whitelist = list(
		JOB_ID_STATION_ENGINEER,
		JOB_ID_ATMOSPHERIC_TECHNICIAN,
		JOB_ID_SENIOR_ENGINEER,
		JOB_ID_CARGO_TECHNICIAN,
		JOB_ID_SHAFT_MINER,
		JOB_ID_QUARTERMASTER,
		JOB_ID_ROBOTICIST,
		JOB_ID_OFFDUTY_CARGO,
		JOB_ID_OFFDUTY_ENGINEER,
		JOB_ID_OFFDUTY_SCIENCE
		)
	origin_whitelist = list(
		"naramadihouses",
		"nameless"
	)

/datum/lore/character_background/faction/onkhera_necropolis
	name = "Onkhera Synthetics & Necropolis"
	id = "oss_necro"
	desc = "Onkhera Synthetic Solutions, and by extension it's subsidiary Necropolis Industries, is one of the few \
	Megacorporations not originating within the Confederacy; instead being owned by a Naramadi House - House Onkhera. \
	While the parent company Onkhera Synthetic Solutions focuses on the civilian market, providing high quality prosthetics to non-humans, \
	- becoming the direct rival of Vey-Med in the process - Necropolis Industries focuses on the Security and Military markets, providing \
	Security services to anybody willing to pay. The Company exports both biological and synthetic augumentations to various Megacorporations found \
	across the frontier."
	contractor_info = "Neutrality of Onkhera Synthetic Solutions and Necropolis Industries has it's benefits, as You often get contracted with various corporations across the frontier. For you, this is just another assignement."
	job_whitelist = list(
		JOB_ID_FIELD_MEDIC,
		JOB_ID_MEDICAL_DOCTOR,
		JOB_ID_HEAD_NURSE,
		JOB_ID_PARAMEDIC,
		JOB_ID_CHEMIST,
		JOB_ID_ROBOTICIST,
		JOB_ID_SCIENTIST,
		JOB_ID_SENIOR_RESEARCHER,
		JOB_ID_OFFDUTY_MEDBAY,
		JOB_ID_OFFDUTY_SCIENCE
		)

/datum/lore/character_background/faction/xam
	name = "Xsysorr Arms and Materiel"
	id = "xam"
	desc = "Xsysorr Arms and Material, also known as XAM. The only true Unathi Megacorporation, and a dealer in heavy equipment. They have cool \
	relations with other Megacorporations, especially those owned and operated by humans. Their exports are limited primarily to industrial equipment and \
	mining gear, along with weapons too cumbersome to use."
	contractor_info = "You've been contracted as part of your obligations. Respect your role until you are disrespected."
	job_whitelist = list(
		JOB_ID_QUARTERMASTER,
		JOB_ID_CARGO_TECHNICIAN,
		JOB_ID_SHAFT_MINER,
		JOB_ID_OFFDUTY_CARGO
		)

/datum/lore/character_background/faction/zaddatguild
	name = "Zaddat Guild"
	id = "zaddatguild"
	desc = "A collection of insular specialists in a given craft. Most well-known are the Engineers, yet there exists a Guild for most technical \
	skills. Often they have their skills contracted out for a period of time for the better interest of their Colony."
	contractor_info = "You are a member from one of the famed Zaddat Guilds, here by agreement of the Colony. Your skill in your field is peerless, and you should not allow anyone to say otherwise. You should not prove otherwise."
	job_whitelist = list(
		JOB_ID_QUARTERMASTER,
		JOB_ID_CARGO_TECHNICIAN,
		JOB_ID_SHAFT_MINER,
		JOB_ID_SENIOR_RESEARCHER,
		JOB_ID_SCIENTIST,
		JOB_ID_ROBOTICIST,
		JOB_ID_PATHFINDER,
		JOB_ID_EXPLORER,
		JOB_ID_FIELD_MEDIC,
		JOB_ID_SENIOR_ENGINEER,
		JOB_ID_STATION_ENGINEER,
		JOB_ID_ATMOSPHERIC_TECHNICIAN,
		JOB_ID_HEAD_NURSE,
		JOB_ID_MEDICAL_DOCTOR,
		JOB_ID_PARAMEDIC,
		JOB_ID_CHEMIST,
		JOB_ID_PSYCHIATRIST,
		JOB_ID_PILOT,
		JOB_ID_BARTENDER,
		JOB_ID_BOTANIST,
		JOB_ID_CHEF,
		JOB_ID_JANITOR,
		JOB_ID_ENTERTAINER,
		JOB_ID_CHAPLAIN,
		JOB_ID_LIBRARIAN,
		JOB_ID_ASSISTANT,
		JOB_ID_OFFDUTY_CIVILLIAN,
		JOB_ID_OFFDUTY_EXPLORER,
		JOB_ID_OFFDUTY_MEDBAY,
		JOB_ID_OFFDUTY_CARGO,
		JOB_ID_OFFDUTY_ENGINEER,
		JOB_ID_OFFDUTY_SCIENCE
		)
