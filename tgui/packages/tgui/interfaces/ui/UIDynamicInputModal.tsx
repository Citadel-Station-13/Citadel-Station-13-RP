import { BooleanLike } from "common/react";
import { useBackend, useLocalState } from "../../backend";
import { Box, Button, Section, Stack, Tooltip } from "../../components";
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

type StringConstraint = [number] | undefined;
type NumberConstraint = [number, number, number] | undefined;
type ListConstraint = string[] | undefined;
type ToggleConstraint = [] | undefined;

type UIDynamicInputOption = StringOption | NumberOption | ListOption | ToggleOption;

type StringOption = string | null | undefined;
type NumberOption = number | null | undefined;
type ListOption = string | null | undefined;
type ToggleOption = BooleanLike;

export const UIDynamicInputModal = (props, context) => {
  const { data, act } = useBackend<UIDynamicInputContext>(context);
  const [options, setOptions] =useLocalState<Record<string, any>>(context, 'options', {});
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
                      <Stack.Item>
                        {`${entry.name} `}
                        <Tooltip content={entry.desc}>
                          <Button icon="question" />
                        </Tooltip>
                      </Stack.Item>
                      <Stack.Item grow={1}>
                        <DynamicEntry id={key} entry={entry} current={options[key]}
                          pick={(val) => { setOptions({ ...options, key: val }); }} />
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
                  <Button.Confirm icon="x"
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
  return built;
};

interface DynamicEntryProps {
  id: string;
  entry: UIDynamicInputEntry;
  current: UIDynamicInputOption;
  pick: (val: any) => void;
}

const DynamicEntry = (props: DynamicEntryProps, context) => {
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

const DynamicEntryNumber = (props: DynamicEntryNumberProps, context) => {
  return (
    <Box>
      Test
    </Box>
  );
};

interface DynamicEntryStringProps extends DynamicEntryProps {
  entry: StringEntry;
  current: StringOption;
}

const DynamicEntryString = (props: DynamicEntryStringProps, context) => {
  return (
    <Box>
      Test
    </Box>
  );
};

interface DynamicEntryPickProps extends DynamicEntryProps {
  entry: PickEntry;
  current: ListOption;
}

const DynamicEntryPick = (props: DynamicEntryPickProps, context) => {
  return (
    <Box>
      Test
    </Box>
  );
};

interface DynamicEntryToggleProps extends DynamicEntryProps {
  entry: ToggleEntry;
  current: ToggleOption;
}

const DynamicEntryToggle = (props: DynamicEntryToggleProps, context) => {
  return (
    <Box>
      Test
    </Box>
  );
};


