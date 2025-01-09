
// -- Datums -- //

/obj/overmap/entity/visitable/sector/delerictcasino
	name = "Monarch of Autumn Casino Station"
	desc = "A defunct casino station that never was finished, with the flora on board that was once the only thing on board overrunning the ship."
	scanner_desc = @{"[i]Incoming Message[/i]: SDF Message to passing ship : The Monarch of Autumn Casino Station has been formaly classified as a delerict. Please approch with caution.
[i] Casino Information [/i]
Welcome to the Monarch of Autumn Casino Station ! Building started in 2530, but multiple problemes financial wise made it impossible to finish.
Activities : Upcomming activities are : Poker, Blackjack, Slots machines, Backarat, Tajaran Poll, Restaurants, Natural Swimming pool, Movie theater, And much more !
Lifesigns: SDF note - Animals and wildlife are arround on the outer ring.
Ownership: The station is currently without a owner (Corporation went Bankrupt), and Happy Trails refused to buy it because of maintenance cost. Claiming ownership of the stations is however impossible.
Warning: While there is no regulation regarding visiting and scavenging operation on this station, the wildlife is presenting low-levels of hostility. However, the secuirty system of the vault and maintenance system is still active. Pirate and other smugglers may also use this station."}
	color = "#ff8c00" //orange ! :D
	in_space = 1
	icon_state = "fueldepot"
	known = FALSE

	initial_generic_waypoints = list(
		"casino_pad_1a",
		"casino_pad_1b",
		"casino_pad_1c",
		"casino_pad_1d",
		"casino_pad_2a",
		"casino_pad_2b",
		"casino_pad_2c",
		"casino_pad_2d",
		"casino_pad_3a",
		"casino_pad_3b",
		"casino_pad_3c",
		"casino_pad_3d",
		"casino_pad_3f",
		"casino_pad_3g",
		"casino_pad_3h"
		)

// -- Mobs -- //

/mob/living/simple_mob/mechanical/corrupt_maint_drone/weak_no_poison/casino //Faster attacks
	name = "Casino Security Drone"
	desc = "Casino Security !"
	base_attack_cooldown = 8
	legacy_melee_damage_lower = 5
	poison_chance = 0
	iff_factions = MOB_IFF_FACTION_CASINO
	color = "#ff9d00"

/mob/living/simple_mob/mechanical/corrupt_maint_drone/matriarch/casino //Tougher, but less lethal and no poison.
	name = "Derelict Casino Master Security Drone"
	desc = "A not so small, normal-looking drone. It looks like one you'd find on station, except... IT'S COMING AT YOU!"
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/corrupt_maint_drone)
	iff_factions = MOB_IFF_FACTION_CASINO

	icon_state = "corrupt-matriarch"
	icon_living = "corrupt-matriarch"
	color = "#ff9d00"

	maxHealth = 70
	health = 70
	poison_chance = 0

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10
	base_attack_cooldown =  8

/mob/living/simple_mob/mechanical/combat_drone/lesser/casino
	name = "Casino Combat Drone"
	desc = "An automated combat drone with an aged apperance."
	color = "#ff9d00"
	movement_cooldown = 10
	iff_factions = MOB_IFF_FACTION_CASINO

/mob/living/simple_mob/mechanical/combat_drone/lesser/casino/Initialize(mapload)
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

	shields = new /obj/item/shield_projector/rectangle/automatic/drone/casino(src)
	return ..()

/obj/projectile/beam/drone
	damage_force = 10

/obj/item/shield_projector/rectangle/automatic/drone/casino
	shield_health = 80
	max_shield_health = 80
	shield_regen_delay = 20 SECONDS
	shield_regen_amount = 10
	size_x = 1
	size_y = 1

/mob/living/simple_mob/animal/space/bear/brown/casino
	icon = 'icons/mob/vore.dmi'
	name = "Autumn brown bear"
	desc = "The casino had the good idea to bring Bear pups to populate the ring Forrest ! Surely they don't grow  that fast..."
	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear-dead"
	icon_gib = "bear-gib"
	iff_factions = MOB_IFF_FACTION_FARM_PET

// ----- ID ------ //

/obj/item/card/id/external/casino1
	name = "Security Casino Ship 1"
	desc = "A Casino Chip working like a ID."
	icon_state = "casino-chip"
	job_access_type = null
	color ="#ff0000f8"
	access = list(410)

/obj/item/card/id/external/casino2
	name = "Security Casino Ship 2"
	desc = "A Casino Chip working like a ID."
	icon_state = "casino-chip"
	job_access_type = null
	color ="#fff200f8"
	access = list(411)

