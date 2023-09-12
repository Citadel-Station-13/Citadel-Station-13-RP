import { useBackend } from "../../backend";
import { Section } from "../../components";
import { Window } from "../../layouts";
import { StackRecipeData } from "../common/StackRecipe";

interface StackCraftingData {
  recipes: StackRecipeData[];
  amount: number;
  maxAmount: number;
  name: string;
}

export const StackCrafting = (props, context) => {
  const { act, data } = useBackend<StackCraftingData>(context);
  return (
    <Window width={350} height={350} title={`${data.name} - ${data.amount}`}>
      <Window.Content>
        <Section>
          Test
        </Section>
      </Window.Content>
    </Window>
  );
};
