import { InfernoNode } from "inferno";
import { Section } from "../../components";
import { RigModuleInert } from "./components/RigModuleInert";
import { RigModuleDynamic } from "./components/RigModuleDynamic";

export const routeRigsuitComponent = (interfaceKey): InfernoNode => {
  switch (interfaceKey) {
    case 'base':
      return RigModuleInert;
    case 'dynamic':
      return RigModuleDynamic;
    default:
      return RigModuleNotFound;
  }
};

const RigModuleNotFound = (props, context) => {
  return (
    <Section>
      Failed to route component. Please contact a coder!
    </Section>
  );
};
