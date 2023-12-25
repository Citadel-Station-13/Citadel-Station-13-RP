import { RigsuitData } from ".";
import { NoticeBox, Section } from "../../components";

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
