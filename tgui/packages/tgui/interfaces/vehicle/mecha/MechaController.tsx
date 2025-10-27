/**
 * @file
 * @license MIT
 */

import { LabeledList, Stack } from "tgui-core/components";

import { useBackend } from "../../../backend";
import { withVehicleComponentData } from "../helpers";
import { VehicleComponentData } from "../types";
import { VehicleController, VehicleControllerBuiltinSettingSections } from "../VehicleController";
import { MechaData } from "./types";

export const MechaController = (props) => {
  const { act, data } = useBackend<MechaData>();

  let mechaOptions = {};
  mechaOptions[VehicleControllerBuiltinSettingSections.Options] = () => (
    <>
      <LabeledList.Item label="Strafing">Test</LabeledList.Item>
      <LabeledList.Item label="Floodlights">Test</LabeledList.Item>
    </>
  );

  return (
    <VehicleController renderStackItemsBelowIntegrityHomeDisplay={(
      <>
        {withVehicleComponentData<VehicleComponentData>(data.mCompHullRef, (d) => (
          <FrontPageComponentHealthRender name="Hull" data={d} />
        ))}
        {withVehicleComponentData<VehicleComponentData>(data.mCompArmorRef, (d) => (
          <FrontPageComponentHealthRender name="Armor" data={d} />
        ))}
      </>
    )} renderAdditionalSettingSectionLabeledListItems={mechaOptions}
      renderAdditionalSettingRootStackItems={
        <>
          <Stack.Item>
            Radio
            <LabeledList>
              <LabeledList.Item label="Frequency">Test</LabeledList.Item>
              <LabeledList.Item label="Transmit">Test</LabeledList.Item>
              <LabeledList.Item label="Receive">Test</LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item>
            Life Support
            <LabeledList>
              <LabeledList.Item label="Airflow">Test</LabeledList.Item>
              <LabeledList.Item label="Port Connection">Test</LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item>
            System
            <LabeledList>
              <LabeledList.Item label="Maintenance Lock">Test</LabeledList.Item>
              <LabeledList.Item label="ID Upload Lock">Test</LabeledList.Item>
              <LabeledList.Item label="Change External Label">Test</LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </>
      } />
  );
};

const FrontPageComponentHealthRender = (props: {
  name: string;
  data: VehicleComponentData | null;
}) => {
  if (props.data === null || !props.data.integrityUsed) {
    return null;
  }
  if (!props.data) {
    return (
      <Stack.Item>
        Test
      </Stack.Item>
    );
  }
  return (
    <Stack.Item>
      <Stack fill>
        <Stack.Item>
          {props.name} Integrity
        </Stack.Item>
        <Stack.Item grow={1}>
          Test
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};
