import { SectionProps } from "../../components/Section";
import { AtmosGasGroups, AtmosGasID, GasContext } from "../common/Atmos";

interface AtmosFilterControlProps extends SectionProps {
  atmosContext: GasContext;
  filteredGases: AtmosGasID[];
  filteredGroups: AtmosGasGroups;

}

/**
 * Can be used for more than filter controls; use the onXYZ() props to customize what it does.
 */
export const AtmosFilterControl = (props: AtmosFilterControlProps, context) => {

}
