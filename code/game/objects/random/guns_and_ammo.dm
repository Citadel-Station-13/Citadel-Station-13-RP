/obj/random/gun/random
	name = "Random Weapon"
	desc = "This is a random energy or ballistic weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energystun100"

/obj/random/gun/random/item_to_spawn()
	return pick(prob(5);/obj/random/energy,
				prob(5);/obj/random/projectile/random)

/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"

/obj/random/energy/item_to_spawn()
	return pick(prob(3);/obj/item/gun/energy/laser,
				prob(4);/obj/item/gun/energy/gun,
				prob(3);/obj/item/gun/energy/gun/burst,
				prob(1);/obj/item/gun/energy/gun/nuclear,
				prob(1);/obj/item/gun/energy/tommylaser,
				prob(5);/obj/item/gun/energy/zip,
				prob(2);/obj/item/gun/energy/retro,
				prob(2);/obj/item/gun/energy/lasercannon,
				prob(3);/obj/item/gun/energy/xray,
				prob(1);/obj/item/gun/energy/sniperrifle,
				prob(1);/obj/item/gun/energy/plasmastun,
				prob(2);/obj/item/gun/energy/ionrifle,
				prob(2);/obj/item/gun/energy/ionrifle/pistol,
				prob(3);/obj/item/gun/energy/toxgun,
				prob(4);/obj/item/gun/energy/taser,
				prob(4);/obj/item/gun/energy/taser/civ,
				prob(2);/obj/item/gun/energy/crossbow/largecrossbow,
				prob(4);/obj/item/gun/energy/stunrevolver)

/obj/random/energy/sec
	name = "Random Security Energy Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"

/obj/random/energy/sec/item_to_spawn()
	return pick(prob(2);/obj/item/gun/energy/laser,
				prob(2);/obj/item/gun/energy/gun)

/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/projectile/item_to_spawn()
	return pick(prob(3);/obj/item/gun/projectile/automatic/wt550,
				prob(3);/obj/item/gun/projectile/automatic/mini_uzi,
				prob(3);/obj/item/gun/projectile/automatic/tommygun,
				prob(2);/obj/item/gun/projectile/automatic/c20r,
				prob(2);/obj/item/gun/projectile/automatic/sts35,
				prob(2);/obj/item/gun/projectile/automatic/z8,
				prob(1);/obj/item/gun/projectile/automatic/fal,
				prob(4);/obj/item/gun/projectile/colt,
				prob(2);/obj/item/gun/projectile/deagle,
				prob(1);/obj/item/gun/projectile/deagle/camo,
				prob(1);/obj/item/gun/projectile/deagle/gold,
				prob(3);/obj/item/gun/projectile/derringer,
				prob(1);/obj/item/gun/projectile/heavysniper,
				prob(4);/obj/item/gun/projectile/luger,
				prob(3);/obj/item/gun/projectile/luger/brown,
				prob(4);/obj/item/gun/projectile/sec,
				prob(3);/obj/item/gun/projectile/sec/wood,
				prob(4);/obj/item/gun/projectile/r9,
				prob(4);/obj/item/gun/projectile/p92x,
				prob(3);/obj/item/gun/projectile/p92x/brown,
				prob(4);/obj/item/gun/projectile/pistol,
				prob(5);/obj/item/gun/projectile/pirate,
				prob(2);/obj/item/gun/projectile/revolver,
				prob(4);/obj/item/gun/projectile/revolver/deckard,
				prob(4);/obj/item/gun/projectile/revolver/detective,
				prob(2);/obj/item/gun/projectile/revolver/judge,
				prob(3);/obj/item/gun/projectile/revolver/lemat,
				prob(2);/obj/item/gun/projectile/revolver/mateba,
				prob(2);/obj/item/gun/projectile/revolver/dirty_harry,
				prob(4);/obj/item/gun/projectile/shotgun/doublebarrel,
				prob(3);/obj/item/gun/projectile/shotgun/doublebarrel/sawn,
				prob(2);/obj/item/gun/projectile/shotgun/doublebarrel/quad,
				prob(3);/obj/item/gun/projectile/shotgun/pump,
				prob(3);/obj/item/gun/projectile/shotgun/pump/rifle/lever/arnold,
				prob(2);/obj/item/gun/projectile/shotgun/pump/combat,
				prob(4);/obj/item/gun/projectile/shotgun/pump/rifle,
				prob(3);/obj/item/gun/projectile/shotgun/pump/rifle/lever,
				prob(3);/obj/item/gun/projectile/shotgun/pump/rifle/lever/win1895,
				prob(2);/obj/item/gun/projectile/silenced)

