/datum/design/item/general/translator_all
  name = "handheld omni-translator"
  id = "translator_all"
  req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)
  materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 3000, "gold" = 500, "silver" = 500)
  build_path = /obj/item/universal_translator/all
  sort_string = "TAACC"

/datum/design/item/general/ear_translator_all
  name = "earpiece omni-translator"
  id = "ear_translator_all"
  req_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 6)	//dude what hte fuck lmao
  materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "gold" = 2000, "silver" = 2000)
  build_path = /obj/item/universal_translator/ear/all
  sort_string = "TAACD"
