import { Input, Section, Stack } from "../../components";

export interface RigsuitConsoleData {
  lines: string[];
}

interface RigsuitConsoleProps {
  readonly data: RigsuitConsoleData;
  readonly inputLine: (raw: string) => void;
}

export const RigsuitConsole = (props: RigsuitConsoleProps, context) => {
  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item grow={1}>
          Test
        </Stack.Item>
        <Stack.Item>
          <Input />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
