# Interfaces Folder

TGUI interfaces go in here.

## Interface Routing

The following paths are routed:
- ./ (for everything else)
. ./computers (for computers and consoles)
- ./items (for items)
- ./machines (for machinery for any kind)
- ./modules (for TGUI modules)

This means that we **only** search for interfaces in these paths. `routes.js` controls this routing.

Interface routing uses the following paths:
- {dir}/{name}.js
- {dir}/{name}.tsx
- {dir}/{name}/index.js
- {dir}/{name}/index.tsx

This means your interface must match one of these, *and* export the {name} in an `export const` for this to work!

## Interface Prefixes

Interfaces are resolved by name only. Two interfaces in different folders with the same name will collide.
Hence, prefixes are enforced for the following folders:

- ./modules interfaces should begin with `TGUI`, e.g. `TGUICardMod`
- ./ui interfaces should begin with `UI`, e.g. `UIListPicker`

## Common Interfaces

Common interfaces that are meant to be *potentially* standalone can be a /datum/tgui_module, whose interfaces generally goes in ./modules.

Common interfaces that are not meant to be standalone go in ./common. See ./common/Access.tsx for an example.
