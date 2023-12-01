import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { ByondAtomColor } from "../common/Color";

interface IcecreamCartData {
  baseIngredients: {
    milk: number,
    flour: number,
    sugar: number,
    ice: number,
  };
  sources: {
    name: string,
    volume: number,
    maxVolume: number,
    color: ByondAtomColor,
  }[];
}

export const IcecreamCart = (props, context) => {
  let { data, act } = useBackend<IcecreamCartData>(context);

  return (
    <Window title="Icecream Cart" width={600} height={300}>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
