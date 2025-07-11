/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { Stack } from "../../../../components";
import { Window } from "../../../../layouts";

interface EldritchHolderData {
  // is the viewer an admin? enables admin controls
  admin: BooleanLike;

  repositoryKnowledge: Record<string, EldritchKnowledge>;
  repositoryPassives: Record<string, EldritchPassive>;
  repositoryAbilities: Record<string, EldritchAbility>;
  repositoryRecipes: Record<string, EldritchRecipe>;

  unlockedAbilities: string[];
  unlockedKnowledge: string[];
  unlockedPassives: string[];
  unlockedRecipes: string[];

  unlockedPatrons: Record<string, EldritchPatron>;

  passiveContexts: Record<string, EldritchPassiveContext>;
  abilityContexts: Record<string, EldritchAbilityContext>;

  activePatron: string | null;
}

interface EldritchKnowledge {
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

interface EldritchPassive {
  id: string;
  name: string;
  desc: string;
  iconAsBase64: string | null;
}

interface EldritchAbility {
  id: string;
  name: string;
  desc: string;
  iconAsBase64: string | null;
}

interface EldritchRecipe {
  id: string;
  name: string;
  desc: string;
  iconAsBase64: string | null;
}

interface EldritchPatron {
  id: string;
  name: string;
  desc: string;
  loreAsUnsafeHtml: string | null;
  iconAsBase64: string | null;
}

interface EldritchPassiveContext {
  enabled: BooleanLike;
}

interface EldritchAbilityContext {
}

export const EldritchHolder = (props, context) => {
  return (
    <Window width={800} height={800}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            test
          </Stack.Item>
          <Stack.Item grow={1}>
            test
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ViewKnowledge = (props: {}, context) => {

};

const ViewPassives = (props: {}, context) => {

};

const ViewAbilities = (props: {}, context) => {

};

const PatronButton = (props: {}, context) => {

};
