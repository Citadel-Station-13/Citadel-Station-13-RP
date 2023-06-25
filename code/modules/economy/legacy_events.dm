
/datum/event/economic_event
	endWhen = 50			//this will be set randomly, later
	announceWhen = 15
	var/event_type = 0
	var/list/cheaper_goods = list()
	var/list/dearer_goods = list()
	var/datum/trade_destination/affected_dest

/datum/event/economic_event/start()
	affected_dest = pickweight(weighted_randomevent_locations)
	if(affected_dest.viable_random_events.len)
		endWhen = rand(60,300)
		event_type = pick(affected_dest.viable_random_events)

		if(!event_type)
			return

		switch(event_type)
			if(RIOTS)
				dearer_goods = list(SECURITY)
				cheaper_goods = list(MINERALS, FOOD)
			if(WILD_ANIMAL_ATTACK)
				cheaper_goods = list(ANIMALS)
				dearer_goods = list(FOOD, BIOMEDICAL)
			if(INDUSTRIAL_ACCIDENT)
				dearer_goods = list(EMERGENCY, BIOMEDICAL, ROBOTICS)
			if(BIOHAZARD_OUTBREAK)
				dearer_goods = list(BIOMEDICAL, GAS)
			if(PIRATES)
				dearer_goods = list(SECURITY, MINERALS)
			if(CORPORATE_ATTACK)
				dearer_goods = list(SECURITY, MAINTENANCE)
			if(ALIEN_RAIDERS)
				dearer_goods = list(BIOMEDICAL, ANIMALS)
				cheaper_goods = list(GAS, MINERALS)
			if(AI_LIBERATION)
				dearer_goods = list(EMERGENCY, GAS, MAINTENANCE)
			if(MOURNING)
				cheaper_goods = list(MINERALS, MAINTENANCE)
			if(CULT_CELL_REVEALED)
				dearer_goods = list(SECURITY, BIOMEDICAL, MAINTENANCE)
			if(SECURITY_BREACH)
				dearer_goods = list(SECURITY)
			if(ANIMAL_RIGHTS_RAID)
				dearer_goods = list(ANIMALS)
			if(FESTIVAL)
				dearer_goods = list(FOOD, ANIMALS)
		for(var/good_type in dearer_goods)
			affected_dest.temp_price_change[good_type] = rand(1,100)
		for(var/good_type in cheaper_goods)
			affected_dest.temp_price_change[good_type] = rand(1,100) / 100

/datum/event/economic_event/announce()
	var/author = "Oculus v6rev7"
	var/channel = "Oculum Content Aggregator"

	//see if our location has custom event info for this event
	var/body = affected_dest.get_custom_eventstring()
	if(!body)
		switch(event_type)
			if(RIOTS)
				body = "[pick("Riots have","Unrest has")] broken out on planet [affected_dest.name]. Authorities call for calm, as [pick("various parties","rebellious elements","peacekeeping forces","\'REDACTED\'")] begin stockpiling weaponry and armour. Meanwhile, food and mineral prices are dropping as local industries attempt empty their stocks in expectation of looting."
			if(WILD_ANIMAL_ATTACK)
				body = "Local [pick("wildlife","animal life","fauna")] on planet [affected_dest.name] has been increasing in agression and raiding outlying settlements for food. Big game hunters have been called in to help alleviate the problem, but numerous injuries have already occurred."
			if(INDUSTRIAL_ACCIDENT)
				body = "[pick("An industrial accident","A smelting accident","A malfunction","A malfunctioning piece of machinery","Negligent maintenance","A cooleant leak","A ruptured conduit")] at a [pick("factory","installation","power plant","dockyards")] on [affected_dest.name] resulted in severe structural damage and numerous injuries. Repairs are ongoing."
			if(BIOHAZARD_OUTBREAK)
				body = "[pick("A nano-contaminant","A biohazard","An outbreak","A virus")] on [affected_dest.name] has resulted in quarantine, stopping much shipping in the area. Although the quarantine is now lifted, authorities are calling for deliveries of medical supplies to treat the infected, and gas to replace contaminated stocks."
			if(PIRATES)
				body = "[pick("Pirates","Criminal elements","A [pick("mercenary","Nos Amis","Xin Cohong","Ue-Katish")] strike force")] have [pick("raided","blockaded","attempted to blackmail","attacked")] [affected_dest.name] today. Security has been tightened, but many valuable minerals were taken."
			if(CORPORATE_ATTACK)
				body = "A small [pick("pirate","Nation of Mars","Revolutionary Solar People's Party","mercenary")] fleet has precise-jumped into proximity with [affected_dest.name], [pick("for a smash-and-grab operation","in a hit and run attack","in an overt display of hostilities")]. Much damage was done, and security has been tightened since the incident."
			if(ALIEN_RAIDERS)
				if(prob(20))
					body = "Ue-Katish pirates exiled from Ue'Orsi have raided [affected_dest.name] today, no doubt on orders from their enigmatic masters. Stealing wildlife, farm animals, medical research materials and kidnapping civilians. [(LEGACY_MAP_DATUM).company_name] authorities are standing by to counter attempts at bio-terrorism."
				else
					body = "The Vox have raided [affected_dest.name] today, stealing wildlife, farm animals, medical research materials and kidnapping civilians. Fleet assets have moved to reinforce the effected region."
			if(AI_LIBERATION)
				body = "A [pick("malignant webcrawler was detected on","Boiling Point operative infiltrated","malignant computer virus was detected on","rogue [pick("slicer","hacker")] was apprehended on")] [affected_dest.name] today, and managed to infect [pick("an A-class factory monitor","an experimental drone wing","a high-powered financial system","an automated defence installation")] before it could be stopped, causing serious damage. Considerable work must be done to repair the affected areas."
			if(MOURNING)
				body = "[pick("The popular","The well-liked","The eminent","The well-known")] [pick("professor","entertainer","singer","researcher","public servant","administrator","ship captain")], [random_name(pick(MALE,FEMALE))] has [pick("passed away","committed suicide","been murdered","died in a freakish accident")] on [affected_dest.name] today. The entire planet is in mourning, and prices have dropped for industrial goods as worker morale drops."
			if(CULT_CELL_REVEALED)
				body = "A [pick("dastardly","blood-thirsty","villanous","crazed")] doomsday cult has [pick("been discovered","been revealed","revealed themselves","gone public")] on [affected_dest.name] earlier today. Public morale has been shaken due to [pick("certain","several","one or two")] [pick("high-profile","well known","popular")] individuals [pick("performing illegal acts","claiming allegiance to the cult","swearing loyalty to the cult leader","promising to aid to the cult")] before those involved could be brought to justice."
			if(SECURITY_BREACH)
				body = "There was [pick("a security breach in","an unauthorised access in","an attempted theft in","an anarchist attack in","violent sabotage of")] a [pick("high-security","restricted access","classified")] [pick("section","zone","area")] this morning. Security was tightened on [affected_dest.name] after the incident, and the editor reassures all [(LEGACY_MAP_DATUM).company_name] personnel that such lapses are rare."
			if(ANIMAL_RIGHTS_RAID)
				body = "[pick("Militant animal rights activists","Members of the terrorist group Galactic Organization for Animal Rights")] have [pick("launched a campaign of terror","unleashed a swathe of destruction","raided farms and pastures","forced entry to an animal processing plant")] on [affected_dest.name] earlier today, freeing numerous [pick("farm animals","animals")]. Prices for tame and breeding animals have spiked as a result."
			if(FESTIVAL)
				body = "A [pick("festival","week long celebration","day of revelry","planet-wide holiday")] has been declared on [affected_dest.name] by [pick("Governor","Commissioner","General","Commandant","Administrator")] [random_name(pick(MALE,FEMALE))] to celebrate [pick("the birth of their [pick("son","daughter","child")]","coming of age of their [pick("son","daughter","child")]","the pacification of rogue military cell","the apprehension of a violent criminal who had been terrorising the planet")]. Massive stocks of food and meat have been bought driving up prices across the planet."

	news_network.SubmitArticle(body, author, channel, null, 1)

