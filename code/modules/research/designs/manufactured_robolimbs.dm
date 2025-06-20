#define DEFINE_PROSTHETIC_HEAD(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/head/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_TORSO_M(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/torso/male/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_TORSO_T(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/torso/female/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_ARM_L(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/l_arm/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_HAND_L(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/l_hand/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_LEG_L(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/l_leg/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_FOOT_L(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/l_foot/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_ARM_R(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/r_arm/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_HAND_R(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/r_hand/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_LEG_R(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/r_leg/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_FOOT_R(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/r_foot/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}


DEFINE_PROSTHETIC_HEAD(bishop, "Bishop", "bishop_head")
DEFINE_PROSTHETIC_TORSO_M(bishop, "Bishop", "bishop_mtorso")
DEFINE_PROSTHETIC_TORSO_T(bishop, "Bishop", "bishop_ftorso")
DEFINE_PROSTHETIC_ARM_L(bishop, "Bishop", "bishop_l_arm")
DEFINE_PROSTHETIC_HAND_L(bishop, "Bishop", "bishop_l_hand")
DEFINE_PROSTHETIC_LEG_L(bishop, "Bishop", "bishop_l_leg")
DEFINE_PROSTHETIC_FOOT_L(bishop, "Bishop", "bishop_l_foot")
DEFINE_PROSTHETIC_ARM_R(bishop, "Bishop", "bishop_r_arm")
DEFINE_PROSTHETIC_HAND_R(bishop, "Bishop", "bishop_r_hand")
DEFINE_PROSTHETIC_LEG_R(bishop, "Bishop", "bishop_r_leg")
DEFINE_PROSTHETIC_FOOT_R(bishop, "Bishop", "bishop_r_foot")

DEFINE_PROSTHETIC_HEAD(mpc, "Moghes Prosthetics Company", "mpc_head")
DEFINE_PROSTHETIC_TORSO_M(mpc, "Moghes Prosthetics Company", "mpc_mtorso")
DEFINE_PROSTHETIC_TORSO_T(mpc, "Moghes Prosthetics Company", "mpc_ftorso")
DEFINE_PROSTHETIC_ARM_L(mpc, "Moghes Prosthetics Company", "mpc_l_arm")
DEFINE_PROSTHETIC_HAND_L(mpc, "Moghes Prosthetics Company", "mpc_l_hand")
DEFINE_PROSTHETIC_LEG_L(mpc, "Moghes Prosthetics Company", "mpc_l_leg")
DEFINE_PROSTHETIC_FOOT_L(mpc, "Moghes Prosthetics Company", "mpc_l_foot")
DEFINE_PROSTHETIC_ARM_R(mpc, "Moghes Prosthetics Company", "mpc_r_arm")
DEFINE_PROSTHETIC_HAND_R(mpc, "Moghes Prosthetics Company", "mpc_r_hand")
DEFINE_PROSTHETIC_LEG_R(mpc, "Moghes Prosthetics Company", "mpc_r_leg")
DEFINE_PROSTHETIC_FOOT_R(mpc, "Moghes Prosthetics Company", "mpc_r_foot")

