/// Generates full subtypes for sofas.
#define GENERATE_SOFA(PATH, SOFA_NAME, PREVIEW_COLOR, MAT_TYPE, REINF_MAT_TYPE) \
##PATH/##SOFA_NAME {                   \
    icon_state = "sofamiddle";         \
    base_icon_state = "sofamiddle";    \
    color = PREVIEW_COLOR;             \
    material = MAT_TYPE;               \
    reinf_material = REINF_MAT_TYPE;   \
}                                      \
##PATH/##SOFA_NAME/right {             \
    icon_state = "sofaend_right";      \
    base_icon_state = "sofaend_right"; \
    color = PREVIEW_COLOR;             \
    material = MAT_TYPE;               \
    reinf_material = REINF_MAT_TYPE;   \
}                                      \
##PATH/##SOFA_NAME/left {              \
    icon_state = "sofaend_left";       \
    base_icon_state = "sofaend_left";  \
    color = PREVIEW_COLOR;             \
    material = MAT_TYPE;               \
    reinf_material = REINF_MAT_TYPE;   \
}                                      \
##PATH/##SOFA_NAME/corner {            \
    icon_state = "sofacorner";         \
    base_icon_state = "sofacorner";    \
    color = PREVIEW_COLOR;             \
    material = MAT_TYPE;               \
    reinf_material = REINF_MAT_TYPE;   \
}

GENERATE_SOFA(/obj/structure/bed/chair/sofa, beige,  "#CEB689", /datum/material/solid/wood, /datum/material/solid/cloth/beige)
GENERATE_SOFA(/obj/structure/bed/chair/sofa, black,  "#505050", /datum/material/solid/wood, /datum/material/solid/cloth/black)
GENERATE_SOFA(/obj/structure/bed/chair/sofa, blue,   "#46698C", /datum/material/solid/wood, /datum/material/solid/cloth/blue)
GENERATE_SOFA(/obj/structure/bed/chair/sofa, brown,  "#5C4831", /datum/material/solid/wood, /datum/material/solid/leather)
GENERATE_SOFA(/obj/structure/bed/chair/sofa, green,  "#B7F27D", /datum/material/solid/wood, /datum/material/solid/cloth/green)
GENERATE_SOFA(/obj/structure/bed/chair/sofa, lime,   "#62E36C", /datum/material/solid/wood, /datum/material/solid/cloth/lime)
GENERATE_SOFA(/obj/structure/bed/chair/sofa, purp,   "#9933FF", /datum/material/solid/wood, /datum/material/solid/cloth/purple) //TODO: RENAME TO PURPLE, WHY IS IT PURP
GENERATE_SOFA(/obj/structure/bed/chair/sofa, red,    "#9D2300", /datum/material/solid/wood, /datum/material/solid/cloth/red)
GENERATE_SOFA(/obj/structure/bed/chair/sofa, teal,   "#00E1FF", /datum/material/solid/wood, /datum/material/solid/cloth/teal)
GENERATE_SOFA(/obj/structure/bed/chair/sofa, yellow, "#FFBF00", /datum/material/solid/wood, /datum/material/solid/cloth/yellow)

#undef GENERATE_SOFA