/datum/event/economic_event/end()
	for(var/good_type in dearer_goods)
		affected_dest.temp_price_change[good_type] = 1
	for(var/good_type in cheaper_goods)
		affected_dest.temp_price_change[good_type] = 1


var/list/weighted_randomevent_locations = list()
var/list/weighted_mundaneevent_locations = list()

/datum/trade_destination
	var/name = ""
	var/description = ""
	var/distance = 0
	var/list/willing_to_buy = list()
	var/list/willing_to_sell = list()
	var/can_shuttle_here = 0		//one day crew from the station will be able to travel to this destination
	var/list/viable_random_events = list()
	var/list/temp_price_change[BIOMEDICAL]
	var/list/viable_mundane_events = list()

/datum/trade_destination/proc/get_custom_eventstring(var/event_type)
	return null

//distance is measured in Arbitrary and corelates to travel time, like, I guess
/datum/trade_destination/luna
	name = "Luna"
	description = "The capital world of the Orion Confederatoin, the primary Human government."
	distance = 1.2
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, CORPORATE_ATTACK, AI_LIBERATION)
	viable_mundane_events = list(ELECTION, RESIGNATION, CELEBRITY_DEATH)

/datum/trade_destination/nohio
	name = "New Ohio"
	description = "A world in the Sagitarius Heights, home to Vey-Medical's research and development facilities."
	distance = 1.7
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, CULT_CELL_REVEALED, BIOHAZARD_OUTBREAK, PIRATES, ALIEN_RAIDERS)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH, BARGAINS, GOSSIP)

/datum/trade_destination/sophia
	name = "Sophia"
	description = "The homeworld of the positronics and an extremely important cultural center."
	distance = 0.6
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(INDUSTRIAL_ACCIDENT, PIRATES, CORPORATE_ATTACK)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH)

/datum/trade_destination/jade
	name = "Jade"
	description = "Jade, in the Zhu Que system, is one of the Bowl's garden worlds and home to a major ore processing operation."
	distance = 7.5
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(PIRATES, INDUSTRIAL_ACCIDENT)
	viable_mundane_events = list(TOURISM)

/datum/trade_destination/sif
	name = "Sif"
	description = "A garden world in the Vir system with a developing phoron-based economy."
	distance = 2.3
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	viable_mundane_events = list(BARGAINS, GOSSIP, SONG_DEBUT, MOVIE_RELEASE, ELECTION, TOURISM, RESIGNATION, CELEBRITY_DEATH)