/obj/random/projectile/sec
	name = "Random Security Projectile Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/projectile/sec/item_to_spawn()
	return pick(prob(3);/obj/item/gun/projectile/shotgun/pump,
				prob(2);/obj/item/gun/projectile/automatic/wt550,
				prob(1);/obj/item/gun/projectile/shotgun/pump/combat)

/obj/random/projectile/shotgun
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "shotgun"

/obj/random/projectile/item_to_spawn()
	return pick(prob(4);/obj/item/gun/projectile/shotgun/doublebarrel,
				prob(3);/obj/item/gun/projectile/shotgun/doublebarrel/sawn,
				prob(3);/obj/item/gun/projectile/shotgun/pump,
				prob(2);/obj/item/gun/projectile/shotgun/doublebarrel/quad,
				prob(1);/obj/item/gun/projectile/shotgun/pump/combat)

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"

/obj/random/handgun/item_to_spawn()
	return pick(prob(4);/obj/item/gun/projectile/sec,
				prob(4);/obj/item/gun/projectile/p92x,
				prob(4);/obj/item/gun/projectile/r9,
				prob(3);/obj/item/gun/projectile/sec/wood,
				prob(3);/obj/item/gun/projectile/p92x/brown,
				prob(3);/obj/item/gun/projectile/colt,
				prob(2);/obj/item/gun/projectile/luger,
				prob(2);/obj/item/gun/energy/gun,
				prob(2);/obj/item/gun/projectile/pistol,
				prob(1);/obj/item/gun/energy/retro,
				prob(1);/obj/item/gun/projectile/luger/brown)

/obj/random/handgun/sec
	name = "Random Security Handgun"
	desc = "This is a random security sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"

/obj/random/handgun/sec/item_to_spawn()
	return pick(prob(3);/obj/item/gun/projectile/sec,
				prob(1);/obj/item/gun/projectile/sec/wood)

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random security ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"

/obj/random/ammo/item_to_spawn()
	return pick(prob(6);/obj/item/storage/box/beanbags,
				prob(2);/obj/item/storage/box/shotgunammo,
				prob(4);/obj/item/storage/box/shotgunshells,
				prob(1);/obj/item/storage/box/stunshells,
				prob(2);/obj/item/ammo_magazine/m45,
				prob(4);/obj/item/ammo_magazine/m45/rubber,
				prob(4);/obj/item/ammo_magazine/m45/flash,
				prob(2);/obj/item/ammo_magazine/m9mmt,
				prob(6);/obj/item/ammo_magazine/m9mmt/rubber)

/obj/random/projectile/random
	name = "Random Projectile Weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/projectile/random/item_to_spawn()
	return pick(prob(3);/obj/random/multiple/gun/projectile/handgun,
				prob(2);/obj/random/multiple/gun/projectile/smg,
				prob(2);/obj/random/multiple/gun/projectile/shotgun,
				prob(1);/obj/random/multiple/gun/projectile/rifle)

/obj/random/multiple/gun/projectile/smg
	name = "random smg projectile gun"
	desc = "Loot for PoIs."
	icon = 'icons/obj/gun.dmi'
	icon_state = "saber"

/obj/random/multiple/gun/projectile/smg/item_to_spawn()
	return pick(
			prob(3);list(
				/obj/item/gun/projectile/automatic/wt550,
				/obj/item/ammo_magazine/m9mmt,
				/obj/item/ammo_magazine/m9mmt
			),
			prob(3);list(
				/obj/item/gun/projectile/automatic/mini_uzi,
				/obj/item/ammo_magazine/m45uzi,
				/obj/item/ammo_magazine/m45uzi
			),
			prob(3);list(
				/obj/item/gun/projectile/automatic/tommygun,
				/obj/item/ammo_magazine/m45tommy,
				/obj/item/ammo_magazine/m45tommy
			),
			prob(2);list(
				/obj/item/gun/projectile/automatic/c20r,
				/obj/item/ammo_magazine/m10mm,
				/obj/item/ammo_magazine/m10mm
			),
			prob(1);list(
				/obj/item/gun/projectile/automatic/p90,
				/obj/item/ammo_magazine/m9mmp90
			)
		)

