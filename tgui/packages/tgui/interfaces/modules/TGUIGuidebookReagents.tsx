/**
 * Reagents guidebook section.
 *
 * Reactions were originally going to be separate, but was included because
 * they require reagent context to be rendered properly.
 *
 * The interfaces here are intentionally distinct from the normal reagent interfaces/classes,
 * because the guidebook system is meant to be maintainable and modular - which means it's
 * unable to directly hook the main systems for reagents.
 *
 * @file
 * @license MIT
 */

import { useLocalState, useModule } from "../../backend";
import { Section, Stack, Tabs } from "../../components";
import { Modular } from "../../layouts/Modular";
import { TGUIGuidebookSectionData } from "./TGUIGuidebook";

export interface TGUIGuidebookReagentsData extends TGUIGuidebookSectionData {
  // id to entry
  readonly reagents: Record<string, TGUIGuidebookReagent>;
  // id to entry
  readonly reactions: Record<string, TGUIGuidebookReaction>;
}

enum ReagentGuidebookFlags {
  Unlisted = (1<<0),
  Hidden = (1<<1),
}

enum ReactionGuidebookFlags {
  Unlisted = (1<<0),
  Hidden = (1<<1),
}

interface TGUIGuidebookReagent {
  // id string
  id: string;
  // reagent flags: currently untyped because there are none
  flags: number;
  // reagent guidebook flags
  guidebookFlags: ReagentGuidebookFlags;
  // name string
  name: string;
  // description string
  desc: string;
  // category
  category: string;

  // alcohol strength
  alcoholStrength: number | null;
}

interface TGUIGuidebookReaction {
  // id string
  id: string;
  // reaction flags: currently untyped because there are none
  flags: number;
  // reaction guidebook flags
  guidebookFlags: ReactionGuidebookFlags;
  // name string
  name: string;
  // description string
  desc: string;
  // category
  category: string;
  // required reagent ids
  requiredReagents: string[];
  // result reagent id
  resultReagent: string;
  // result reagent amount
  resultAmount: number;
}

export const TGUIGuidebookReagents = (props: TGUIGuidebookReagentsData, context) => {
  let { act, data } = useModule<TGUIGuidebookReagentsData>(context);
  const [activeTab, setActiveTab] = useLocalState<string | null>(context, 'activeReagentsTab', null);

  let rendered = null;

  switch (activeTab) {
    case 'reagents':
      break;
    case 'reactions':
      break;
  }

  return (
    <Modular window={{ width: 800, height: 800 }} section={{ fill: true }}>
      <Stack vertical fill>
        <Stack.Item>
          <Tabs>
            <Tabs.Tab selected={activeTab === "reagents"}
              onClick={() => setActiveTab("reagents")}>
              Reagents
            </Tabs.Tab>
            <Tabs.Tab selected={activeTab === "reactions"}
              onClick={() => setActiveTab("reactions")}>
              Reactions
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item grow={1}>
          <Section>
            {rendered}
          </Section>
        </Stack.Item>
      </Stack>
    </Modular>
  );
};