/datum/trade_destination/mars
	name = "Mars"
	description = "A major industrial center in the Sol system."
	distance = 6.6
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	viable_mundane_events = list(ELECTION, TOURISM, RESIGNATION)

/datum/trade_destination/nisp
	name = "Nisp"
	description = "A near-garden world known for its hostile wildlife and its N2O atmosphere."
	distance = 8.9
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)

/datum/trade_destination/abelsrest
	name = "Abel's Rest"
	description = "A garden world on the Hegemony border. Coinhabitated rather uncomfortably by Unathi and Orion settlers."
	distance = 7.5
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)
/datum/event/lore_news
	endWhen = 10

/datum/event/lore_news/announce()
	var/author = "Oculus v6rev7"
	var/channel = "Oculum Content Aggregator"


	//locations by region for later pick()
	//probably would be good to move these to a global somehwere but fuck if I know how to do that
	var/list/rim = list("Shelf", "Vounna", "Relan", "Whythe", "Angessa's Pearl") // this is also the Association list for most purposes
	var/list/crescent = list("Saint Columbia", "Ganesha", "Gavel", "Oasis", "Kess-Gendar") //Vir not included
	var/list/core = list("Sol", "Alpha Centauri", "Tau Ceti", "Altair")
	var/list/heights = list("New Ohio", "Mahi-Mahi", "Parvati", "Sidhe", "New Seoul")
	var/list/bowl = list("Zhu Que", "New Singapore", "Isavau's Gamble", "Love", "Viola", "Stove")
	var/list/crypt = list("El", "Jahan's Post", "Abel's Rest", "Raphael", "Thoth", "Terminus")
	var/list/weird = list("Silk", "Nyx") //no region

	//by government
	var/list/oricon = crescent + core + heights + bowl + crypt + weird
	var/list/skrell = list("Qerr'Vallis", "Qerma-Lakirr", "Harrqak", "Kauq'xum")
	var/list/skrellfar = list("The Far Kingdom of Light and Shifting Shadow")// more colonies Elgeon
	var/list/unathi = list("Moghes", "Qerrna-Qamxea", "Abel's Rest") // more colonies Anewbe
	var/list/tajara = list("Rarkajar", "Mesomori", "Arathiir")
	var/list/independent = list("New Kyoto", "Casini's Reach", "Ue'Orsi", "Natuna", "Neon Light")

	//this is what you should pick for most applications
	//whether or not the rim goes there is something that should be changed per the metaplot
	var/list/loc = oricon + skrell + tajara

	//this includes systems Sol doesn't really have eyes on
	var/list/allloc = loc + unathi + skrellfar + independent + rim

	//copied right from organizations.dm
	var/list/ship_names = list(
		"Kestrel",
		"Beacon",
		"Signal",
		"Freedom",
		"Glory",
		"Axiom",
		"Eternal",
		"Harmony",
		"Light",
		"Discovery",
		"Endeavor",
		"Explorer",
		"Swift",
		"Dragonfly",
		"Ascendant",
		"Tenacious",
		"Pioneer",
		"Hawk",
		"Haste",
		"Radiant",
		"Luminous"
		)

	//generated based on Cerebulon's thing on the wiki
	var/list/prefixes = list("IAV","ICV","IDV","IDV","IEV","IFV","IIV","ILV","IMV","IRV","ISV","ITV","SCG-A","SCG-C","SCG-D","SCG-D","SCG-E","SCG-F","SCG-I","SCG-L","SCG-M","SCG-R","SCG-S","SCG-T","BAV","BCV","BDV","BDV","BEV","BFV","BIV","BLV","BMV","BRV","BSV","BTV","HAV","HCV","HDV","HDV","HEV","HFV","HIV","HLV","HMV","HRV","HSV","HTV","MAV","MCV","MDV","MDV","MEV","MFV","MIV","MLV","MMV","MRV","MSV","MTV","NAV","NCV","NDV","NDV","NEV","NFV","NIV","NLV","NMV","NRV","NSV","NTV","VAV","VCV","VDV","VDV","VEV","VFV","VIV","VLV","VMV","VRV","VSV","VTV","WAV","WCV","WDV","WDV","WEV","WFV","WIV","WLV","WMV","WRV","WSV","WTV","XAV","XCV","XDV","XDV","XEV","XFV","XIV","XLV","XMV","XRV","XSV","XTV","ZAV","ZCV","ZDV","ZDV","ZEV","ZFV","ZIV","ZLV","ZMV","ZRV","ZSV","ZTV","GAV","GCV","GDV","GDV","GEV","GFV","GIV","GLV","GMV","GRV","GSV","GTV","AAV","ACV","ADV","ADV","AEV","AFV","AIV","ALV","AMV","ARV","ASV","ATV","LAV","LCV","LDV","LDV","LEV","LFV","LIV","LLV","LMV","LRV","LSV","LTV")

	//formatting breaks my fucking eyes
	var/body = pick("A high-ranking Vey-Med executive was revealed to have been experimenting on biological neural enhancement techniques, believed to be of Skrellian origin, which could lead to the production of transhuman entities with an average cognitive capacity 30% greater than a baseline human.",
	"[random_name(MALE)], chairman of the controversial Friends of Ned party, is scheduled to speak at a prominant university in [pick(core)] this Monday, according to a statement on his official newsfeed.",
	"A wing of Ward-Takahashi B-class drones became catatonic this Thursday after tripping late-stage anti-emergence protocols. W-T Chief of Development has declined to comment.",
	"A brand-new shipment of recreational voidcraft has been deemed \"Unsafe for use\" and seized at [pick(oricon)] customs. Wulf Aeronautics blames error in automated manufactory on [pick(oricon)], assures shareholders of \"One time incident\" after shares drop 4%.",
	"Activity in a mostly automated Xion work-site in [pick(oricon)] has been suspended indefinitely, after reports of atypical drone behavior. The EIO's assigned investigator commented on the shutdown, saying \"We'll get them up and running again as soon as we're sure it's safe.\" No comment so far on an estimated time or date of reopening.",
	"The EIO has officially raised the Emergence Threat Level in [pick(oricon)] to Blue. Citizens are reminded to comply with all EIO Agent requests. Failure to do so will be met with legal action, up to and including imprisonment.",
	"All OriCon citizens beware, the scourge know as the Vox have increased the frequency of their attacks on isolated and poorly defended OriCon territories in [pick(bowl)]. Citizens have been advised to travel in groups and remain aware of their surroundings at all times.",
	"The Unathi have recently moved a large amount of material into Abel's Rest, under the premise of building additional power plants. According to our sources, the material is in fact being channeled into domestic terrorist groups on both sides, in an attempt to incite a OriCon response. More news as the story develops.",
	"Controversial Kishari director [random_name(FEMALE)] announced this Friday a sequel to the 2525 animated series Soldiers of the Yearlong War. Open auditions for supporting cast members have been called.",
	"Amid concerns that it promotes a pro-transtech agenda, a high-profile screening of the award-winning animated film \"The Inventor's Marvelous Mechanical Maidens\" was canceled today on [pick(pick(core, heights))].",
	"A radiation leak caused by a power unit rupture at a [pick(oricon)] hazardous materials reclamation plant has left several workers and neighboring residents with acute radiation poisoning. Witnesses report that a basic lifting drone failed to recognize and collided with the misplaced unit.",
	"Xenophobic fringe group Humanity First has claimed credit for a bombing at a local government office on [pick(oricon)] which left three seriously injured. Police report that they have two suspects in custody, but details remain sparse.",
	"Government official [random_name(MALE)] reports that the crew of the [pick(prefixes)] [pick(ship_names)], the vessel boarded by Jaguar Gang pirates earlier this week, are \"Safe, unharmed, and happy to be back at work.\" Officials were unable to comment on future security measures at this time.",
	"Sanitation Technician [random_name(FEMALE)] says she was trapped in her work bathroom for three days after the locking system went haywire! The furious techie says she wants a \"hefty sum\" from her employers and that she won't be visiting that cubicle again any time soon!",
	"Experts at a top university have said that almost every position in modern society might be filled by a robot within the next few decades if production continues at its current rate. Workers' Rights groups have expressed alarm at the news, and have called for protections against the \"Tin menace\".",
	"An alleged cyberattack on Bishop Cybernetics systems reported to have resulted in the theft of customer data including detailed medical and biological records has been dismissed as \"Unfounded scaremongering\" by company executives.",
	"[pick(crescent)] resident [random_name(FEMALE)] says she was overjoyed when her son told her he was planning to get married, but was appalled to find the bride-to-be was a common household cleaning drone! GR3TA assures us that \"Cleaning is complete.\"",
	"Striking workers at a manufacturing plant on [pick(bowl)] have returned to work after news spread that plant owners would relocate operations to an automated facility if production did not resume by the end of the month. Factory investor [random_name(FEMALE)] expressed admiration at the \"Decisive action\" taken by the company.",
	"Police in [pick(core)] report that they have arrested a man in connection with multinationalist fringe group Nation of Mars. Authorities were alerted when the man's ID was flagged by new screening software at the city spaceport as a known sympathizer with the violent terrorist organization.",
	"The mystery of the [pick(prefixes)] [pick(ship_names)] has come to its end as a member of the vessel's skeleton crew was arrested in connection with Golden Tiger activities on the Skrell border. According to authorities, the ship - declared missing some months ago - was illegally sold to criminal elements on its way to breaking yards at [pick(heights)].",
	"[random_name(MALE)] comes clean about his decade-long nightmare kept as a slave on Eutopia in a new book to be released later this year. The harried author has fought lawsuits at every turn that claim that his account is \"A work of pure fiction with an obvious leftist agenda.\"",
	"Gas mask toting Revolutionary Solar People's Party extremists have reportedly attacked police at a rally in [pick(crypt)]. Peace-keeping officers were viscously pelted with objects and several protesters were found to be equipped with bottles containing an \"unknown substance.\"",
	"Be careful what you say around your personal AI device as you never know who might be listening, say top minds! Cybercrime expert [random_name(FEMALE)] says hackers can easily trick your device to listen in on your conversations, record you in secret, or even steal your identity!",
	"Thousands of travellers have been stranded at [pick(loc)] spaceport as a major error with the artificial intelligence system purged weeks worth of scheduling and manifest data from the port's mainframe. Major Bill's Transportation is offering stranded passengers 20% off replacement flights.",
	"An outraged pet owner claims that a cybernetic company in [pick(oricon)] performed \"disturbing\" surgeries on their beloved cat, Pickles. [random_name(PLURAL)], 58 claims that the local cybernetics firm stole the furry friend from the vet's office and \"Replaced his brain with ones and zeroes.\"",
	"Doctors in [pick(pick(skrell, heights))] were left in awe and horror as a Teshari was hatched with the features of an adult human man! Sources say that the youngster hatched with a full head of hair and could recite six nursery rhymes from memory. Could Skrell genetic experiments be to blame?",
	"Miners in [pick(bowl)] were dismayed to discover that their boss was actually a C-class drone intelligence! \"I should've known there was something wrong,\" says dumbfounded miner [random_name(MALE)],\"I'd say good morning and he'd just start listing off mineral densities and coordinates. I just thought he loved his job a little too much.\"",
	"The remains of an early 22nd century voidcraft containing \"Period artifacts, technology and human remains\" has been located on the surface of Luna after centuries of being disregarded as worthless wreck. Historians hope the find will provide insight into daily life under the short-lived Selene Federation.",
	"The unexpected discovery of the remains of a what was believed to be a previously undiscovered species by workers on [pick("Nisp", "Binma", "Sif", "Kishar", "Abel's Rest", "Merelar")] has now been dismissed. Upon close analysis of the specimen, it was identified as a \"Bear with mange\", apparently dumped there some weeks prior.",
	"According to a public statement by electronics giant Ward-Takahashi, many artificial intelligence systems - ranging from household appliances to industrial drones and habitat control networks - manufactured before 2550 could be at risk from a new virus dubbed \"Cap-3k\".",
	"A controversial opera billed as \"The true story of Nos Amis\" has been criticized by law enforcement agencies as \"glorifying\" some of the most infamous gangsters of the 22nd century. The Polish-language \"Z Francji, do Gwiazd\" is to be distributed exclusively in Alpha Centauri for one week only.",
	"Injury count continues to rise in the aftermath of the Positronic Rights Group Rally in [pick(pick(bowl, core, heights))]. Homemade teargas grenades were launched into the crowd at approximately 3:45 pm on Saturday by an unidentified person. Authorities urge anyone with information to call in, toll-free, at any time.",
	"Representatives report that investigations continue on a string of fires on [pick("Nisp", "Binma", "Sif", "Kishar", "Abel's Rest", "Merelar")]. While no information has been released to the public, authorities assure the press that they are doing everything in their power to find those responsible.",
	"En-route to the contentious rim system, a medical aid mission to Natuna was stopped by Ue-Katish pirates masquerading as refugees, who boarded the ship and stripped it of all supplies.",
	"Lead Singer of Strawberry Idol Revealed As Three Teshari In A Trench Coat-- Newest gimmick or shocking revelation??",
	"Shocking art critics throughout the system, a recent submission to the [pick(oricon)] Museum of Absurdism's contemporary exhibit was revealed to actually be the nutritional information on the back of a dehydrated cereal product common in Skrell space.",
	"The celebrated magical kid series \"Petit Yuusha Jossen Temonila\" has announced its newest season at the height of its demicentenial festival. Noted director [random_name(MALE)] has promised to bring a diverse production staff to the venerable series, and has stated a theme of \"the friendships that transcend borders\".",
	"The Hephaestus Industries board of directors announced this Monday the highest annual profits since the height of the Lizard Riots.",
	"A radical group of Mercurials were convicted today of violations of Five Points legislature at an extraordinary court on [pick(oricon)]. These convictions come at the heels of a successful sting operation six years in the making, lead by local Head of EIO [random_name(FEMALE)].",
	"An unnamed official of the shipping TSC Major Bill's Transportation narrowly escaped an attempt on their life by a deranged assassin. The assassin claims to have been driven to this henious act by the corporation's infamous jingle.",
	"In the aftermath of yesterday's synthphobic rally on [pick(oricon)], three positronic citizens were left irreparably damaged by a hostile mob, who claim that the victims were \"AAs\" attempting to infiltrate the rally.",
	"EIO spokesperson [random_name(MALE)] stated in a press conference yesterday that the \"Shakespear\" A-class codeline was briefly available for download on the darknet, although they claim to be \"confident that the leak was shut down before any significant portion could be downloaded\". Experts suspect Association involvement.",
	"[pick("Strives Towards", "Embraces", "Dreams of", "Cultivates", "Advocates", "Exemplifies")] [pick("Strength", "Wisdom", "Independence", "Pragmatism", "Reason", "Development")], a Community Child from Angessa's Pearl, published his memoir today, detailing a shocking level of abuse by caretakers and educators.",
	"Nova Sixty, Mercurial web personality, claims that the disappearence of the SCG-R Song Shi was a plot by \"extradimensional rockmen\" who intend to sow mistrust between the Association and OriCon. Quote Sixty, \"The Far Kingdoms' attempt to hide the TRUTH only proves that they and their rockman allies are NOT to be trusted.\"",
	"Unusual stellar phenomena was detected on [pick(allloc)], sparking concerns about the colonies in the system.",
	)

	news_network.SubmitArticle(body, author, channel, null, 1)


