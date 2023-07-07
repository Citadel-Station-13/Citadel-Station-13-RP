import { Section, SectionProps } from "../../components/Section";
import { ByondColorMatrixRGBC } from "../common/Color";

export type LoadoutId = string;

export interface LoadoutData {
  slots?: PartialLoadoutSlot[];
  slotAct?: (index: number) => void;
  slot: FullLoadoutSlot;
  slotRenameAct?:
  /// toggle
  toggleAct?: (id: string) => void;
}

export interface LoadoutContext {
  instances: Record<LoadoutId, LoadoutEntry>;
  categories: string[];
}

export interface LoadoutEntry {
  id: LoadoutId;
  name: string;
  cost: number;
  category: string;
  desc: string;
  customize: LoadoutCustomizations;
}

export interface LoadoutSelected {
  rename: string | null;
  redesc: string | null;
  recolor: string | null | ByondColorMatrixRGBC;
  tweaks: Record<string, any>;
}

export interface FullLoadoutSlot extends PartialLoadoutSlot {
  entries: Record<LoadoutId, LoadoutSelected>;
}

export interface PartialLoadoutSlot {
  name: string;
}

export enum LoadoutCustomizations {
  None = 0,
  Rename = (1<<0),
  Redesc = (1<<1),
  Color = (1<<3),
}

interface LoadoutProps extends SectionProps {
  gearContext: LoadoutContext;
  gearData: LoadoutData;
}

export const CharacterLoadout = (props: LoadoutProps) => {
  return (
    <Section {...props}>
      Unimplemented
    </Section>
  );
};
