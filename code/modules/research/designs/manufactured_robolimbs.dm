#define DEFINE_PROSTHETIC_HEAD(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/head/##man_for_path { \
	design_unlock = DESIGN_UNLOCK_UPLOAD; \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_TORSO_M(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/torso/male/##man_for_path { \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_TORSO_T(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/torso/female/##man_for_path { \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_ARM_L(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/l_arm/##man_for_path { \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_HAND_L(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/l_hand/##man_for_path { \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_LEG_L(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/l_leg/##man_for_path { \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_FOOT_L(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/l_foot/##man_for_path { \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_ARM_R(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/r_arm/##man_for_path { \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_HAND_R(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/r_hand/##man_for_path { \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_LEG_R(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/r_leg/##man_for_path { \
	id = ##new_id; \
	subcategory = ##man; \
}

#define DEFINE_PROSTHETIC_FOOT_R(man_for_path, man, new_id) /datum/prototype/design/science/prosfab/pros/r_foot/##man_for_path { \
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

DEFINE_PROSTHETIC_HEAD(morpheus, "Morpheus", "morpheus_head")
DEFINE_PROSTHETIC_HEAD(morpheus_zenit, "Morpheus - Zenith", "morpheus_head_zenit")
DEFINE_PROSTHETIC_HEAD(morpheus_skele, "Morpheus - Skeleton Crew", "morpheus_head_zenit")
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
