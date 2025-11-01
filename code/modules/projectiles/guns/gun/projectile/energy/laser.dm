/datum/firemode/energy/laser_rifle
	abstract_type = /datum/firemode/energy/laser_rifle

/datum/firemode/energy/laser_rifle/normal
	name = "normal"
	cycle_cooldown = 0.8 SECONDS
	projectile_type = /obj/projectile/beam/midlaser
	charge_cost = 2400 / 10

/datum/firemode/energy/laser_rifle/suppression
	name = "suppressive"
	cycle_cooldown = 0.4 SECONDS
	projectile_type = /obj/projectile/beam/weaklaser
	charge_cost = 2400 / 40

/obj/item/gun/projectile/energy/laser
	name = "laser rifle"
	desc = "A Hephaestus Industries G40E rifle, designed to kill with concentrated energy blasts.  This variant has the ability to \
	switch between standard fire and a more efficient but weaker 'suppressive' fire."
	icon_state = "laser"
	item_state = "laser"
	wielded_item_state = "laser-wielded"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2000)
	heavy = TRUE
	one_handed_penalty = 30
	worth_intrinsic = 350

	firemodes = list(
		/datum/firemode/energy/laser_rifle/normal,
		/datum/firemode/energy/laser_rifle/suppression,
	)

/obj/item/gun/projectile/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1
	one_handed_penalty = 0 // Not sure if two-handing gets checked for mounted weapons, but better safe than sorry.

/obj/item/gun/projectile/energy/laser/mounted/augment
	use_external_power = FALSE
	use_organic_power = TRUE

/obj/item/gun/projectile/energy/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."

	firemodes = /datum/firemode/energy{
		name = "normal";
		projectile_type = /obj/projectile/beam/practice;
		charge_cost = 2400 / 80;
		cycle_cooldown = 0.4 SECONDS;
	}

/obj/item/gun/projectile/energy/retro
	name = "retro laser"
	icon_state = "retro"
	item_state = "retro"
	desc = "An older model of the basic lasergun. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL

	firemodes = /datum/firemode/energy{
		name = "normal";
		charge_cost = 2400 / 10;
		projectile_type = /obj/projectile/beam;
		cycle_cooldown = 1 SECONDS;
	}

/obj/item/gun/projectile/energy/retro/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/gun/projectile/energy/retro/empty
	icon_state = "retro"
	cell_type = null

/obj/item/gun/projectile/energy/retro/apidean
	name = "apidean retro laser"
	icon_state = "apilaser"
	desc = "An older model of the basic lasergun. This version's casing has been painted yellow. Originating from, and carried by, Apidean combatants, it's unclear where they obtained them."

/datum/category_item/catalogue/anomalous/precursor_a/alien_pistol
	name = "Precursor Alpha Weapon - Appendageheld Laser"
	desc = "This object strongly resembles a weapon, and if one were to pull the \
	trigger located on the handle of the object, it would fire a deadly \
	laser at whatever it was pointed at. The beam fired appears to cause too \
	much damage to whatever it would hit to have served as a long ranged repair tool, \
	therefore this object was most likely designed to be a deadly weapon. If so, this \
	has several implications towards its creators;\
	<br><br>\
	Firstly, it implies that these precursors, at some point during their development, \
	had needed to defend themselves, or otherwise had a need to utilize violence, and \
	as such created better tools to do so. It is unclear if violence was employed against \
	themselves as a form of in-fighting, or if violence was exclusive to outside species.\
	<br><br>\
	Secondly, the shape and design of the weapon implies that the creators of this \
	weapon were able to grasp objects, and be able to manipulate the trigger independently \
	from merely holding onto the weapon, making certain types of appendages like tentacles be \
	unlikely.\
	<br><br>\
	An interesting note about this weapon, when compared to contemporary energy weapons, is \
	that this gun appears to utilize some sort of exotic particle beam instead of being a laser \
	or plasma. The beam fired is decently capable of causing damage, and the power consumption is close \
	to that of a human-made energy side-arm. One possible explaination is that the creators of this \
	weapon, in their later years, had less of a need to optimize their capability for war, \
	and instead focused on other endeavors. Another explaination is that vast age of the weapon \
	may have caused it to degrade, yet still remain functional at a reduced capability."
	value = CATALOGUER_REWARD_MEDIUM

/obj/item/gun/projectile/energy/alien
	name = "alien pistol"
	desc = "A weapon that works very similarly to a traditional energy weapon. How this came to be will likely be a mystery for the ages."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_pistol)
	icon_state = "alienpistol"
	item_state = "alienpistol"

	firemodes = /datum/firemode/energy {
		projectile_type = /obj/projectile/beam/cyan;
		charge_cost = 2400 / 10;
		cycle_cooldown = 1 SECONDS;
	}

	cell_type = /obj/item/cell/device/weapon/recharge/alien // Self charges.
	origin_tech = list(TECH_COMBAT = 8, TECH_MAGNET = 7)
	modifystate = "alienpistol"

