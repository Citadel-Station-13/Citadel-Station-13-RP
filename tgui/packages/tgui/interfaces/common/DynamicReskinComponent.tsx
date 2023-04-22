import { BooleanLike } from "../../../common/react";
import { Window } from "../../layouts";

interface DynamicReskinComponentData {
  mapRef: string;
  currentStyle: string;
  styles: string[];
  canColor: BooleanLike;
}

export const DynamicReskinComponent = (props, context) => {
  return (
    <Window>
      test
    </Window>
  );
};
