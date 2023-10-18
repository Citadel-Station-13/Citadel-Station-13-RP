/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { selectBackend, useBackend } from './backend';
import { Icon, Section, Stack } from './components';
import { UI_HARD_REFRESHING } from './constants';
import { selectDebug } from './debug/selectors';
import { Window } from './layouts';

const requireInterface = require.context('./interfaces');

const routingNotFound = (props, context) => {
  const { tgui_root, tgui_module } = props;
  const { config } = useBackend(context);
  return tgui_root? (
    <Window>
      <Window.Content scrollable>
        <div>Interface <b>{config.interface}</b> was not found.</div>
      </Window.Content>
    </Window>
  ) : (
    <Section>
      <div>Module <b>{tgui_module}</b> was not found.</div>
    </Section>
  );
};

const routingMissingExport = (props, context) => {
  const { tgui_root, tgui_module } = props;
  const { config } = useBackend(context);
  return tgui_root? (
    <Window>
      <Window.Content scrollable>
        <div>Interface <b>{config.interface}</b> is missing an export.</div>
      </Window.Content>
    </Window>
  ) : (
    <Section>
      <div>Module <b>{tgui_module}</b> is missing an export.</div>
    </Section>
  );
};

const SuspendedWindow = () => {
  return (
    <Window>
      <Window.Content scrollable />
    </Window>
  );
};

const RefreshingWindow = () => {
  return (
    <Window title="Loading">
      <Window.Content>
        <Section fill>
          <Stack align="center" fill justify="center" vertical>
            <Stack.Item>
              <Icon color="blue" name="toolbox" spin size={4} />
            </Stack.Item>
            <Stack.Item>
              Please wait...
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

const interfaceSubdirectories = [
  `.`,
  `./computers`,
  `./items`,
  `./machines`,
  `./modules`,
  `./ui`,
];

const interfacePath = (name: string) => {
  let built: [string?] = [];
  for (let i = 0; i < interfaceSubdirectories.length; i++) {
    let dir = interfaceSubdirectories[i];
    built.push(`${dir}/${name}.js`);
    built.push(`${dir}/${name}.tsx`);
    built.push(`${dir}/${name}/index.js`);
    built.push(`${dir}/${name}/index.tsx`);
  }
  return built;
};

export const getRoutedComponent = store => {
  const state = store.getState();
  const { suspended, config } = selectBackend(state);
  if (suspended) {
    return SuspendedWindow;
  }
  if (config.refreshing === UI_HARD_REFRESHING) {
    return RefreshingWindow;
  }
  if (process.env.NODE_ENV !== 'production') {
    const debug = selectDebug(state);
    // Show a kitchen sink
    if (debug.kitchenSink) {
      return require('./debug').KitchenSink;
    }
  }
  return directlyRouteComponent(config?.interface);
};

export const directlyRouteComponent = (name) => {
  let esModule;
  const got: Array<string> = interfacePath(name) as Array<string>;
  for (let i = 0; i < got.length; i++) {
    let path: string = got[i];
    try {
      esModule = requireInterface(path);
    }
    catch (err) {
      if (err.code !== 'MODULE_NOT_FOUND') {
        throw err;
      }
    }
    if (esModule) {
      break;
    }
  }
  if (!esModule) {
    return routingNotFound;
  }
  const Component = esModule[name];
  if (!Component) {
    return routingMissingExport;
  }
  return Component;
};
