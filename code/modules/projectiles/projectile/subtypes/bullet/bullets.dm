
/* short-casing projectiles, like the kind used in pistols or SMGs */

/obj/projectile/bullet/pistol // 9mm pistols and most SMGs. Sacrifice power for capacity.
	fire_sound = 'sound/weapons/weaponsounds_smallpistolshot.ogg'
	damage_force = 20

/obj/projectile/bullet/pistol/lap //Light Armor Piercing
	damage_force = 20
	damage_tier = 3.5

/obj/projectile/bullet/pistol/ap
	damage_force = 15
	damage_tier = 4

/obj/projectile/bullet/pistol/hp
	damage_force = 25
	damage_tier = 2.25

/obj/projectile/bullet/pistol/hunter
	damage_force = 15
	SA_bonus_damage = 25 // 40 total against animals
	SA_vulnerability = MOB_CLASS_ANIMAL
	embed_chance = -1

/obj/projectile/bullet/pistol/silver
	damage_force = 18 // 10% less than base
	SA_bonus_damage = 8 // ~1.3x base to vulnerable
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	holy = TRUE

/obj/projectile/bullet/pistol/medium // .45 (and maybe .40 if it ever gets added) caliber security pistols. Balance between capacity and power.
	fire_sound = 'sound/weapons/weaponsounds_pistolshot.ogg' // Snappier sound.
	damage_force = 25

/obj/projectile/bullet/pistol/medium/ap
	damage_force = 20
	damage_tier = 4.25

/obj/projectile/bullet/pistol/medium/hp
	damage_force = 30
	damage_tier = 2.25

/obj/projectile/bullet/pistol/medium/hunter
	damage_force = 15
	SA_bonus_damage = 45 // 60 total against animals
	SA_vulnerability = MOB_CLASS_ANIMAL
	embed_chance = -1

/obj/projectile/bullet/pistol/medium/silver
	damage_force = 22 // ~10% less than base
	SA_bonus_damage = 11 // ~1.3x base to vulnerable
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	holy = TRUE

/obj/projectile/bullet/pistol/medium/ap/suppressor // adminspawn only
	name = "suppressor bullet" // this guy is Important and also Hates You
	fire_sound = 'sound/weapons/doompistol.ogg' // converted from .wavs extracted from doom 2
	damage_force = 10 // high rof kinda fucked up lets be real
	damage_tier = 4.5
	damage_inflict_agony = 10 // brute easily heals, agony not so much
	accuracy_overall_modify = 0.8 // heehoo
	speed = 25 * WORLD_ICON_SIZE

/obj/projectile/bullet/pistol/medium/ap/suppressor/turbo // spicy boys
	speed = 50 * WORLD_ICON_SIZE

/obj/projectile/bullet/pistol/strong // .357 and .44 caliber stuff. High power pistols like the Mateba or Desert Eagle. Sacrifice capacity for power.
	fire_sound = 'sound/weapons/weaponsounds_heavypistolshot.ogg'
	damage_force = 60

/obj/projectile/bullet/pistol/strong/silver //Because all Demons need to die
	fire_sound = 'sound/weapons/weaponsounds_heavypistolshot.ogg'
	damage_force = 54 // 10% less than base
	SA_bonus_damage = 24 // 1.3x base to vulnerable
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	holy = TRUE

/obj/projectile/bullet/pistol/rubber // "Rubber" bullets for all other pistols.
	name = "rubber bullet"
	damage_force = 5
	damage_inflict_agony = 40
	embed_chance = 0
	damage_mode = NONE
	damage_flag = ARMOR_MELEE
	fire_sound ='sound/weapons/weaponsounds_smallpistolshot.ogg' // It may be rubber shots but it's still a gun homie it shouldn't be as pathetic as it was

/obj/projectile/bullet/pistol/rubber/strong // "Rubber" bullets for high power pistols.
	fire_sound = 'sound/weapons/weaponsounds_heavypistolshot.ogg' // Rubber shots have less powder, but these still have more punch than normal rubber shot.
	damage_force = 10
	damage_inflict_agony = 60
	embed_chance = 0
	damage_flag = ARMOR_MELEE

