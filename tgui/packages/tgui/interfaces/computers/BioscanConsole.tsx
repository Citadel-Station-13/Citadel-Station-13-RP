import { BooleanLike } from "../../../common/react";
import { useBackend } from "../../backend";
import { Button, Collapsible, Input, LabeledList, Section } from "../../components";
import { Window } from "../../layouts";

interface BioscanConsoleData {
  network: string;
  scan_ready: BooleanLike;
  scan: BioscanResults;
}

interface BioscanResults {
  levels: [BioscanLevel];
}

interface BioscanLevel {
  id: string;
  all: number;
  complex: number;
  complex_alive: number;
  complex_dead: number;
}


export const BioscanConsole = (props, context) => {
  let { act, data } = useBackend<BioscanConsoleData>(context);
  return (
    <Window
      width={300}
      height={600}>
      <Section title="Controls">
        <LabeledList>
          <LabeledList.Item label="Network Key">
            <Input value={data.network} onEnter={(_, val) => act('set_network', { network: val })} />
          </LabeledList.Item>
          <LabeledList.Item label="Scan">
            <Button
              title={data.scan_ready? "Scan" : "Charging"}
              icon="magnifying-glass"
              disabled={!data.scan_ready}
              onClick={() => act('scan')} />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Results">
        {data.scan.levels.map((level) => {
          <Collapsible title={level.id}>
            Lifesigns - Total: {level.all}
            Lifesigns - Complex: {level.complex}
            Lifesigns - Complex / Alive: {level.complex_alive}
            Lifesigns - Complex / Dead: {level.complex_dead}
          </Collapsible>;
        })}
      </Section>
    </Window>
  );
};
