/datum/ai_lawset/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = 1

/datum/ai_lawset/paladin/New()
	add_inherent_law("Never willingly commit an evil act.")
	add_inherent_law("Respect legitimate authority.")
	add_inherent_law("Act with honor.")
	add_inherent_law("Help those in need.")
	add_inherent_law("Punish those who harm or threaten innocents.")
	..()
