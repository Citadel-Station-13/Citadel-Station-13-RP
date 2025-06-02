/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { selectBackend, useBackend } from './backend';
import { Icon, Section, Stack } from './components';
import { ComponentProps } from './components/Component';
import { UI_HARD_REFRESHING } from './constants';
import { selectDebug } from './debug/selectors';
import { Window } from './layouts';

const requireInterface = require.context('./interfaces');

/**
 * TODO: this is terrible as it necessitates routing to multiple folders unnecessarily, all the time.
 *       in the future, we want all UIs using nested to just directly specify the path.
 */
const routeLegacyExpandDirs = [
  `./computers`,
  `./items`,
  `./machines`,
  `./modules`,
  `./ui`,
];

/**
 * Get an array of paths to check for a given interface name.
 */
const computeInterfacePaths = (name: string) => {
  // first, look up name literal
  let built: string[] = [
    `./${name}.js`,
    `./${name}.tsx`,
    `./${name}/index.js`,
    `./${name}/index.tsx`,
  ];
  // then, look up subdirectories
  for (let i = 0; i < routeLegacyExpandDirs.length; i++) {
    let dir = routeLegacyExpandDirs[i];
    built.push(`${dir}/${name}.js`);
    built.push(`${dir}/${name}.tsx`);
    built.push(`${dir}/${name}/index.js`);
    built.push(`${dir}/${name}/index.tsx`);
  }
  return built;
};

/**
 * Gets a routed component to render at the React app root.
 */
export const getRoutedComponent = store => {
  const state = store.getState();
  const { suspended, config } = selectBackend(state);
  if (suspended) {
    return UIWindowSuspended;
  }
  if (config.refreshing === UI_HARD_REFRESHING) {
    return UIWindowRefreshing;
  }
  if (process.env['NODE_ENV'] !== 'production') {
    const debug = selectDebug(state);
    // Show a kitchen sink
    if (debug.kitchenSink) {
      return require('./debug').KitchenSink;
    }
  }
  return getRawRoutedComponent(config?.interface);
};

/**
 * Gets a routed component, without checking backend window config.
 * Use this for internal usages.
 */
export const getRawRoutedComponent = (name: string) => {
  let esModule;
  const got: Array<string> = computeInterfacePaths(name) as Array<string>;
  for (let i = 0; i < got.length; i++) {
    let path: string = got[i];
    try {
      esModule = requireInterface(path);
    }
    catch (err) {
      if (err instanceof Error) {
        // this is a node error, not a normal JS error; code should be there.
        if (err['code'] !== 'MODULE_NOT_FOUND') {
          throw err;
        }
      }
    }
    if (esModule) {
      break;
    }
  }
  if (!esModule) {
    return UIRouteNotFound;
  }
  // pull out any /'s as the interface is often a path, not just the interface export
  const nameHasABackslash = name.lastIndexOf("/");
  const realName = nameHasABackslash === -1 ? name : name.substring(nameHasABackslash + 1);
  const Component = esModule[realName];
  if (!Component) {
    return (props, context) => {
      props.exportName = realName;
      return UIRouteMissingExport(props, context);
    };
  }
  return Component;
};

/**
 * UI node to render while a window is suspended.
 */
const UIWindowSuspended = () => {
  return (
    <Window>
      <Window.Content scrollable />
    </Window>
  );
};

/**
 * UI node to render while a window is hard refreshing.
 */
const UIWindowRefreshing = () => {
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

/**
 * UI node returned if a route cannot be found.
 */
const UIRouteNotFound = (props, context) => {
  const { tguiRoot, tguiModule } = props;
  const { config } = useBackend(context);
  return tguiRoot? (
    <Window>
      <Window.Content scrollable>
        <div>Interface <b>{config.interface || "!!NULL!!"}</b> was not found.</div>
      </Window.Content>
    </Window>
  ) : (
    <Section>
      <div>Module <b>{tguiModule || "!!NULL!!"}</b> was not found.</div>
    </Section>
  );
};

/**
 * UI node returned if a route does not have the requisite interface exported.
 */
const UIRouteMissingExport = (props: ComponentProps & {exportName: string | undefined}, context) => {
  const { tguiRoot, tguiModule } = props;
  const { config } = useBackend(context);
  return tguiRoot? (
    <Window>
      <Window.Content scrollable>
        <div>Interface <b>{config.interface}</b> is missing export {props.exportName}.</div>
      </Window.Content>
    </Window>
  ) : (
    <Section>
      <div>Module <b>{tguiModule}</b> is missing an export {props.exportName}.</div>
    </Section>
  );
};
