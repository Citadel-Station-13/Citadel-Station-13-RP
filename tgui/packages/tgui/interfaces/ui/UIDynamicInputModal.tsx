
interface UIDynamicInputContext {
  title: string;
  message: string;
  timeout: number;
  // key to entry data
  query: Record<string, UIDynamicInputEntry>;
}

interface UIDynamicInputEntry {
  name: string;
  desc: string;
}

interface StringEntry extends UIDynamicInputEntry {
  type: UIDynamicInputType.String;
  constraints: StringConstraint;
}

interface NumberEntry extends UIDynamicInputEntry {
  type: UIDynamicInputType.Number;
  constraints: NumberConstraint;
}

interface PickEntry extends UIDynamicInputEntry {
  type: UIDynamicInputType.ListSingle;
  constraints: NumberConstraint;
}

interface ToggleEntry extends UIDynamicInputEntry {
  type: UIDynamicInputType.Toggle;
  constraints: NumberConstraint;
}

enum UIDynamicInputType {
  String = "text",
  Number = "num",
  ListSingle = "list_single",
  Toggle = "bool",
}

type UIDynamicInputConstraint = StringConstraint | NumberConstraint | ListConstraint | ToggleConstraint;

type StringConstraint = [number] | undefined;
type NumberConstraint = [number, number, number] | undefined;
type ListConstraint = string[] | undefined;
type ToggleConstraint = [] | undefined;

export const UIDynamicInputModal = (props, context) => {

};

interface DynamicEntryProps {
  entry: UIDynamicInputEntry;
  id: string;
}

const DynamicEntry = (props: DynamicEntryProps, context) => {

};

const DynamicEntryNumber = (props, context) => {

};

const DynamicEntryString = (props, context) => {

};

const DynamicEntryPick = (props, context) => {

};

const DynamicEntryToggle = (props, context) => {

};


