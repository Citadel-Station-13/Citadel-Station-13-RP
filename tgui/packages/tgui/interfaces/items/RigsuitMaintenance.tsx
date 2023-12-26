/**
 * @file
 * @license MIT
 */

import { NoticeBox, Section } from "../../components";
import { RigsuitData } from "./Rigsuit";

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
