/**
 * @file
 * @license MIT
 */
import { ReactNode } from "react";
import { Button, Collapsible, ColorBox, Dropdown, Input, NumberInput, Section, Stack, Tooltip } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { ByondAtomColor, ByondColorString, ColorPicker } from "../common/Color";

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

export const GamePreferenceEntry = (props: GamePreferenceEntryProps) => {
  let innerContent: ReactNode = null;
  switch (props.schema.type) {
    case 'number':
      innerContent = (
        <NumberEntry {...props as any} />
      );
      break;
    case 'string':
      innerContent = (
        <StringEntry {...props as any} />
      );
      break;
    case 'toggle':
      innerContent = (
        <ToggleEntry {...props as any} />
      );
      break;
    case 'dropdown':
      innerContent = (
        <DropdownEntry {...props as any} />
      );
      break;
    case 'simpleColor':
      innerContent = (
        <SimpleColorEntry {...props as any} />
      );
      break;
  }
  return (
    <Stack>
      <Stack.Item width="33%">
        <Stack>
          <Stack.Item grow>
            <b>{props.schema.name}</b>
          </Stack.Item>
          <Stack.Item>
            <Tooltip content={props.schema.desc}>
              <Button icon="question" />
            </Tooltip>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow>
        {innerContent}
      </Stack.Item>
    </Stack>
  );
};

const NumberEntry = (props: {
  readonly schema: PreferenceNumberEntrySchema;
  readonly value: number;
  readonly setValue: (val: number) => void;
}) => {
  return (
    <NumberInput fluid value={props.value}
      minValue={props.schema.minValue || -Infinity} maxValue={props.schema.maxValue || Infinity}
      step={props.schema.roundTo || 1} onChange={(val) => props.setValue(val)} />
  );
};

const StringEntry = (props: {
  // eslint-disable-next-line react/no-unused-prop-types
  readonly schema: PreferenceStringEntrySchema;
  readonly value: string;
  readonly setValue: (val: string) => void;
}) => {
  return (
    <Input fluid value={props.value} onChange={(val) => props.setValue(val)} />
  );
};

const ToggleEntry = (props: {
  // eslint-disable-next-line react/no-unused-prop-types
  readonly schema: PreferenceToggleEntrySchema;
  readonly value: BooleanLike;
  readonly setValue: (val: BooleanLike) => void;
}) => {
  return (
    <Button.Checkbox fluid color="transparent" content={props.value ? props.schema.enabledName : props.schema.disabledName}
      checked={props.value} onClick={() => props.setValue(!props.value)} />
  );
};

const DropdownEntry = (props: {
  readonly schema: PreferenceDropdownEntrySchema;
  readonly value: string;
  readonly setValue: (val: string) => void;
}) => {
  return (
    <Dropdown selected={props.value} options={props.schema.options}
      onSelected={(v) => props.setValue(v)} width="100%" />
  );
};

const SimpleColorEntry = (props: {
  // eslint-disable-next-line react/no-unused-prop-types
  readonly schema: PreferenceSimpleColorEntrySchema;
  readonly value: ByondColorString;
  readonly setValue: (val: ByondColorString) => void;
}) => {
  return (
    <Collapsible color="transparent" title={props.value ? (
      <>
        <ColorBox color={props.value} /> {props.value}
      </>
    ) : ""}>
      <Section>
        <ColorPicker currentColor={props.value || "#ffffff"} allowMatrix={false}
          setColor={(what) => props.setValue(what as ByondColorString)} />
      </Section>
    </Collapsible>
  );
};
