import { BooleanLike } from "../../../common/react";
import { useBackend } from "../../backend";
import { Button, Collapsible, Input, LabeledList, Section } from "../../components";
import { Window } from "../../layouts";

interface BioscanConsoleData {
  network: string;
  scan_ready: BooleanLike;
  scan: BioscanResults;
  antennas: [BioscanAntenna];
}

interface BioscanAntenna {
  level: string;
  id: string;
  anchor: BooleanLike;
  x: number;
  y: number;
  name: string;
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
      title="Bioscan Control Console"
      width={400}
      height={750}>
      <Window.Content>
        <Section title="Controls">
          <LabeledList>
            <LabeledList.Item label="Network Key">
              <Input value={data.network} onEnter={(_, val) => act('set_network', { network: val })} />
            </LabeledList.Item>
            <LabeledList.Item label="Scan">
              <Button
                content={data.scan_ready? "Scan" : "Charging"}
                icon="undo"
                disabled={!data.scan_ready}
                onClick={() => act('scan')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <Collapsible color="transparent" title="Antennas">
            {
              data.antennas.sort((a, b) => (a.level.localeCompare(b.level))).map((antenna) => (
                <Collapsible title={`${antenna.name} - ${antenna.level}`} key={antenna.id} color="transparent">
                  <LabeledList>
                    <LabeledList.Item label="Coordinates">
                      {antenna.x} / {antenna.y}
                    </LabeledList.Item>
                    <LabeledList.Item label="Sector / Level">
                      {antenna.level}
                    </LabeledList.Item>
                    <LabeledList.Item label="Floor Bolts">
                      {antenna.anchor? "Anchored" : "Unanchored"}
                    </LabeledList.Item>
                  </LabeledList>
                </Collapsible>
              ))
            }
          </Collapsible>
        </Section>
        <Section title="Results">
          {data.scan? (
            data.scan.levels.map((level) => (
              <Collapsible title={level.id} key={level.id} color="transparent">
                <Section>
                  <LabeledList>
                    <LabeledList.Item label="Lifesigns - Total">
                      {level.all}
                    </LabeledList.Item>
                    <LabeledList.Item label="Lifesigns - Complex">
                      {level.complex}
                    </LabeledList.Item>
                    <LabeledList.Item label="Lifesigns - Complex / Alive">
                      {level.complex_alive}
                    </LabeledList.Item>
                    <LabeledList.Item label="Lifesigns - Complex / Dead">
                      {level.complex_dead}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Collapsible>
            ))
          ) : (
            "No scan data."
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
