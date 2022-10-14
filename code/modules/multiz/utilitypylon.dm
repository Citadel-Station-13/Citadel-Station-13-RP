/**
 * A machine to ease the near constant struggle of mappers and engineers alike to get a proper connection between z-levels.
 * 
 */
#define PYLON_PIPE_VOLUME 210

/datum/pylon_handler
    var/list/pylons = list()

/datum/pylon_handler/proc/join_other_handler(var/datum/pylon_handler/other)
    if(other)
        for(var/obj/machinery/utility_pylon/P in pylons)
            P.column = other
        LAZYOR(other.pylons, src.pylons)
        qdel(src)
    else
        CRASH("pylon handler was asked to join null")

/datum/pylon_handler/proc/add_pylon(var/obj/machinery/utility_pylon/P)
    if(P)
        LAZYOR(pylons, P)

/datum/pylon_handler/proc/remove_pylon(var/obj/machinery/utility_pylon/P,var/secure = FALSE)
    if(P)
        LAZYREMOVE(pylons, P)
    if(!pylons.len && !secure)//No pylons?
        qdel(src)

/datum/pylon_handler/proc/get_pylons()
    return pylons

/datum/pylon_handler/proc/check_coheasion()
    var/smallest_z = 1000
    var/largest_z = 0
    
    //list of Zs
    var/list/z_level_list = list()
    for(var/pyl in pylons)
        var/z_level_number = get_z(pyl)
        if(z_level_number in z_level_list)
            CRASH("More than one Utility Pylon detected on the same Z([z_level_number])")
        z_level_list += z_level_number
        smallest_z = (smallest_z > z_level_number ? z_level_number : smallest_z)
        largest_z = (largest_z < z_level_number ? z_level_number : largest_z)

    //figure out if there is any gaps
    //ideas, the sum off all should be a fibronacci number with offset, if we know the smallest and the largest we can
    var/controll_sum = 0
    var/i = smallest_z
    while(i <= largest_z)
        controll_sum += i
        i++
    var/level_sum
    for(var/j in z_level_list)
        level_sum += j

    if(level_sum != controll_sum)//there is a gap somewhere, we commit suicide
        for(var/obj/machinery/utility_pylon/pylon in pylons)
            remove_pylon(pylon, TRUE)//qdel is called when the pylons list is empty
            pylon.built_column()
        CRASH("Pylons lost coheasion!")
    else
        return TRUE

/**
 * the parent type, maybe used for construction later
 */
/obj/machinery/utility_pylon
    name = "Utility Pylon"
    desc = "This is an empty utility Pylon. Pretty useless at the moment"
    var/datum/pylon_handler/column = null

/obj/machinery/utility_pylon/Initialize()
    . = ..()
    built_column()
    
/obj/machinery/utility_pylon/proc/built_column()
    var/turf/above = GetAbove(src)
    var/obj/machinery/utility_pylon/friend_above = null
    if(above)
        friend_above = locate() in above
        if(friend_above)
            if(friend_above.column)//if our friend above has a handler we add ourselves to it, and copy it to ourselves
                add_to_handler(friend_above.column)
    
    var/turf/below = GetBelow(src)
    var/obj/machinery/utility_pylon/friend_below = null
    if(below)
        friend_below = locate() in below
        if(friend_below)
            if(friend_below.column)//if our friend below has a handler we add ourselves to it, and copy it to ourselves
                add_to_handler(friend_below.column)
    
    if(!column)//we still dont have a column so we make our own!
        src.column = new()
        src.column.pylons += src
        src.column.add_pylon(friend_above)//even if either of them are null we are good, add_pylon is nullsafe
        src.column.add_pylon(friend_below)//With blackjack and hookers!

/obj/machinery/utility_pylon/process()


/obj/machinery/utility_pylon/proc/add_to_handler(var/datum/pylon_handler/handler)
    if(handler)
        if(column)
            column.join_other_handler()
        else//we dont need to do this if we let our handler join, because that automaticly does this for us
            column = handler
            LAZYOR(handler.pylons, src)

/obj/machinery/utility_pylon/Destroy()
    if(column)
        column.remove_pylon(src)
    . = ..()


/**
 * Atmospherics variant, connects to all pipelayers
 */

/obj/machinery/utility_pylon/atmos
    name = "Atmospherics Utility Pylon"
    desc = "This is a Atmospherics Utility Pylon. Its a wide vertical tube loaded atmospherics utility connections."
    
    var/obj/machinery/atmospherics/node_regular
    var/obj/machinery/atmospherics/node_supply
    var/obj/machinery/atmospherics/node_scrubber
    var/obj/machinery/atmospherics/node_fuel
    var/obj/machinery/atmospherics/node_aux

    var/list/datum/pipe_network/networks = list()

/obj/machinery/utility_pylon/atmos/Initialize()
    . = ..()

    node_regular = new()
    node_regular.connect_types = CONNECT_TYPE_REGULAR

    node_supply = new()
    node_supply.connect_types = CONNECT_TYPE_SUPPLY

    node_scrubber = new()
    node_scrubber.connect_types = CONNECT_TYPE_SCRUBBER

    node_fuel = new()
    node_fuel.connect_types = CONNECT_TYPE_FUEL

    node_aux = new()
    node_aux.connect_types = CONNECT_TYPE_AUX


/**
 * Power variant
 */
/obj/machinery/utility_pylon/power
    name = "Power Utility Pylon"
    desc = "This is a Power Utility Pylon. Its a wide vertical tube loaded power utility connections."

    var/datum/powernet/powernet = null

/obj/machinery/utility_pylon/power/proc/update_for_new_powernet()
    var/list/friends = column.get_pylons()
    for(var/obj/machinery/utility_pylon/power/pp in friends)
        powernet.add_utility_pylon(pp)

/*/obj/machinery/utility_pylon/power/proc/update_leaving_powernet()
    var/list/friends = column.get_pylons()
    for(var/obj/machinery/utility_pylon/power/pp in friends)*/
