
//list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0),
/datum/dna2/record
	var/datum/dna/dna = null
	var/types=0
	var/name="Empty"

	// Stuff for cloners
	var/id=null
	var/implant=null
	var/ckey=null
	var/mind=null
	var/languages=null
	var/list/flavor=null
	var/gender = null
	var/list/body_descriptors = null
	var/list/genetic_modifiers = list() // Modifiers with the MODIFIER_GENETIC flag are saved.  Note that only the type is saved, not an instance.

/datum/dna2/record/proc/GetData()
	var/list/ser=list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0)
	if(dna)
		ser["ue"] = (types & DNA2_BUF_UE) == DNA2_BUF_UE
		if(types & DNA2_BUF_SE)
			ser["data"] = dna.SE
		else
			ser["data"] = dna.UI
		ser["owner"] = src.dna.real_name
		ser["label"] = name
		if(types & DNA2_BUF_UI)
			ser["type"] = "ui"
		else
			ser["type"] = "se"
	return ser
