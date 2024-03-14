/**
 * @file
 * @license MIT
 */
import { BooleanLike } from "common/react";
import { getModuleData, useBackend, useComputedOnce, useLocalState } from "../../backend";
import { Button, Section, Stack, Tabs } from "../../components";
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

  return (
    <Tabs fluid>
      {}
    </Tabs>
  );
};

const GamePreferencesTab = (props: {
  readonly onClick?: () => void;
  readonly name: string;
  readonly selected: BooleanLike;
}, context) => {
  return (
    <Button selected={props.selected} onClick={props.onClick}>{props.name}</Button>
  );
};

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
        {JSON.stringify(categoryCache)}
        <Stack vertical fill>
          <Stack.Item>
            <GamePreferencesTabs />
          </Stack.Item>
          <Stack.Item grow={1}>
            <GamePreferencesBody />
          </Stack.Item>
        </Stack>
        {JSON.stringify(data)}
      </Window.Content>
    </Window>
  );
};

const GamePreferencesBody = (props, context) => {
  const { act, data } = useBackend<GamePreferencesData>(context);

  let categoryCache = useComputedOnce(context, "prefsCategoryCache", () => computeGamePreferenceCategoryCache(data.entries));
  let [activeCategory, setActiveCategory] = useLocalState<string>(context, "prefsCategoryActive", Object.keys(categoryCache)[0]);
  let [activeMiddleware, setActiveMiddleware] = useLocalState<string | null>(context, "prefsMiddlewareActive", null);


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
            <GamePreferenceEntry schema={entry} key={entry.key} value={data.values[entry.key]}
              setValue={(val) => act('set', { key: entry.key, value: val })} />
          ))}
        </Section>
      ))}
    </Section>
  );
};
