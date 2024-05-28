# atom hud system

atom HUDs are ultimately a way to attach /image's to specific /atom's, and manage showing/hiding them from consumers.

atom HUDs consist of 2 parts

## /datum/atom_hud_provider

provides icons to atom huds. tracks and processes updates.

## /datum/atom_hud

this is a hud that draws from a group of providers to provide those images to **perspectives** that use it.
