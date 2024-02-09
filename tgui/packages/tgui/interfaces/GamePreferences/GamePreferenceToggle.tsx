import { BooleanLike } from "common/react";

interface GamePreferenceToggleProps {
  schema: GamePreferenceToggleSchema;
  enabled: BooleanLike;
  onToggle: (state?: BooleanLike) => void;
}

export interface GamePreferenceToggleSchema {

}

export const GamePreferenceToggle = (props: GamePreferenceToggleProps, context) => {

};
