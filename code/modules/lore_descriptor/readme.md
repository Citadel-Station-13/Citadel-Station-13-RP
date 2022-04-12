# Culture_Descriptors

## Introduction

Basically the way this all works is that Languages, Economic Modifiers, etc.
(essentially non-physical traits) are inherited from the cultures the species is set to get.

### Culture

So culture is essentially how you live. Like it could be a basic descriptor of
a species' way of life (like Diona's), or it could be a caste or level you're in
a society (like Skrell's)

### Factions

Factions are what you think they are. Companies, Governments, etc.
When culture showed your way of life, this can show how you lived (Unathi for example).

### Locations

Locations are signifigant places, generally chosen for where you came from or grew up.
These also have details such as the capital of this location, or what is the ruling body.

#### Univerasl Vars

All culture_descriptors can generally come with these values, to which you can customize:

- name

Names are what you think they are. It's the visual name of the culture.
We generally define a var to hold these in `code\__DEFINES\species\culture.dm`

- description

Also what you think they are. This is the blurb of information the player can read
so they can get a basic understanding of their culture

- language

Language is the primary language inherented from this culture. By default this is set to GALCOM

- secondary_langs

These are additional langauges which are forced onto you to know. Generally used for GALCOM

- optional_langs

These are optional languages that the player can choose due to their culture.

- hidden

This hides the culture from being seen unless you have this culture. Check Xenos.

- economic_power

This is a modifier that is added up from all your descriptors to influence how much money you start with.

#### Faction-Specific Vars

- mob_faction

This is used for faction/mob interaction. Mainly so you can set the faction of a mob and they shouldn't hurt you if you're in their faction.

#### Location-Specific Vars

- distance

Distance is the distance to our choice point of origin. Originally being Sol.

- ruling_body

The ruling body of the location, by default it's set to FACTION_SOL_CENTRAL

- captial

The capital of this location. Isn't set by default.
