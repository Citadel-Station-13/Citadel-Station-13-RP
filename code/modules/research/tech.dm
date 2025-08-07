/***************************************************************
**						Technology Datums					  **
**	Includes all the various technoliges and what they make.  **
***************************************************************/

///Datum of individual technologies.
/datum/tech
	///Name of the technology.
	var/name = "name"
	///General description of what it does and what it makes.
	var/desc = "description"
	///An easily referenced ID. Must be alphanumeric, lower-case, and no symbols.
	var/id = "id"
	///A simple number scale of the research level. Level 0 = Secret tech.
	var/level = 1

/datum/tech/materials
	name = "Materials Research"
	desc = "Development of new and improved materials."
	id = TECH_MATERIAL

/datum/tech/engineering
	name = "Engineering Research"
	desc = "Development of new and improved engineering parts."
	id = TECH_ENGINEERING

/datum/tech/phorontech
	name = "Phoron Research"
	desc = "Research into the mysterious substance colloqually known as 'phoron'."
	id = TECH_PHORON

/datum/tech/powerstorage
	name = "Power Manipulation Technology"
	desc = "The various technologies behind the storage and generation of electicity."
	id = TECH_POWER

/datum/tech/bluespace
	name = "'Blue-space' Research"
	desc = "Research into the sub-reality known as 'blue-space'"
	id = TECH_BLUESPACE

/datum/tech/biotech
	name = "Biological Technology"
	desc = "Research into the deeper mysteries of life and organic substances."
	id = TECH_BIO

/datum/tech/combat
	name = "Combat Systems Research"
	desc = "The development of offensive and defensive systems."
	id = TECH_COMBAT

/datum/tech/magnets
	name = "Electromagnetic Spectrum Research"
	desc = "Research into the electromagnetic spectrum. No clue how they actually work, though."
	id = TECH_MAGNET

/datum/tech/programming
	name = "Data Theory Research"
	desc = "The development of new computer and artificial intelligence and data storage systems."
	id = TECH_DATA

/datum/tech/syndicate
	name = "Illegal Technologies Research"
	desc = "The study of technologies that violate standard government regulations."
	id = TECH_ILLEGAL
	level = 0

/datum/tech/arcane
	name = "Anomalous Research"
	desc = "Study of phenomena that disobey the fundamental laws of this universe."
	id = TECH_ARCANE
	level = 0

/datum/tech/precursor
	name = "Precursor Research"
	desc = "The applied study of Precursor Technology, for modern applications."
	id = TECH_PRECURSOR
	level = 0
