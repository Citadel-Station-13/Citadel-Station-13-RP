import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { StackRecipeData } from "../common/StackRecipe";

interface StackCraftingData {
  recipes: StackRecipeData[];
  amount: number;
  maxAmount: number;
}

export const StackCrafting = (props, context) => {
  const { act, data } = useBackend<StackCraftingData>(context);
  return (
    <Window width={350} height={350}>
      <Window.Content>
        Testing
      </Window.Content>
    </Window>
  );
};
