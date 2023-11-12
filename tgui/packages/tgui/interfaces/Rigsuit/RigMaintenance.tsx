import { RigsuitData } from ".";
import { Section } from "../../components";

export interface RigMaintenanceProps {
  rig: RigsuitData;
}

export const RigMaintenance = (props: RigMaintenanceProps, context) => {
  return (
    <Section fill>
      Test
    </Section>
  );
};
