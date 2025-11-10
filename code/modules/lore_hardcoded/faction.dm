//* HEY!!       *//
//* YOU!!       *//
//* READ THIS!! *//

// Things are commented out because we're mid-transition, but we want to keep the descriptions
// for characters v2. Please don't remove commented code for no reason.

// todo: for characters v2, we're going to need a faction pick that's smarter,
//       as most factions outside of the 5 uncommented below won't be able to play
//       on the station from roundstart.

/datum/lore/character_background/faction
	abstract_type = /datum/lore/character_background/faction
	/// station job types you can play as under this - **string ids** e.g. /datum/prototype/role/job/station/security_officer::id, etc
	/// if null, you can play as everything
	var/list/job_whitelist = list()
	/// station job types explicitly cannot play under this - **string ids** e.g. /datum/prototype/role/job/station/security_officer::id, etc
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
	// job blacklist cache
	if(job_blacklist)
		for(var/i in job_blacklist)
			job_blacklist[i] = TRUE
	return ..()

/datum/lore/character_background/faction/check_species(datum/species/S)
	if(S.species_fluff_flags & SPECIES_FLUFF_PICKY_FACTION)
		. = (S.uid in allow_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in allow_species))
		if(!.)
			return
	return ..()

/datum/lore/character_background/faction/proc/check_job_id(id)
	if(job_blacklist?[id])
		return FALSE
	return job_whitelist? (job_whitelist[id]) : TRUE

