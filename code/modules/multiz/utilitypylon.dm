/**
 * A machine to ease the near constant struggle of mappers and engineers alike to get a proper connection between z-levels.
 * 
 */
#define PYLON_PIPE_VOLUME 210

/obj/machinery/power/utility_pylon
    name = "Utility Pylon"
    desc = "This is an empty utility Pylon. Pretty useless at the moment"
    var/list/obj/machinery/power/utility_pylon/column = null

    icon = 'icons/obj/structures/multiz.dmi'
    icon_state = "utility_power"

/obj/machinery/power/utility_pylon/Initialize()
    . = ..()
    built_column()
    connect_to_network()
    add_column_to_network()
    return INITIALIZE_HINT_LATELOAD
    
/obj/machinery/power/utility_pylon/LateInitialize()
    //add_column_to_network()



/obj/machinery/power/utility_pylon/proc/built_column()
    LAZYOR(column, src)
    var/turf/above = GetAbove(src)
    var/obj/machinery/power/utility_pylon/friend_above = null
    if(above)
        friend_above = locate() in above
        if(friend_above)
            if(friend_above.column)//if our friend above has a handler we add ourselves to it, and copy it to ourselves
                LAZYOR(column, friend_above)
                LAZYOR(column, friend_above.column)
                LAZYOR(friend_above.column, column)
    
    var/turf/below = GetBelow(src)
    var/obj/machinery/power/utility_pylon/friend_below = null
    if(below)//
        friend_below = locate() in below
        if(friend_below)
            if(friend_below.column)//if our friend below has a handler we add ourselves to it, and copy it to ourselves
                LAZYOR(column, friend_below)
                LAZYOR(column, friend_below.column)
                LAZYOR(friend_below.column, column)



/obj/machinery/power/utility_pylon/connect_to_network()
    var/turf/T = src.loc
    if(!T || !istype(T))
        return 0

    var/obj/structure/cable/C = T.get_cable_node() //check if we have a node cable on the machine turf, the first found is picked
    if(!C || !C.powernet)
        return 0

    C.powernet.add_utility_pylon(src)
    return 1

/obj/machinery/power/utility_pylon/disconnect_from_network()
    if(!powernet)
        return 0
    powernet.remove_pylon(src)
    return 1

/obj/machinery/power/utility_pylon/proc/add_column_to_network()
    for(var/obj/machinery/power/utility_pylon/P in column)
        merge_powernets(powernet, P.powernet)
        //powernet.add_utility_pylon(P)
