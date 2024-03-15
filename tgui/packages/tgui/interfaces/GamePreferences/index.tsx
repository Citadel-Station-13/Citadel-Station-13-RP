/**
 * @file
 * @license MIT
 */
import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { getModuleData, useBackend, useComputedOnce, useLocalState } from "../../backend";
import { Button, Section, Stack } from "../../components";
import { Window } from "../../layouts";
import { GamePreferenceEntry, GamePreferenceEntrySchema } from "./GamePreferenceEntry";
import { GamePreferenceKeybindScreen } from "./GamePreferenceKeybinds";
import { GamePreferenceToggleScreen } from "./GamePreferenceToggles";

interface GamePreferencesData {
  entries: GamePreferenceEntrySchema[];
  // middleware key --> name
  middleware: Record<string, string>;
  // entry key --> value as any
  values: Record<string, any>;
}

const GamePreferencesTabs = (props, context) => {
  const { act, data } = useBackend<GamePreferencesData>(context);

  let categoryCache = useComputedOnce(context, "prefsCategoryCache", () => computeGamePreferenceCategoryCache(data.entries));
  let [activeCategory, setActiveCategory] = useLocalState<string>(context, "prefsCategoryActive", Object.keys(categoryCache)[0]);
  let [activeMiddleware, setActiveMiddleware] = useLocalState<string | null>(context, "prefsMiddlewareActive", null);
  let tabs: InfernoNode[] = [];
  Object.keys(categoryCache).forEach((cat) => tabs.push(
    <Stack.Item grow={1}>
      <GamePreferencesTab
        name={cat}
        selected={activeCategory === cat && !activeMiddleware}
        onClick={() => { setActiveCategory(cat); setActiveMiddleware(null); }} />
    </Stack.Item>
  ));
  Object.entries(data.middleware).forEach(([key, name]) => { tabs.push(
    <Stack.Item grow={1}>
      <GamePreferencesTab
        name={name}
        selected={key === activeMiddleware}
        onClick={() => { setActiveMiddleware(key); }} />
    </Stack.Item>
  ); });

  return (
    <Stack>
      {tabs}
    </Stack>
  );
};

const GamePreferencesTab = (props: {
  readonly onClick?: () => void;
  readonly name: string;
  readonly selected: BooleanLike;
}, context) => {
  return (
    <Button color="transparent"
      fluid selected={props.selected} onClick={props.onClick} textAlign="center">{props.name}
    </Button>
  );
};

const computeGamePreferenceCategoryCache = (entries: GamePreferenceEntrySchema[]): Record<string, string[]> => {
  let computed: Record<string, string[]> = {};
  entries.forEach((entry) => {
    if (!computed[entry.category]) {
      computed[entry.category] = [];
    }
    if (!computed[entry.category].includes(entry.subcategory)) {
      computed[entry.category].push(entry.subcategory);
    }
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
    <Window width={600} height={800} title="Game Preferences">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <GamePreferencesTabs />
          </Stack.Item>
          <Stack.Item grow={1}>
            <GamePreferencesBody />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const GamePreferencesBody = (props, context) => {
  const { act, data } = useBackend<GamePreferencesData>(context);

  let categoryCache = useComputedOnce(context, "prefsCategoryCache", () => computeGamePreferenceCategoryCache(data.entries));
  let [activeCategory, setActiveCategory] = useLocalState<string>(context, "prefsCategoryActive", Object.keys(categoryCache)[0]);
  let [activeMiddleware, setActiveMiddleware] = useLocalState<string | null>(context, "prefsMiddlewareActive", null);


  if (activeMiddleware) {
    let middlewareData = getModuleData(context, activeMiddleware);
    switch (activeMiddleware) {
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
      <Stack fill vertical overflowY="auto">
        {categoryCache[activeCategory].map((subcat) => (
          <Stack.Item key={subcat}>
            <h1>{subcat}</h1>
            {data.entries.filter((e) => e.category === activeCategory && e.subcategory === subcat).map((entry) => (
              <GamePreferenceEntry schema={entry} key={entry.key} value={data.values[entry.key]}
                setValue={(val) => act('set', { key: entry.key, value: val })} />
            ))}
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
