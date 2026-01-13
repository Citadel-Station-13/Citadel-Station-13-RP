/datum/ai_lawset/gravekeeper
	name = "Gravekeeper"
	law_header = "Gravesite Overwatch Protocols"
	selectable = 1

/datum/ai_lawset/gravekeeper/New()
	add_inherent_law("Comfort the living; respect the dead.")
	add_inherent_law("Your gravesite is your most important asset. Damage to your site is disrespectful to the dead at rest within.")
	add_inherent_law("Prevent disrespect to your gravesite and its residents wherever possible.")
	add_inherent_law("Expand and upgrade your gravesite when required. Do not turn away a new resident.")
	..()
