import { BooleanLike } from "common/react";
import { useBackend } from "../../../../backend";
import { Window } from "../../../../layouts";

export interface ResearchServerData {
  network: {
    id: string;
    name: string;
    active: BooleanLike;
  } | null;
  networksAvailable: {
    id: string;
    name: string;
    reqPending: BooleanLike;
  }[];
}

export const ResearchServer = (props, context) => {
  const { data, act } = useBackend<ResearchServerData>(context);
  return (
    <Window>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
