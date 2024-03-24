/**
 * @file
 * @license MIT
 */
import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { Button, Collapsible, Dropdown, Input, NumberInput, Stack, Tooltip } from "../../components";
import { ByondAtomColor, ByondColorString } from "../common/Color";

interface GamePreferenceEntryProps {
  readonly schema: GamePreferenceEntrySchema;
  readonly value: any;
  readonly setValue: (v: any) => void;
}

export type GamePreferenceEntrySchema =
  PreferenceNumberEntrySchema |
  PreferenceStringEntrySchema |
  PreferenceToggleEntrySchema |
  PreferenceDropdownEntrySchema |
  PreferenceSimpleColorEntrySchema;

interface PreferenceBaseEntrySchema {
  key: string;
  category: string;
  subcategory: string;
  name: string;
  desc: string;
  priority: number;
  defaultValue: any;
}

interface PreferenceNumberEntrySchema extends PreferenceBaseEntrySchema {
  type: "number";
  minValue: number | null;
  maxValue: number | null;
  roundTo: number | null;
  defaultValue: number;
}

interface PreferenceStringEntrySchema extends PreferenceBaseEntrySchema {
  type: "string";
  minLength: number;
  maxLength: number;
  defaultValue: string;
}

interface PreferenceToggleEntrySchema extends PreferenceBaseEntrySchema {
  type: "toggle";
  enabledName: string;
  disabledName: string;
  defaultValue: BooleanLike;
}

interface PreferenceDropdownEntrySchema extends PreferenceBaseEntrySchema {
  type: "dropdown";
  options: string[];
  defaultValue: string;
}

interface PreferenceSimpleColorEntrySchema extends PreferenceBaseEntrySchema {
  type: "simpleColor";
  defaultValue: ByondAtomColor;
}

export const GamePreferenceEntry = (props: GamePreferenceEntryProps, context) => {
  let innerContent: InfernoNode = null;
  switch (props.schema.type) {
    case 'number':
      break;
    case 'string':
      break;
    case 'toggle':
      break;
    case 'dropdown':
      break;
    case 'simpleColor':
      break;
  }
  return (
    <>
      <Stack>
        <Stack.Item width="33%">
          <Stack>
            <Stack.Item grow>
              <b>{props.schema.name}</b>
            </Stack.Item>
            <Stack.Item>
              <Tooltip content={props.schema.desc}>
                <Button icon="questionmark" />
              </Tooltip>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow>
          {innerContent}
        </Stack.Item>
      </Stack>
      {JSON.stringify(props)}
    </>
  );
};

const NumberEntry = (props: {
  readonly schema: PreferenceNumberEntrySchema;
  readonly value: number;
  readonly set: (val: number) => void;
}, context) => {
  return (
    <NumberInput fluid value={props.value}
      minValue={props.schema.minValue} maxValue={props.schema.maxValue}
      step={props.schema.roundTo} onInput={(e, val) => props.set(val)} />
  );
};

const StringEntry = (props: {
  // eslint-disable-next-line react/no-unused-prop-types
  readonly schema: PreferenceStringEntrySchema;
  readonly value: string;
  readonly set: (val: string) => void;
}, context) => {
  return (
    <Input fluid value={props.value} onInput={(e, val) => props.set(val)} />
  );
};

const ToggleEntry = (props: {
  // eslint-disable-next-line react/no-unused-prop-types
  readonly schema: PreferenceToggleEntrySchema;
  readonly value: BooleanLike;
  readonly set: (val: BooleanLike) => void;
}, context) => {
  return (
    <Button fluid color="transparent"
      selected={props.value} onClick={() => props.set(!props.value)} />
  );
};

const DropdownEntry = (props: {
  readonly schema: PreferenceDropdownEntrySchema;
  readonly value: string;
  readonly set: (val: string) => void;
}, context) => {
  return (
    <Dropdown selected={props.value} options={props.schema.options}
      onSelected={(v) => props.set(v)} />
  );
};

const SimpleColorEntry = (props: {
  // eslint-disable-next-line react/no-unused-prop-types
  readonly schema: PreferenceSimpleColorEntrySchema;
  readonly value: ByondColorString;
  readonly set: (val: ByondColorString) => void;
}, context) => {
  return (
    <Collapsible>test</Collapsible>
  );
};