/obj/projectile/bullet/pistol/spin // Special weak ammo for Service Spin mode.
	fire_sound = 'sound/weapons/weaponsounds_smallpistolshot.ogg'
	damage_force = 5
	SA_bonus_damage = 10 // 15 total against demons
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

/* shotgun projectiles */

/obj/projectile/bullet/shotgun
	name = "slug"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage_force = 50
	damage_tier = 4.25

/obj/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	damage_force = 20
	damage_inflict_agony = 60
	embed_chance = 0
	damage_mode = NONE
	damage_flag = ARMOR_MELEE

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage_force = 13
	pellets = 6
	pellet_loss = 0.66 / WORLD_ICON_SIZE

/obj/projectile/bullet/pellet/shotgun_improvised
	name = "shrapnel"
	damage_force = 4
	pellets = 10

/obj/projectile/bullet/pellet/shotgun/flak
	damage_force = 2 //The main weapon using these fires four at a time, usually with different destinations. Usually.
	damage_tier = 3.75

// This is my boomstick,
/obj/projectile/bullet/pellet/shotgun/silvershot
	name = "shrapnel"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage_force = 12 // ~10% less than buckshot
	SA_bonus_damage = 5 // ~1.3x buckshot to vulnerable
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	pellets = 6
	holy = TRUE

/obj/projectile/bullet/shotgun/silver
	name = "slug"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage_force = 45 // 10% less than base
	SA_bonus_damage = 20 // 1.3x base to vulnerable
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

/obj/projectile/bullet/shotgun/stake // adminspawn only
	name = "stake"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage_force = 50
	damage_tier = 3.75
	SA_bonus_damage = 30
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

//EMP shotgun 'slug', it's basically a beanbag that pops a tiny emp when it hits.
/obj/projectile/bullet/shotgun/ion
	name = "ion slug"
	fire_sound = 'sound/weapons/gunshot/gunshot_tech_huge.ogg'
	damage_force = 15
	embed_chance = 0
	damage_mode = NONE
	damage_flag = ARMOR_MELEE
	combustion = FALSE

	base_projectile_effects = list(
		/datum/projectile_effect/detonation/legacy_emp{
			sev_3 = 2;
		}
	)

//Frag shot
/obj/projectile/bullet/shotgun/frag12
	name ="frag12 slug"
	damage_force = 25

/obj/projectile/bullet/shotgun/frag12/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	explosion(target, -1, 0, 1)
	. |= PROJECTILE_IMPACT_DELETE

/* "Rifle" rounds */

/obj/projectile/bullet/rifle
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	damage_tier = 4
	legacy_penetrating = 1

/obj/projectile/bullet/rifle/a762
	fire_sound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'
	damage_force = 35

/obj/projectile/bullet/rifle/a762/sniper // Hitscan specifically for sniper ammo; to be implimented at a later date, probably for the SVD. -Ace
	fire_sound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'
	hitscan = 1 //so the ammo isn't useless as a sniper weapon

/obj/projectile/bullet/rifle/a762/ap
	damage_force = 30
	damage_tier = 4.75

/obj/projectile/bullet/rifle/a762/ap/silver // Only used by the Service Weapon
	damage_force = 30
	damage_tier = 5
	SA_bonus_damage = 30 // 60 total against demons
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

/obj/projectile/bullet/rifle/a762/hp
	damage_force = 40
	damage_tier = 2.75
	legacy_penetrating = 0

/obj/projectile/bullet/rifle/a762/hunter // Optimized for killing simple animals and not people, because Balance(tm)
	damage_force = 25
	SA_bonus_damage = 45 // 70 total on animals.
	SA_vulnerability = MOB_CLASS_ANIMAL
	embed_chance = -1

/obj/projectile/bullet/rifle/a762/sniperhunter
	damage_force = 25
	SA_bonus_damage = 45 // 70 total on animals.
	SA_vulnerability = MOB_CLASS_ANIMAL
	embed_chance = -1
	speed = 25 * WORLD_ICON_SIZE

/obj/projectile/bullet/rifle/a762/silver
	damage_force = 31 //~10% less than base
	SA_bonus_damage = 15 // ~1.3x base to vulnerable
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

