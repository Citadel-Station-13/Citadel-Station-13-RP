
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
	that this gun appears to be inferior to modern laser weapons. The beam fired has less \
	of an ability to harm, and the power consumption appears to be higher than average for \
	a human-made energy side-arm. One possible explaination is that the creators of this \
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
	fire_delay = 10 // Handguns should be inferior to two-handed weapons. Even alien ones I suppose.
	charge_cost = 480 // Five shots.

	projectile_type = /obj/projectile/beam/cyan
	cell_initial = /obj/item/cell/device/weapon/recharge/alien // Self charges.
	origin_tech = list(TECH_COMBAT = 8, TECH_MAGNET = 7)
	modifystate = "alienpistol"

