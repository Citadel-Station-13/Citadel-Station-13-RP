import { ceiling } from "common/math";
import { useBackend, useLocalState } from "../../backend";
import { Button, Collapsible, Input, NumberInput, Section, Stack } from "../../components";
import { Window } from "../../layouts";
import { StackRecipeData } from "../common/StackRecipe";

interface StackCraftingData {
  recipes: StackRecipeData[];
  amount: number;
  maxAmount: number;
  name: string;
}

interface StackCraftingEntryProps {
  recipe: StackRecipeData;
  craft: (ref: string, amt: number) => void;
}

const StackCraftingEntry = (props: StackCraftingEntryProps, context) => {
  const [amt, setAmt] = useLocalState<number>(context, props.recipe.ref, props.recipe.resultAmt);
  return (
    <Stack>
      <Stack.Item grow={1}>
        <Button.Confirm icon="wrench" fluid content={props.recipe.name} onClick={() => props.craft(props.recipe.ref, amt)} />
      </Stack.Item>
      {(!!props.recipe.isStack || !!props.recipe.maxAmount) && (
        <>
          <Stack.Item>
            <Button icon="plus" onClick={() => setAmt(amt + props.recipe.resultAmt)} />
          </Stack.Item>
          <Stack.Item>
            <NumberInput width={2.5} value={amt}
              onChange={(e, val) => setAmt(
                ceiling(
                  Math.min(Math.max(1, val), props.recipe.maxAmount? props.recipe.maxAmount : Infinity),
                  props.recipe.resultAmt
                ))} />
          </Stack.Item>
          <Stack.Item>
            <Button icon="minus" onClick={() => setAmt(Math.max(props.recipe.resultAmt, amt - props.recipe.resultAmt))} />
          </Stack.Item>
        </>
      )}
    </Stack>
  );
};

export const StackCrafting = (props, context) => {
  const { act, data } = useBackend<StackCraftingData>(context);
  let approximateEntries = 0;
  let categories: string[] = [];
  const [searchText, setSearchText] = useLocalState<string | null>(context, "searchText", null);
  let searchString = searchText?.toLowerCase() || "";
  data.recipes.forEach((r) => {
    if (r.category) {
      if (!categories.includes(r.category)) {
        categories.push(r.category);
        approximateEntries++;
      }
    }
    else {
      approximateEntries++;
    }
  });
  return (
    <Window width={350} height={Math.max(300, 30 + approximateEntries * 30)} title={`${data.name}`}>
      <Window.Content>
        <Section scrollable fill title={"Amount: " + data.amount} buttons={(
          <>
            Search
            <Input
              autoFocus
              value={searchText}
              onInput={(e, val) => setSearchText(val)}
              mx={1} />
          </>
        )}>
          <Stack vertical>
            {searchText && searchText.length >= 3? (
              <>
                {data.recipes.filter((r) => r.name.toLowerCase().includes(searchString)).sort(
                  (a, b) => a.name.localeCompare(b.name)
                ).map((r) => (
                  <Stack.Item key={r.ref}>
                    <StackCraftingEntry recipe={r} craft={(ref, amt) => act(
                      'craft',
                      { recipe: ref, amount: amt }
                    )} />
                  </Stack.Item>
                ))}
              </>
            ) : (
              <>
                {categories.sort((a, b) => a.localeCompare(b)).map((cat) => (
                  <Stack.Item key={cat}>
                    <Collapsible title={cat} contentFunction={() => (
                      <Stack vertical ml={1} mt={1}>
                        {data.recipes.filter((r) => r.category === cat).map((r) => (
                          <Stack.Item key={r.name}>
                            <StackCraftingEntry recipe={r} craft={(ref, amt) => act(
                              'craft',
                              { recipe: ref, amount: amt }
                            )} />
                          </Stack.Item>
                        ))}
                      </Stack>
                    )} />
                  </Stack.Item>
                ))}
                {data.recipes.filter((r) => !r.category).sort((a, b) =>
                  (a.sortOrder === b.sortOrder? a.name.localeCompare(b.name) : b.sortOrder - a.sortOrder)
                ).map((r) => (
                  <Stack.Item key={r.name} ml={0.75}>
                    <StackCraftingEntry recipe={r} craft={(ref, amt) => act(
                      'craft',
                      { recipe: ref, amount: amt }
                    )} />
                  </Stack.Item>
                ))}
              </>
            )}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
