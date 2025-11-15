import { useBackend } from "../../backend";
import { Window } from "../../layouts";

interface MortarBasicData {
  targetX: number;
  targetY: number;
  adjustX: number;
  adjustY: number;
  adjustMax: number;
}

export const MortarBasic = (props) => {
  const { act, data } = useBackend<MortarBasicData>();

  return (
    <Window>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