/obj/random/multiple/gun/projectile/rifle
	name = "random rifle projectile gun"
	desc = "Loot for PoIs."
	icon = 'icons/obj/gun.dmi'
	icon_state = "carbine"

//Concerns about the bullpup, but currently seems to be only a slightly stronger z8. But we shall see.

/obj/random/multiple/gun/projectile/rifle/item_to_spawn()
	return pick(
			prob(2);list(
				/obj/item/gun/projectile/automatic/sts35,
				/obj/item/ammo_magazine/m545,
				/obj/item/ammo_magazine/m545
			),
			prob(2);list(
				/obj/item/gun/projectile/automatic/z8,
				/obj/item/ammo_magazine/m762,
				/obj/item/ammo_magazine/m762
			),
			prob(4);list(
				/obj/item/gun/projectile/shotgun/pump/rifle,
				/obj/item/ammo_magazine/clip/c762,
				/obj/item/ammo_magazine/clip/c762
			),
			prob(3);list(
				/obj/item/gun/projectile/shotgun/pump/rifle/lever/win1895,
				/obj/item/ammo_magazine/clip/c762,
				/obj/item/ammo_magazine/clip/c762
			),
			prob(1);list(
				/obj/item/gun/projectile/garand,
				/obj/item/ammo_magazine/m762garand,
				/obj/item/ammo_magazine/m762garand
			),
			prob(1);list(
				/obj/item/gun/projectile/automatic/bullpup,
				/obj/item/ammo_magazine/m762,
				/obj/item/ammo_magazine/m762
			)
		)