/obj/item/gun/projectile/energy/captain
	name = "antique laser gun"
	icon_state = "caplaser"
	item_state = "caplaser"
	desc = "A rare weapon, handcrafted by a now defunct specialty manufacturer on Luna for a small fortune. It's certainly aged well."
	damage_force = 5
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	w_class = WEIGHT_CLASS_NORMAL
	projectile_type = /obj/projectile/beam
	charge_cost = /obj/item/cell/device/weapon/recharge/captain::maxcharge / 5
	cell_type = /obj/item/cell/device/weapon/recharge/captain
	legacy_battery_lock = 1

/obj/item/gun/projectile/energy/lasercannon
	name = "laser cannon"
	desc = "The Hephaestus Industries G80E encloses the lasing medium within a tube lined with uranium-235 and subjected to high-neutron flux via a miniature nuclear reactor, necessitating brief periods between shots for the components to cool down. In layman's terms, big laser gets hot."
	icon_state = "lasercannon"
	item_state = null
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	slot_flags = SLOT_BELT|SLOT_BACK
	projectile_type = /obj/projectile/beam/heavylaser/cannon
	firemodes = /datum/firemode/energy{
		cycle_cooldown = 2 SECONDS;
	}
	legacy_battery_lock = 1
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	one_handed_penalty = 90 // The thing's heavy and huge.
	accuracy = 75
	charge_cost = 600

/obj/item/gun/projectile/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	//accuracy = 0 // Mounted cannons are just fine the way they are.
	one_handed_penalty = 0 // Not sure if two-handing gets checked for mounted weapons, but better safe than sorry.
	projectile_type = /obj/projectile/beam/heavylaser
	charge_cost = 400

/obj/item/gun/projectile/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun, the experimental NT-XRD fire concentrated x-ray blasts, capable of penetrating armor far better than standard photonic lasers. A potent 'anti-armor' weapon."
	icon_state = "xray"
	heavy = TRUE
	item_state = "xray"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	projectile_type = /obj/projectile/beam/xray
	charge_cost = 200
	worth_intrinsic = 500 // op as balls

/obj/item/gun/projectile/energy/sniperrifle
	name = "marksman energy rifle"
	desc = "The HI DMR 9E is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful \
	ionized beams, this is a weapon to kill from a distance."
	description_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly.  To recharge this weapon, use a weapon recharger. \
	To use the scope, use the appropriate verb in the object tab."
	icon_state = "sniper"
	item_state = "sniper"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "z8carbine", SLOT_ID_LEFT_HAND = "z8carbine") //placeholder
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)

	worth_intrinsic = 750

	projectile_type = /obj/projectile/beam/sniper
	firemodes = /datum/firemode/energy{
		cycle_cooldown = 3.5 SECONDS;
	}
	slot_flags = SLOT_BACK
	charge_cost = 600
	damage_force = 10
	heavy = TRUE
	w_class = WEIGHT_CLASS_HUGE // So it can't fit in a backpack.
	accuracy = 25 //shooting at the hip
	scoped_accuracy = 80
//	requires_two_hands = 1
	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.

/obj/item/gun/projectile/energy/sniperrifle/verb/scope()
	set category = VERB_CATEGORY_OBJECT
	set name = "Use Scope"
	set popup_menu = 1
	set src in usr

	toggle_scope(2.0)

/obj/item/gun/projectile/energy/sniperrifle/locked
	name = "expedition marksman energy rifle"
	desc = "A modified version of the HI DMR 9E with a replacement firing pin and reduced shot capacity in exchange for a self recharging cell."
	pin = /obj/item/firing_pin/explorer
	cell_type = /obj/item/cell/device/weapon/recharge/sniper
	accuracy = 45 //Modifications include slightly better hip-firing furniture.
	legacy_battery_lock = 1 //With the change that the normal DMR can now change the weapon cell, we need to add this here so people can't take out the self-recharging special cell.
	scoped_accuracy = 100
	charge_cost = 600

/obj/item/gun/projectile/energy/monorifle
	name = "antique mono-rifle"
	desc = "An old laser rifle. This one can only fire once before requiring recharging."
	description_fluff = "Modeled after ancient hunting rifles, this rifle was dubbed the 'Rainy Day Special' by some, due to its use as some barmens' fight-stopper of choice. One shot is all it takes, or so they say."
	icon_state = "eshotgun"
	item_state = "shotgun"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_POWER = 3)
	projectile_type = /obj/projectile/beam/sniper
	slot_flags = SLOT_BACK
	charge_cost = 1300
	damage_force = 8
	heavy = TRUE
	w_class = WEIGHT_CLASS_BULKY
	accuracy = 70
	scoped_accuracy = 95
	var/scope_multiplier = 1.5