/* /datum/event/mundane_news
	endWhen = 10

/datum/event/mundane_news/announce()
	var/datum/trade_destination/affected_dest = pickweight(weighted_mundaneevent_locations)
	var/event_type = 0
	if(affected_dest.viable_mundane_events.len)
		event_type = pick(affected_dest.viable_mundane_events)

	if(!event_type)
		return

	var/author = "The "+(LEGACY_MAP_DATUM).starsys_name+" Times"
	var/channel = author

	//see if our location has custom event info for this event
	var/body = affected_dest.get_custom_eventstring()
	if(!body)
		body = ""
		switch(event_type)
			if(RESEARCH_BREAKTHROUGH)
				body = "A major breakthough in the field of [pick("phoron research","super-compressed materials","nano-augmentation","bluespace research","volatile power manipulation")] \
				was announced [pick("yesterday","a few days ago","last week","earlier this month")] by a private firm on [affected_dest.name]. \
				[(LEGACY_MAP_DATUM).company_name] declined to comment as to whether this could impinge on profits."

			if(ELECTION)
				body = "The pre-selection of an additional candidates was announced for the upcoming [pick("supervisors council","advisory board","governership","board of inquisitors")] \
				election on [affected_dest.name] was announced earlier today, \
				[pick("media mogul","web celebrity", "industry titan", "superstar", "famed chef", "popular gardener", "ex-army officer", "multi-billionaire")] \
				[random_name(pick(MALE,FEMALE))]. In a statement to the media they said '[pick("My only goal is to help the [pick("sick","poor","children")]",\
				"I will maintain my company's record profits","I believe in our future","We must return to our moral core","Just like... chill out dudes")]'."

			if(RESIGNATION)
				body = "[(LEGACY_MAP_DATUM).company_name] regretfully announces the resignation of [pick("Sector Admiral","Division Admiral","Ship Admiral","Vice Admiral")] [random_name(pick(MALE,FEMALE))]."
				if(prob(25))
					var/locstring = pick("Segunda","Salusa","Cepheus","Andromeda","Gruis","Corona","Aquila","Asellus") + " " + pick("I","II","III","IV","V","VI","VII","VIII")
					body += " In a ceremony on [affected_dest.name] this afternoon, they will be awarded the \
					[pick("Red Star of Sacrifice","Purple Heart of Heroism","Blue Eagle of Loyalty","Green Lion of Ingenuity")] for "
					if(prob(33))
						body += "their actions at the Battle of [pick(locstring,"REDACTED")]."
					else if(prob(50))
						body += "their contribution to the colony of [locstring]."
					else
						body += "their loyal service over the years."
				else if(prob(33))
					body += " They are expected to settle down in [affected_dest.name], where they have been granted a handsome pension."
				else if(prob(50))
					body += " The news was broken on [affected_dest.name] earlier today, where they cited reasons of '[pick("health","family","REDACTED")]'"
				else
					body += " Administration Aerospace wishes them the best of luck in their retirement ceremony on [affected_dest.name]."

			if(CELEBRITY_DEATH)
				body = "It is with regret today that we announce the sudden passing of the "
				if(prob(33))
					body += "[pick("distinguished","decorated","veteran","highly respected")] \
					[pick("Ship's Captain","Vice Admiral","Colonel","Lieutenant Colonel")] "
				else if(prob(50))
					body += "[pick("award-winning","popular","highly respected","trend-setting")] \
					[pick("comedian","singer/songwright","artist","playwright","TV personality","model")] "
				else
					body += "[pick("successful","highly respected","ingenious","esteemed")] \
					[pick("academic","Professor","Doctor","Scientist")] "

				body += "[random_name(pick(MALE,FEMALE))] on [affected_dest.name] [pick("last week","yesterday","this morning","two days ago","three days ago")]\
				[pick(". Assassination is suspected, but the perpetrators have not yet been brought to justice",\
				" due to mercenary infiltrators (since captured)",\
				" during an industrial accident",\
				" due to [pick("heart failure","kidney failure","liver failure","brain hemorrhage")]")]"

			if(BARGAINS)
				body += "BARGAINS! BARGAINS! BARGAINS! Commerce Control on [affected_dest.name] wants you to know that everything must go! Across all retail centres, \
				all goods are being slashed, and all retailors are onboard - so come on over for the \[shopping\] time of your life."

			if(SONG_DEBUT)
				body += "[pick("Singer","Singer/songwriter","Saxophonist","Pianist","Guitarist","TV personality","Star")] [random_name(pick(MALE,FEMALE))] \
				announced the debut of their new [pick("single","album","EP","label")] '[pick("Everyone's","Look at the","Baby don't eye those","All of those","Dirty nasty")] \
				[pick("roses","three stars","starships","nanobots","cyborgs","Skrell","Sren'darr")] \
				[pick("on Venus","on Reade","on Moghes","in my hand","slip through my fingers","die for you","sing your heart out","fly away")]' \
				with [pick("pre-puchases available","a release tour","cover signings","a launch concert")] on [affected_dest.name]."

			if(MOVIE_RELEASE)
				body += "From the [pick("desk","home town","homeworld","mind")] of [pick("acclaimed","award-winning","popular","stellar")] \
				[pick("playwright","author","director","actor","TV star")] [random_name(pick(MALE,FEMALE))] comes the latest sensation: '\
				[pick("Deadly","The last","Lost","Dead")] [pick("Starships","Warriors","outcasts","Tajarans",SPECIES_UNATHI,"Skrell")] \
				[pick("of","from","raid","go hunting on","visit","ravage","pillage","destroy")] \
				[pick("Moghes","Earth","Biesel","Meralar","Rarkajar","the Void","the Edge of Space")]'.\
				. Own it on webcast today, or visit the galactic premier on [affected_dest.name]!"

			if(BIG_GAME_HUNTERS)
				body += "Game hunters on [affected_dest.name] "
				if(prob(33))
					body += "were surprised when an unusual species experts have since identified as \
					[pick("a subclass of mammal","a divergent abhuman species","an intelligent species of lemur","organic/cyborg hybrids")] turned up. Believed to have been brought in by \
					[pick("alien smugglers","early colonists","mercenary raiders","unwitting tourists")], this is the first such specimen discovered in the wild."
				else if(prob(50))
					body += "were attacked by a vicious [pick("nas'r","diyaab","samak","predator which has not yet been identified")]\
					. Officials urge caution, and locals are advised to stock up on armaments."
				else
					body += "brought in an unusually [pick("valuable","rare","large","vicious","intelligent")] [pick("mammal","predator","farwa","samak")] for inspection \
					[pick("today","yesterday","last week")]. Speculators suggest they may be tipped to break several records."

			if(GOSSIP)
				body += "[pick("TV host","Webcast personality","Superstar","Model","Actor","Singer")] [random_name(pick(MALE,FEMALE))] "
				if(prob(33))
					body += "and their partner announced the birth of their [pick("first","second","third")] child on [affected_dest.name] early this morning. \
					Doctors say the child is well, and the parents are considering "
					if(prob(50))
						body += capitalize(pick(GLOB.first_names_female))
					else
						body += capitalize(pick(GLOB.first_names_male))
					body += " for the name."
				else if(prob(50))
					body += "announced their [pick("split","break up","marriage","engagement")] with [pick("TV host","webcast personality","superstar","model","actor","singer")] \
					[random_name(pick(MALE,FEMALE))] at [pick("a society ball","a new opening","a launch","a club")] on [affected_dest.name] yesterday, pundits are shocked."
				else
					body += "is recovering from plastic surgery in a clinic on [affected_dest.name] for the [pick("second","third","fourth")] time, reportedly having made the decision in response to "
					body += "[pick("unkind comments by an ex","rumours started by jealous friends",\
					"the decision to be dropped by a major sponsor","a disasterous interview on [(LEGACY_MAP_DATUM).starsys_name] Tonight")]."
			if(TOURISM)
				body += "Tourists are flocking to [affected_dest.name] after the surprise announcement of [pick("major shopping bargains by a wily retailer",\
				"a huge new ARG by a popular entertainment company","a secret tour by popular artiste [random_name(pick(MALE,FEMALE))]")]. \
				The [(LEGACY_MAP_DATUM).starsys_name] Times is offering discount tickets for two to see [random_name(pick(MALE,FEMALE))] live in return for eyewitness reports and up to the minute coverage."

	news_network.SubmitArticle(body, author, channel, null, 1)
*/
/datum/event/trivial_news
	endWhen = 10

