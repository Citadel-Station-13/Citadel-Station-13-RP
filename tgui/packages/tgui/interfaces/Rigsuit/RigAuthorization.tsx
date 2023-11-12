import { RigsuitData } from ".";
import { Section } from "../../components";

export interface RigAuthorizationProps {
  rig: RigsuitData;
}

export const RigAuthorization = (props: RigAuthorizationProps, context) => {
  return (
    <Section fill>
      Test
    </Section>
  );
};
