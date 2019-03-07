/datum/firamode
	var/name = "default"

	//Badmin shennanigans/varedits. DO NOT USE THIS IN CODE, EXTREMELY INEFFICIENT!
	var/list/custom_gun_vars
	var/list/custom_ammo_vars
	var/list/custom_projectile_vars


/datum/firemode/New(obj/item/gun/gun,

/datum/firemode/proc/apply_to_gun(obj/item/gun/G)
	if(custom_gun_vars)
		for(var/key in custom_gun_vars)
			G.vv_edit_var(key, custom_gun_vars[key])

	return G

/datum/firemode/proc/apply_to_casing(obj/item/ammu_casing/C)
	if(custom_ammo_vars)
		for(var/key in custom_ammo_vars)
			C.vv_edit_var(key, custom_ammo_vars[key])

	return C

/datum/firemode/proc/apply_to_projectile(obj/item/projectile/P)
	if(custom_projectile_vars)
		for(var/key in custom_projectile_vars)
			P.vv_edit_var(key, custom_projectile_vars[key]

	return P


/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()

/datum/firemode/New(obj/item/weapon/gun/gun, list/properties = null)
	..()
	if(!properties) return

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/proc/apply_to(obj/item/weapon/gun/gun)
	for(var/propname in settings)
		gun.vars[propname] = settings[propname]
