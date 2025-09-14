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

import { ReactNode, useState } from "react";
import { Input, Section, Stack, Tabs } from "tgui-core/components";

import { Modular } from "../../layouts/Modular";
import { useLegacyModule } from "../../legacyModuleSystem";
import { TGUIGuidebookSectionData } from "./TGUIGuidebook";

export interface TGUIGuidebookReagentsData extends TGUIGuidebookSectionData {
  // id to entry
  readonly reagents: Record<string, TGUIGuidebookReagent>;
  // id to entry
  readonly reactions: Record<string, TGUIGuidebookReaction>;
}

enum ReagentGuidebookFlags {
  Unlisted = (1 << 0),
  Hidden = (1 << 1),
}

enum ReactionGuidebookFlags {
  Unlisted = (1 << 0),
  Hidden = (1 << 1),
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

export const TGUIGuidebookReagents = (props) => {
  let { act, data } = useLegacyModule<TGUIGuidebookReagentsData>();
  const [activeTab, setActiveTab] = useState<string | null>(null);
  const [searchText, setSearchText] = useState<string | null>(null);

  let rendered: ReactNode | null = null;
  let categorizedReagents: Record<string, TGUIGuidebookReagent[]> = {};
  let categorizedReactions: Record<string, TGUIGuidebookReaction[]> = {};

  switch (activeTab) {
    case 'reagents':
      Object.values(data.reagents).filter(
        (reagent) => !searchText || reagent.name.toLowerCase().includes(searchText)).forEach(
          (reagent) => {
            if (categorizedReagents[reagent.category] === undefined) {
              categorizedReagents[reagent.category] = [];
            }
            categorizedReagents[reagent.category].push(reagent);
          });
      rendered = (
        <Stack vertical>
          {Object.entries(categorizedReagents).sort(([cat1, a1], [cat2, a2]) => cat1.localeCompare(cat2)).map(
            ([cat, catReagents]) => (
              <Stack.Item key={cat}>
                <Section title={cat}>
                  <Stack vertical>
                    {catReagents.sort((r1, r2) => r1.name.localeCompare(r2.name)).map((reagent) => (
                      <Stack.Item key={reagent.id}>
                        {reagent.name}
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            )
          )}
        </Stack>
      );
      break;
    case 'reactions':
      Object.values(data.reactions).filter(
        (reaction) => !searchText || reaction.name.toLowerCase().includes(searchText)).forEach(
          (reaction) => {
            if (categorizedReactions[reaction.category] === undefined) {
              categorizedReactions[reaction.category] = [];
            }
            categorizedReactions[reaction.category].push(reaction);
          });
      rendered = (
        <Stack vertical>
          {Object.entries(categorizedReactions).sort(([cat1, a1], [cat2, a2]) => cat1.localeCompare(cat2)).map(
            ([cat, catReactions]) => (
              <Stack.Item key={cat}>
                <Section title={cat}>
                  <Stack vertical>
                    {catReactions.sort((r1, r2) => r1.name.localeCompare(r2.name)).map((reaction) => (
                      <Stack.Item key={reaction.id}>
                        {reaction.name}
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            )
          )}
        </Stack>
      );
      break;
  }

  return (
    <Modular window={{ width: 800, height: 800 }} section={{ fill: true }}>
      <Stack vertical fill>
        <Stack.Item>
          <Stack>
            <Stack.Item grow={1}>
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
            <Stack.Item>
              Search <Input width="100px" onChange={(val) => setSearchText(val.toLowerCase())} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow={1}>
          <Section scrollable fill>
            {rendered}
          </Section>
        </Stack.Item>
      </Stack>
    </Modular>
  );
};
