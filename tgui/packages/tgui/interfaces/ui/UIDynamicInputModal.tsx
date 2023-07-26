
interface UIDynamicInputContext {
  query: UIDynamicInputEntry[];
}

interface UIDynamicInputEntry {
  key: string;
  name: string;
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
type ListConstraint = string[];
type ToggleConstraint = [] | undefined;

export const UIDynamicInputModal = (props, context) => {

};

interface DynamicEntryProps {
  entry: UIDynamicInputEntry;
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


