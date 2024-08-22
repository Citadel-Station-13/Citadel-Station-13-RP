//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/item/gun/ballistic/nt_expeditionary/light_rifle
	abstract_type = /obj/item/gun/ballistic/nt_expeditionary/light_rifle
	caliber = /datum/ammo_caliber/nt_expeditionary/light_rifle

#warn sprites

/obj/item/gun/ballistic/nt_expeditionary/light_rifle/pistol
	name = "high-caliber pistol"
	desc = "The XNP Mk.9 \"David\" pistol; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		An oddball of a pistol, the Mark 9 was made as little more than a proof of concept.
		Chambering 7.5x39mm light rifle ammunition, the "David" sidearm is capable of consistently,
		and accurately (for its uncanny size) punching above its paygrade.
		Unfortunately, the downsides of using such a heavy caliber in a pistol limits its
		practical use. This is nonetheless seen now and then in the hands of enthusiasts.
	"} + "<br>" +/obj/item/gun/ballistic/nt_expeditionary::description_fluff

/obj/item/gun/ballistic/nt_expeditionary/light_rifle/semirifle
	name = "semi-automatic rifle"
	desc = "The XNR Mk.4 \"Scout\" light rifle; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		The basis of a new family of carbines developed to make use of 7.5x39mm ammunition,
		the “Scout is a traditional pattern of semi-automatic rifle with a mid-length barrel and
		adjustable stock, using a short stroke gas piston to cycle the action.
		The basic design is fitted with a zero magnification optic and comes packaged with
		relatively compact magazines. However, larger magazines will also work with this
		workhorse of a weapon.
	"} + "<br>" +/obj/item/gun/ballistic/nt_expeditionary::description_fluff

/obj/item/gun/ballistic/nt_expeditionary/light_rifle/autorifle
	name = "automatic rifle"
	desc = "The XNR Mk.4 Mod.1 \"Auto Scout\" light rifle; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		The first modification of the Mk.4 carbine, the “Auto Scout” is the next logical step
		of the platform by adding an automatic fire control group. Still using the same short-stroke
		gas piston and featuring a compensator on the end to help control recoil,
		this rifle still sports a zero-magnification optic and adds a short vertical grip as
		standard to the forward handguard. Issued with larger magazines to make better use of
		the automatic fire this weapon is capable of.
	"} + "<br>" +/obj/item/gun/ballistic/nt_expeditionary::description_fluff

/obj/item/gun/ballistic/nt_expeditionary/light_rifle/pdw
	name = "personal defense weapon"
	desc = "The XNR Mk.4 Mod.2 \"Little Scout\" personal defense weapon; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Taking the concept of the original “Scout” and chopping the barrel, this weapon is lighter,
		more handy, and easier to carry when you need something more than a pistol,
		but a rifle would interfere with other duties. Sticking to the semi-automatic fire
		control of the parent, but chopping the barrel and adding the compensator of the Mod.1,
		this weapon's ability to fold away helps make it easy to package and
		store inside cramped cockpits and into survival kits with its compact magazines.
	"} + "<br>" +/obj/item/gun/ballistic/nt_expeditionary::description_fluff

/obj/item/gun/ballistic/nt_expeditionary/light_rifle/lmg
	name = "squad automatic weapon"
	desc = "The XNR Mk.4 Mod.3 \"Machine Scout\" squad automatic weapon; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		The final entry of the “Scout” series, the “Machine Scout” makes use of a heavier barrel,
		a recoil compensating gyro on the bottom of the handguard,
		and the option to feed from larger box and drum magazines, this gives a heavy punch to
		recon teams and security units while keeping a common set of parts
		to reduce the complexities of servicing and maintaining the series as a whole.
	"} + "<br>" +/obj/item/gun/ballistic/nt_expeditionary::description_fluff

#warn impl all
