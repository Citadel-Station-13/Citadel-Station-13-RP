/*******
 * Crypto miner, turns power into points for engineering
 * Basicly a glorified power sink
 * Heats either atmos in the connector below or atmos in the environment
 * Reduced efficency the warmer it gets
 * Breaks down when to warm
 * Conversion rate tbd, starting value 100kJ => 1 Point
 *
 * Can be configured on how much power it draws or just wipes all avaiable power.
 */
GLOBAL_VAR_INIT(points_mined, 0)
GLOBAL_VAR_INIT(power_per_point, 1000 KILOWATTS)
/obj/machinery/power/crypto_miner
    name = "Encryption Reinforcing Heater"
    desc = "This device uses massive amounts of electric energy to create entropy levels. These Entropy levels are used to reinforce encryptions of NT communications.<br> Use a multitool to configure the powerlevel, powerlevel of zero or below mean the device is off."
    icon = 'icons/obj/salvageable.dmi' //salvageable.dmi
    icon_state = "data0"
    anchored = TRUE
    density = 1.0
    var/power_level = 0//used to determin wether the device is on or not
    var/points_stored = 0
    var/power_drawn = 0
    var/safe_storage_temp = 350//Kelvin // just being exposed to temperatures above this should case damage to the circuits.
    var/optimal_temperature = 200//Kelvin
    var/unsafe_lower_temp = 0//Kelvin, semiconductors dont like being frozen and operated at the same time removed for now, its hard enough to juggle anyway
    var/efficency = 0//the cooler the environment is the more efficent the calculations work, and the more points are generated per Megawatt(shouldnt go over 1)
    //also factors damage to the machine in.
    var/temperature_damage = 0//If not sufficently cooled the circuits take damage and calculations get weaker, at 100 we condsider the circuit fried and it needs repairs/replacement


/obj/machinery/power/crypto_miner/examine(mob/user)
    . = ..()
    if(GLOB.points_mined)//Only show this if someone actually mined
        . += "[src] is [power_level? "on":"off"]. Current Power Level reads [power_level]."
        . += "Progress to next Point: [(power_drawn/GLOB.power_per_point) *100] %"
        . += "There are [points_stored] points up for claims."
        . += "The circuit looks [temperature_damage ? "damaged" : "intact"]. <i>Damage: [temperature_damage]%</i>"
        . += "The miner is running at [efficency*100]% Efficency."
        . += "[name] currently needs [GLOB.power_per_point] Joules per point."
        . += "A total of [GLOB.points_mined] points has been mined."


/obj/machinery/power/crypto_miner/process(delta_time)
    if(!powernet || !power_level || !anchored)
        return

    if(temperature_damage >= 100)//Once the circuit is fried, turn off
        power_level = 0
        return

    var/new_power_drawn = draw_power(power_level * 0.001) * 1000
    power_drawn += new_power_drawn
    heat_environ(new_power_drawn)//Converts the used power into heat, will probably overheat the room fairly quick.
    process_thermal_properties()//calculates damage and efficency

    if(!power_drawn)
        return

    if (power_drawn > GLOB.power_per_point)
        var/newpoints = round((power_drawn / GLOB.power_per_point) * efficency)
        power_drawn -= newpoints*(GLOB.power_per_point)
        points_stored += newpoints
        GLOB.points_mined += newpoints
        GLOB.power_per_point = round(1 MEGAWATTS * (1.00276 ** GLOB.points_mined))//1.00276 doubles the first time at 250 points, which is the most expansive item in the vendor currently

/obj/machinery/power/crypto_miner/attackby(obj/item/W, mob/user)

    if(istype(W, /obj/item/card/id))
        var/obj/item/card/id/used_id = W
        used_id.engineer_points += points_stored
        to_chat(user, SPAN_NOTICE("You transfer [points_stored] points to your ID"))
        points_stored = 0
        return
    if(W.is_wrench())
        default_unfasten_wrench(user, W)
        return
    if(W.is_wirecutter())
        repair(user, 20, 5)
        return
    if(W.is_screwdriver())
        default_deconstruction_screwdriver(user, W)
    if(W.is_multitool())
        var/new_power_level = input("What Power would you like to draw from the network?", "Power level Controls", power_level) as num|null
        if(new_power_level != null)
            power_level = max(new_power_level, 0)
            to_chat(user, "You set the Power Level to [power_level] Watts.")
        return
    return ..()


/obj/machinery/power/crypto_miner/proc/heat_environ(var/power_used)
    var/datum/gas_mixture/env = loc.return_air()
    if(!env)
        if(temperature_damage < 100)
            temperature_damage++
        return
    env.adjust_thermal_energy(power_used)

/obj/machinery/power/crypto_miner/proc/process_thermal_properties()
    var/datum/gas_mixture/env = loc.return_air()
    if(!env)
        efficency = 0
    if(env.temperature <= optimal_temperature)
        efficency = 1
    if(env.temperature > optimal_temperature)
        var/times_optimal_temp = env.temperature / optimal_temperature
        efficency = 1 / (times_optimal_temp ** 4)//massive performance drop the further you get away from optimal temperature.

    if((env.temperature < unsafe_lower_temp) && (temperature_damage < 80))//Lower temperature doesnt completely fry the circuit tho it can causes severe damage
        temperature_damage++
        efficency = min(efficency, 0.1)//Bottles the efficency at 10%

    if((env.temperature > safe_storage_temp) && (temperature_damage < 100))//no need to fry it further.
        temperature_damage++

    if(temperature_damage)
        efficency = efficency - (temperature_damage/100)//One thermal damage means a reduction of 1% on the total efficency
    efficency = clamp(efficency, 0,1)

/obj/machinery/power/crypto_miner/proc/repair(var/mob/user,var/delay,var/damage_repaired)
    if(temperature_damage)
        to_chat(user, SPAN_NOTICE("You start to fix some damage on the [src]'s circuit"))
        if(do_after(user,delay,src))
            temperature_damage = max(temperature_damage-damage_repaired,0)
            if(temperature_damage)
                to_chat(user, SPAN_NOTICE("You fix some damage on the [src]'s circuit"))
            else
                to_chat(user, SPAN_NOTICE("You completely restore the [src]'s circuit"))
    else
        to_chat(user, SPAN_NOTICE("There is no damage on the [src]'s circuit"))

