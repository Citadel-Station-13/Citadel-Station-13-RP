import { RigsuitData } from ".";
import { NoticeBox, Section } from "../../components";

export interface RigMaintenanceProps {
  rig: RigsuitData;
}

export const RigMaintenance = (props: RigMaintenanceProps, context) => {
  return (
    <Section fill>
      <NoticeBox warning>This section is under construction.</NoticeBox>
    </Section>
  );
};
