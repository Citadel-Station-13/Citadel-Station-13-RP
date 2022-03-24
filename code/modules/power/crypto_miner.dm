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

/obj/machinery/power/crypto_miner
    name = "CRyP70 - 9er"
    desc = "The 'CRyP70 - 9er' offers crypto ethusiasts the perfect opportunity to live their dreams of becoming a crypto millionare, simply insert power, wait, and become rich! No garuntees."
    //desc_alt = "The CRyP70 - 9er is the most complex heater on the market."
    icon = 'icons/misc/Consoles_and_Servers.dmi'
    icon_state = "vbox_0"
    anchored = TRUE
    density = 1.0
    var/mode = 0
    //Modes 0 = Off
    //1 = 100 kW
    //2 = Surplus
    //3 = ALL THE POWER!
    var/power_level = 100 KILOWATTS
    var/points_stored = 0
    var/power_per_point = 1 MEGAWATTS
    var/power_drawn = 0

/obj/machinery/power/crypto_miner/Initialize()
    //START_PROCESSING(SSobj, src)
    . = ..()

/obj/machinery/power/crypto_miner/process(delta_time)
    if(!powernet || !mode)
        STOP_PROCESSING(SSobj, src)
        return
    switch (mode)
        if(1)
            power_drawn += draw_power(power_level)
        if(2)
            power_drawn += draw_power(surplus())
        if(3)
            power_drawn += draw_power(avail())
    if(!power_drawn || prob(5))//5% to just not make points
        return
    if (power_drawn > power_per_point)
        var/newpoints = round(power_drawn / power_per_point)
        points_stored += newpoints
        power_drawn -= newpoints*power_per_point

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
    return ..()

/obj/machinery/power/crypto_miner/proc/switch_mode(mob/user)
    switch(mode)
        if(3)
            mode = 0
            to_chat(user, SPAN_NOTICE("You turn the [name] off."))
        if(2)
            mode = 3
            to_chat(user, SPAN_NOTICE("You set the [name] to draw as much power as possible."))
        if(1)
            mode = 2
            to_chat(user, SPAN_NOTICE("You set the [name] to draw as much power as avaiable."))
        if(0)
            mode = 1
            to_chat(user, SPAN_NOTICE("You set the [name] to draw [power_level] Watts."))

/obj/machinery/power/crypto_miner/AltClick(mob/user)
    if(Adjacent(user))
        switch_mode(user)

/obj/machinery/power/CtrlClick(mob/user)
    START_PROCESSING(SSobj, src)
