import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { MaterialsContext } from "../common/Materials";

interface SheetSiloData {
  materialContext: MaterialsContext;
  stored: Record<string, number>;
}

export const SheetSilo = (props, context) => {
  const { act, data } = useBackend<SheetSiloData>(context);

  return (
    <Window width={400} height={800}>
      <Window.Content>
        test
      </Window.Content>
    </Window>
  );
};