/obj/projectile/bullet/rifle/a556
	fire_sound = 'sound/weapons/weaponsounds_rifleshot.ogg'
	damage_force = 25

/obj/projectile/bullet/rifle/a556/ap
	damage_force = 20
	damage_tier = 4.75

/obj/projectile/bullet/rifle/a556/hp
	damage_force = 35
	damage_tier = 2.75
	legacy_penetrating = 0

/obj/projectile/bullet/rifle/a556/hunter
	damage_force = 15
	SA_bonus_damage = 35 // 50 total on animals.
	SA_vulnerability = MOB_CLASS_ANIMAL

/obj/projectile/bullet/rifle/a556/silver
	damage_force = 23 // ~10% less than base
	SA_bonus_damage = 10 // ~1.3x base to vulnerable.
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

/obj/projectile/bullet/rifle/a12_7mm
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg' // This is literally an anti-tank rifle caliber. It better sound like a fucking cannon.
	damage_force = 80
	stun = 3
	weaken = 3
	legacy_penetrating = 5
	damage_tier = 6
	hitscan = 1 //so the PTR isn't useless as a sniper weapon

/obj/projectile/bullet/mecha/a12mm_gauss //Mecha gauss rifle round.
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg' // This is literally an anti-tank rifle caliber. It better sound like a fucking cannon.
	damage_force = 60
	legacy_penetrating = 1
	damage_tier = 6

/* Miscellaneous */

/obj/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	damage_force = 20
	damage_type = DAMAGE_TYPE_OXY

/obj/projectile/bullet/cyanideround
	name = "poison bullet"
	damage_force = 40
	damage_type = DAMAGE_TYPE_TOX

/obj/projectile/bullet/cyanideround/jezzail
	name = "toxic penetrator shard"
	damage_force = 25
	damage_tier = 3.75
	damage_inflict_agony = 5
	embed_chance = 1
	damage_type = DAMAGE_TYPE_TOX

/obj/projectile/bullet/burstbullet
	name = "exploding bullet"
	fire_sound = 'sound/soundbytes/effects/explosion/explosion1.ogg'
	damage_force = 20
	embed_chance = 0
	damage_mode = DAMAGE_MODE_EDGE

/obj/projectile/bullet/burstbullet/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	explosion(target, -1, 0, 2)
	. |= PROJECTILE_IMPACT_DELETE

/obj/projectile/bullet/burstbullet/service
	name = "charge bullet"
	fire_sound = 'sound/soundbytes/effects/explosion/explosion1.ogg'
	damage_force = 20
	embed_chance = 0
	SA_bonus_damage = 40 // 60 total damage against demons.
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

/obj/projectile/bullet/burstbullet/service/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(isturf(target))
		explosion(target, 0, 1, 2)
	return . | PROJECTILE_IMPACT_DELETE

/* Black Powder */

/obj/projectile/bullet/musket // Big Slow and bad against armor.
	fire_sound = 'sound/weapons/weaponsounds_heavypistolshot.ogg'
	damage_force = 60
	speed = 8.3 * WORLD_ICON_SIZE
	damage_tier = 2

/obj/projectile/bullet/musket/silver
	damage_force = 54 // 10% less than base
	SA_bonus_damage = 24 // 1.3x base to vulnerable
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	holy = TRUE

/obj/projectile/bullet/pellet/blunderbuss //More Damage at close range greater falloff
	damage_force = 10
	pellets = 8
	pellet_loss = 1.5 / WORLD_ICON_SIZE

/obj/projectile/bullet/pellet/blunderbuss/silver
	damage_force = 9 // 10% less than base
	SA_bonus_damage = 4 // 1.3x base to vulnerable
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	holy = TRUE

//10 Gauge Shot
/obj/projectile/bullet/heavy_shotgun
	name = "heavy slug"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage_force = 60
	damage_tier = 4.5

/obj/projectile/bullet/pellet/heavy_shotgun //I want this to use similar calcuations to blunderbuss shot for falloff.
	damage_force = 3 //Fires five pellets at a time.
	damage_tier = 3.75

/obj/projectile/bullet/pellet/heavy_shotgun/silver
	damage_force = 3
	SA_bonus_damage = 1
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