/obj/random/multiple/gun/projectile/handgun
	name = "random handgun projectile gun"
	desc = "Loot for PoIs."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/multiple/gun/projectile/handgun/item_to_spawn()
	return pick(
			prob(5);list(
				/obj/item/gun/projectile/colt,
				/obj/item/ammo_magazine/m45,
				/obj/item/ammo_magazine/m45
			),
			prob(4);list(
				/obj/item/gun/projectile/contender,
				/obj/item/ammo_magazine/s357,
				/obj/item/ammo_magazine/s357
			),
			prob(3);list(
				/obj/item/gun/projectile/contender/tacticool,
				/obj/item/ammo_magazine/s357,
				/obj/item/ammo_magazine/s357
			),
			prob(2);list(
				/obj/item/gun/projectile/deagle,
				/obj/item/ammo_magazine/m44,
				/obj/item/ammo_magazine/m44
			),
			prob(1);list(
				/obj/item/gun/projectile/deagle/camo,
				/obj/item/ammo_magazine/m44,
				/obj/item/ammo_magazine/m44
			),
			prob(1);list(
				/obj/item/gun/projectile/deagle/gold,
				/obj/item/ammo_magazine/m44,
				/obj/item/ammo_magazine/m44
			),
			prob(4);list(
				/obj/item/gun/projectile/derringer,
				/obj/item/ammo_magazine/s357,
				/obj/item/ammo_magazine/s357
			),
			prob(5);list(
				/obj/item/gun/projectile/luger,
				/obj/item/ammo_magazine/m9mm/compact,
				/obj/item/ammo_magazine/m9mm/compact
			),
			prob(4);list(
				/obj/item/gun/projectile/luger/brown,
				/obj/item/ammo_magazine/m9mm/compact,
				/obj/item/ammo_magazine/m9mm/compact
			),
			prob(5);list(
				/obj/item/gun/projectile/sec,
				/obj/item/ammo_magazine/m45,
				/obj/item/ammo_magazine/m45
			),
			prob(4);list(
				/obj/item/gun/projectile/sec/wood,
				/obj/item/ammo_magazine/m45,
				/obj/item/ammo_magazine/m45
			),
			prob(5);list(
				/obj/item/gun/projectile/p92x,
				/obj/item/ammo_magazine/m9mm,
				/obj/item/ammo_magazine/m9mm
			),
			prob(5);list(
				/obj/item/gun/projectile/r9,
				/obj/item/ammo_magazine/clip/c9mm,
				/obj/item/ammo_magazine/clip/c9mm
			),
			prob(4);list(
				/obj/item/gun/projectile/p92x/brown,
				/obj/item/ammo_magazine/m9mm,
				/obj/item/ammo_magazine/m9mm
			),
			prob(2);list(
				/obj/item/gun/projectile/p92x/large,
				/obj/item/ammo_magazine/m9mm/large,
				/obj/item/ammo_magazine/m9mm/large
			),
			prob(5);list(
				/obj/item/gun/projectile/pistol,
				/obj/item/ammo_magazine/m9mm/compact,
				/obj/item/ammo_magazine/m9mm/compact
			),
			prob(2);list(
				/obj/item/gun/projectile/silenced,
				/obj/item/ammo_magazine/m45,
				/obj/item/ammo_magazine/m45
			),
			prob(2);list(
				/obj/item/gun/projectile/revolver,
				/obj/item/ammo_magazine/s357,
				/obj/item/ammo_magazine/s357
			),
			prob(4);list(
				/obj/item/gun/projectile/revolver/deckard,
				/obj/item/ammo_magazine/s38,
				/obj/item/ammo_magazine/s38
			),
			prob(4);list(
				/obj/item/gun/projectile/revolver/detective,
				/obj/item/ammo_magazine/s38,
				/obj/item/ammo_magazine/s38
			),
			prob(2);list(
				/obj/item/gun/projectile/revolver/judge,
				/obj/item/ammo_magazine/clip/c12g,
				/obj/item/ammo_magazine/clip/c12g,
				/obj/item/ammo_magazine/clip/c12g
			),
			prob(2);list(
				/obj/item/gun/projectile/revolver/lemat,
				/obj/item/ammo_magazine/s38,
				/obj/item/ammo_magazine/s38,
				/obj/item/ammo_magazine/clip/c12g
			),
			prob(2);list(
				/obj/item/gun/projectile/revolver/mateba,
				/obj/item/ammo_magazine/s357,
				/obj/item/ammo_magazine/s357
			),
			prob(2);list(
				/obj/item/gun/projectile/revolver/webley,
				/obj/item/ammo_magazine/s44,
				/obj/item/ammo_magazine/s44
			),
			prob(2);list(
				/obj/item/gun/projectile/revolver/dirty_harry,
				/obj/item/ammo_magazine/s44,
				/obj/item/ammo_magazine/s44
			),
			prob(1);list(
				/obj/item/gun/projectile/revolver/webley/auto,
				/obj/item/ammo_magazine/s44,
				/obj/item/ammo_magazine/s44
			)
		)

/obj/random/multiple/gun/projectile/shotgun
	name = "random shotgun projectile gun"
	desc = "Loot for PoIs."
	icon = 'icons/obj/gun.dmi'
	icon_state = "shotgun"

/obj/random/multiple/gun/projectile/shotgun/item_to_spawn()
	return pick(
			prob(4);list(
				/obj/item/gun/projectile/shotgun/doublebarrel/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet
			),
			prob(3);list(
				/obj/item/gun/projectile/shotgun/doublebarrel/sawn,
				/obj/item/ammo_magazine/clip/c12g/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet
			),
			prob(3);list(
				/obj/item/gun/projectile/shotgun/doublebarrel/quad,
				/obj/item/ammo_magazine/clip/c12g/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet,
				/obj/item/ammo_magazine/clip/c12g/pellet
			),
			prob(3);list(
				/obj/item/gun/projectile/shotgun/pump/slug,
				/obj/item/storage/box/shotgunammo
			),
			prob(1);list(
				/obj/item/gun/projectile/shotgun/pump/combat,
				/obj/item/storage/box/shotgunammo
			)
		)


