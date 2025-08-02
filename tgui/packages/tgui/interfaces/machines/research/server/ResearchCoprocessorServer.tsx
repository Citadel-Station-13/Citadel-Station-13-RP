import { useBackend } from "../../../../backend";
import { ResearchServer, ResearchServerData } from "./common";

interface ResearchCoprocessorServerData extends ResearchServerData {
  cpuCapacity: number;
  cpuScheduled: number;
  jobs: {
    name: string;
    load: number;
  }[];
}

export const ResearchCoprocessorServer = (props, context) => {
  const { data, act } = useBackend<ResearchCoprocessorServerData>(context);
  return (
    <ResearchServer>
      Test
    </ResearchServer>
  );
};
