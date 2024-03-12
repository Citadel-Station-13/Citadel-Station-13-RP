import { getModuleData, useBackend, useComputedOnce, useLocalState } from "../../backend";
import { Button, Section, Stack } from "../../components";
import { Window } from "../../layouts";
import { GamePreferenceEntry, GamePreferenceEntrySchema } from "./GamePreferenceEntry";
import { GamePreferenceKeybindScreen } from "./GamePreferenceKeybinds";
import { GamePreferenceToggleScreen } from "./GamePreferenceToggles";

interface GamePreferencesData {
  entries: GamePreferenceEntrySchema[];
  middleware: string[];
  // entry key --> value as any
  values: Record<string, any>;
}

const computeGamePreferenceCategoryCache = (entries: GamePreferenceEntrySchema[]): Record<string, string[]> => {
  let computed: Record<string, string[]> = {};
  entries.forEach((entry) => {
    if (!computed[entry.category]) {
      computed[entry.category] = [];
    }
    computed[entry.category].push(entry.subcategory);
  });
  Object.values(computed).forEach((arr) => arr.sort((a, b) => a.localeCompare(b)));
  return computed;
};

export const GamePreferences = (props, context) => {
  const { act, data } = useBackend<GamePreferencesData>(context);

  let categoryCache = useComputedOnce(context, "prefsCategoryCache", () => computeGamePreferenceCategoryCache(data.entries));
  let [activeCategory, setActiveCategory] = useLocalState<string>(context, "prefsCategoryActive", Object.keys(categoryCache)[0]);
  let [activeMiddleware, setActiveMiddleware] = useLocalState<string | null>(context, "prefsMiddlewareActive", null);

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
            <GamePreferencesBody
              activeCategory={activeCategory}
              activeMiddleware={activeMiddleware}
              subcategories={categoryCache[activeCategory]}
              middleware={data.middleware} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

interface GamePreferencesBodyProps {
  readonly activeCategory: string;
  readonly activeMiddleware: string | null;
  readonly subcategories: string[];
  readonly middleware: string[];
}

const GamePreferencesBody = (props: GamePreferencesBodyProps, context) => {
  const { act, data } = useBackend<GamePreferencesData>(context);

  if (props.activeMiddleware) {
    let middlewareData = getModuleData(context, props.activeMiddleware);
    switch (props.activeMiddleware) {
      case 'keybindings':
        return (
          <GamePreferenceKeybindScreen />
        );
      case 'toggles':
        return (
          <GamePreferenceToggleScreen />
        );
    }
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
