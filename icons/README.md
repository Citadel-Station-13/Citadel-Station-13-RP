# Icons

This folder contains all(most) of our .dmi files.

We enforce a rigid-ish structure for organization.

*Please* contact a maintainer before changing the hierarchy!

## Hierarchy

**Anything not in here is currently undecided and may be freely placed.**
Yes, this currently includes all turfs, mobs, objs, and misc things. Sorry. We'll work on this, we promise. Anyone can propose changes to the hierarchy, just know what you're doing!

- /icons
  - /clothing - general, non-module clothing items placed in here
    - /{type} - uniform, head, shoes, suit, etc
      - /costumes - vanity costumes like kilts, mime outfits, clown outfits, cueball outfits, etc
      - /formal - formalwear like suits, dresses, etc
      - /job - basic job uniforms
      - /misc - unsorted things
      - /rank - "formal" "rank"-wear like flight suits, military/naval, etc
    - /gearsets - bundled sets, like voidsuits, cryosuits, etc
  - /effects - generic visual effects that are not screen/rendering: e.g. attack, emp, bomb, etc.
  - /items - general, non-module, non-clothing items placed in here
    - /items/stacks - general `/obj/item/stack` types placed in here.
  - /interface - used for stuff going into spritesheets for tgui, etc. if it's a HUD object, it should go in /screen instead.
  - /machinery - used for sprites for general, non-module machines. use subdirectories if more than one .dmi is needed, or for closely related machinery.
  - /mapping - used for sprites for in-map-editor objects that are   invisible in game world
    - /helpers - mapping helpers like autopipe/autocable/baseturf replacers   go here
    - /landmarks - landmark icons
    - /spawners - things like window spawners
  - /materials - material sprites
  - /mob - mob sprites
    - /bodysets - limbs and their corrosponding sprite accessories & markings & miscellaneous.
                  used in the abstraction of limb sprite from limb definition.
    - /sprite_accessories - unconverted sprite accessories
    - /sprite_accessory - modern sprite accessory system
  - /modules - used for specific departments / content packs / logical bundles
    - /{modulename} - the examples below are just that, examples. some modules will require different styles of icon organization.
      - /items - items
      - /clothing - clothing
      - /machinery - machinery
      - /structures - structures
  - /objects - miscellaneous objects that are not items, machinery, or structures
  - /runtime - follow similar structure inside this, treat it as a   sub-copy. icons in this are copied over for use during runtime
    - currently being deprecated; we have chosen to instead copy over all icons/sounds, so the runtime
      server can access them.
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
