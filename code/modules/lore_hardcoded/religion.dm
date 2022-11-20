/datum/lore/character_background/religion
	abstract_type = /datum/lore/character_background/religion

/datum/lore/character_background/religion/check_character_species(datum/character_species/S)
	if(S.species_fluff_flags & SPECIES_FLUFF_PICKY_RELIGION)
		. = (S.uid in allow_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in allow_species))
		if(!.)
			return
	return ..()

/datum/lore/character_background/religion/unathiancestors
	name = "Ancestors Cult"
	id = "unathiancestor"
	desc = "The belief that one's blood ancestors live on as spirits in a near afterlife of sorts, a plane of reality layered over our own. \
	Many spirits of great beasts or other such superstitions are also believed to exist. Most Unathi follow this sort of belief either \
	spiritually or more secularly, doing away with the notion of an afterlife and simply revering their forefathers."

/datum/lore/character_background/religion/handofthevine
	name = "Hand of the Vine"
	id = "handofthevine"
	desc = "A cult of Unathi belief that states cooperation and harmony is the perfect path in life. \
	To aid in this goal many believers will injest, smoke, or inject herbs and other such substances to further their understanding. \
	These believers often act the 'most human' out of their peers, and do in fact get along well with many aliens -- \
	less so with more conservative Unathi."

/datum/lore/character_background/religion/grandstratagem
	name = "Grand Stratagem"
	id = "grandstrategem"
	desc = "A cult of Unathi belief where all conflict brings growth. Conflict with other Unathi, conflict within a Clan, \
	conflict with aliens, conflict within oneself. If there is a clash between two ideas, two forces, then overcoming that obstacle \
	will bring about a better idea. The resolution to such conflicts vary wildly, but personal scale disputes often end in a duel."

/datum/lore/character_background/religion/fruitfullights
	name = "Fruitful Lights"
	id = "fruitfullights"
	desc = "A cult of Unathi belief that 'grows' potential progress from innovation, research, and iteration. \
	Not everyone who follows this ideology is a studied person; there are some laborers who simply find the best way to complete their work. \
	The end goal of those who follow this belief is to better their people, whether it be their Clan or the Unathi as a whole."

/datum/lore/character_background/religion/markesheli
	name = "Markesheli"
	id = "markesheli"
	desc = " Originally a Vhetriss'Unathi idea of an artisian doing everything in his power to better that singular craft. \
	The term and the belief have been taken up by a minority of other Unathi, but the Zaddat find the pursuit of perfection appealing as well. \
	The actual skill or craft being perfected is up to an indicidual; the one thing that binds all believers together is the singular focus \
	on their craft, and the desire to be the best they can within it."
/datum/lore/character_background/religion/custom
	name = "Other"
	id = "custom"
	desc = "Whether you're in a small sect of a niche religion, or simply have nonstandard beliefs, you don't fit into any of the above."
