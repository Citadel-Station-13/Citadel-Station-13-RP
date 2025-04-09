//////////////////////////////////////////
// New Kingdom of Adhomai (NKA) Firearms
///////////////////////////////////////////
/* Notes on NKA Firearms:
The New Kingdom of Adhomai (NKA) is both a backward reactionary monarchy and a space faring nation. Their technology \
is a strange mix of both laughably dated and suprisingly advanced. The political situation in the NKA was until recent \
unfavorable to technological development, as such the NKA has a bevy of extremely dated weapons that are noticably \
behind their counterparts on Adhomai. A newly empowered faction within the Royal Court led by the crown prince \
believes that the NKA can modernize into a technofuedal state and are vigorously pursuing modernization with a \
traditional twist. As a result the advanced tech of the NKA serve to reinforce traditional values and feudalism. \
Their weapon design reflects this as even advanced weapons have traditional elements. Ideally advanced weapons of \
the NKA use some handcrafted parts at the very least. Many also have aesthetics reminescent of a fuedal ideal \
as their noble knights can't be knightly unless their weapons are ornate enough. */

///////////////////
//One Handed
///////////////////

// todo: default-unloaded, add /loaded
/obj/item/gun/projectile/ballistic/revolver/mateba/taj
	name = "Adhomai revolver"
	desc = "The Akhan and Khan Royal Service Revolver. Sophisticated but dated, this weapon is a metaphor for the New Kingdom of Adhomai itself."
	icon = 'icons/content/factions/tajara/items/guns/taj_revolver.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_revolver.dmi'
	icon_state = "revolver"
	item_state = "revolver"
	render_use_legacy_by_default = FALSE

// todo: default-unloaded, add /loaded
/obj/item/gun/projectile/ballistic/revolver/mateba/taj/knife
	name = "Adhomai knife revolver"
	desc = "An ornate knife revolver from an Adhomai gunsmith. Popular among Tajaran nobility just before the civil war, many of these revolvers \
	found their way into the market when they were taken as trophies by Grand People's Army soldiers and DPRA guerillas."
	icon_state = "knifegun"
	item_state = "knifegun"
	caliber = /datum/ammo_caliber/a38
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a38
	internal_magazine_size = 15
	damage_force = 15
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	render_use_legacy_by_default = FALSE

///////////////////
//Two Handed
///////////////////

// todo: default-unloaded, add /loaded
/obj/item/gun/projectile/ballistic/shotgun/pump/rifle/taj
	name = "Adhomai bolt action rifle"
	desc = "The Arkhan & Khan carbine (or just A&K-c) bolt action rifle was adopted by the New Kingdom just after the outbreak of the Adhomai civil war. \
	After many decades of service it is finally been retired as the New Kingdom embraces modern firearms."
	icon = 'icons/content/factions/tajara/items/guns/taj_boltaction.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_boltaction.dmi'
	icon_state = "boltaction"
	item_state = "boltaction"
	wielded_item_state = "boltaction-wielded"
	render_use_legacy_by_default = FALSE

// todo: default-unloaded, add /loaded
/obj/item/gun/projectile/ballistic/automatic/sts35/taj
	name = "Adhomai assault rifle"
	desc = "The Arkhan & Khan 'Halbred' battle rifle uses wooden furniture and brass banding to diguise the fact that it's internals are a knock-off of Hephaestus \
	Industries' STS-35. The New Kingdom of Adhomai only recently adopted this rifle which it is already rolling out in massive numbers. A feat some say is \
	beyond the Industrial capabilities of the New Kingdom leading many to speculate that some of the rifles are foriegn supplied."
	icon = 'icons/content/factions/tajara/items/guns/taj_arifle.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_arifle.dmi'
	icon_state = "arifle"
	item_state = "arifle"
	wielded_item_state = "arifle-wielded"
	render_use_legacy_by_default = FALSE

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(60,45,40), dispersion=list(0.0, 0.8, 0.8))
		)

///////////////////
//Energy
///////////////////
/obj/item/gun/projectile/energy/retro/taj
	name = "Adhomai dueling laser"
	desc = "The New Kingdom of Adhomai's was resistant to the adoption of energy weapons until an enterprising Tajara technician presented the crown prince with a ornate \
	laser pistol built in the style of old flintlock dueling pistols. As planned laser mania instantly took over NKA high society and laser pistols such as these became \
	a must have item for even the most traditional noble. Increasingly these pistols are finding their way to the frontier as their style brings in customers outside \
	of Adhomai."
	icon = 'icons/content/factions/tajara/items/guns/taj_duelinglaser.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_duelinglaser.dmi'
	icon_state = "retro"
	item_state = "retro"
	render_use_legacy_by_default = FALSE
