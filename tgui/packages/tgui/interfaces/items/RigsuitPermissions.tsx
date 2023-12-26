/**
 * @file
 * @license MIT
 */

import { NoticeBox, Section } from "../../components";
import { RigsuitData } from "./Rigsuit";

export interface RigAuthorizationProps {
  rig: RigsuitData;
}

export const RigAuthorization = (props: RigAuthorizationProps, context) => {
  return (
    <Section fill>
      <NoticeBox warning>This section is under construction.</NoticeBox>
    </Section>
  );
};
