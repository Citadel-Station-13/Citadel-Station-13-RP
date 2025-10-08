/**
 * @file
 * @license MIT
*/

import { bitfieldToPositions } from "common/math";
import { Box, Button, Collapsible, LabeledList, Section } from "tgui-core/components";
import { round } from "tgui-core/math";

import { SectionProps } from "../../components";

//* Context

export type AtmosGasID = string;
export type AtmosGasIDs = AtmosGasID[];

export enum AtmosGasGroupFlags {
  None = (0),
  Core = (1 << 0),
  Other = (1 << 1),
  Unknown = (1 << 2),
  Reagents = (1 << 3),
}
export type AtmosGasGroups = AtmosGasGroupFlags;

export const AtmosGroupFlagNames = [
  "Core",
  "Other",
  "Unknown",
  "Reagents",
];

export const ATMOS_GROUP_COUNT = 4;

export enum AtmosGasFlags {
  None = (0),
  Fuel = (1 << 0),
  Oxidizer = (1 << 1),
  Contaminent = (1 << 2),
  FusionFuel = (1 << 3),
  Unknown = (1 << 4),
  Core = (1 << 5),
  Filterable = (1 << 6),
  Dangerous = (1 << 7),
}

interface BaseGasContext {
  coreGases: AtmosGasID[];
  groupNames: string[];
  filterableGases: AtmosGasID[];
  filterableGroups: AtmosGasGroups;
}

export interface GasContext extends BaseGasContext {
  gases: Record<AtmosGasID, AtmosGas>;
}

export interface FullGasContext extends BaseGasContext {
  gases: Record<AtmosGasID, FullAtmosGas>;
}

export interface AtmosGas {
  id: AtmosGasID;
  name: string;
  flags: AtmosGasFlags;
  groups: AtmosGasGroups;
  specificHeat: number;
  molarMass: number;
}

export interface FullAtmosGas extends AtmosGas {

}

//* Analyzer

export interface AtmosAnalyzerResults {
  // kpa
  pressure: number;
  // in Kelvin
  temperature: number;
  // id to mols
  gases: Record<string, number>;
  // id to g/mol
  masses: Record<string, number>;
  // id to name
  names: Record<string, number>;
  // total moles
  moles: number;
}

interface AtmosAnalysisProps extends SectionProps {
  readonly results: AtmosAnalyzerResults;
}

export const AtmosAnalysis = (props: AtmosAnalysisProps) => {
  const temperatureRounded = round(props.results.temperature, 2);
  return (
    <Section {...props}>
      <LabeledList>
        <LabeledList.Item label="Pressure">
          {round(props.results.pressure, 2)} kPa
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          {temperatureRounded}°K ({temperatureRounded - 273.15}°C)
        </LabeledList.Item>
        {
          Object.entries(props.results.gases).map(([k, v]) => {
            const percent = v / props.results.moles;
            return (
              <LabeledList.Item key={k}
                label={props.results.names[k] || k}>
                {round(percent, 2)}%
              </LabeledList.Item>
            );
          })
        }
      </LabeledList>
    </Section>
  );
};

//* Filtering

interface AtmosFilterListProps extends SectionProps {
  readonly gasContext: GasContext;
  readonly selectedGroups: AtmosGasGroups;
  readonly selectedIds: AtmosGasIDs;
  readonly selectGroup?: (group: AtmosGasGroupFlags, filter: boolean) => void;
  readonly selectId?: (id: AtmosGasID, filter: boolean) => void;
}

export const AtmosFilterList = (props: AtmosFilterListProps) => {
  return (
    <Section {...props}>
      <Collapsible
        buttons={(
          <>
            <div style={{ display: "inline", color: "#7e90a7", "marginLeft": "-0.235em", "paddingRight": "1.225em" }}>Gases: </div>
            {props.gasContext.coreGases.map((id) => (
              <Button.Checkbox
                key={id}
                content={props.gasContext.gases[id].name}
                selected={props.selectedIds.includes(id)}
                onClick={() => props.selectId?.(id, !props.selectedIds.includes(id))} />
            ))}
          </>
        )} color="transparent">
        {props.gasContext.filterableGases.filter((id) => !props.gasContext.coreGases.includes(id)).map(
          (id) => props.gasContext.gases[id]
        ).sort(
          (a, b) => a.name.localeCompare(b.name)
        ).map((gas) => (
          <Button.Checkbox
            key={gas.id}
            content={gas.name}
            selected={props.selectedIds.includes(gas.id)}
            onClick={() => props.selectId?.(gas.id, !props.selectedIds.includes(gas.id))} />
        ))}
      </Collapsible>
      <LabeledList>
        <LabeledList.Item label="Groups">
          {bitfieldToPositions(props.gasContext.filterableGroups, ATMOS_GROUP_COUNT).map((pos) => (
            <Button.Checkbox
              key={pos}
              content={AtmosGroupFlagNames[pos]}
              selected={props.selectedGroups & (1 << pos)}
              onClick={() => props.selectGroup?.(1 << pos, !(props.selectedGroups & (1 << pos)))} />
          ))}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

//* Tanks

export interface AtmosTank {
  name: string;
  // kpa
  pressure: number;
  // gauge limit, not actual cap/limit
  pressureLimit: number;
  // liters
  volume: number;
}

interface AtmosTankSlotProps extends SectionProps {
  readonly ejectAct?: () => void;
  readonly canEject?: boolean;
  readonly tank: AtmosTank | null;
}

export const AtmosTankSlot = (props: AtmosTankSlotProps) => {
  return (
    <Section title="Tank" {...props}
      buttons={
        <Button content="Eject" disabled={!props.tank}
          icon="eject"
          onClick={() => props.ejectAct?.()} />
      }>
      {props.tank ? (
        <LabeledList>
          <LabeledList.Item label="Label">
            {props.tank.name}
          </LabeledList.Item>
          <LabeledList.Item label="Pressure">
            {props.tank.pressure} kPa
          </LabeledList.Item>
        </LabeledList>
      ) : (
        <Box textColor="average">
          No holding tank
        </Box>
      )}
    </Section>
  );
};