/datum/event/trivial_news/announce()
	var/author = "Editor Mike Hammers"
	var/channel = "The Gibson Gazette"

	var/datum/trade_destination/affected_dest = pick(weighted_mundaneevent_locations)
	var/body = pick(
	"Tree stuck in tajaran; firefighters baffled.",\
	"Armadillos want aardvarks removed from dictionary claims 'here first'.",\
	"Angel found dancing on pinhead ordered to stop; cited for public nuisance.",\
	"Letters claim they are better than number; 'Always have been'.",\
	"Pens proclaim pencils obsolete, 'lead is dead'.",\
	"Rock and paper sues scissors for discrimination.",\
	"Steak tell-all book reveals he never liked sitting by potato.",\
	"Woodchuck stops counting how many times he�s chucked 'Never again'.",\
	"[affected_dest.name] clerk first person able to pronounce '@*$%!'.",\
	"[affected_dest.name] delis serving boiled paperback dictionaries, 'Adjectives chewy' customers declare.",\
	"[affected_dest.name] weather deemed 'boring'; meteors and rad storms to be imported.",\
	"Most [affected_dest.name] security officers prefer cream over sugar.",\
	"Palindrome speakers conference in [affected_dest.name]; 'Wow!' says Otto.",\
	"Question mark worshipped as deity by ancient [affected_dest.name] dwellers.",\
	"Spilled milk causes whole [affected_dest.name] populace to cry.",\
	"World largest carp patty at display on [affected_dest.name].",\
	"'Here kitty kitty' no longer preferred tajaran retrieval technique.",\
	"Man travels 7000 light years to retrieve lost hankie, 'It was my favourite'.",\
	"New bowling lane that shoots mini-meteors at bowlers very popular.",\
	"[pick(SPECIES_UNATHI,"Spacer")] gets tattoo of "+(LEGACY_MAP_DATUM).starsys_name+" on chest '[pick("[(LEGACY_MAP_DATUM).boss_short]","star","starship","asteroid")] tickles most'.",\
	"Skrell marries computer; wedding attended by 100 modems.",\
	"Chef reports successfully using harmonica as cheese grater.",\
	"[(LEGACY_MAP_DATUM).company_name] invents handkerchief that says 'Bless you' after sneeze.",\
	"Clone accused of posing for other clones�s school photo.",\
	"Clone accused of stealing other clones�s employee of the month award.",\
	"Woman robs station with hair dryer; crewmen love new style.",\
	"This space for rent.",\
	"[affected_dest.name] Baker Wins Pickled Crumpet Toss Three Years Running",\
	"Skrell Scientist Discovers Abacus Can Be Used To Dry Towels",\
	"Survey: 'Cheese Louise' Voted Best Pizza Restaurant In [(LEGACY_MAP_DATUM).starsys_name]",\
	"I Was Framed, jokes [affected_dest.name] artist",\
	"Mysterious Loud Rumbling Noises In [affected_dest.name] Found To Be Mysterious Loud Rumblings",\
	"Alien ambassador becomes lost on [affected_dest.name], refuses to ask for directions",\
	"Swamp Gas Verified To Be Exhalations Of Stars--Movie Stars--Long Passed",\
	"Tainted Broccoli Weapon Of Choice For Efficient Assassins",\
	"Chefs Find Broccoli Effective Tool For Cutting Cheese",\
	"Broccoli Found To Cause Grumpiness In Monkeys",\
	"Survey: 80% Of People on [affected_dest.name] Love Clog-Dancing",\
	"Giant Hairball Has Perfect Grammar But Rolls rr's Too Much, Linguists Say",\
	"[affected_dest.name] Phonebooks Print All Wrong Numbers; Results In 15 New Marriages",\
	"Tajaran Burglar Spotted on [affected_dest.name], Mistaken For Dalmatian",\
	"Gibson Gazette Updates Frequently Absurd, Poll Indicates",\
	"Esoteric Verbosity Culminates In Communicative Ennui, [affected_dest.name] Academics Note",\
	"Taj Demand Longer Breaks, Cleaner Litter, Slower Mice",\
	"Survey: 3 Out Of 5 Skrell Loathe Modern Art",\
	"Skrell Scientist Discovers Gravity While Falling Down Stairs",\
	"Boy Saves Tajaran From Tree on [affected_dest.name], Thousands Cheer",\
	"Shipment Of Apples Overturns, [affected_dest.name] Diner Offers Applesauce Special",\
	"Spotted Owl Spotted on [affected_dest.name]",\
	"Humans Everywhere Agree: Purring Tajarans Are Happy Tajarans",\
	"From The Desk Of Wise Guy Sammy: One Word In This Gazette Is Sdrawkcab",\
	"From The Desk Of Wise Guy Sammy: It's Hard To Have Too Much Shelf Space",\
	"From The Desk Of Wise Guy Sammy: Wine And Friendships Get Better With Age",\
	"From The Desk Of Wise Guy Sammy: The Insides Of Golf Balls Are Mostly Rubber Bands",\
	"From The Desk Of Wise Guy Sammy: You Don't Have To Fool All The People, Just The Right Ones",\
	"From The Desk Of Wise Guy Sammy: If You Made The Mess, You Clean It Up",\
	"From The Desk Of Wise Guy Sammy: It Is Easier To Get Forgiveness Than Permission",\
	"From The Desk Of Wise Guy Sammy: Check Your Facts Before Making A Fool Of Yourself",\
	"From The Desk Of Wise Guy Sammy: You Can't Outwait A Bureaucracy",\
	"From The Desk Of Wise Guy Sammy: It's Better To Yield Right Of Way Than To Demand It",\
	"From The Desk Of Wise Guy Sammy: A Person Who Likes Cats Can't Be All Bad",\
	"From The Desk Of Wise Guy Sammy: Help Is The Sunny Side Of Control",\
	"From The Desk Of Wise Guy Sammy: Two Points Determine A Straight Line",\
	"From The Desk Of Wise Guy Sammy: Reading Improves The Mind And Lifts The Spirit",\
	"From The Desk Of Wise Guy Sammy: Better To Aim High And Miss Then To Aim Low And Hit",\
	"From The Desk Of Wise Guy Sammy: Meteors Often Strike The Same Place More Than Once",\
	"Tommy B. Saif Sez: Look Both Ways Before Boarding The Shuttle",\
	"Tommy B. Saif Sez: Hold On; Sudden Stops Sometimes Necessary",\
	"Tommy B. Saif Sez: Keep Fingers Away From Moving Panels",\
	"Tommy B. Saif Sez: No Left Turn, Except Shuttles",\
	"Tommy B. Saif Sez: Return Seats And Trays To Their Proper Upright Position",\
	"Tommy B. Saif Sez: Eating And Drinking In Docking Bays Is Prohibited",\
	"Tommy B. Saif Sez: Accept No Substitutes, And Don't Be Fooled By Imitations",\
	"Tommy B. Saif Sez: Do Not Remove This Tag Under Penalty Of Law",\
	"Tommy B. Saif Sez: Always Mix Thoroughly When So Instructed",\
	"Tommy B. Saif Sez: Try To Keep Six Month's Expenses In Reserve",\
	"Tommy B. Saif Sez: Change Not Given Without Purchase",\
	"Tommy B. Saif Sez: If You Break It, You Buy It",\
	"Tommy B. Saif Sez: Reservations Must Be Cancelled 48 Hours Prior To Event To Obtain Refund",\
	"Doughnuts: Is There Anything They Can't Do",\
	"If Tin Whistles Are Made Of Tin, What Do They Make Foghorns Out Of?",\
	"Broccoli discovered to be colonies of tiny aliens with murder on their minds"\
	)

	news_network.SubmitArticle(body, author, channel, null, 1)