/obj/item/gun/projectile/energy/monorifle/verb/sights()
	set category = VERB_CATEGORY_OBJECT
	set name = "Aim Down Sights"
	set popup_menu = 1
	set src in usr

	toggle_scope(scope_multiplier)

/obj/item/gun/projectile/energy/monorifle/combat
	name = "combat mono-rifle"
	desc = "A modernized version of the mono-rifle. This one can fire twice before requiring recharging."
	description_fluff = "A modern design produced by a company once working from Saint Columbia, based on the antique mono-rifle 'Rainy Day Special' design."
	icon_state = "ecshotgun"
	item_state = "cshotgun"
	charge_cost = 1000
	damage_force = 12
	accuracy = 70
	scoped_accuracy = 95

////////Laser Tag////////////////////

/obj/item/gun/projectile/energy/lasertag
	name = "laser tag gun"
	item_state = "laser"
	desc = "Based off an ancient model of laser gun, the NT-Tagger will make you the terror of the next workplace lasertag tournament."
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2000)
	projectile_type = /obj/projectile/beam/lasertag/blue
	cell_type = /obj/item/cell/device/weapon/recharge
	legacy_battery_lock = 1
	suit_storage_class = SUIT_STORAGE_CLASS_HARDWEAR | SUIT_STORAGE_CLASS_SOFTWEAR

/obj/item/gun/projectile/energy/lasertag/blue
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/projectile/beam/lasertag/blue
	pin = /obj/item/firing_pin/tag/blue

/obj/item/gun/projectile/energy/lasertag/red
	icon_state = "redtag"
	item_state = "redtag"
	projectile_type = /obj/projectile/beam/lasertag/red
	pin = /obj/item/firing_pin/tag/red

/obj/item/gun/projectile/energy/lasertag/omni
	projectile_type = /obj/projectile/beam/lasertag/omni

// Laser scattergun, proof of concept.

/obj/item/gun/projectile/energy/lasershotgun
	name = "laser scattergun"
	item_state = "laser"
	icon_state = "scatter"
	desc = "A strange Almachi weapon, utilizing a refracting prism to turn a single laser blast into a diverging cluster."
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 1, TECH_MATERIAL = 4)
	heavy = TRUE
	projectile_type = /obj/projectile/scatter/laser

// Other laser guns.

/obj/item/gun/projectile/energy/tommylaser
	name = "M-2421 'Tommy-Laser'"
	desc = "A automatic laser weapon resembling a Tommy-Gun. Designed by Cybersun Industries to be a man portable supressive fire laser weapon."
	icon_state = "tommylas"
	item_state = "tommylas"
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	slot_flags = SLOT_BACK
	charge_cost = 60 // 40 shots, lay down the firepower
	projectile_type = /obj/projectile/beam/weaklaser
	cell_type = /obj/item/cell/device/weapon
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 5, TECH_ILLEGAL = 3)

	firemodes = list(
		list(mode_name="single shot", burst = 1, fire_delay=4, move_delay=null, burst_accuracy = null, dispersion = null),
		list(mode_name="three shot bursts", burst=3, fire_delay=10 , move_delay=4,    burst_accuracy=list(65,65,65), dispersion=list(1,1,1)),
		list(mode_name="short bursts",	burst=5, fire_delay=10 ,move_delay=6, burst_accuracy = list(65,65,65,65,65), dispersion = list(4,4,4,4,4)),
		)

/obj/item/gun/projectile/energy/zip
	name = "Zip-Las"
	desc = "A homemade (and somehow safe) laser gun designed around shooting single powerful laser beam draining the cell entirely. Better not miss and better have spare cells."
	icon_state = "ziplas"
	item_state = "ziplas"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT|SLOT_BACK
	charge_cost = 1500 //You got 1 shot...
	projectile_type = /obj/projectile/beam/heavylaser //But it hurts a lot
	cell_type = /obj/item/cell/device/weapon
	unstable = 1

//NT SpecOps Laser Rifle
/obj/item/gun/projectile/energy/combat
	name = "NT-LR-4 laser rifle"
	desc = "A sturdy laser rifle fine tuned for Nanotrasen special operations. More reliable than mass production models, this weapon was designed to kill, and nothing else."
	icon_state = "clrifle"
	item_state = "clrifle"
	firemodes = /datum/firemode/energy{
		cycle_cooldown = 0.6 SECONDS;
	}
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2000, "plastic" = 1000)
	projectile_type = /obj/projectile/beam/midlaser
	heavy = FALSE
	one_handed_penalty = 25

	firemodes = list(
		list(mode_name="normal", fire_delay=6, projectile_type=/obj/projectile/beam/midlaser, charge_cost = 200),
		list(mode_name="suppressive", fire_delay=3, projectile_type=/obj/projectile/beam/weaklaser, charge_cost = 50),
		)
