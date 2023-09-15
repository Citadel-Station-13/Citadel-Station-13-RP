import { useBackend } from "../../backend";
import { Collapsible, Section, Stack } from "../../components";
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
  let categories: string[] = [];
  data.recipes.forEach((r) => {
    if (r.category !== undefined && !categories.includes(r.category)) {
      categories.push(r.category);
    }
  });
  return (
    <Window width={350} height={350} title={`${data.name} - ${data.amount}`}>
      <Window.Content>
        <Section fill>
          {JSON.stringify(data)}
          <Stack vertical>
            {categories.sort((a, b) => a.localeCompare(b)).map((cat) => (
              <Stack.Item key={cat}>
                <Collapsible title={cat} contentFunction={() => (
                  <Stack vertical>
                    {data.recipes.filter((r) => r.category === cat).map((r) => (
                      <Stack.Item key={r.name}>
                        Test
                      </Stack.Item>
                    ))}
                  </Stack>
                )} />
              </Stack.Item>
            ))}
            {data.recipes.filter((r) => r.category === undefined).map((r) => (
              <Stack.Item key={r.name}>
                Test
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
