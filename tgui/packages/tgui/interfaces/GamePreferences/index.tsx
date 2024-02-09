import { useBackend, useComputedOnce, useLocalState } from "../../backend";
import { Button, Section, Stack } from "../../components";
import { Window } from "../../layouts";
import { GamePreferenceKeybindScreen } from "./GamePreferenceKeybinds";
import { GamePreferenceEntry, GamePreferenceEntrySchema } from "./GamePreferenceEntry";
import { GamePreferenceToggleSchema } from "./GamePreferenceToggle";

interface GamePreferencesData {
  entries: GamePreferenceEntrySchema[];
  toggles: GamePreferenceToggleSchema[];
}

const middlewareCategories = [
  "Keybindings",
];

const computeGamePreferenceCategoryCache = (entries: GamePreferenceEntrySchema[]): Record<string, string[]> => {
  let computed: Record<string, string[]> = {};
  entries.forEach((entry) => {
    if (!computed[entry.category]) {
      computed[entry.category] = [];
    }
    computed[entry.category].push(entry.subcategory);
  });
  middlewareCategories.forEach((cat) => {
    if (!computed[cat]) {
      computed[cat] = [];
    }
  });
  Object.values(computed).forEach((arr) => arr.sort((a, b) => a.localeCompare(b)));
  return computed;
};

export const GamePreferences = (props, context) => {
  const { act, data } = useBackend<GamePreferencesData>(context);
  
  let categoryCache = useComputedOnce(context, "prefsCategoryCache", () => computeGamePreferenceCategoryCache(data.entries));
  let [activeCategory, setActiveCategory] = useLocalState<string>(context, "prefsCategoryActive", Object.keys(categoryCache)[0]);

  return (
    <Window width={800} height={800}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Stack fill>
              {Object.keys(categoryCache).sort((a, b) => a.localeCompare(b)).map((cat) => (
                <Stack.Item grow={1} key={cat}>
                  <Button 
                    content={cat}
                    selected={activeCategory === cat}
                    onClick={() => setActiveCategory(cat)} />
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
          <Stack.Item grow={1}>
            <GamePreferencesBody activeCategory={activeCategory} subcategories={categoryCache[activeCategory]} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

interface GamePreferencesBodyProps {
  readonly activeCategory: string;
  readonly subcategories: string[];
}

const GamePreferencesBody = (props: GamePreferencesBodyProps, context) => {
  const { act, data } = useBackend<GamePreferencesData>(context);

  switch (props.activeCategory) {
    case "Keybindings":
      return (
        <GamePreferenceKeybindScreen />
      );
  }

  return (
    <Section fill>
      {props.subcategories.map((subcat) => (
        <Section title={subcat} key={subcat}>
          {data.entries.filter((e) => e.category === props.activeCategory && e.subcategory === subcat).map((entry) => (
            <GamePreferenceEntry schema={entry} key={entry.key} />
          ))}
        </Section>
      ))}
    </Section>
  );
};