/obj/random/weapon // For Gateway maps and Syndicate. Can possibly spawn almost any gun in the game.
	name = "Random Illegal Weapon"
	desc = "This is a random illegal weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "p08"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(11);/obj/random/ammo_all,\
					prob(11);/obj/item/gun/energy/laser,\
					prob(11);/obj/item/gun/projectile/pirate,\
					prob(10);/obj/item/material/twohanded/spear,\
					prob(10);/obj/item/gun/energy/stunrevolver,\
					prob(10);/obj/item/gun/energy/taser,\
					prob(10);/obj/item/gun/projectile/shotgun/doublebarrel/pellet,\
					prob(10);/obj/item/material/knife,\
					prob(10);/obj/item/gun/projectile/luger,\
				/*	prob(10);/obj/item/gun/projectile/pipegun,\ */
					prob(10);/obj/item/gun/projectile/revolver/detective,\
					prob(10);/obj/item/gun/projectile/revolver/judge,\
					prob(10);/obj/item/gun/projectile/colt,\
					prob(10);/obj/item/gun/projectile/shotgun/pump,\
					prob(10);/obj/item/gun/projectile/shotgun/pump/rifle,\
					prob(10);/obj/item/melee/baton,\
					prob(10);/obj/item/melee/telebaton,\
					prob(10);/obj/item/melee/classic_baton,\
					prob(9);/obj/item/gun/projectile/automatic/wt550/lethal,\
					prob(9);/obj/item/gun/projectile/automatic/pdw,\
					prob(9);/obj/item/gun/projectile/automatic/sol, \
					prob(9);/obj/item/gun/energy/crossbow/largecrossbow,\
					prob(9);/obj/item/gun/projectile/pistol,\
					prob(9);/obj/item/gun/projectile/shotgun/pump,\
					prob(9);/obj/item/cane/concealed,\
					prob(9);/obj/item/gun/energy/gun,\
					prob(8);/obj/item/gun/energy/retro,\
					prob(8);/obj/item/gun/energy/gun/eluger,\
					prob(8);/obj/item/gun/energy/xray,\
					prob(8);/obj/item/gun/projectile/automatic/c20r,\
					prob(8);/obj/item/melee/energy/sword,\
					prob(8);/obj/item/gun/projectile/derringer,\
					prob(8);/obj/item/gun/projectile/revolver/lemat,\
				/*	prob(8);/obj/item/gun/projectile/shotgun/pump/rifle/mosin,\ */
				/*	prob(8);/obj/item/gun/projectile/automatic/m41a,\ */
					prob(7);/obj/item/material/butterfly,\
					prob(7);/obj/item/material/butterfly/switchblade,\
					prob(7);/obj/item/gun/projectile/giskard,\
					prob(7);/obj/item/gun/projectile/automatic/p90,\
					prob(7);/obj/item/gun/projectile/automatic/sts35,\
					prob(7);/obj/item/gun/projectile/shotgun/pump/combat,\
					prob(6);/obj/item/gun/energy/sniperrifle,\
					prob(6);/obj/item/gun/projectile/automatic/z8,\
					prob(6);/obj/item/gun/energy/captain,\
					prob(6);/obj/item/material/knife/tacknife,\
					prob(5);/obj/item/gun/projectile/shotgun/pump/USDF,\
					prob(5);/obj/item/gun/projectile/giskard/olivaw,\
					prob(5);/obj/item/gun/projectile/revolver/consul,\
					prob(5);/obj/item/gun/projectile/revolver/mateba,\
					prob(5);/obj/item/gun/projectile/revolver,\
					prob(4);/obj/item/gun/projectile/deagle,\
					prob(4);/obj/item/material/knife/tacknife/combatknife,\
					prob(4);/obj/item/melee/energy/sword,\
					prob(4);/obj/item/gun/projectile/automatic/mini_uzi,\
					prob(4);/obj/item/gun/projectile/contender,\
					prob(4);/obj/item/gun/projectile/contender/tacticool,\
					prob(3);/obj/item/gun/projectile/SVD,\
					prob(3);/obj/item/gun/energy/lasercannon,\
					prob(3);/obj/item/gun/projectile/shotgun/pump/rifle/lever,\
					prob(3);/obj/item/gun/projectile/automatic/bullpup,\
					prob(2);/obj/item/gun/energy/pulse_rifle,\
					prob(2);/obj/item/gun/energy/gun/nuclear,\
					prob(2);/obj/item/gun/projectile/automatic/l6_saw,\
					prob(2);/obj/item/gun/energy/gun/burst,\
					prob(2);/obj/item/storage/box/frags,\
					prob(2);/obj/item/material/twohanded/fireaxe,\
					prob(2);/obj/item/gun/projectile/luger/brown,\
					prob(2);/obj/item/gun/launcher/crossbow,\
				/*	prob(1);/obj/item/gun/projectile/automatic/battlerifle,\ */ // Too OP
					prob(1);/obj/item/gun/projectile/deagle/gold,\
					prob(1);/obj/item/gun/energy/imperial,\
					prob(1);/obj/item/gun/projectile/automatic/as24,\
					prob(1);/obj/item/gun/launcher/rocket,\
					prob(1);/obj/item/gun/launcher/grenade,\
					prob(1);/obj/item/gun/projectile/gyropistol,\
					prob(1);/obj/item/gun/projectile/heavysniper,\
					prob(1);/obj/item/plastique,\
					prob(1);/obj/item/gun/energy/ionrifle,\
					prob(1);/obj/item/material/sword,\
					prob(1);/obj/item/cane/concealed,\
					prob(1);/obj/item/material/sword/katana)

