/**
 * @file
 * @license MIT
 */

import { Component, ReactNode } from "react";
import { Section, Stack } from "tgui-core/components";

import { Window } from "../../layouts";

interface VehicleControllerProps {
  // render something below the integrity bar at home screen
  // * This should be a Stack.Item or several Stack.Item's in a Fragment.
  renderStackItemsBelowIntegrityHomeDisplay?: ReactNode;
  // render something below all integrity bars
  // * This should be a Stack.Item or several Stack.Item's in a Fragment.
  renderStackItemsBelowIntegrityDisplay?: ReactNode;
  // additional tab names associated to functions to generate ReactNode's to render when
  // they are selected.
  // * These can override the default ones. Use this at your own peril.
  // * If a default one is nulled out it'll be suppressed.
  tabRenderers?: Record<VehicleControllerTabKey, () => ReactNode | null>;
}

interface VehicleControllerState {
  activeControllerTabe: VehicleControllerTabKey | null;
}

enum VehicleControllerBuiltinTabs {
  Home = "home",
  Modules = "modules",
  Components = "components",
  Settings = "settings",
}

type VehicleControllerTabKey = VehicleControllerBuiltinTabs | string;

/**
 * Vehicle controller app window
 */
// eslint-disable-next-line react/prefer-stateless-function
export class VehicleController extends Component<VehicleControllerProps, VehicleControllerState> {
  constructor(props) {
    super(props);
    this.state = {
      activeControllerTabe: VehicleControllerBuiltinTabs.Home,
    };
  }

  render() {
    return (
      <Window width={500} height={800}>
        <Window.Content>
          <Stack>
            <Stack.Item>
              Tabs
            </Stack.Item>
            <Stack.Item grow>
              <VehicleControllerContent activeTab={this.state.activeControllerTabe} />
            </Stack.Item>
          </Stack>
        </Window.Content>
      </Window>
    );
  }
}

const VehicleControllerContent = (props: {
  activeTab: VehicleControllerTabKey | null,
  customRenderers?: Record<VehicleControllerTabKey, () => ReactNode | null>;
}) => {
  if (props.activeTab && props.customRenderers?.[props.activeTab] !== undefined) {
    return props.customRenderers[props.activeTab]() || (<Section fill />);
  }
  switch (props.activeTab) {
    case VehicleControllerBuiltinTabs.Home:
      return VehicleControllerHome({});
    case VehicleControllerBuiltinTabs.Modules:
      return VehicleControllerModules({});
    case VehicleControllerBuiltinTabs.Components:
      return VehicleControllerComponents({});
    case VehicleControllerBuiltinTabs.Settings:
      return VehicleControllerSettings({});
  }
  return (<Section fill />);
};

interface VehicleControllerHomeProps {

}

const VehicleControllerHome = (props) => {
  return (
    <>
      Test
    </>
  );
};

interface VehicleControllerModulesProps {

}

const VehicleControllerModules = (props) => {
  return (
    <>
      Test
    </>
  );
};

interface VehicleControllerComponentsProps {

}

const VehicleControllerComponents = (props) => {
  return (
    <>
      Test
    </>
  );
};

interface VehicleControllerSettingsProps {

}

const VehicleControllerSettings = (props) => {
  return (
    <>
      Test
    </>
  );
};
