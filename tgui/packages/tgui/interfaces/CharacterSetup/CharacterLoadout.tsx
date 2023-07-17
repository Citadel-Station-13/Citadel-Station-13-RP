import { useLocalState } from "../../backend";
import { Button, Dropdown, LabeledList, Stack, Tabs } from "../../components";
import { Section, SectionProps } from "../../components/Section";
import { ByondAtomColor, ByondColorMatrixRGBC } from "../common/Color";

export type LoadoutId = string;

export interface LoadoutData {
  slots?: PartialLoadoutSlot[];
  slot: FullLoadoutSlot;
  slotIndex: number;
}

export interface LoadoutContext {
  instances: Record<LoadoutId, LoadoutEntry>;
  categories: string[];
}

export interface LoadoutEntry {
  id: LoadoutId;
  name: string;
  cost: number;
  category: string;
  desc: string;
  customize: LoadoutCustomizations;
}

export interface LoadoutSelected {
  rename: string | null;
  redesc: string | null;
  recolor: string | null | ByondColorMatrixRGBC;
  tweaks: Record<string, any> | null;
  tweakTexts: Record<string, any>;
}

export interface FullLoadoutSlot extends PartialLoadoutSlot {
  entries: Record<LoadoutId, LoadoutSelected>;
  costUsed: number;
  costMax: number;
}

export interface PartialLoadoutSlot {
  name: string;
}

export enum LoadoutCustomizations {
  None = 0,
  Rename = (1<<0),
  Redesc = (1<<1),
  Color = (1<<2),
}

interface LoadoutProps extends SectionProps {
  gearContext: LoadoutContext;
  gearData: LoadoutData;
  slotChangeAct?: (index: number) => void;
  slotRenameAct?: (index: number, name?: string) => void;
  toggleAct?: (id: string) => void;
  customizeNameAct?: (id: string, name?: string) => void;
  customizeDescAct?: (id: string, desc?: string) => void;
  customizeColorAct?: (id: string, color?: ByondAtomColor) => void;
  clearSlotAct?: (index: number) => void;
}

export const CharacterLoadout = (props: LoadoutProps, context) => {
  // todo: get rid of 'context' requirement.
  let [loadoutCategory, setLoadoutCategory] = useLocalState<string | null>(context, "loadoutCategory", null);
  return (
    <Section {...props}>
      <Stack vertical>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Slot">
                  <Dropdown
                    color="transparent"
                    selected={
                      props.gearData.slot.name || props.gearData.slotIndex.toFixed(0)
                    }
                    options={
                      props.gearData.slots?.map((slot, index) => slot.name || index.toFixed(0))
                    }
                    onSelected={(val) => props.slotChangeAct?.(
                      props.gearData.slots?.findIndex((slot) => slot.name === val)
                        || Number.parseInt(val, 10)
                    )} />
                  <Button
                    color="transparent"
                    icon="pen"
                    onClick={() => props.slotRenameAct?.(props.gearData.slotIndex)} />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item grow>
              <LabeledList>
                <LabeledList.Item label="Points">
                  {props.gearData.slot.costUsed} / {props.gearData.slot.costMax}
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <Button.Confirm
                color="transparent"
                icon="trash"
                onClick={() => props.clearSlotAct?.(props.gearData.slotIndex)}
                content="Clear Loadout" />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow>
          <Stack>
            <Stack.Item>
              <Tabs vertical>
                {props.gearContext.categories.map((cat) => (
                  <Tabs.Tab
                    key={cat}
                    selected={cat === loadoutCategory}
                    onClick={() => setLoadoutCategory(cat)}>
                    {cat}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Stack.Item>
            <Stack.Item grow>
              <Section scrollable>
                <Stack vertical>
                  {
                    Object.entries(props.gearContext.instances).filter(
                      ([id, entry]) => entry.category === loadoutCategory
                    ).map(
                      ([id, entry]) => {
                        return (
                          <Stack.Item key={id}>
                            Test
                          </Stack.Item>
                        );
                      }
                    )
                  }
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
