import { useBackend, useComputedOnce, useLocalState } from "../../backend";
import { Button, Section, Stack } from "../../components";
import { Window } from "../../layouts";
import { KeybindScreen } from "./KeybindScreen";
import { PreferenceEntry, PreferenceEntrySchema } from "./PreferenceEntry";
import { PreferenceToggleSchema } from "./PreferenceToggle";

interface GamePreferencesData {
  entries: PreferenceEntrySchema[];
  toggles: PreferenceToggleSchema[];
}

const middlewareCategories = [
  "Keybindings",
];

const computeGamePreferenceCategoryCache = (entries: PreferenceEntrySchema[]): Record<string, string[]> => {
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
        <KeybindScreen />
      );
  }

  return (
    <Section fill>
      {props.subcategories.map((subcat) => (
        <Section title={subcat} key={subcat}>
          {data.entries.filter((e) => e.category === props.activeCategory && e.subcategory === subcat).map((entry) => (
            <PreferenceEntry schema={entry} key={entry.key} />
          ))}
        </Section>
      ))}
    </Section>
  );
};
