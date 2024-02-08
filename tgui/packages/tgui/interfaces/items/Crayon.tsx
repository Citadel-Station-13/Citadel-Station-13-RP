import { useBackend } from "../../backend";
import { Window } from "../../layouts";

const CRAYON_SPRITESHEET_NAME = "crayon-graffiti";

interface CrayonDatapack {
  name: string;
  states: string[];
  width: number;
  height: number;
}

interface CrayonUIData {
  datapacks: CrayonDatapack[];
}

const sizeKeyForCrayonDatapack = (pack: CrayonDatapack) => {
  return `${pack.width}x${pack.height}`;
};

export const Crayon = (props, context) => {
  const { data, act } = useBackend<CrayonDatapack>(context);

  return (
    <Window width={800} height={800}>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );

};
