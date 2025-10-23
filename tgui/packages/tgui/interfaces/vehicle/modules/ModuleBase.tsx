/**
 * @file
 * @license MIT
 */

import { PropsWithChildren, ReactNode, useState } from "react";
import { Button, Dimmer, Section } from "tgui-core/components";

import { VehicleModuleData } from "../types";

interface ModuleBaseProps {
  data: VehicleModuleData;
}

export const ModuleBase = (props: PropsWithChildren<ModuleBaseProps>) => {
  const [ejectModal, setEjectModal] = useState<ReactNode | null>(null);
  return (
    <>
      {ejectModal}
      <Section title={props.data.name} fill buttons={(
        <>
          <Button.Confirm confirmContent={null} confirmIcon="eject" icon="eject"
            onClick={() => setEjectModal((
              <Dimmer>
                Test
              </Dimmer>
            ))} />
          <Button icon="question" tooltip={props.data.desc} />
        </>
      )}>
        {props.children}
      </Section>
    </>
  );
};
