/obj/item/clothing/mask/cold
    name = "heat absorbent coif"
    desc = "A close-fitting cap that covers the top, back, and sides of the head. Can also be adjusted to cover the lower part of the face so it keeps the user warm in harsh conditions."
    clothing_flags = ALLOW_SURVIVALFOOD
    flags_inv = HIDEEARS|HIDEFACE
    body_parts_covered = HEAD|FACE|EYES
    w_class = ITEMSIZE_NORMAL
    item_state_slots = list(SLOT_ID_RIGHT_HAND = "gas_alt", SLOT_ID_LEFT_HAND = "gas_alt")
    gas_transfer_coefficient = 0.01
    permeability_coefficient = 0.01
    siemens_coefficient = 0.9
    var/thermal_power = 100//the amount of power we can use to warm the air
    var/set_to_temp = T20C //to what temperature we can set it

/obj/item/clothing/mask/cold/alter_breath(datum/gas_mixture/air)
    if(!air || !istype(air))
        return air//if its not the right thing, just throw it back
    
    if(air.temperature >= set_to_temp)
        return

    return air.adjust_thermal_energy(clamp(air.get_thermal_energy_change(set_to_temp),thermal_power,0))
