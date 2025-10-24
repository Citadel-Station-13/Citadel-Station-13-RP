/**
 * @file
 * @license MIT
 */

import { PropsWithChildren, ReactNode, useState } from "react";
import { Button, Dimmer, Section } from "tgui-core/components";

import { useVehicleComponent } from "../helpers";
import { VehicleComponentData } from "../types";

interface ComponentBaseProps { }

export const ComponentBase = (props: PropsWithChildren<ComponentBaseProps>) => {
  const { act, data } = useVehicleComponent<VehicleComponentData>();
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
