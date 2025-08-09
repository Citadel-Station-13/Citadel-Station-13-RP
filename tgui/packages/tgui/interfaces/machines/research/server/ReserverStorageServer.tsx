import { useBackend } from "../../../../backend";
import { ResearchServer, ResearchServerData } from "./common";

interface ResearchStorageServerData extends ResearchServerData {
  baysCount: number;
  bays: {
    name: string;
  }[];
}

export const ResearchStorageServer = (props, context) => {
  const { data, act } = useBackend<ResearchStorageServerData>(context);
  return (
    <ResearchServer>
      Test
    </ResearchServer>
  );
};
