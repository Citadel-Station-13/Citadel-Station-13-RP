# Icons

This folder contains all(most) of our .dmi files.

We enforce a rigid-ish structure for organization.

*Please* contact a maintainer before changing the hierarchy!

## Hierarchy

**Anything not in here is currently undecided and may be freely placed.**
Yes, this currently includes all turfs, mobs, objs, and misc things. Sorry. We'll work on this, we promise. Anyone can propose changes to the hierarchy, just know what you're doing!

### Sub-hierarchies

/enigmas, /factions, /modules are subhierarchies for storing specific groups within /code/game/enigams, /code/game/factions, /code/modules.

This is to further enforce namespacing and reduce in the amount of over-filled icon folders.

### Hierarchy View

- /icons
  - /clothing - general, non-module clothing items placed in here
    - /{type} - uniform, head, shoes, suit, etc
      - /costumes - vanity costumes like kilts, mime outfits, clown outfits, cueball outfits, etc
      - /formal - formalwear like siuts, dresses, etc
      - /job - basic job uniforms
      - /misc - unsorted things
      - /rank - "formal" "rank"-wear like flight suits, military/naval, etc
    - /gearsets - bundled sets, like voidsuits, cryosuits, etc
  - /enigmas - one-off / specific / themed content goes in here
    - /\<enigma-name\> - everything under this is optional; these 4 paths are the recommendations.
      - /clothing
      - /items
      - /machinery
      - /structures
  - /factions - faction content goes in here
    - /\<faction-name\> - everything under this is optional; these 4 paths are the recommendations.
      - /clothing
      - /items
      - /machinery
      - /structures
  - /items - general, non-module, non-clothing items placed in here
  - /machinery - used for sprites for general, non-module machines. use subdirectories if more than one .dmi is needed, or for closely related machinery.
  - /mapping - used for sprites for in-map-editor objects that are   invisible in game world
    - /helpers - mapping helpers like autopipe/autocable/baseturf replacers   go here
    - /landmarks - landmark icons
    - /spawners - things like window spawners
  - /modules - used for specific departments / content packs / logical bundles
    - /{modulename} - everything under this is optional; these 4 paths are the recommendations.
      - /items - items
      - /clothing - clothing
      - /machinery - machinery
      - /structures - structures
  - /objects - miscellaneous objects that are not items, machinery, or structures
  - /overmaps - **All** overmap sprites, whether or not it's screen   rendering, goes in here
  - /runtime - follow similar structure inside this, treat it as a   sub-copy. icons in this are copied over for use during runtime
    - **Warning!** - everything not in this folder cannot be accessed by   "filename" and must be compiled in with 'filename'.
  - /screen - all screen objects, like hud icons, buttons, inventory   interface, parallax, etc
    - /actions - all action button sprites go in here
    - /atom_hud - the /image huds that atoms can have has their icons in   here
    - /fullscreen - fullscreen effects go in here (see code/_rendering/  fullscreen)
    - /hud - "regular" hud objects go in here, like mob intent buttons,   inventory buttons, etc
      - /common - common, theme-agnostic icons
      - /theme1, /theme2, ..., etc - put theme icons in here, name by theme!
    - /parallax - parallax/skybox images. base parallax images are 480x480.
    - /rendering - low level rendering things like clickcatcher
  - /structures - used for sprites for general, non-module structures. use subdirectories if more than one .dmi is needed, or for closely related structures.
  - /system - used for internal fuctions, like get_flat_icon and similar.
