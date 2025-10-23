/**
 * @file
 * @license MIT
 */

import { Component, ReactNode } from "react";
import { LabeledList, Section, Stack } from "tgui-core/components";

import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { VehicleComponent, VehicleModule } from "./helpers";
import { VehicleData } from "./types";

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
  tabRenderers?: Record<VehicleControllerTabKey, () => ReactNode>;
  // additional LabeledList items to render in options
  renderAdditionalSettingSectionLabeledListItems?: Partial<Record<VehicleControllerBuiltinSettingSections, () => ReactNode>>;
  // additional Stack.Item's to render in options
  renderAdditionalSettingSectionStackItems?: Partial<Record<VehicleControllerBuiltinSettingSections, () => ReactNode>>;
}

interface VehicleControllerState {
  activeControllerTabe: VehicleControllerTabKey | null;
}

export enum VehicleControllerBuiltinTabs {
  Home = "home",
  Modules = "modules",
  Components = "components",
  Settings = "settings",
}

export enum VehicleControllerBuiltinSettingSections {
  Options = "options",
  Radio = "radio",
  Air = "air",
  System = "system",
}

export type VehicleControllerTabKey = VehicleControllerBuiltinTabs | string;

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
      <Window width={500} height={800} theme="hackerman">
        <Window.Content>
          <Stack>
            <Stack.Item>
              <Section>
                <Stack vertical>
                  <Stack.Item>
                    <Stack>
                      <Stack.Item>
                        Chassis Integrity
                      </Stack.Item>
                      <Stack.Item grow>
                        Test
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  {this.props.renderStackItemsBelowIntegrityHomeDisplay}
                  {this.props.renderStackItemsBelowIntegrityDisplay}
                </Stack>
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Section>
                Tabs
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <VehicleControllerContent
                activeTab={this.state.activeControllerTabe}
                customRenderers={this.props.tabRenderers}
                renderAdditionalSettingSectionLabeledListItems={this.props.renderAdditionalSettingSectionLabeledListItems}
                renderAdditionalSettingSectionStackItems={this.props.renderAdditionalSettingSectionStackItems} />
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
  renderAdditionalSettingSectionLabeledListItems?: Partial<Record<VehicleControllerBuiltinSettingSections, () => ReactNode>>;
  renderAdditionalSettingSectionStackItems?: Partial<Record<VehicleControllerBuiltinSettingSections, () => ReactNode>>;
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
      return VehicleControllerSettings({
        renderAdditionalSettingSectionLabeledListItems: props.renderAdditionalSettingSectionLabeledListItems,
        renderAdditionalSettingSectionStackItems: props.renderAdditionalSettingSectionStackItems,
      });
  }
  return (<Section fill />);
};

interface VehicleControllerHomeProps {

}

const VehicleControllerHome = (props: VehicleControllerHomeProps) => {
  const { act, data } = useBackend<VehicleData>();
  return (
    <Section>
      Test
    </Section>
  );
};

interface VehicleControllerModulesProps {

}

const VehicleControllerModules = (props: VehicleControllerModulesProps) => {
  const { act, data } = useBackend<VehicleData>();
  return (
    <Section>
      <Stack fill vertical>
        {data.moduleRefs.map((ref) => {
          return (
            <Stack.Item key={ref}>
              <VehicleModule ref={ref} />
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};

interface VehicleControllerComponentsProps {

}

const VehicleControllerComponents = (props: VehicleControllerComponentsProps) => {
  const { act, data } = useBackend<VehicleData>();
  return (
    <Section>
      <Stack fill vertical>
        {data.componentRefs.map((ref) => {
          return (
            <Stack.Item key={ref}>
              <VehicleComponent ref={ref} />
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};

interface VehicleControllerSettingsProps {
  // additional LabeledList items to render in options
  renderAdditionalSettingSectionLabeledListItems?: Partial<Record<VehicleControllerBuiltinSettingSections, () => ReactNode>>;
  // additional Stack.Item's to render in options
  renderAdditionalSettingSectionStackItems?: Partial<Record<VehicleControllerBuiltinSettingSections, () => ReactNode>>;
}

const VehicleControllerSettings = (props: VehicleControllerSettingsProps) => {
  return (
    <Section>
      <Stack fill vertical>
        <Stack.Item>
          Options
          <LabeledList>
            <LabeledList.Item label="Floodlights">Test</LabeledList.Item>
            {props.renderAdditionalSettingSectionLabeledListItems?.[VehicleControllerBuiltinSettingSections.Options]?.()}
          </LabeledList>
          {props.renderAdditionalSettingSectionStackItems?.[VehicleControllerBuiltinSettingSections.Options]?.()}
        </Stack.Item>
        <Stack.Item>
          Radio
          <LabeledList>
            <LabeledList.Item label="Frequency">Test</LabeledList.Item>
            <LabeledList.Item label="Transmit">Test</LabeledList.Item>
            <LabeledList.Item label="Receive">Test</LabeledList.Item>
            {props.renderAdditionalSettingSectionLabeledListItems?.[VehicleControllerBuiltinSettingSections.Radio]?.()}
          </LabeledList>
          {props.renderAdditionalSettingSectionStackItems?.[VehicleControllerBuiltinSettingSections.Radio]?.()}
        </Stack.Item>
        <Stack.Item>
          Life Support
          <LabeledList>
            <LabeledList.Item label="Airflow">Test</LabeledList.Item>
            <LabeledList.Item label="Port Connection">Test</LabeledList.Item>
            {props.renderAdditionalSettingSectionLabeledListItems?.[VehicleControllerBuiltinSettingSections.Air]?.()}
          </LabeledList>
          {props.renderAdditionalSettingSectionStackItems?.[VehicleControllerBuiltinSettingSections.Air]?.()}
        </Stack.Item>
        <Stack.Item>
          System
          <LabeledList>
            <LabeledList.Item label="Maintenance Lock">Test</LabeledList.Item>
            <LabeledList.Item label="ID Upload Lock">Test</LabeledList.Item>
            <LabeledList.Item label="Change External Label">Test</LabeledList.Item>
            {props.renderAdditionalSettingSectionLabeledListItems?.[VehicleControllerBuiltinSettingSections.System]?.()}
          </LabeledList>
          {props.renderAdditionalSettingSectionStackItems?.[VehicleControllerBuiltinSettingSections.System]?.()}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
