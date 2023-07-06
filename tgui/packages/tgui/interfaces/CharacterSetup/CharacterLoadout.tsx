import { Section, SectionProps } from "../../components/Section";
import { ByondColorMatrixRGBC } from "../common/Color";

export type LoadoutId = string;

export interface LoadoutData {
  selected: Record<LoadoutId, LoadoutSelected>;
  selectAct: (id: string) => void;
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
  reName: string | null;
  reDesc: string | null;
  reColor: string | null | ByondColorMatrixRGBC;
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
