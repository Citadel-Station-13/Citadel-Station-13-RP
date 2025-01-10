# Click Handling

Contains:

* Low level click handling
* Clickchain procs

The game's core / low-level click procs have the job of constructing
a `/datum/event_args/actor/clickchain`, which is then fed into unified clickchain handling.

Clickchain handling exists at the `/mob`, and `/obj/item` level.
The latter is used to handle clicking-with-item. The former is used to handle unarmed interactions.
Consequently, `/mob` clickchains are usually slightly less complicated than those on `/obj/item`.

Things like action buttons capturing clicks should be handled **before** entering clickchains.
