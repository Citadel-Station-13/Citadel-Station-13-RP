/**
 * the citrp game preferences system
 * attempts to be fast but is ultimately unoptimized
 * the optimized version will be our character setup system : )
 *
 * todo: when character tgui is done, maybe this should use a similar backend? who knows.
 *
 * @file
 * @license MIT
 */
import { ReactNode } from "react";
import { Button, Flex, Section, Stack, Tooltip } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { useBackend, useLocalState } from "../../backend";
import { Window } from "../../layouts";
import { GamePreferenceEntry, GamePreferenceEntrySchema } from "./GamePreferenceEntry";
import { GamePreferenceKeybindMiddlware, GamePreferenceKeybindScreen } from "./GamePreferenceKeybinds";
import { GamePreferenceToggleScreen, GamePreferenceTogglesMiddleware } from "./GamePreferenceToggles";

interface GamePreferencesData {
  entries: GamePreferenceEntrySchema[];
  // middleware key --> name
  middleware: Record<string, string>;
  // entry key --> value as any
  values: Record<string, any>;
  // do we need saving?
  dirty: BooleanLike;
}

const GamePreferencesTabs = (props) => {
  const { act, data } = useBackend<GamePreferencesData>();

  let categoryCache = computeGamePreferenceCategoryCache(data.entries);
  let [activeCategory, setActiveCategory] = useLocalState<string>('category', Object.keys(categoryCache)[0]);
  let [activeMiddleware, setActiveMiddleware] = useLocalState<string | null>('middleware', null);
  let tabs: ReactNode[] = [];
  Object.keys(categoryCache).forEach((cat) => tabs.push(
    <Stack.Item grow={1}>
      <GamePreferencesTab
        name={cat}
        selected={activeCategory === cat && !activeMiddleware}
        onClick={() => { setActiveCategory(cat); setActiveMiddleware(null); }} />
    </Stack.Item>
  ));
  Object.entries(data.middleware).forEach(([key, name]) => {
    tabs.push(
      <Stack.Item grow={1}>
        <GamePreferencesTab
          name={name}
          selected={key === activeMiddleware}
          onClick={() => { setActiveMiddleware(key); }} />
      </Stack.Item>
    );
  });

  return (
    <Section>
      <Stack>
        {tabs}
      </Stack>
    </Section>
  );
};

const GamePreferencesTab = (props: {
  readonly onClick?: () => void;
  readonly name: string;
  readonly selected: BooleanLike;
}) => {
  return (
    <Button color={props.selected ? null : "transparent"}
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

export const GamePreferences = (props) => {
  const { act, data } = useBackend<GamePreferencesData>();

  let categoryCache = computeGamePreferenceCategoryCache(data.entries);
  let [activeCategory, setActiveCategory] = useLocalState<string>('category', Object.keys(categoryCache)[0]);
  let [activeMiddleware, setActiveMiddleware] = useLocalState<string | null>('middleware', null);

  // sigh
  // this is shitcode
  // todo: refactor game prefs ui again
  const [activeCapture, setActiveCapture] = useLocalState<ReactNode | null>('keybindCapture', null);

  return (
    <Window width={600} height={800} title="Game Preferences">
      {/* inject active capture vnode */}
      {activeCapture}
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <GamePreferenceHeader />
          </Stack.Item>
          <Stack.Item grow={1}>
            <GamePreferencesBody />
          </Stack.Item>
          <Stack.Item>
            <GamePreferenceFooter activeCategory={activeCategory} activeMiddleware={activeMiddleware} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const GamePreferencesBody = (props) => {
  const { act, data, nestedData } = useBackend<GamePreferencesData>();

  let categoryCache = computeGamePreferenceCategoryCache(data.entries);
  let [activeCategory, setActiveCategory] = useLocalState<string>('category', Object.keys(categoryCache)[0]);
  let [activeMiddleware, setActiveMiddleware] = useLocalState<string | null>('middleware', null);

  // todo: this is so fucking awful bros please don't make the same mistake on character setup.
  if (activeMiddleware && (typeof activeMiddleware === 'string')) {
    let middlewareData = nestedData[activeMiddleware];
    switch (activeMiddleware) {
      case 'keybindings':
        return (
          <GamePreferenceKeybindScreen
            addBind={(id, key, replacing) => act('addBind', {
              ...key,
              replaceKey: replacing,
              keybind: id,
            }, activeMiddleware)}
            removeBind={(id, key) => act('removeBind', { keybind: id, key: key }, activeMiddleware)}
            setHotkeyMode={(on) => act('hotkeys', { value: on }, activeMiddleware)}
            {...middlewareData as GamePreferenceKeybindMiddlware} />
        );
      case 'toggles':
        return (
          <GamePreferenceToggleScreen
            toggleAct={(key: string, val: BooleanLike) => act('toggle', { key: key, val: val }, 'toggles')}
            {...middlewareData as GamePreferenceTogglesMiddleware} />
        );
    }
  }

  return (
    <Section fill scrollable>
      <Stack vertical>
        {categoryCache[activeCategory].map((subcat) => (
          <Stack.Item key={subcat}>
            <h1 style={{ textAlign: "center" }}>{subcat}</h1>
            <hr />
            <Stack vertical>
              {data.entries.filter((e) => e.category === activeCategory && e.subcategory === subcat).map((entry) => (
                <Stack.Item key={entry.key}>
                  <GamePreferenceEntry schema={entry} value={data.values[entry.key]}
                    setValue={(val) => act('set', { key: entry.key, value: val })} />
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const GamePreferenceHeader = (props) => {
  return (
    <Flex direction="column">
      <Flex.Item>
        <GamePreferencesTabs />
      </Flex.Item>
      <Flex.Item />
    </Flex>
  );
};

const GamePreferenceFooter = (props: {
  readonly activeCategory: string,
  readonly activeMiddleware: string | null
}) => {
  const { act, data } = useBackend<GamePreferencesData>();
  return (
    <Section>
      <Stack fill>
        <Stack.Item grow={1}>
          <Tooltip content="Performs a full save of your preferences.">
            <Button.Confirm fluid
              textAlign="center"
              color="transparent"
              bold={!!data.dirty}
              onClick={() => act('save')}
              content="Save" />
          </Tooltip>
        </Stack.Item>
        <Stack.Item grow={1}>
          <Tooltip content="Reloads your preferences from disk, discarding all current changes.">
            <Button.Confirm fluid
              textAlign="center"
              color="transparent"
              bold={!!data.dirty}
              onClick={() => act('discard')}
              content="Discard" />
          </Tooltip>
        </Stack.Item>
        <Stack.Item grow={1}>
          <Tooltip content="Resets the current page to default.">
            <Button.Confirm fluid
              textAlign="center"
              color="transparent"
              onClick={() =>
                act('reset', props.activeCategory ? { category: props.activeCategory } : {}, props.activeMiddleware)}
              content="Reset to Default" />
          </Tooltip>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
