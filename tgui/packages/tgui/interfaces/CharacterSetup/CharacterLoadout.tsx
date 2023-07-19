import { Component } from "inferno";
import { useLocalState } from "../../backend";
import { Box, Button, Collapsible, Dropdown, Input, Stack, Tabs } from "../../components";
import { Section, SectionProps } from "../../components/Section";
import { ByondAtomColor, ByondColorMatrixRGBC, ColorPicker } from "../common/Color";

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
  // ids
  tweaks: string[];
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
  // ids
  gearAllowed: string[];
  gearData: LoadoutData;
  slotChangeAct?: (index: number) => void;
  slotRenameAct?: (index: number, name?: string) => void;
  toggleAct?: (id: string) => void;
  customizeNameAct?: (id: string, name?: string) => void;
  customizeDescAct?: (id: string, desc?: string) => void;
  customizeColorAct?: (id: string, color?: ByondAtomColor) => void;
  tweakAct?: (id: string, tweakId: string) => void;
  clearSlotAct?: (index: number) => void;
}

export const CharacterLoadout = (props: LoadoutProps, context) => {
  // todo: get rid of 'context' requirement.
  let [loadoutCategory, setLoadoutCategory] = useLocalState<string | null>(context, "loadoutCategory", null);
  return (
    <Section {...props}>
      <Stack vertical grow fill>
        <Stack.Item>
          <Section>
            <Stack fill>
              <Stack.Item>
                <Box mt={0.5}>
                  Slot:
                </Box>
              </Stack.Item>
              <Stack.Item width="30%">
                <Dropdown
                  width="100%"
                  color="transparent"
                  selected={
                    props.gearData.slot.name || `Slot ${props.gearData.slotIndex.toFixed(0)}`
                  }
                  options={
                    props.gearData.slots?.map((slot, index) => slot.name || index.toFixed(0))
                  }
                  onSelected={(val) => {
                    let index = (props.gearData.slots?.findIndex((slot) => slot.name === val));
                    if (index === undefined) {
                      index = -1;
                    }
                    else {
                      index += 1;
                    }
                    if (index === -1) {
                      index = Number.parseInt(val, 10) + 1;
                    }
                    props.slotChangeAct?.(index);
                  }} />
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="transparent"
                  icon="pen"
                  onClick={() => props.slotRenameAct?.(props.gearData.slotIndex)} />
              </Stack.Item>
              <Stack.Item>
                <Box mt={0.5}>
                  Points: {props.gearData.slot.costUsed} / {props.gearData.slot.costMax}
                </Box>
              </Stack.Item>
              <Stack.Item grow />
              <Stack.Item>
                <Button.Confirm
                  color="transparent"
                  icon="trash"
                  onClick={() => props.clearSlotAct?.(props.gearData.slotIndex)}
                  content="Clear" />
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item grow>
          <Stack fill>
            <Stack.Item>
              <Section fill title="Categories">
                <Tabs vertical>
                  {props.gearContext.categories.sort(
                    (a, b) => a.localeCompare(b)
                  ).map((cat) => (
                    <Tabs.Tab
                      key={cat}
                      selected={cat === loadoutCategory}
                      onClick={() => setLoadoutCategory(cat)}>
                      {cat}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section title="Items" fill scrollable>
                <Stack vertical>
                  {
                    props.gearAllowed.map((id) => props.gearContext.instances[id]).filter(
                      (entry) => entry.category === loadoutCategory
                    ).sort(
                      (e1, e2) => e1.name.localeCompare(e2.name)
                    ).map(
                      (entry) => {
                        return (
                          <CharacterLoadoutEntry
                            key={`${entry.id}`}
                            selected={props.gearData.slot.entries[entry.id] || null}
                            entry={entry}
                            toggleAct={props.toggleAct}
                            customizeColorAct={props.customizeColorAct}
                            customizeDescAct={props.customizeDescAct}
                            customizeNameAct={props.customizeNameAct}
                            tweakAct={props.tweakAct} />
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

interface CharacterLoadoutEntryProps {
  entry: LoadoutEntry;
  selected: LoadoutSelected | null;
  toggleAct?: (id: string) => void;
  customizeNameAct?: (id: string, name?: string) => void;
  customizeDescAct?: (id: string, desc?: string) => void;
  customizeColorAct?: (id: string, color?: ByondAtomColor) => void;
  tweakAct?: (id: string, tweakId: string) => void;
}

interface CharacterLoadoutEntryState {
  editingName: boolean;
  editingDesc: boolean;
  editingColor: boolean;
}

class CharacterLoadoutEntry extends Component<CharacterLoadoutEntryProps, CharacterLoadoutEntryState> {
  state: CharacterLoadoutEntryState = {
    editingName: false,
    editingDesc: false,
    editingColor: false,
  };

  render() {
    return (
      <Stack.Item>
        <Collapsible
          captureKeys={false}
          title={(
            <>
              {(this.props.entry.customize & LoadoutCustomizations.Rename) && !!this.props.selected && (
                <Button width="22px" icon="pen" mr={1}
                  onClick={
                    () => this.props.selected && this.setState((prevState) => ({
                      ...prevState,
                      editingName: !prevState.editingName,
                    }))
                  } color="transparent" selected={this.state.editingName || !!this.props.selected?.rename} />
              )}
              {this.state.editingName? (
                <Input
                  value={this.props.selected?.rename}
                  onChange={(e, val) => {
                    this.props.customizeNameAct?.(this.props.entry.id, val);
                    this.setState((prevState) => ({ ...prevState, editingName: false }));
                  }} />
              ) : (this.props.selected?.rename !== undefined? this.props.selected.rename : this.props.entry.name)}
            </>
          )}
          color="transparent"
          buttons={(
            <Button
              content={this.props.selected? "Selected" : "Select"}
              selected={!!this.props.selected}
              color="transparent"
              onClick={() => this.props.toggleAct?.(this.props.entry.id)} />)}>
          <div style={{ position: "relative" }}>
            {(this.props.entry.customize & LoadoutCustomizations.Color) && !!this.props.selected && (
              <Button
                icon="tint"
                position="absolute"
                left={0.35}
                top={0}
                color="transparent"
                selected={this.state.editingColor}
                onClick={() => this.props.selected
                        && this.setState((prev) => ({ ...prev, editingColor: !prev.editingColor }))} />
            )}
            <Box ml={4.25}>
              <Box>
                {(this.props.entry.customize & LoadoutCustomizations.Redesc) && !!this.props.selected && (
                  <Button mr={1} icon="pen" onClick={
                    () => this.props.selected && this.setState((prevState) => ({
                      ...prevState,
                      editingDesc: !prevState.editingDesc,
                    }))
                  } color={this.props.selected.recolor? undefined : "transparent"} selected={this.state.editingDesc || !!this.props.selected?.redesc} />
                )}
                {this.state.editingDesc? (
                  <Input
                    value={this.props.selected?.redesc}
                    onChange={(e, val) => {
                      this.props.customizeDescAct?.(this.props.entry.id, val);
                      this.setState((prevState) => ({ ...prevState, editingDesc: false }));
                    }} />
                ) : (this.props.selected?.redesc !== undefined? this.props.selected.redesc : this.props.entry.desc)}
              </Box>
              {this.state.editingColor && !!this.props.selected && (
                <Section>
                  <ColorPicker
                    allowMatrix
                    currentColor={this.props.selected?.recolor || "#ffffff"}
                    setColor={(color) => {
                      this.props.customizeColorAct?.(this.props.entry.id, color);
                    }} />
                </Section>
              )}
              {!!this.props.selected && this.props.entry.tweaks?.map((id) => {
                return (
                  <Button key={id} content={this.props.selected?.tweakTexts?.[id]}
                    color="transparent" onClick={() => this.props.tweakAct?.(this.props.entry.id, id)} />
                );
              })}
            </Box>
          </div>
        </Collapsible>
      </Stack.Item>
    );
  }
}