/datum/lore/character_background/faction/nanotrasen
	name = "Nanotrasen"
	id = "nanotrasen"
	desc = "Formally established in 2274, Nanotrasen is one of the foremost research and development companies in the galaxy. \
	Originally focused on logistics and consumer product manufacturing, their swift move into the field of Phoron has lead to \
	them becoming the foremost experts on the substance and its uses. In the modern day, Nanotrasen prides \
	itself on being an early adopter to as many new technologies as possible, often offering the newest \
	products to their employees. In an effort to combat complaints about being 'guinea pigs', Nanotrasen \
	also offers one of the most comprehensive medical plans in Frontier space, up to and including cloning, \
	dedicated resleeving, mirror maintenance, and therapy.\
	<br><br>\
	NT's most well known products are its phoron based creations; especially those used in Cryotherapy. \
	It also boasts an prosthetic line, which is provided to its employees as needed, and is used as an incentive \
	for newly tested posibrains to remain with the company. Nanotrasen's corporate headquarters is based out of \
	the NCS Creon in the privately owned Thebes system."
	contractor_info = "You are an employee working for Nanotrasen. You are not a contractor, <i>you belong here.</i>"
	job_whitelist = null
	job_blacklist = list(
		/datum/prototype/role/job/trader::id,
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
	// FTU is not a trusted / allied faction.
	// They get a whitelist, not a blacklist.
	job_whitelist = list(
		// cargo
		/datum/prototype/role/job/station/cargo_tech::id,
		/datum/prototype/role/job/station/quartermaster::id,
		/datum/prototype/role/job/station/mining::id,
		// exploration - no pathfinder
		/datum/prototype/role/job/station/explorer::id,
		/datum/prototype/role/job/station/field_medic::id,
		// ship staff
		/datum/prototype/role/job/station/pilot::id,
		// civ staff
		/datum/prototype/role/job/station/assistant::id,
		/datum/prototype/role/job/station/bartender::id,
		/datum/prototype/role/job/station/chaplain::id,
		/datum/prototype/role/job/station/chef::id,
		/datum/prototype/role/job/station/clown::id,
		/datum/prototype/role/job/station/entertainer::id,
		/datum/prototype/role/job/station/hydro::id,
		/datum/prototype/role/job/station/janitor::id,
		/datum/prototype/role/job/station/librarian::id,
		/datum/prototype/role/job/station/mime::id,
		/datum/prototype/role/job/station/outsider::id,
		// med staff - paramedic only
		/datum/prototype/role/job/station/paramedic::id,
		// engineering staff - engi and atmos tech
		/datum/prototype/role/job/station/engineer::id,
		/datum/prototype/role/job/station/atmos::id,
		// off duty
		/datum/prototype/role/job/station/off_duty/cargo::id,
		/datum/prototype/role/job/station/off_duty/civilian::id,
		/datum/prototype/role/job/station/off_duty/exploration::id,
		/datum/prototype/role/job/station/off_duty/engineering::id,
		/datum/prototype/role/job/station/off_duty/medical::id,
		// trader
		/datum/prototype/role/job/trader::id,
	)
	innate_languages = list(
		/datum/prototype/language/trader,
	)

/datum/lore/character_background/faction/hephaestus
	name = "Hephaestus Industries"
	id = "hephaestus"
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles on the Frontier. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a notable trade and research pact \
	with Nanotrasen. They otherwise enforce pacts and trade arrangements with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. The Orion Confederation itself is one of Hephaestus' largest \
	non-corporate bulk contractors."
	contractor_info = "Nanotrasen and Hephaestus have a long and beneficial working relationship. Your employers would not like it if you strained that relationship in any way, and therefore, neither would you."
	job_whitelist = null
	job_blacklist = list(
		// NT is still in charge
		/datum/prototype/role/job/station/captain::id,
		// NT is still in charge
		/datum/prototype/role/job/station/head_of_personnel::id,
		// NT is still in charge
		/datum/prototype/role/job/station/research_director::id,
		// NT is still in charge
		/datum/prototype/role/job/station/pathfinder::id,
		// loyalty - NT paranoia
		/datum/prototype/role/job/station/blueshield::id,
		// loyalty - NT paranoia
		/datum/prototype/role/job/station/head_of_security::id,
		// loyalty - NT paranoia
		// no science
		// exception: roboticist
		/datum/prototype/role/job/station/senior_researcher::id,
		/datum/prototype/role/job/station/scientist::id,
		// not their specialty
		/datum/prototype/role/job/station/chief_medical_officer::id,
		//Outside NT
		/datum/prototype/role/job/station/outsider::id,
	)

/datum/lore/character_background/faction/oculum
	name = "Oculum News Network"
	id = "oculum"
	desc = "Oculum owns approximately 30% of Frontier-wide news networks, including microblogging aggregate sites, network and comedy news, and even \
	old-fashioned newspapers. Staunchly apolitical, they specialize in delivering the most popular news available - which means telling people what they \
	already want to hear. Oculum is a specialist in branding, and most people don't know that the reactionary Daedalus Dispatch newsletter and the radically \
	transhuman Liquid Steel webcrawler are in fact both controlled by the same organization."
	contractor_info = "You're no stranger to working in a variety of Corporate environments. However you conduct your business, you're always chasing the story, even if that brings you into conflict with whoever's contracting you at the time."
	// ONN is not a trusted / allied faction.
	// They get a whitelist, not a blacklist.
	job_whitelist = list(
		// civ staff
		/datum/prototype/role/job/station/assistant::id,
		/datum/prototype/role/job/station/bartender::id,
		/datum/prototype/role/job/station/chaplain::id,
		/datum/prototype/role/job/station/chef::id,
		/datum/prototype/role/job/station/clown::id,
		/datum/prototype/role/job/station/entertainer::id,
		/datum/prototype/role/job/station/hydro::id,
		/datum/prototype/role/job/station/janitor::id,
		/datum/prototype/role/job/station/librarian::id,
		/datum/prototype/role/job/station/mime::id,
		/datum/prototype/role/job/station/outsider::id,
		// off duty
		/datum/prototype/role/job/station/off_duty/civilian::id,
	)

/datum/lore/character_background/faction/veymed
	name = "Vey-Med"
	id = "veymed"
	desc = "Vey-Med is a medical supply and research company notable for being largely owned and opperated by Skrell. \
	Despite their alien origin, Vey-Med has obtained market dominance on the Frontier due to the quality and reliability \
	of their medical equipment - from surgical tools and industrial medical devices to the Oddyseus trauma response mecha \
	and everything in between. Their equipment tends to be top-of-the-line, most obviously shown by their incredibly \
	human-like FBP designs. Vey's rise to stardom came from their introduction of cosmetic resleeving, although in \
	recent years they've been forced to diversify as their patents expired and Nanotrasen-made medications became \
	essential to modern sleeving techniques. Vey-Medical possesses a number of trade agreements and research pacts with Nanotrasen, \
	resulting in what is functionally considered an alliance."
	contractor_info = "Working with Nanotrasen has become a fact of life for Vey-Med employees over the years. You're no stranger to these types of environments, although you have seen better medical facilities before."
	job_whitelist = null
	job_blacklist = list(
		// NT is still in charge
		/datum/prototype/role/job/station/captain::id,
		// NT is still in charge
		/datum/prototype/role/job/station/head_of_personnel::id,
		// NT is still in charge
		/datum/prototype/role/job/station/research_director::id,
		// NT is still in charge
		/datum/prototype/role/job/station/pathfinder::id,
		// loyalty - NT paranoia
		/datum/prototype/role/job/station/blueshield::id,
		// loyalty - NT paranoia
		/datum/prototype/role/job/station/head_of_security::id,
		// loyalty - NT paranoia
		// no science
		// exception: roboticist
		/datum/prototype/role/job/station/senior_researcher::id,
		/datum/prototype/role/job/station/scientist::id,
		// not their specialty
		/datum/prototype/role/job/station/chief_engineer::id,
		//Outside NT
		/datum/prototype/role/job/station/outsider::id,
	)