/obj/random/weapon/guarenteed
	spawn_nothing_percentage = 0

/obj/random/ammo_all
	name = "Random Ammunition (All)"
	desc = "This is random ammunition. Spawns all ammo types."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "666"
	item_to_spawn()
		return pick(prob(5);/obj/item/storage/box/shotgunammo,\
					prob(5);/obj/item/storage/box/shotgunshells,\
					prob(5);/obj/item/ammo_magazine/clip/c762,\
					prob(5);/obj/item/ammo_magazine/m380,\
					prob(5);/obj/item/ammo_magazine/m45,\
					prob(5);/obj/item/ammo_magazine/m9mm,\
					prob(5);/obj/item/ammo_magazine/s38,\
					prob(4);/obj/item/ammo_magazine/clip/c45,\
					prob(4);/obj/item/ammo_magazine/clip/c9mm,\
					prob(4);/obj/item/ammo_magazine/m45uzi,\
					prob(4);/obj/item/ammo_magazine/m9mml,\
					prob(4);/obj/item/ammo_magazine/m9mmt,\
					prob(4);/obj/item/ammo_magazine/m9mmp90,\
					prob(4);/obj/item/ammo_magazine/m10mm,\
					prob(4);/obj/item/ammo_magazine/m545/small,\
					prob(3);/obj/item/ammo_magazine/clip/c10mm,\
					prob(3);/obj/item/ammo_magazine/clip/c44,\
					prob(3);/obj/item/ammo_magazine/s44,\
					prob(3);/obj/item/ammo_magazine/m762,\
					prob(3);/obj/item/ammo_magazine/m545,\
					prob(3);/obj/item/cell/device/weapon,\
					prob(2);/obj/item/ammo_magazine/m44,\
					prob(2);/obj/item/ammo_magazine/s357,\
					prob(2);/obj/item/ammo_magazine/m762m,\
					prob(2);/obj/item/ammo_magazine/clip/c12g,
					prob(2);/obj/item/ammo_magazine/clip/c12g/pellet,\
					prob(1);/obj/item/ammo_magazine/m45tommy,\
				/*	prob(1);/obj/item/ammo_magazine/m95,\ */
					prob(1);/obj/item/ammo_casing/rocket,\
					prob(1);/obj/item/storage/box/sniperammo,\
					prob(1);/obj/item/storage/box/flashshells,\
					prob(1);/obj/item/storage/box/beanbags,\
					prob(1);/obj/item/storage/box/stunshells,\
					prob(1);/obj/item/ammo_magazine/mtg,\
					prob(1);/obj/item/ammo_magazine/m12gdrum,\
					prob(1);/obj/item/ammo_magazine/m12gdrum/pellet,\
					prob(1);/obj/item/ammo_magazine/m45tommydrum
					)
