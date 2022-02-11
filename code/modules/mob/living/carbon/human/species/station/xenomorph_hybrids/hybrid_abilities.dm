
/mob/living/human/proc/sprint()
    set name = "Sprinting"
    set desc = "Allows you to move much faster at the cost of increased hunger."
    set category = "Abilities"

    var/mob/living/carbon/human/C = src
    if(C.nutrition < 15)//You need some nutrition to sprint around..
        to_chat(C, "<span class='notice'>You lack the nutrition to run.</span>")
        return
    if(restrained())
        to_chat(C, "<span class='notice'>You can't sprint while restraint.</span>")
        return
    
    if(C.species.slowdown < C.old_slow)
        C.species.slowdown = C.old_slow
        C.species.hunger_factor -= 0.05
        to_chat(C, "<span class='notice'>You begin to move slower again.</span>")
    else
        to_chat(C, "<span class='notice'>You begin to move faster.</span>")
        C.species.slowdown -= 1
        C.species.hunger_factor += 0.05

/mob/living/carbon/human/proc/active_heal()
    set name = "Focused Healing"
    set desc = "You focus on regenerating your wounds."
    set category = "Abilities"

    src.healing = !src.healing
    if(healing)
        to_chat(src, "<span class='notice'>You begin to heal faster.</span>")
    else
        to_chat(src, "<span class='notice'>You stop healing faster.</span>")
