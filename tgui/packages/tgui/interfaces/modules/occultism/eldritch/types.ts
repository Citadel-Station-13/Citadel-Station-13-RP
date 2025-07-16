import { BooleanLike } from "common/react";

export interface EldritchKnowledge {
  id: string;
  name: string;
  desc: string;
  category: string;
  loreAsUnsafeHtml: string | null;
  iconAsBase64: string | null;
  secret: BooleanLike;
  hidden: BooleanLike;
  reqKnowledgeIds: string[] | null;
  giveAbilities: EldritchAbility[] | null;
  givePassives: EldritchPassive[] | null;
  giveKnowledgeIds: string[] | null;
  giveRecips: EldritchRecipe[] | null;
}

export interface EldritchPassive {
  id: string;
  name: string;
  desc: string;
  iconAsBase64: string | null;
}

export interface EldritchAbility {
  id: string;
  name: string;
  desc: string;
  iconAsBase64: string | null;
}

export interface EldritchRecipe {
  id: string;
  name: string;
  desc: string;
  iconAsBase64: string | null;
}

export interface EldritchPatron {
  id: string;
  name: string;
  desc: string;
  loreAsUnsafeHtml: string | null;
  iconAsBase64: string | null;
}
