import { RigsuitData } from ".";
import { Section } from "../../components";

export interface RigControllerProps {
  rig: RigsuitData;
}

export const RigController = (props: RigControllerProps, context) => {
  return (
    <Section fill>
      Test
    </Section>
  );
};
