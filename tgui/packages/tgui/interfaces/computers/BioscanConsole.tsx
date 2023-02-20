import { BooleanLike } from "../../../common/react";
import { useBackend } from "../../backend";
import { Section } from "../../components";

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
  let {act, data} = useBackend<BioscanConsoleData>(context);
  return (
    <Window
      width={300}
      height={600}>
        <Section title="Controls">
          test
        </Section>
        <Section title="Results">

        </Section>
      </Window>

  )
}
