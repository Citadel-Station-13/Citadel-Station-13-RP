//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Constants *//

#define REAGENT_HOLDER_VOLUME_PRECISION 0.00001
#define REAGENT_HOLDER_VOLUME_QUANTIZE(VAL) round(VAL, REAGENT_HOLDER_VOLUME_PRECISION)

//* flags for /datum/reagent_holder/var/reagent_holder_flags *//

/// currently reacting
#define REAGENT_HOLDER_FLAG_CURRENTLY_REACTING (1<<0)