DEFINE_PROSTHETIC_HEAD(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_head")
DEFINE_PROSTHETIC_TORSO_M(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_mtorso")
DEFINE_PROSTHETIC_TORSO_T(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_ftorso")
DEFINE_PROSTHETIC_ARM_L(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_l_arm")
DEFINE_PROSTHETIC_HAND_L(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_l_hand")
DEFINE_PROSTHETIC_LEG_L(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_l_leg")
DEFINE_PROSTHETIC_FOOT_L(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_l_foot")
DEFINE_PROSTHETIC_ARM_R(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_r_arm")
DEFINE_PROSTHETIC_HAND_R(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_r_hand")
DEFINE_PROSTHETIC_LEG_R(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_r_leg")
DEFINE_PROSTHETIC_FOOT_R(vulkan_brass, "Vulkan Brassworks Inc.", "vulkan_brass_r_foot")

DEFINE_PROSTHETIC_HEAD(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_head")
DEFINE_PROSTHETIC_TORSO_M(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_mtorso")
DEFINE_PROSTHETIC_TORSO_T(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_ftorso")
DEFINE_PROSTHETIC_ARM_L(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_l_arm")
DEFINE_PROSTHETIC_HAND_L(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_l_hand")
DEFINE_PROSTHETIC_LEG_L(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_l_leg")
DEFINE_PROSTHETIC_FOOT_L(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_l_foot")
DEFINE_PROSTHETIC_ARM_R(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_r_arm")
DEFINE_PROSTHETIC_HAND_R(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_r_hand")
DEFINE_PROSTHETIC_LEG_R(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_r_leg")
DEFINE_PROSTHETIC_FOOT_R(eggnerd, "Eggnerd Prototyping Ltd.", "eggnerd_r_foot")

DEFINE_PROSTHETIC_HEAD(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_head")
DEFINE_PROSTHETIC_TORSO_M(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_mtorso")
DEFINE_PROSTHETIC_TORSO_T(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_ftorso")
DEFINE_PROSTHETIC_ARM_L(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_l_arm")
DEFINE_PROSTHETIC_HAND_L(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_l_hand")
DEFINE_PROSTHETIC_LEG_L(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_l_leg")
DEFINE_PROSTHETIC_FOOT_L(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_l_foot")
DEFINE_PROSTHETIC_ARM_R(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_r_arm")
DEFINE_PROSTHETIC_HAND_R(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_r_hand")
DEFINE_PROSTHETIC_LEG_R(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_r_leg")
DEFINE_PROSTHETIC_FOOT_R(eggnerd_red, "Eggnerd Prototyping Ltd. (Red)", "eggnerd_red_r_foot")

DEFINE_PROSTHETIC_HEAD(oss_taj, "OSS - Tajaran", "oss_taj_head")
DEFINE_PROSTHETIC_TORSO_M(oss_taj, "OSS - Tajaran", "oss_taj_mtorso")
DEFINE_PROSTHETIC_TORSO_T(oss_taj, "OSS - Tajaran", "oss_taj_ftorso")
DEFINE_PROSTHETIC_ARM_L(oss_taj, "OSS - Tajaran", "oss_taj_l_arm")
DEFINE_PROSTHETIC_HAND_L(oss_taj, "OSS - Tajaran", "oss_taj_l_hand")
DEFINE_PROSTHETIC_LEG_L(oss_taj, "OSS - Tajaran", "oss_taj_l_leg")
DEFINE_PROSTHETIC_FOOT_L(oss_taj, "OSS - Tajaran", "oss_taj_l_foot")
DEFINE_PROSTHETIC_ARM_R(oss_taj, "OSS - Tajaran", "oss_taj_r_arm")
DEFINE_PROSTHETIC_HAND_R(oss_taj, "OSS - Tajaran", "oss_taj_r_hand")
DEFINE_PROSTHETIC_LEG_R(oss_taj, "OSS - Tajaran", "oss_taj_r_leg")
DEFINE_PROSTHETIC_FOOT_R(oss_taj, "OSS - Tajaran", "oss_taj_r_foot")

DEFINE_PROSTHETIC_HEAD(oss_liz, "OSS - Lizard", "oss_liz_head")
DEFINE_PROSTHETIC_TORSO_M(oss_liz, "OSS - Lizard", "oss_liz_mtorso")
DEFINE_PROSTHETIC_TORSO_T(oss_liz, "OSS - Lizard", "oss_liz_ftorso")
DEFINE_PROSTHETIC_ARM_L(oss_liz, "OSS - Lizard", "oss_liz_l_arm")
DEFINE_PROSTHETIC_HAND_L(oss_liz, "OSS - Lizard", "oss_liz_l_hand")
DEFINE_PROSTHETIC_LEG_L(oss_liz, "OSS - Lizard", "oss_liz_l_leg")
DEFINE_PROSTHETIC_FOOT_L(oss_liz, "OSS - Lizard", "oss_liz_l_foot")
DEFINE_PROSTHETIC_ARM_R(oss_liz, "OSS - Lizard", "oss_liz_r_arm")
DEFINE_PROSTHETIC_HAND_R(oss_liz, "OSS - Lizard", "oss_liz_r_hand")
DEFINE_PROSTHETIC_LEG_R(oss_liz, "OSS - Lizard", "oss_liz_r_leg")
DEFINE_PROSTHETIC_FOOT_R(oss_liz, "OSS - Lizard", "oss_liz_r_foot")

DEFINE_PROSTHETIC_HEAD(oss_cheese, "OSS - Naramadi", "oss_cheese_head")
DEFINE_PROSTHETIC_TORSO_M(oss_cheese, "OSS - Naramadi", "oss_cheese_mtorso")
DEFINE_PROSTHETIC_TORSO_T(oss_cheese, "OSS - Naramadi", "oss_cheese_ftorso")
DEFINE_PROSTHETIC_ARM_L(oss_cheese, "OSS - Naramadi", "oss_cheese_l_arm")
DEFINE_PROSTHETIC_HAND_L(oss_cheese, "OSS - Naramadi", "oss_cheese_l_hand")
DEFINE_PROSTHETIC_LEG_L(oss_cheese, "OSS - Naramadi", "oss_cheese_l_leg")
DEFINE_PROSTHETIC_FOOT_L(oss_cheese, "OSS - Naramadi", "oss_cheese_l_foot")
DEFINE_PROSTHETIC_ARM_R(oss_cheese, "OSS - Naramadi", "oss_cheese_r_arm")
DEFINE_PROSTHETIC_HAND_R(oss_cheese, "OSS - Naramadi", "oss_cheese_r_hand")
DEFINE_PROSTHETIC_LEG_R(oss_cheese, "OSS - Naramadi", "oss_cheese_r_leg")
DEFINE_PROSTHETIC_FOOT_R(oss_cheese, "OSS - Naramadi", "oss_cheese_r_foot")

DEFINE_PROSTHETIC_HEAD(oss_nev, "OSS - Nevrean", "oss_nev_head")
DEFINE_PROSTHETIC_TORSO_M(oss_nev, "OSS - Nevrean", "oss_nev_mtorso")
DEFINE_PROSTHETIC_TORSO_T(oss_nev, "OSS - Nevrean", "oss_nev_ftorso")
DEFINE_PROSTHETIC_ARM_L(oss_nev, "OSS - Nevrean", "oss_nev_l_arm")
DEFINE_PROSTHETIC_HAND_L(oss_nev, "OSS - Nevrean", "oss_nev_l_hand")
DEFINE_PROSTHETIC_LEG_L(oss_nev, "OSS - Nevrean", "oss_nev_l_leg")
DEFINE_PROSTHETIC_FOOT_L(oss_nev, "OSS - Nevrean", "oss_nev_l_foot")
DEFINE_PROSTHETIC_ARM_R(oss_nev, "OSS - Nevrean", "oss_nev_r_arm")
DEFINE_PROSTHETIC_HAND_R(oss_nev, "OSS - Nevrean", "oss_nev_r_hand")
DEFINE_PROSTHETIC_LEG_R(oss_nev, "OSS - Nevrean", "oss_nev_r_leg")
DEFINE_PROSTHETIC_FOOT_R(oss_nev, "OSS - Nevrean", "oss_nev_r_foot")

DEFINE_PROSTHETIC_HEAD(oss_vlk, "OSS - Vulpkanin", "oss_vlk_head")
DEFINE_PROSTHETIC_TORSO_M(oss_vlk, "OSS - Vulpkanin", "oss_vlk_mtorso")
DEFINE_PROSTHETIC_TORSO_T(oss_vlk, "OSS - Vulpkanin", "oss_vlk_ftorso")
DEFINE_PROSTHETIC_ARM_L(oss_vlk, "OSS - Vulpkanin", "oss_vlk_l_arm")
DEFINE_PROSTHETIC_HAND_L(oss_vlk, "OSS - Vulpkanin", "oss_vlk_l_hand")
DEFINE_PROSTHETIC_LEG_L(oss_vlk, "OSS - Vulpkanin", "oss_vlk_l_leg")
DEFINE_PROSTHETIC_FOOT_L(oss_vlk, "OSS - Vulpkanin", "oss_vlk_l_foot")
DEFINE_PROSTHETIC_ARM_R(oss_vlk, "OSS - Vulpkanin", "oss_vlk_r_arm")
DEFINE_PROSTHETIC_HAND_R(oss_vlk, "OSS - Vulpkanin", "oss_vlk_r_hand")
DEFINE_PROSTHETIC_LEG_R(oss_vlk, "OSS - Vulpkanin", "oss_vlk_r_leg")
DEFINE_PROSTHETIC_FOOT_R(oss_vlk, "OSS - Vulpkanin", "oss_vlk_r_foot")

DEFINE_PROSTHETIC_HEAD(oss_shr, "OSS - Akula", "oss_shr_head")
DEFINE_PROSTHETIC_TORSO_M(oss_shr, "OSS - Akula", "oss_shr_mtorso")
DEFINE_PROSTHETIC_TORSO_T(oss_shr, "OSS - Akula", "oss_shr_ftorso")
DEFINE_PROSTHETIC_ARM_L(oss_shr, "OSS - Akula", "oss_shr_l_arm")
DEFINE_PROSTHETIC_HAND_L(oss_shr, "OSS - Akula", "oss_shr_l_hand")
DEFINE_PROSTHETIC_LEG_L(oss_shr, "OSS - Akula", "oss_shr_l_leg")
DEFINE_PROSTHETIC_FOOT_L(oss_shr, "OSS - Akula", "oss_shr_l_foot")
DEFINE_PROSTHETIC_ARM_R(oss_shr, "OSS - Akula", "oss_shr_r_arm")
DEFINE_PROSTHETIC_HAND_R(oss_shr, "OSS - Akula", "oss_shr_r_hand")
DEFINE_PROSTHETIC_LEG_R(oss_shr, "OSS - Akula", "oss_shr_r_leg")
DEFINE_PROSTHETIC_FOOT_R(oss_shr, "OSS - Akula", "oss_shr_r_foot")

DEFINE_PROSTHETIC_HEAD(oss_vas, "OSS - Vasilissan", "oss_vas_head")
DEFINE_PROSTHETIC_TORSO_M(oss_vas, "OSS - Vasilissan", "oss_vas_mtorso")
DEFINE_PROSTHETIC_TORSO_T(oss_vas, "OSS - Vasilissan", "oss_vas_ftorso")
DEFINE_PROSTHETIC_ARM_L(oss_vas, "OSS - Vasilissan", "oss_vas_l_arm")
DEFINE_PROSTHETIC_HAND_L(oss_vas, "OSS - Vasilissan", "oss_vas_l_hand")
DEFINE_PROSTHETIC_LEG_L(oss_vas, "OSS - Vasilissan", "oss_vas_l_leg")
DEFINE_PROSTHETIC_FOOT_L(oss_vas, "OSS - Vasilissan", "oss_vas_l_foot")
DEFINE_PROSTHETIC_ARM_R(oss_vas, "OSS - Vasilissan", "oss_vas_r_arm")
DEFINE_PROSTHETIC_HAND_R(oss_vas, "OSS - Vasilissan", "oss_vas_r_hand")
DEFINE_PROSTHETIC_LEG_R(oss_vas, "OSS - Vasilissan", "oss_vas_r_leg")
DEFINE_PROSTHETIC_FOOT_R(oss_vas, "OSS - Vasilissan", "oss_vas_r_foot")

DEFINE_PROSTHETIC_HEAD(oss_tsh, "OSS - Teshari", "oss_tsh_head")
DEFINE_PROSTHETIC_TORSO_M(oss_tsh, "OSS - Teshari", "oss_tsh_mtorso")
DEFINE_PROSTHETIC_TORSO_T(oss_tsh, "OSS - Teshari", "oss_tsh_ftorso")
DEFINE_PROSTHETIC_ARM_L(oss_tsh, "OSS - Teshari", "oss_tsh_l_arm")
DEFINE_PROSTHETIC_HAND_L(oss_tsh, "OSS - Teshari", "oss_tsh_l_hand")
DEFINE_PROSTHETIC_LEG_L(oss_tsh, "OSS - Teshari", "oss_tsh_l_leg")
DEFINE_PROSTHETIC_FOOT_L(oss_tsh, "OSS - Teshari", "oss_tsh_l_foot")
DEFINE_PROSTHETIC_ARM_R(oss_tsh, "OSS - Teshari", "oss_tsh_r_arm")
DEFINE_PROSTHETIC_HAND_R(oss_tsh, "OSS - Teshari", "oss_tsh_r_hand")
DEFINE_PROSTHETIC_LEG_R(oss_tsh, "OSS - Teshari", "oss_tsh_r_leg")
DEFINE_PROSTHETIC_FOOT_R(oss_tsh, "OSS - Teshari", "oss_tsh_r_foot")

DEFINE_PROSTHETIC_HEAD(cortexcases_mmi, "cortexCases - MMI", "cortexcases_mmi_head")
DEFINE_PROSTHETIC_HEAD(cortexcases_posi, "cortexCases - Posi", "cortexcases_posi_head")


DEFINE_PROSTHETIC_HEAD(cybersolutions_array, "Cyber Solutions - Array", "cybersolutions_array_head")

DEFINE_PROSTHETIC_HEAD(cybersolutions, "Cyber Solutions", "cybersolutions_head")
DEFINE_PROSTHETIC_TORSO_M(cybersolutions, "Cyber Solutions", "cybersolutions_mtorso")
DEFINE_PROSTHETIC_TORSO_T(cybersolutions, "Cyber Solutions", "cybersolutions_ftorso")
DEFINE_PROSTHETIC_ARM_L(cybersolutions, "Cyber Solutions", "cybersolutions_l_arm")
DEFINE_PROSTHETIC_HAND_L(cybersolutions, "Cyber Solutions", "cybersolutions_l_hand")
DEFINE_PROSTHETIC_LEG_L(cybersolutions, "Cyber Solutions", "cybersolutions_l_leg")
DEFINE_PROSTHETIC_FOOT_L(cybersolutions, "Cyber Solutions", "cybersolutions_l_foot")
DEFINE_PROSTHETIC_ARM_R(cybersolutions, "Cyber Solutions", "cybersolutions_r_arm")
DEFINE_PROSTHETIC_HAND_R(cybersolutions, "Cyber Solutions", "cybersolutions_r_hand")
DEFINE_PROSTHETIC_LEG_R(cybersolutions, "Cyber Solutions", "cybersolutions_r_leg")
DEFINE_PROSTHETIC_FOOT_R(cybersolutions, "Cyber Solutions", "cybersolutions_r_foot")

DEFINE_PROSTHETIC_HEAD(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_head")
DEFINE_PROSTHETIC_TORSO_M(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_mtorso")
DEFINE_PROSTHETIC_TORSO_T(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_ftorso")
DEFINE_PROSTHETIC_ARM_L(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_l_arm")
DEFINE_PROSTHETIC_HAND_L(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_l_hand")
DEFINE_PROSTHETIC_LEG_L(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_l_leg")
DEFINE_PROSTHETIC_FOOT_L(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_l_foot")
DEFINE_PROSTHETIC_ARM_R(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_r_arm")
DEFINE_PROSTHETIC_HAND_R(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_r_hand")
DEFINE_PROSTHETIC_LEG_R(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_r_leg")
DEFINE_PROSTHETIC_FOOT_R(cybersolutions_wight, "Cyber Solutions - Wight", "cybersolutions_wight_r_foot")

DEFINE_PROSTHETIC_HEAD(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_head")
DEFINE_PROSTHETIC_TORSO_M(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_mtorso")
DEFINE_PROSTHETIC_TORSO_T(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_ftorso")
DEFINE_PROSTHETIC_ARM_L(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_l_arm")
DEFINE_PROSTHETIC_HAND_L(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_l_hand")
DEFINE_PROSTHETIC_LEG_L(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_l_leg")
DEFINE_PROSTHETIC_FOOT_L(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_l_foot")
DEFINE_PROSTHETIC_ARM_R(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_r_arm")
DEFINE_PROSTHETIC_HAND_R(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_r_hand")
DEFINE_PROSTHETIC_LEG_R(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_r_leg")
DEFINE_PROSTHETIC_FOOT_R(cybersolutions_outmoded, "Cyber Solutions - Outdated", "cybersolutions_outmoded_r_foot")

DEFINE_PROSTHETIC_HEAD(morpheus, "Morpheus", "morpheus_head")
DEFINE_PROSTHETIC_HEAD(morpheus_zenit, "Morpheus - Zenith", "morpheus_head_zenit")
DEFINE_PROSTHETIC_HEAD(morpheus_skele, "Morpheus - Skeleton Crew", "morpheus_head_skele")
DEFINE_PROSTHETIC_TORSO_M(morpheus, "Morpheus", "morpheus_mtorso")
DEFINE_PROSTHETIC_TORSO_T(morpheus, "Morpheus", "morpheus_ftorso")
DEFINE_PROSTHETIC_ARM_L(morpheus, "Morpheus", "morpheus_l_arm")
DEFINE_PROSTHETIC_HAND_L(morpheus, "Morpheus", "morpheus_l_hand")
DEFINE_PROSTHETIC_LEG_L(morpheus, "Morpheus", "morpheus_l_leg")
DEFINE_PROSTHETIC_FOOT_L(morpheus, "Morpheus", "morpheus_l_foot")
DEFINE_PROSTHETIC_ARM_R(morpheus, "Morpheus", "morpheus_r_arm")
DEFINE_PROSTHETIC_HAND_R(morpheus, "Morpheus", "morpheus_r_hand")
DEFINE_PROSTHETIC_LEG_R(morpheus, "Morpheus", "morpheus_r_leg")
DEFINE_PROSTHETIC_FOOT_R(morpheus, "Morpheus", "morpheus_r_foot")

DEFINE_PROSTHETIC_HEAD(grayson, "Grayson", "grayson_head")
DEFINE_PROSTHETIC_HEAD(grayson_monitor, "Grayson Monitor", "grayson_monitor_head")
DEFINE_PROSTHETIC_TORSO_M(grayson, "Grayson", "grayson_mtorso")
DEFINE_PROSTHETIC_TORSO_T(grayson, "Grayson", "grayson_ftorso")
DEFINE_PROSTHETIC_ARM_L(grayson, "Grayson", "grayson_l_arm")
DEFINE_PROSTHETIC_HAND_L(grayson, "Grayson", "grayson_l_hand")
DEFINE_PROSTHETIC_LEG_L(grayson, "Grayson", "grayson_l_leg")
DEFINE_PROSTHETIC_FOOT_L(grayson, "Grayson", "grayson_l_foot")
DEFINE_PROSTHETIC_ARM_R(grayson, "Grayson", "grayson_r_arm")
DEFINE_PROSTHETIC_HAND_R(grayson, "Grayson", "grayson_r_hand")
DEFINE_PROSTHETIC_LEG_R(grayson, "Grayson", "grayson_r_leg")
DEFINE_PROSTHETIC_FOOT_R(grayson, "Grayson", "grayson_r_foot")

DEFINE_PROSTHETIC_HEAD(grayson_rein, "Grayson - Reinforced", "grayson_rein_head")
DEFINE_PROSTHETIC_TORSO_M(grayson_rein, "Grayson - Reinforced", "grayson_rein_mtorso")
DEFINE_PROSTHETIC_TORSO_T(grayson_rein, "Grayson - Reinforced", "grayson_rein_ftorso")
DEFINE_PROSTHETIC_ARM_L(grayson_rein, "Grayson - Reinforced", "grayson_rein_l_arm")
DEFINE_PROSTHETIC_HAND_L(grayson_rein, "Grayson - Reinforced", "grayson_rein_l_hand")
DEFINE_PROSTHETIC_LEG_L(grayson_rein, "Grayson - Reinforced", "grayson_rein_l_leg")
DEFINE_PROSTHETIC_FOOT_L(grayson_rein, "Grayson - Reinforced", "grayson_rein_l_foot")
DEFINE_PROSTHETIC_ARM_R(grayson_rein, "Grayson - Reinforced", "grayson_rein_r_arm")
DEFINE_PROSTHETIC_HAND_R(grayson_rein, "Grayson - Reinforced", "grayson_rein_r_hand")
DEFINE_PROSTHETIC_LEG_R(grayson_rein, "Grayson - Reinforced", "grayson_rein_r_leg")
DEFINE_PROSTHETIC_FOOT_R(grayson_rein, "Grayson - Reinforced", "grayson_rein_r_foot")

DEFINE_PROSTHETIC_HEAD(hephaestus, "Hephaestus", "hephaestus_head")
DEFINE_PROSTHETIC_TORSO_M(hephaestus, "Hephaestus", "hephaestus_mtorso")
DEFINE_PROSTHETIC_TORSO_T(hephaestus, "Hephaestus", "hephaestus_ftorso")
DEFINE_PROSTHETIC_ARM_L(hephaestus, "Hephaestus", "hephaestus_l_arm")
DEFINE_PROSTHETIC_HAND_L(hephaestus, "Hephaestus", "hephaestus_l_hand")
DEFINE_PROSTHETIC_LEG_L(hephaestus, "Hephaestus", "hephaestus_l_leg")
DEFINE_PROSTHETIC_FOOT_L(hephaestus, "Hephaestus", "hephaestus_l_foot")
DEFINE_PROSTHETIC_ARM_R(hephaestus, "Hephaestus", "hephaestus_r_arm")
DEFINE_PROSTHETIC_HAND_R(hephaestus, "Hephaestus", "hephaestus_r_hand")
DEFINE_PROSTHETIC_LEG_R(hephaestus, "Hephaestus", "hephaestus_r_leg")
DEFINE_PROSTHETIC_FOOT_R(hephaestus, "Hephaestus", "hephaestus_r_foot")

DEFINE_PROSTHETIC_HEAD(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_head")
DEFINE_PROSTHETIC_TORSO_M(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_mtorso")
DEFINE_PROSTHETIC_TORSO_T(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_ftorso")
DEFINE_PROSTHETIC_ARM_L(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_l_arm")
DEFINE_PROSTHETIC_HAND_L(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_l_hand")
DEFINE_PROSTHETIC_LEG_L(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_l_leg")
DEFINE_PROSTHETIC_FOOT_L(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_l_foot")
DEFINE_PROSTHETIC_ARM_R(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_r_arm")
DEFINE_PROSTHETIC_HAND_R(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_r_hand")
DEFINE_PROSTHETIC_LEG_R(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_r_leg")
DEFINE_PROSTHETIC_FOOT_R(hephaestus_frontier, "Hephaestus - Frontier", "hephaestus_frontier_r_foot")

DEFINE_PROSTHETIC_HEAD(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_head")
DEFINE_PROSTHETIC_TORSO_M(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_mtorso")
DEFINE_PROSTHETIC_TORSO_T(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_ftorso")
DEFINE_PROSTHETIC_ARM_L(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_l_arm")
DEFINE_PROSTHETIC_HAND_L(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_l_hand")
DEFINE_PROSTHETIC_LEG_L(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_l_leg")
DEFINE_PROSTHETIC_FOOT_L(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_l_foot")
DEFINE_PROSTHETIC_ARM_R(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_r_arm")
DEFINE_PROSTHETIC_HAND_R(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_r_hand")
DEFINE_PROSTHETIC_LEG_R(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_r_leg")
DEFINE_PROSTHETIC_FOOT_R(hephaestus_athena, "Hephaestus - Athena", "hephaestus_athena_r_foot")

DEFINE_PROSTHETIC_HEAD(veymed, "Vey-Med", "veymed_head")
DEFINE_PROSTHETIC_TORSO_M(veymed, "Vey-Med", "veymed_mtorso")
DEFINE_PROSTHETIC_TORSO_T(veymed, "Vey-Med", "veymed_ftorso")
DEFINE_PROSTHETIC_ARM_L(veymed, "Vey-Med", "veymed_l_arm")
DEFINE_PROSTHETIC_HAND_L(veymed, "Vey-Med", "veymed_l_hand")
DEFINE_PROSTHETIC_LEG_L(veymed, "Vey-Med", "veymed_l_leg")
DEFINE_PROSTHETIC_FOOT_L(veymed, "Vey-Med", "veymed_l_foot")
DEFINE_PROSTHETIC_ARM_R(veymed, "Vey-Med", "veymed_r_arm")
DEFINE_PROSTHETIC_HAND_R(veymed, "Vey-Med", "veymed_r_hand")
DEFINE_PROSTHETIC_LEG_R(veymed, "Vey-Med", "veymed_r_leg")
DEFINE_PROSTHETIC_FOOT_R(veymed, "Vey-Med", "veymed_r_foot")

DEFINE_PROSTHETIC_HEAD(psyche_moth, "Psyche - Moth", "psyche_moth_head")
DEFINE_PROSTHETIC_TORSO_M(psyche_moth, "Psyche - Moth", "psyche_moth_mtorso")
DEFINE_PROSTHETIC_TORSO_T(psyche_moth, "Psyche - Moth", "psyche_moth_ftorso")
DEFINE_PROSTHETIC_ARM_L(psyche_moth, "Psyche - Moth", "psyche_moth_l_arm")
DEFINE_PROSTHETIC_HAND_L(psyche_moth, "Psyche - Moth", "psyche_moth_l_hand")
DEFINE_PROSTHETIC_LEG_L(psyche_moth, "Psyche - Moth", "psyche_moth_l_leg")
DEFINE_PROSTHETIC_FOOT_L(psyche_moth, "Psyche - Moth", "psyche_moth_l_foot")
DEFINE_PROSTHETIC_ARM_R(psyche_moth, "Psyche - Moth", "psyche_moth_r_arm")
DEFINE_PROSTHETIC_HAND_R(psyche_moth, "Psyche - Moth", "psyche_moth_r_hand")
DEFINE_PROSTHETIC_LEG_R(psyche_moth, "Psyche - Moth", "psyche_moth_r_leg")
DEFINE_PROSTHETIC_FOOT_R(psyche_moth, "Psyche - Moth", "psyche_moth_r_foot")

DEFINE_PROSTHETIC_HEAD(psyche_insect, "Psyche - Insect", "psyche_insect_head")
DEFINE_PROSTHETIC_TORSO_M(psyche_insect, "Psyche - Insect", "psyche_insect_mtorso")
DEFINE_PROSTHETIC_TORSO_T(psyche_insect, "Psyche - Insect", "psyche_insect_ftorso")
DEFINE_PROSTHETIC_ARM_L(psyche_insect, "Psyche - Insect", "psyche_insect_l_arm")
DEFINE_PROSTHETIC_HAND_L(psyche_insect, "Psyche - Insect", "psyche_insect_l_hand")
DEFINE_PROSTHETIC_LEG_L(psyche_insect, "Psyche - Insect", "psyche_insect_l_leg")
DEFINE_PROSTHETIC_FOOT_L(psyche_insect, "Psyche - Insect", "psyche_insect_l_foot")
DEFINE_PROSTHETIC_ARM_R(psyche_insect, "Psyche - Insect", "psyche_insect_r_arm")
DEFINE_PROSTHETIC_HAND_R(psyche_insect, "Psyche - Insect", "psyche_insect_r_hand")
DEFINE_PROSTHETIC_LEG_R(psyche_insect, "Psyche - Insect", "psyche_insect_r_leg")
DEFINE_PROSTHETIC_FOOT_R(psyche_insect, "Psyche - Insect", "psyche_insect_r_foot")

DEFINE_PROSTHETIC_HEAD(wt, "Ward-Takahashi", "wt_head")
DEFINE_PROSTHETIC_HEAD(wt_monitor, "Ward-Takahashi Monitor", "wt_head_for_playing_doom")
DEFINE_PROSTHETIC_HEAD(wt_shroud, "Ward-Takahashi - Shroud", "wt_head_shroud")
DEFINE_PROSTHETIC_TORSO_M(wt, "Ward-Takahashi", "wt_mtorso")
DEFINE_PROSTHETIC_TORSO_T(wt, "Ward-Takahashi", "wt_ftorso")
DEFINE_PROSTHETIC_ARM_L(wt, "Ward-Takahashi", "wt_l_arm")
DEFINE_PROSTHETIC_HAND_L(wt, "Ward-Takahashi", "wt_l_hand")
DEFINE_PROSTHETIC_LEG_L(wt, "Ward-Takahashi", "wt_l_leg")
DEFINE_PROSTHETIC_FOOT_L(wt, "Ward-Takahashi", "wt_l_foot")
DEFINE_PROSTHETIC_ARM_R(wt, "Ward-Takahashi", "wt_r_arm")
DEFINE_PROSTHETIC_HAND_R(wt, "Ward-Takahashi", "wt_r_hand")
DEFINE_PROSTHETIC_LEG_R(wt, "Ward-Takahashi", "wt_r_leg")
DEFINE_PROSTHETIC_FOOT_R(wt, "Ward-Takahashi", "wt_r_foot")

DEFINE_PROSTHETIC_HEAD(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_head")
DEFINE_PROSTHETIC_TORSO_M(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_mtorso")
DEFINE_PROSTHETIC_TORSO_T(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_ftorso")
DEFINE_PROSTHETIC_ARM_L(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_l_arm")
DEFINE_PROSTHETIC_HAND_L(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_l_hand")
DEFINE_PROSTHETIC_LEG_L(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_l_leg")
DEFINE_PROSTHETIC_FOOT_L(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_l_foot")
DEFINE_PROSTHETIC_ARM_R(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_r_arm")
DEFINE_PROSTHETIC_HAND_R(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_r_hand")
DEFINE_PROSTHETIC_LEG_R(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_r_leg")
DEFINE_PROSTHETIC_FOOT_R(wt_spirit, "Ward-Takahashi - Spirit", "wt_spirit_r_foot")

DEFINE_PROSTHETIC_HEAD(xion, "Xion", "xion_head")
DEFINE_PROSTHETIC_HEAD(xion_monitor, "Xion Monitor", "xion_head_monitor")
DEFINE_PROSTHETIC_TORSO_M(xion, "Xion", "xion_mtorso")
DEFINE_PROSTHETIC_TORSO_T(xion, "Xion", "xion_ftorso")
DEFINE_PROSTHETIC_ARM_L(xion, "Xion", "xion_l_arm")
DEFINE_PROSTHETIC_HAND_L(xion, "Xion", "xion_l_hand")
DEFINE_PROSTHETIC_LEG_L(xion, "Xion", "xion_l_leg")
DEFINE_PROSTHETIC_FOOT_L(xion, "Xion", "xion_l_foot")
DEFINE_PROSTHETIC_ARM_R(xion, "Xion", "xion_r_arm")
DEFINE_PROSTHETIC_HAND_R(xion, "Xion", "xion_r_hand")
DEFINE_PROSTHETIC_LEG_R(xion, "Xion", "xion_r_leg")
DEFINE_PROSTHETIC_FOOT_R(xion, "Xion", "xion_r_foot")

DEFINE_PROSTHETIC_HEAD(xion_breach, "Xion - Breach", "xion_breach_head")
DEFINE_PROSTHETIC_TORSO_M(xion_breach, "Xion - Breach", "xion_breach_mtorso")
DEFINE_PROSTHETIC_TORSO_T(xion_breach, "Xion - Breach", "xion_breach_ftorso")
DEFINE_PROSTHETIC_ARM_L(xion_breach, "Xion - Breach", "xion_breach_l_arm")
DEFINE_PROSTHETIC_HAND_L(xion_breach, "Xion - Breach", "xion_breach_l_hand")
DEFINE_PROSTHETIC_LEG_L(xion_breach, "Xion - Breach", "xion_breach_l_leg")
DEFINE_PROSTHETIC_FOOT_L(xion_breach, "Xion - Breach", "xion_breach_l_foot")
DEFINE_PROSTHETIC_ARM_R(xion_breach, "Xion - Breach", "xion_breach_r_arm")
DEFINE_PROSTHETIC_HAND_R(xion_breach, "Xion - Breach", "xion_breach_r_hand")
DEFINE_PROSTHETIC_LEG_R(xion_breach, "Xion - Breach", "xion_breach_r_leg")
DEFINE_PROSTHETIC_FOOT_R(xion_breach, "Xion - Breach", "xion_breach_r_foot")

DEFINE_PROSTHETIC_HEAD(xion_hull, "Xion - Hull", "xion_hull_head")
DEFINE_PROSTHETIC_TORSO_M(xion_hull, "Xion - Hull", "xion_hull_mtorso")
DEFINE_PROSTHETIC_TORSO_T(xion_hull, "Xion - Hull", "xion_hull_ftorso")
DEFINE_PROSTHETIC_ARM_L(xion_hull, "Xion - Hull", "xion_hull_l_arm")
DEFINE_PROSTHETIC_HAND_L(xion_hull, "Xion - Hull", "xion_hull_l_hand")
DEFINE_PROSTHETIC_LEG_L(xion_hull, "Xion - Hull", "xion_hull_l_leg")
DEFINE_PROSTHETIC_FOOT_L(xion_hull, "Xion - Hull", "xion_hull_l_foot")
DEFINE_PROSTHETIC_ARM_R(xion_hull, "Xion - Hull", "xion_hull_r_arm")
DEFINE_PROSTHETIC_HAND_R(xion_hull, "Xion - Hull", "xion_hull_r_hand")
DEFINE_PROSTHETIC_LEG_R(xion_hull, "Xion - Hull", "xion_hull_r_leg")
DEFINE_PROSTHETIC_FOOT_R(xion_hull, "Xion - Hull", "xion_hull_r_foot")

DEFINE_PROSTHETIC_HEAD(xion_wo, "Xion - Whiteout", "xion_wo_head")
DEFINE_PROSTHETIC_TORSO_M(xion_wo, "Xion - Whiteout", "xion_wo_mtorso")
DEFINE_PROSTHETIC_TORSO_T(xion_wo, "Xion - Whiteout", "xion_wo_ftorso")
DEFINE_PROSTHETIC_ARM_L(xion_wo, "Xion - Whiteout", "xion_wo_l_arm")
DEFINE_PROSTHETIC_HAND_L(xion_wo, "Xion - Whiteout", "xion_wo_l_hand")
DEFINE_PROSTHETIC_LEG_L(xion_wo, "Xion - Whiteout", "xion_wo_l_leg")
DEFINE_PROSTHETIC_FOOT_L(xion_wo, "Xion - Whiteout", "xion_wo_l_foot")
DEFINE_PROSTHETIC_ARM_R(xion_wo, "Xion - Whiteout", "xion_wo_r_arm")
DEFINE_PROSTHETIC_HAND_R(xion_wo, "Xion - Whiteout", "xion_wo_r_hand")
DEFINE_PROSTHETIC_LEG_R(xion_wo, "Xion - Whiteout", "xion_wo_r_leg")
DEFINE_PROSTHETIC_FOOT_R(xion_wo, "Xion - Whiteout", "xion_wo_r_foot")

DEFINE_PROSTHETIC_HEAD(zenghu, "Zeng-Hu", "zenghu_head")
DEFINE_PROSTHETIC_TORSO_M(zenghu, "Zeng-Hu", "zenghu_mtorso")
DEFINE_PROSTHETIC_TORSO_T(zenghu, "Zeng-Hu", "zenghu_ftorso")
DEFINE_PROSTHETIC_ARM_L(zenghu, "Zeng-Hu", "zenghu_l_arm")
DEFINE_PROSTHETIC_HAND_L(zenghu, "Zeng-Hu", "zenghu_l_hand")
DEFINE_PROSTHETIC_LEG_L(zenghu, "Zeng-Hu", "zenghu_l_leg")
DEFINE_PROSTHETIC_FOOT_L(zenghu, "Zeng-Hu", "zenghu_l_foot")
DEFINE_PROSTHETIC_ARM_R(zenghu, "Zeng-Hu", "zenghu_r_arm")
DEFINE_PROSTHETIC_HAND_R(zenghu, "Zeng-Hu", "zenghu_r_hand")
DEFINE_PROSTHETIC_LEG_R(zenghu, "Zeng-Hu", "zenghu_r_leg")
DEFINE_PROSTHETIC_FOOT_R(zenghu, "Zeng-Hu", "zenghu_r_foot")

DEFINE_PROSTHETIC_HEAD(nt, "Nanotrasen", "nt_head")
DEFINE_PROSTHETIC_TORSO_M(nt, "Nanotrasen", "nt_mtorso")
DEFINE_PROSTHETIC_TORSO_T(nt, "Nanotrasen", "nt_ftorso")
DEFINE_PROSTHETIC_ARM_L(nt, "Nanotrasen", "nt_l_arm")
DEFINE_PROSTHETIC_HAND_L(nt, "Nanotrasen", "nt_l_hand")
DEFINE_PROSTHETIC_LEG_L(nt, "Nanotrasen", "nt_l_leg")
DEFINE_PROSTHETIC_FOOT_L(nt, "Nanotrasen", "nt_l_foot")
DEFINE_PROSTHETIC_ARM_R(nt, "Nanotrasen", "nt_r_arm")
DEFINE_PROSTHETIC_HAND_R(nt, "Nanotrasen", "nt_r_hand")
DEFINE_PROSTHETIC_LEG_R(nt, "Nanotrasen", "nt_r_leg")
DEFINE_PROSTHETIC_FOOT_R(nt, "Nanotrasen", "nt_r_foot")

DEFINE_PROSTHETIC_HEAD(antares, "Antares Robotics", "antares_head")
DEFINE_PROSTHETIC_TORSO_M(antares, "Antares Robotics", "antares_mtorso")
DEFINE_PROSTHETIC_TORSO_T(antares, "Antares Robotics", "antares_ftorso")
DEFINE_PROSTHETIC_ARM_L(antares, "Antares Robotics", "antares_l_arm")
DEFINE_PROSTHETIC_HAND_L(antares, "Antares Robotics", "antares_l_hand")
DEFINE_PROSTHETIC_LEG_L(antares, "Antares Robotics", "antares_l_leg")
DEFINE_PROSTHETIC_FOOT_L(antares, "Antares Robotics", "antares_l_foot")
DEFINE_PROSTHETIC_ARM_R(antares, "Antares Robotics", "antares_r_arm")
DEFINE_PROSTHETIC_HAND_R(antares, "Antares Robotics", "antares_r_hand")
DEFINE_PROSTHETIC_LEG_R(antares, "Antares Robotics", "antares_r_leg")
DEFINE_PROSTHETIC_FOOT_R(antares, "Antares Robotics", "antares_r_foot")

DEFINE_PROSTHETIC_HEAD(cenilimi, "Cenilimi Cybernetics", "cenilimi_head")
DEFINE_PROSTHETIC_TORSO_M(cenilimi, "Cenilimi Cybernetics", "cenilimi_mtorso")
DEFINE_PROSTHETIC_TORSO_T(cenilimi, "Cenilimi Cybernetics", "cenilimi_ftorso")
DEFINE_PROSTHETIC_ARM_L(cenilimi, "Cenilimi Cybernetics", "cenilimi_l_arm")
DEFINE_PROSTHETIC_HAND_L(cenilimi, "Cenilimi Cybernetics", "cenilimi_l_hand")
DEFINE_PROSTHETIC_LEG_L(cenilimi, "Cenilimi Cybernetics", "cenilimi_l_leg")
DEFINE_PROSTHETIC_FOOT_L(cenilimi, "Cenilimi Cybernetics", "cenilimi_l_foot")
DEFINE_PROSTHETIC_ARM_R(cenilimi, "Cenilimi Cybernetics", "cenilimi_r_arm")
DEFINE_PROSTHETIC_HAND_R(cenilimi, "Cenilimi Cybernetics", "cenilimi_r_hand")
DEFINE_PROSTHETIC_LEG_R(cenilimi, "Cenilimi Cybernetics", "cenilimi_r_leg")
DEFINE_PROSTHETIC_FOOT_R(cenilimi, "Cenilimi Cybernetics", "cenilimi_r_foot")

DEFINE_PROSTHETIC_HEAD(talon, "Talon LLC", "talon_head")
DEFINE_PROSTHETIC_TORSO_M(talon, "Talon LLC", "talon_mtorso")
DEFINE_PROSTHETIC_TORSO_T(talon, "Talon LLC", "talon_ftorso")
DEFINE_PROSTHETIC_ARM_L(talon, "Talon LLC", "talon_l_arm")
DEFINE_PROSTHETIC_HAND_L(talon, "Talon LLC", "talon_l_hand")
DEFINE_PROSTHETIC_LEG_L(talon, "Talon LLC", "talon_l_leg")
DEFINE_PROSTHETIC_FOOT_L(talon, "Talon LLC", "talon_l_foot")
DEFINE_PROSTHETIC_ARM_R(talon, "Talon LLC", "talon_r_arm")
DEFINE_PROSTHETIC_HAND_R(talon, "Talon LLC", "talon_r_hand")
DEFINE_PROSTHETIC_LEG_R(talon, "Talon LLC", "talon_r_leg")
DEFINE_PROSTHETIC_FOOT_R(talon, "Talon LLC", "talon_r_foot")

DEFINE_PROSTHETIC_HEAD(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_head")
DEFINE_PROSTHETIC_TORSO_M(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_mtorso")
DEFINE_PROSTHETIC_TORSO_T(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_ftorso")
DEFINE_PROSTHETIC_ARM_L(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_l_arm")
DEFINE_PROSTHETIC_HAND_L(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_l_hand")
DEFINE_PROSTHETIC_LEG_L(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_l_leg")
DEFINE_PROSTHETIC_FOOT_L(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_l_foot")
DEFINE_PROSTHETIC_ARM_R(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_r_arm")
DEFINE_PROSTHETIC_HAND_R(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_r_hand")
DEFINE_PROSTHETIC_LEG_R(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_r_leg")
DEFINE_PROSTHETIC_FOOT_R(diona_skrell_mech, "Skrellian Exoskeleton", "diona_skrell_mech_r_foot")

//HOW TO USE THESE
//use the prefix from the autodefines' IDs in the autoinit company (e.g antares for all of antares' limbs). case sensitive
//put static designs (extra monitorheads, etc.) in design_ids

//you can look at cyber solutions etc. for an example
/obj/item/disk/design_disk/limbs
	name = "limb blueprint disk"
	desc = "A disk containing the blueprints for prosthetics."
	design_capacity = 120 //fat
	var/autoinit_company


/obj/item/disk/design_disk/limbs/Initialize(mapload)
	. = ..()
	if(autoinit_company)
		for(var/i in list("head", "mtorso", "ftorso", "l_arm", "l_hand", "l_leg", "l_foot", "r_arm", "r_hand", "r_leg", "r_foot"))
			for(var/j in COERCE_OPTIONS_LIST(autoinit_company))
				LAZYDISTINCTADD(design_ids, "[j]_[i]")


/obj/item/disk/design_disk/limbs/antares
	name = "Antares Robotics limb blueprint disk"
	autoinit_company = "antares"

/obj/item/disk/design_disk/limbs/bishop
	name = "Bishop Cybernetics limb blueprint disk"
	autoinit_company = "bishop"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/bishop)

/obj/item/disk/design_disk/limbs/cenilimi
	name = "Cenilimi Cybernetics limb blueprint disk"
	autoinit_company = "cenilimi"


/obj/item/disk/design_disk/limbs/cortex_cases
	name = "cortexCases head blueprint disk"
	design_ids = list("cortexcases_mmi_head", "cortexcases_posi_head")

/obj/item/disk/design_disk/limbs/cyber_solutions
	name = "Cyber Solutions limb blueprint disk"
	autoinit_company = "cyber_solutons"
	design_ids = list("cybersolutions_array_head")
	autoinit_company = list("cybersolutions", "cybersolutions_wight", "cybersolutions_outmoded")

/obj/item/disk/design_disk/limbs/talon
	name = "Talon LLC limb blueprint disk"
	autoinit_company = "talon"

/obj/item/disk/design_disk/limbs/grayson
	name = "Grayson Manufactories limb blueprint disk"
	design_ids = list("grayson_monitor_head")
	autoinit_company = list("grayson", "grayson_rein")

/obj/item/disk/design_disk/limbs/hephaestus
	name = "Hephaestus Industries limb blueprint disk"
	autoinit_company = list("hephaestus", "hephaestus_frontier", "hephaestus_athena")
	catalogue_data = list(/datum/category_item/catalogue/information/organization/hephaestus)

/obj/item/disk/design_disk/limbs/morpheus
	name = "Morpheus Cyberkinetics limb blueprint disk"
	autoinit_company = "morpheus"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/morpheus)

/obj/item/disk/design_disk/limbs/veymed
	name = "Vey-Medical limb blueprint disk"
	autoinit_company = "veymed"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)

// adminBus disk for Diona mech parts.
// please don't put this in game thanks :D
/obj/item/disk/design_disk/limbs/diona
	name = "vikara combine advanced limb blueprint disk"
	autoinit_company = "diona_skrell_mech"

/obj/item/disk/design_disk/limbs/ward_takahashi
	name = "Ward-Takashi General Manufacturing Conglomerate limb blueprint disk"
	autoinit_company = list("wt", "wt_spirit")
	catalogue_data = list(/datum/category_item/catalogue/information/organization/ward_takahashi)

/obj/item/disk/design_disk/limbs/xion
	name = "Xion Manufacturing Group limb blueprint disk"
	autoinit_company = list("xion", "xion_breach", "xion_hull", "xion_wo")
	catalogue_data = list(/datum/category_item/catalogue/information/organization/xion)

/obj/item/disk/design_disk/limbs/zenghu
	name = "Zeng-Hu Pharmaceuticals limb blueprint disk"
	autoinit_company = "zenghu"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/zeng_hu)

/obj/item/disk/design_disk/limbs/nt
	name = "Nanotrasen Incorporated limb blueprint disk"
	autoinit_company = "nt"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)


//OSS/egg

/obj/item/disk/design_disk/limbs/eggnerd
	name = "hastily-cloned Eggnerd Prototyping, LLC disk"
	autoinit_company = list("eggnerd", "eggnerd_red")

/obj/item/disk/design_disk/limbs/oss
	name = "OSS omnibus blueprint disk"
	autoinit_company = list("oss_taj", "oss_liz", "oss_cheese", "oss_nev", "oss_shr", "oss_vlk", "oss_vas", "oss_tsh")