//Special 10g rounds for Grit, since I don't want ALL 10g to do this:
/obj/projectile/bullet/heavy_shotgun/grit
	name = "custom heavy slug"

/obj/projectile/bullet/heavy_shotgun/grit/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(isliving(target))
		var/mob/living/L = target
		var/throwdir = get_dir(firer,L)
		if(prob(10) && (efficiency < 0.95))
			L.afflict_stun(20 * 1)
			L.Confuse(1)
		L.throw_at_old(get_edge_target_turf(L, throwdir), rand(3,6), 10)

/obj/projectile/bullet/pellet/heavy_shotgun/grit
	name = "heavy buckshot"

/obj/projectile/bullet/pellet/heavy_shotgun/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(isliving(target))
		var/mob/living/L = target
		var/throwdir = get_dir(firer,L)
		if(prob(10) && (efficiency >= 0.9))
			L.afflict_stun(2 SECONDS)
			L.Confuse(1)
		if(!L.throwing)
			L.throw_at_old(get_edge_target_turf(L, throwdir), rand(3,6), 10)

/* Incendiary */

/obj/projectile/bullet/incendiary
	name = "incendiary bullet"
	icon_state = "bullet_alt"
	damage_force = 15
	damage_type = DAMAGE_TYPE_BURN
	incendiary = 1
	flammability = 2

/obj/projectile/bullet/incendiary/shotgun
	name = "dragonsbreath pellet"
	icon_state = "bullet_alt"
	damage_force = 10
	damage_type = DAMAGE_TYPE_BURN
	incendiary = 1
	flammability = 2

/obj/projectile/bullet/incendiary/flamethrower
	name = "ball of fire"
	desc = "Don't stand in the fire."
	icon_state = "fireball"
	damage_force = 10
	embed_chance = 0
	//incendiary = 2 //The Trail of Fire doesn't work.
	flammability = 4
	damage_inflict_agony = 30
	range = WORLD_ICON_SIZE * 4
	vacuum_traversal = 0

/obj/projectile/bullet/incendiary/flamethrower/weak
	flammability = 2

/obj/projectile/bullet/incendiary/flamethrower/large
	damage_force = 15
	range = WORLD_ICON_SIZE * 6

/obj/projectile/bullet/incendiary/caseless
	name = "12.7mm phoron slug"
	icon_state = "bullet_alt"
	damage_force = 60
	damage_type = DAMAGE_TYPE_BRUTE
	incendiary = 1
	flammability = 4
	damage_tier = 5.35
	legacy_penetrating = 5
	combustion = TRUE

/obj/projectile/bullet/incendiary/caseless/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	// todo: burn this to the ground
	if(isliving(target))
		var/mob/living/L = target
		L.adjustFireLoss(10)

/obj/projectile/bullet/incendiary/phoronshrap
	name = "phoron shrapnel slug"
	icon_state = "bullet_alt"
	damage_force = 40
	damage_tier = 4.75
	damage_type = DAMAGE_TYPE_BRUTE
	incendiary = 1
	flammability = 4
	legacy_penetrating = 1
	combustion = TRUE


/* Practice rounds and blanks */

/obj/projectile/bullet/practice
	damage_force = 5

/obj/projectile/bullet/pistol/cap // Just the primer, such as a cap gun.
	name = "cap"
	damage_type = DAMAGE_TYPE_HALLOSS
	fire_sound = 'sound/effects/snap.ogg'
	damage_force = 0
	nodamage = 1
	embed_chance = 0
	damage_mode = NONE
	incendiary = 1
	flammability = 4

	combustion = FALSE

/obj/projectile/bullet/pistol/cap/process(delta_time)
	loc = null
	qdel(src)

/obj/projectile/bullet/blank
	name = "blank"
	damage_type = DAMAGE_TYPE_HALLOSS
	fire_sound = 'sound/weapons/weaponsounds_rifleshot.ogg' // Blanks still make loud noises.
	damage_force = 0
	nodamage = 1
	embed_chance = 0
	damage_mode = NONE

/obj/projectile/bullet/blank/cap/process(delta_time)
	loc = null
	qdel(src)
