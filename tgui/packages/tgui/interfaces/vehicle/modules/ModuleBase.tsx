/**
 * @file
 * @license MIT
 */

import { PropsWithChildren, ReactNode, useState } from "react";
import { Button, Dimmer, Section } from "tgui-core/components";

import { useVehicleModule } from "../helpers";
import { VehicleModuleData } from "../types";


interface ModuleBaseProps { }

export const ModuleBase = (props: PropsWithChildren<ModuleBaseProps>) => {
  const { act, data } = useVehicleModule<VehicleModuleData>();
  const [ejectModal, setEjectModal] = useState<ReactNode | null>(null);
  return (
    <>
      {ejectModal}
      <Section title={data.name} fill buttons={(
        <>
          <Button.Confirm confirmContent={null} confirmIcon="eject" icon="eject"
            onClick={() => setEjectModal((
              <Dimmer>
                Test
              </Dimmer>
            ))} />
          <Button icon="question" tooltip={data.desc} />
        </>
      )}>
        {props.children}
      </Section>
    </>
  );
};
