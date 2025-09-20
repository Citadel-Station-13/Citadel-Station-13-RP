import { useState } from "react";
import { Button, Dropdown, Input, NumberInput, Section, Stack, Tooltip } from "tgui-core/components";
import { round } from "tgui-core/math";
import { BooleanLike } from "tgui-core/react";

import { useBackend } from "../../backend";
import { Window } from "../../layouts";

interface UIDynamicInputContext {
  title: string;
  message: string;
  timeout: number;
  // key to entry data
  query: Record<string, UIDynamicInputEntry>;
}

type UIDynamicInputEntry = StringEntry | NumberEntry | PickEntry | ToggleEntry;

interface BaseEntry {
  name: string;
  desc: string;
}

interface StringEntry extends BaseEntry {
  type: UIDynamicInputType.String;
  constraints: StringConstraint;
  default: StringOption;
}

interface NumberEntry extends BaseEntry {
  type: UIDynamicInputType.Number;
  constraints: NumberConstraint;
  default: NumberOption;
}

interface PickEntry extends BaseEntry {
  type: UIDynamicInputType.ListSingle;
  constraints: ListConstraint;
  default: ListOption;
}

interface ToggleEntry extends BaseEntry {
  type: UIDynamicInputType.Toggle;
  constraints: ToggleConstraint;
  default: ToggleOption;
}

enum UIDynamicInputType {
  String = "text",
  Number = "num",
  ListSingle = "list_single",
  Toggle = "bool",
}

type UIDynamicInputConstraint = StringConstraint | NumberConstraint | ListConstraint | ToggleConstraint;

type StringConstraint = [number];
type NumberConstraint = [number, number, number | null];
type ListConstraint = string[];
type ToggleConstraint = [];

type UIDynamicInputOption = StringOption | NumberOption | ListOption | ToggleOption;

type StringOption = string | null | undefined;
type NumberOption = number | null | undefined;
type ListOption = string | null | undefined;
type ToggleOption = BooleanLike;

export const UIDynamicInputModal = (props) => {
  const { data, act } = useBackend<UIDynamicInputContext>();
  const [options, setOptions] = useState<Record<string, any>>({});
  return (
    <Window title={data.title}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              {data.message}
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Section fill>
              <Stack vertical>
                {Object.entries(data.query).map(([key, entry]) => (
                  <Stack.Item key={key}>
                    <Stack>
                      <Stack.Item grow={1}>
                        <Stack>
                          <Stack.Item grow={1}>
                            {`${entry.name} `}
                          </Stack.Item>
                          <Stack.Item>
                            <Tooltip content={entry.desc}>
                              <Button icon="question" />
                            </Tooltip>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                      {/*
                        WARNING: You see that 'as any'? That's to forcefully disable typescript checking.
                        This is because 'right' does work as an align-items CSS properties as of time of writing,
                        but this may change in the future. If shit breaks, remove it and find another hack
                        to align the items.
                       */}
                      <Stack.Item grow={1} shrink={1} align={"right" as any}>
                        <DynamicEntry id={key} entry={entry} current={options[key]}
                          pick={(val) => {
                            let mutated = options;
                            mutated[key] = val;
                            setOptions(mutated);
                          }} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Stack>
                <Stack.Item grow={1} align="center">
                  <Button.Confirm icon="check"
                    content="Confirm" onClick={() => act('submit', { choices: preprocessOptions(options, data.query) })} />
                </Stack.Item>
                <Stack.Item grow={1} align="center">
                  <Button.Confirm icon="xmark"
                    content="Cancel" onClick={() => act('cancel')} />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const preprocessOptions = (picked: Record<string, any>, query: Record<string, UIDynamicInputEntry>) => {
  let built = {};
  for (let key in Object.keys(query)) {
    built[key] = picked[key] === undefined ? query[key].default : picked[key];
  }
  return built;
};

interface DynamicEntryProps {
  // eslint-disable-next-line react/no-unused-prop-types
  readonly id: string;
  readonly entry: UIDynamicInputEntry;
  readonly current: UIDynamicInputOption;
  readonly pick: (val: any) => void;
}

const DynamicEntry = (props: DynamicEntryProps) => {
  switch (props.entry.type) {
    case UIDynamicInputType.ListSingle:
      return (
        <DynamicEntryPick {...props} current={props.current as ListOption} entry={props.entry} />
      );
    case UIDynamicInputType.Number:
      return (
        <DynamicEntryNumber {...props} current={props.current as NumberOption} entry={props.entry} />
      );
    case UIDynamicInputType.String:
      return (
        <DynamicEntryString {...props} current={props.current as StringOption} entry={props.entry} />
      );
    case UIDynamicInputType.Toggle:
      return (
        <DynamicEntryToggle {...props} current={props.current as ToggleOption} entry={props.entry} />
      );
  }
};

interface DynamicEntryNumberProps extends DynamicEntryProps {
  entry: NumberEntry;
  current: NumberOption;
}

const DynamicEntryNumber = (props: DynamicEntryNumberProps) => {
  let current = props.current === undefined ? props.entry.default === null ? 0 : props.entry.default : props.current;
  return (
    <NumberInput value={current || "---"} step={0.0001} minValue={props.entry.constraints[0]} maxValue={props.entry.constraints[1]}
      onChange={(val) => props.pick(
        props.entry.constraints[2] === null ? val : round(val, props.entry.constraints[2])
      )} width="100%" />
  );
};

interface DynamicEntryStringProps extends DynamicEntryProps {
  entry: StringEntry;
  current: StringOption;
}

const DynamicEntryString = (props: DynamicEntryStringProps) => {
  let current = props.current === undefined ? props.entry.default === null ? "" : props.entry.default : props.current;
  return (
    <Input value={current || undefined} maxLength={props.entry.constraints[0]}
      onChange={(val) => props.pick(
        val
      )} width="100%" />
  );
};

interface DynamicEntryPickProps extends DynamicEntryProps {
  entry: PickEntry;
  current: ListOption;
}

const DynamicEntryPick = (props: DynamicEntryPickProps) => {
  let current = props.current === undefined ? (
    props.entry.constraints.length > 0 ? props.entry.constraints[0] : ""
  ) : props.current;
  return (
    <Dropdown
      options={props.entry.constraints}
      selected={current}
      onSelected={(v) => props.pick(v)} />
  );
};

interface DynamicEntryToggleProps extends DynamicEntryProps {
  entry: ToggleEntry;
  current: ToggleOption;
}

const DynamicEntryToggle = (props: DynamicEntryToggleProps) => {
  let current = props.current === undefined ? !!props.entry.default : props.current;
  return (
    <Button.Checkbox
      selected={current}
      onClick={() => props.pick(!current)} />
  );
};


