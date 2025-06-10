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

  // all knowledge nodes by id. non-admins won't have hidden ones sent.
  possibleKnowledge: Record<string, EldritchKnowledge>;
  // researched knowledge; flat list of ids
  unlockedKnowledge: string[];

  // all passives in holder
  // * not allowed to admin edit manually; passives must be given via knowledge system
  passivesUnlocked: Record<string, EldritchPassive>;
  // passive enable/disable state
  passivesToggled: Record<string, BooleanLike>;

  // all abilities in holder
  // * not allowed to admin edit manually; abilities must be given via knowledge system
  abilitiesUnlocked: Record<string, EldritchAbility>;
  // ability enable/disable state
  abilitiesToggled: Record<string, BooleanLike>;

  // all patrons selectable in holder
  patronsUnlocked: Record<string, EldritchPatron>;
  // active patron by id, if any
  patronActive: string | null;
}

interface EldritchKnowledge {
  id: string;
}

interface EldritchPassive {
  id: string;
}

interface EldritchAbility {
  id: string;
}

interface EldritchPatron {
  id: string;
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
