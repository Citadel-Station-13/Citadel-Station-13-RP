# Tools 

External tools, including our build script, are stored in here.

All versions are grabbed from ../dependencies.sh

- /bootstrap: Used to setup, and execute our scripts within the 'tools' context with the given verison from ../dependencies.sh
- /build: The build system
- /ci: Scripts used for our CI suite
- /common: Common functions/things to include.

# Todo

we still need to develop:

- github webhook processor replacement in js if possible to replace server'd infrastructure with only needing to put it on github actions
- we use actions caches based on the overall dependency file. we should only build the cache key off of the actual thing being cached, to avoid unnecessary cache rebuilding.
- proper matrix'd / concurrent ci building for all maps
- proper map / icon lint / merge infrastructure / make it more clear
- clean up the rest of this folder

