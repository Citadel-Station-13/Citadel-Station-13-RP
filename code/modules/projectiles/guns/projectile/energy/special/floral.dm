/datum/firemode/energy/floral
	abstract_type = /datum/firemode/energy/floral
	charge_cost = 240

/datum/firemode/energy/floral/mutation
	name = "induce mutations"
	projectile_type = /obj/projectile/energy/floramut
	legacy_modifystate = "floramut"

/datum/firemode/energy/floral/yield
	name = "increase yield"
	projectile_type = /obj/projectile/energy/florayield
	legacy_modifystate = "florayield"

/datum/firemode/energy/floral/gene
	name = "induce specific mutations"
	projectile_type = /obj/projectile/energy/floramut/gene
	legacy_modifystate = "floramut"

/obj/item/gun/projectile/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "floramut100"
	item_state = "floramut"
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	cell_type = /obj/item/cell/device/weapon/recharge
	no_pin_required = 1
	battery_lock = 1
	var/singleton/plantgene/gene = null

	regex_this_firemodes = list(
		/datum/firemode/energy/floral/mutation,
		/datum/firemode/energy/floral/yield,
		/datum/firemode/energy/floral/gene,
	)

/obj/item/gun/projectile/energy/floragun/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	//allow shooting into adjacent hydrotrays regardless of intent
	if((clickchain_flags & CLICKCHAIN_HAS_PROXIMITY) && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		user.visible_message("<span class='danger'>\The [user] fires \the [src] into \the [target]!</span>")
		Fire(target,user)
		return
	..()

/obj/item/gun/projectile/energy/floragun/verb/select_gene()
	set name = "Select Gene"
	set category = "Object"
	set src in view(1)

	var/genemask = input("Choose a gene to modify.") as null|anything in SSplants.plant_gene_datums

	if(!genemask)
		return

	gene = SSplants.plant_gene_datums[genemask]

	to_chat(usr, "<span class='info'>You set the [src]'s targeted genetic area to [genemask].</span>")

	return

/obj/item/gun/projectile/energy/floragun/consume_next_projectile()
	. = ..()
	var/obj/projectile/energy/floramut/gene/G = .
	if(istype(G))
		G.gene = gene
