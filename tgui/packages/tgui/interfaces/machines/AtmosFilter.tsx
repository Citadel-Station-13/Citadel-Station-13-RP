import { useBackend } from "../../backend";
import { Section, SectionProps } from "../../components/Section";
import { AtmosGasGroups, AtmosGasID, GasContext } from "../common/Atmos";
import { AtmosComponent, AtmosComponentData } from "../common/AtmosMachine";

interface AtmosFilterControlProps extends SectionProps {
  atmosContext: GasContext;
  filtering: null | AtmosGasGroups | AtmosGasID;
  setFiltering: (target: AtmosGasGroups|AtmosGasID) => void;
}

export const AtmosFilterControl = (props: AtmosFilterControlProps, context) => {
  return (
    <Section>
      test
    </Section>
  );
};

interface AtmosFilterData extends AtmosComponentData {
  atmosContext: GasContext;
  filtering: null | AtmosGasGroups | AtmosGasID;
}

export const AtmosFilter = (props, context) => {
  const { act, data } = useBackend<AtmosFilterData>(context);

  return (
    <AtmosComponent>
      <AtmosFilterControl
        setFiltering={(target) => act('filter', { target: target })}
        atmosContext={data.atmosContext}
        filtering={data.filtering} />
    </AtmosComponent>
  );
};
