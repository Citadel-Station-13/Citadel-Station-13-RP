# Introspection Module

A fully functional, self-contained module for performing debugging and manipulation actions on the game.

Contains the following:
- View / Edit Variables
- Function Calling
- Arbitrary Datum Marking & Retrieval
- "Backreferencing" system for contextual marking

Limitations / Caveats:
- The entire system is namespaced on /datum, and /datum/vv_context. The system will not work without a /datum/vv_context set up. This makes it slightly fragile when doing low level debugging, when there's no assuredness of /datum/vv_context being bound / hooked correctly.
- Backreferences are **not** to be treated as a security measure. They can be freely forged via href, and are there for convenience purposes rather than security purposes.
- **Deletions** are specifically forbidden to be hooked, unlike everything else. Hooking VV deletes implies special behavior for VV, which we want to avoid because it leads to weird code practices. The only place this is changed is globally on /datum/vv_context, which is where you put codebase specific handling for things like /turfs.
