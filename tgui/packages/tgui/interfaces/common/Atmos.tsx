/**
 * @file
 * @license MIT
*/

import { bitfieldToPositions } from "common/math";
import { Button, LabeledList, Section } from "../../components";
import { SectionProps } from "../../components/Section";

//* Context

export type AtmosGasID = string;
export type AtmosGasIDs = AtmosGasID[];

export enum AtmosGasGroupFlags {
  None = (0),
  Core = (1<<0),
  Other = (1<<1),
  Unknown = (1<<2),
  Reagents = (1<<3),
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
  Fuel = (1<<0),
  Oxidizer = (1<<1),
  Contaminent = (1<<2),
  FusionFuel = (1<<3),
  Unknown = (1<<4),
  Core = (1<<5),
  Filterable = (1<<6),
  Dangerous = (1<<7),
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
  pressure: number;
  temperature: number;
  gases: Record<string, number>;
  masses: Record<string, number>;
  names: Record<string, number>;
  moles: number;
}

interface AtmosAnalysisProps extends SectionProps {
  results: AtmosAnalyzerResults;
}

export const AtmosAnalysis = (props: AtmosAnalysisProps) => {
  return (
    <Section {...props}>
      Unimplemented
    </Section>
  );
};

//* Filtering

interface AtmosFilterListProps extends SectionProps {
  gasContext: GasContext;
  selectedGroups: AtmosGasGroups;
  selectedIds: AtmosGasIDs;
  selectGroup?: (group: AtmosGasGroupFlags, filter: boolean) => void;
  selectId?: (id: AtmosGasID, filter: boolean) => void;
}

export const AtmosFilterList = (props: AtmosFilterListProps) => {
  return (
    <Section {...props}>
      <LabeledList>
        <LabeledList.Item label="Gases">
          {props.gasContext.filterableGases.map((id) => (
            <Button.Checkbox
              key={id}
              selected={props.selectedIds.includes(id)}
              onClick={() => props.selectId?.(id, !props.selectedIds.includes(id))} />
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Groups">
          {bitfieldToPositions(props.gasContext.filterableGroups, ATMOS_GROUP_COUNT).map((pos) => (
            <Button.Checkbox
              key={pos}
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
  ejectAct?: () => void;
  canEject?: boolean;
  tank: AtmosTank | null;
}

export const AtmosTankSlot = (props: AtmosTankSlotProps, context) => {
  return (
    <Section title="Tank" {...props}>
      test
    </Section>
  );
};
