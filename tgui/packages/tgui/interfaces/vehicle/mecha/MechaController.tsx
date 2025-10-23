/**
 * @file
 * @license MIT
 */

import { Stack } from "tgui-core/components";

import { useBackend } from "../../../backend";
import { useVehicleComponent } from "../helpers";
import { VehicleComponentData } from "../types";
import { VehicleController } from "../VehicleController";
import { MechaData } from "./types";

export const MechaController = (props) => {
  const { act, data } = useBackend<MechaData>();

  return (
    <VehicleController renderStackItemsBelowIntegrityHomeDisplay={(
      <>
        {useVehicleComponent<VehicleComponentData>(data.mCompHullRef, (d) => (
          <FrontPageComponentHealthRender name="Hull" data={d} />
        ))}
        {useVehicleComponent<VehicleComponentData>(data.mCompArmorRef, (d) => (
          <FrontPageComponentHealthRender name="Armor" data={d} />
        ))}
      </>
    )} />
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
