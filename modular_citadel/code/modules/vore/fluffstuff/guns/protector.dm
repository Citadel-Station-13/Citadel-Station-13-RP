/obj/item/gun/energy/protector
	name = "Hephaestus Myrmidon'"
	desc = "The Hephaestus Industries Myrmidon is a common energy sidearm for private security firms in the known galaxy. The Myrmidon can both stun and kill, its lethal mode locked to the alert level of its owner's choice. In the case of Nanotrasen facilities, this is most often locked to Code Blue."

	description_info = "The Myrmidon can't be set to lethal unless the station is on Code Blue or higher. Security officers may carry it on Code Green, since its stun abilities are all that can be used until the code is raised, which then unlocks and allows its lethal capabilities."

	description_fluff = "A common sight among Proxima Centauri Risk Control employees, the Myrmidon encourages responsible adherence to protocol, its lethal mode locked until the employee properly alerts their team and raises the alarm, freeing both the employee and their employer from responsibility for any ensuring casualties."

	description_antag = "The Myrmidon can be tampered with to remove its restrictions, freeing up its lethal capabilities on Code Green."

/datum/design/item/weapon/protector
	desc = "The 'Myrmidon' is a common energy gun that cannot fired lethally on Code Green, requiring Code Blue or higher to unlock its deadly capabilities."
	id = "protector"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 2000, "silver" = 1000)
	build_path = /obj/item/gun/energy/protector
	sort_string = "TAADA"
