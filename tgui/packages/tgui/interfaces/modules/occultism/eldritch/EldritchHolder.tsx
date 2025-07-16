/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { Stack } from "../../../../components";
import { Window } from "../../../../layouts";
import { EldritchAbility, EldritchKnowledge, EldritchPassive, EldritchPatron, EldritchRecipe } from "./types";
import { useBackend } from "../../../../backend";

interface EldritchHolderData {
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

interface EldritchPassiveContext {
  enabled: BooleanLike;
}

interface EldritchAbilityContext {
}

export const EldritchHolder = (props, context) => {
  const { act, data, config, modules } = useBackend<EldritchHolderData>(context);

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
