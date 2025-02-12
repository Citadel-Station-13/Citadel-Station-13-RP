/**
 * Food recipe guidebook section.
 *
 *
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";
import { useLocalState, useModule } from "../../backend";
import { Input, Section, Stack, Tabs } from "../../components";
import { Modular } from "../../layouts/Modular";
import { TGUIGuidebookSectionData } from "./TGUIGuidebook";

export interface TGUIGuidebookCookingRecipeData extends TGUIGuidebookSectionData {
  // list of recipes
  readonly recipes: TGUIGuidebookCookingRecipe[];
}

enum CookingRecipeGuidebookFlags {
  Unlisted = (1 << 0),
  Hidden = (1 << 1),
}

interface TGUIGuidebookCookingRecipe {
  // recipe flags: currently untyped because there are none
  // flags: number;
  // reaction guidebook flags
  // guidebookFlags: CookingRecipeGuidebookFlags;
  // result name string
  result: string;
  // result reagent names
  result_reagents: string;
  // result amount
  result_amount: number;
  // required item names
  req_items: string;
  // required grown names
  req_growns: string;
  // required reagent names
  req_reagents: string;
  // required cooking method
  req_method: string;
}

export const TGUIGuidebookCookingRecipes = (props, context) => {
  let { data } = useModule<TGUIGuidebookCookingRecipeData>(context);
  const [activeTab, setActiveTab] = useLocalState<string | null>(context, 'activeRecipesTab', null);
  const [searchText, setSearchText] = useLocalState<string | null>(context, 'activeRecipesSearch', null);

  let rendered: InfernoNode | null = null;
  let categorizedRecipes: Record<string, TGUIGuidebookCookingRecipe[]> = {};

  switch (activeTab) {
    case 'recipeTab':
      Object.values(data.recipes).filter(
        (recipe) => !searchText || recipe.result.includes(searchText)).forEach(
        (recipe) => {
          (categorizedRecipes[recipe.req_method] = categorizedRecipes[recipe.req_method] || []).push(recipe);
        });
      rendered = (
        <Stack vertical>
          {Object.entries(categorizedRecipes).sort(([cat1, a1], [cat2, a2]) => cat1.localeCompare(cat2)).map(
            ([cat, catRecipes]) => (
              <Stack.Item key={cat}>
                <Section title={cat}>
                  <Stack vertical>
                    {catRecipes.sort((r1, r2) => r1.result.localeCompare(r2.result)).map((recipe) => (
                      <Stack.Item key={recipe.result}>
                        {recipe.result} requires {recipe.req_items}, {recipe.req_growns} and {recipe.req_reagents}
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            )
          )}
        </Stack>
      );
      break;
  }

  return (
    <Modular window={{ width: 800, height: 800 }} section={{ fill: true }}>
      <Stack vertical fill>
        <Stack.Item>
          <Stack>
            <Stack.Item grow={1}>
              <Tabs>
                <Tabs.Tab selected={activeTab === "recipeTab"}
                  onClick={() => setActiveTab("recipeTab")}>
                  Recipes
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
            <Stack.Item>
              Search <Input width="100px" onInput={(e, value) => setSearchText(value)} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow={1}>
          <Section scrollable fill>
            {rendered}
          </Section>
        </Stack.Item>
      </Stack>
    </Modular>
  );
};
