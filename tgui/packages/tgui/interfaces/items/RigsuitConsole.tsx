import { Input, Section, Stack } from "../../components";
import { SectionProps } from "../../components/Section";

export interface RigsuitConsoleData {
  lines: string[];
}

interface RigsuitConsoleProps extends SectionProps {
  readonly consoleData: RigsuitConsoleData;
  readonly consoleInput?: (raw: string) => void;
}

export const RigsuitConsole = (props: RigsuitConsoleProps, context) => {
  return (
    <Section fill {...props} className="Rigsuit__Console">
      <Stack vertical fill>
        <Stack.Item grow={1}>
          <Stack vertical fill className="Rigsuit__Console-container" overflowY="scroll">
            {props.consoleHistory.lines.map((line) => (
              <Stack.Item key={line}>
                {line}
              </Stack.Item>
            ))}
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Input placeholder="help" onEnter={(e, val) => props.consoleInput?.(val)} />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
