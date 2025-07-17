# Game System - Backend

The core game system of Citadel RP

As a non-traditional ss13 server, we employ a modular approach to round flow

There's some modules to note here:

## Game

This module holds the 'active' components of the game:

- Factions
- Objectives

Ticking / management is done by SSticker, which is responsible for ticking and processing the round's elements.

This module **executes** the world.

## Storyteller

This module places 'pawns' into place in a given round for the desired experience.

Ticking / management is done by SSstoryteller, which is responsible for controlling the round's flow by placing pawns and firing off events.

This module **acts** for the world.

## World

TODO: rename this something other than 'world' because 'world' is a BYOND concept.

This module has the core definitions and relationship definitions of things like world factions, locations, associated lore, etc.

Management is done by SSgame_world, but at some point, might be moved to a static repository.

This is the only 'non-ticking' module; it **describes** the world, as opposed to acts as the world.
