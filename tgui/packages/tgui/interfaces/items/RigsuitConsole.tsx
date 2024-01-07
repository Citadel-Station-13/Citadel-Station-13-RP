import { Input, Section, Stack } from "../../components";
import { SectionProps } from "../../components/Section";

export interface RigsuitConsoleData {
  lines: string[];
}

interface RigsuitConsoleProps extends SectionProps {
  readonly consoleData: RigsuitConsoleData;
  readonly consoleInput?: (raw: string) => void;
  readonly consoleLines?: number;
}

export const RigsuitConsole = (props: RigsuitConsoleProps, context) => {
  let lines = props.consoleLines || 10;
  return (
    <Section {...props}>
      <Stack vertical>
        <Stack.Item>
          <div style={{ height: `${lines+1}em` }} className="Rigsuit__Console-container">
            Test
          </div>
        </Stack.Item>
        {/* <Stack.Item grow={1}>
          <Stack vertical fill
            height={`${lines}em`}
            className="Rigsuit__Console-container" overflowY="scroll">
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
