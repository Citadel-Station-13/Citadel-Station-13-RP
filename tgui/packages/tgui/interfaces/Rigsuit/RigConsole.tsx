import { Input, Section, Stack } from "../../components";
import { SectionProps } from "../../components/Section";

export interface RigConsoleData {
  lines: string[];
}

interface RigConsoleProps extends SectionProps {
  readonly consoleData: RigConsoleData;
  readonly consoleInput?: (raw: string) => void;
  readonly consoleLines?: number;
}

export const RigConsole = (props: RigConsoleProps, context) => {
  let lines = props.consoleLines || 10;
  return (
    <Section {...props}>
      <Stack vertical>
        <Stack.Item>
          <div style={{ height: `${lines+1}em` }} className="Rig__Console-container">
            Test
          </div>
        </Stack.Item>
        {/* <Stack.Item grow={1}>
          <Stack vertical fill
            height={`${lines}em`}
            className="Rig__Console-container" overflowY="scroll">
            {props.consoleData.lines.map((line) => (
              <Stack.Item key={line}>
                {line}
              </Stack.Item>
            ))}
          </Stack>
        </Stack.Item> */}
        <Stack.Item>
          <Input placeholder="help" onEnter={(e, val) => props.consoleInput?.(val)}
            fluid />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
