# Signals

## Naming

- Signals should be named `COMSIG_<CATEGORY>_<DESCRIBE>`
- Return flags should be named `RAISE_<CATEGORY>_<DESCRIBE>_*`

## Hierarchy

- /components - component-specific signals, `signals_component_*`
- /datums - datum-specific signals, `signals_<datumname>`
- /elements - element-specific signals, `signals_element_*`
- /items - item-specific signals, `signals_<itemname>`
- /modules - sets of signals for a module, `signals_module_*`
- /signals_atom - /atom signals, `signals_atom_*` or `signals_movable_*`
- /signals_item - /item signals, `signals_item_*`
- /signals_mob - /mob signals, `signals_mob_*`
