# Icons

This folder contains all(most) of our .dmi files.

We enforce a rigid-ish structure for organization.

*Please* contact a maintainer before changing the hierarchy!

## Hierarchy

**Anything not in here is currently undecided and may be freely placed.**
Yes, this currently includes all turfs, mobs, objs, and misc things. Sorry. We'll work on this, we promise. Anyone can propose changes to the hierarchy, just know what you're doing!

- /icons
  - /clothing - clothing items placed in here
    - /uniform - uniforms
    - /costumes - vanity costumes like kilts, mime outfits, clown outfits, cueball outfits, etc
    - /formal - formalwear like siuts, dresses, etc
    - /job - basic job uniforms
    - /misc - unsorted things
    - /rank - "formal" "rank"-wear like flight suits, military/naval, etc
  - /machinery - used for sprites for general, non-module machines. use subdirectories if more than one .dmi is needed.
  - /mapping - used for sprites for in-map-editor objects that are   invisible in game world
    - /helpers - mapping helpers like autopipe/autocable/baseturf replacers   go here
    - /landmarks - landmark icons
    - /spawners - things like window spawners
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
