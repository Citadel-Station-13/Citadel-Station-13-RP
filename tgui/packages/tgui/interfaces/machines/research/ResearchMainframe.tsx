import { BooleanLike } from "common/react";
import { Window } from "../../../layouts";
import { ResearchNetworkManager } from "./network";
import { useBackend } from "../../../backend";

interface ResearchMainframeData {
  hasNetwork: BooleanLike;
  networkId: string | null;
}

export const ResearchMainframe = (props, context) => {
  const { data, act } = useBackend<ResearchMainframeData>(context);
  return (
    <Window>
      <Window.Content>
        <ResearchNetworkManager data={} act={(a, p) => act('networkAct', { action: a, params: p })} />
      </Window.Content>
    </Window>
  );
};