/obj/item/card/id/external/casino3
	name = "Security Casino Ship 3"
	desc = "A Casino Chip working like a ID."
	icon_state = "casino-chip"
	job_access_type = null
	color ="#1500fff8"
	access = list(412)

//notes

/obj/item/paper/casinoatc
	name = "Faxed Letter - Final ATC note"
	info = {"2568-08-25 - Destination - Hadii's Folley : Miaphus'irra : Outpost 7 'Grey Sand' village : House 12.\
	 Hey, ill be heading back. Yes, even after that sector explosion I am still alive.\
	 But the company lost interess. Actually, they lost everything and are going bankrupt.\
	 Its me that is closing up shop. The blast got one of the room, wich was enough to get us a lawsuit with a bigger investisor.\
	 Was tasked to get the security system of the vault up and running, there might still be some valuable bits in there.\
	 Ill see you soon, Lil sis. - Neruk Mri'Jan"}

/obj/item/paper/casinolawsuit
	name = "Lawsuit Draft"
	info = {"2568-08-22 - Destination - Orion Confederatie : Earth : London - 5 Vulcan Street.\
	 (The documents itself seems to have been drench in water. However, a notes on the less damaged parts of the document are still readable).\
	 30 years that my father and myself invested in that project. And the stay I had here was dreadfull.\
	 Yes, the explosion hitting east side of the station, and destroying my room wasn't their fault, but you must understand me, my precious darling :\
	 The workers are not organised, there is no plans, the station was build in a awfull order... Looks at the plants. Sure, it was always to be a forrest,\
	 but the plants were planted 30 years ago, and are now growing out of control, at a point where recruited botanist wants a insane salary.\
	 I am affraid that I will have to sue the company. They are incopetent... We won't have our little space forrest in space, my dearest.\
	 I will return in November, my love - Daren.L"}

/obj/item/paper/casinochips
	name = "Faxed Letter - URGENT - The 3 chips"
	color = "#ffc42f"
	info = {"- We have a issue. While the staff is being all dissmissed safely, and returned to their home with compensation like planned,\
	We noticed that the 3 security poker chips are missing.\
	We have emptied the vault of the majority of its content, but we still had a few things in there.\
	Those 3 poker chips are the only thing that could open the vault. We expect them to still be lost on board.\
	The remain staff is unsure where they are :\
	One think that one was passed to the visiting investor, Daren Lachance. But his room was spaced.\
	I think Torini saw one fall in the river... Good thing they float. It was Westside.\
	No clue on the final one. A other team will have to search.\
	Before I leave myself, may I command to our dear CEO : Why did we greenlit the use of encrypted poker chips instead of keycards ?\
	Acting Director Swank"}

/obj/item/paper/casinosec
	name = "Note - Security System"
	info = {"Please use the 3 Security Casino Chip to open the shutter, they must be equipped to open the shutters. - Security Team"}

/obj/item/paper/casinowork
	name = "Note - To the Construction team"
	info = {"2556-02-04" : To the incomming construction team, please be carefull. Our boss, Benny, is a moron, the plants grew too fast and keep growing to fast.\
	The bear pup also grew. I think they ate Billy ! We sedated them, and tried to ship them away to a reserve, but the boss decided to keep 2 !\
	"ThEy ArE cUtE" he said. If you have a other contract, take it please! I think there are leeches in the water ! This station is not worth the danger !"}

/obj/item/paper/casinowork2
	name = "Letter to Kellern's Bio Farms 1"
	info = {"2535-11-08" : This is the Botanical team of the Monarch of Autumn Station.\
	The experimental "Ever Autumn" chem is making wonders to the color of the trees,\
	But we noticed that the groth rate of the flora here is out of control.\
	We only put arround 100 ounces in the ground, and now we have issues even killing the plants.\
	What can we do ?"}

/obj/item/paper/casinowork3
	name = "Letter from Kellern's Bio Farms"
	info = {"2535-11-15" : 100 Ounces ?! Didn't you read the label ?! You are supposed to only put down 5 Ounces ! You only can burn it down now !"}

/obj/item/paper/casinowork4
	name = "Orders from the boss"
	info = {"2531-01-08" : Botanical team, I want the forrest to be ready as soon as possible.\
	We found some some unlabled chems from Kellern's. They said something about quantity, but just put everything in the ground.\
	Director Benny."}

/obj/item/paper/casinowork5
	name = "Responce to the boss"
	info = {"2535-11-16" : Director Benny, we have put too much chems on your orders, and we can't kill the plants. They are growing too fast."}

/obj/item/paper/casinowork6
	name = "Orders from the boss 2"
	info = {"2535-11-16" : Oops. Oh well. You are all fired.\
	Director Benny."}
