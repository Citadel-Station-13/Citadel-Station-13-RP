/**
 * @file
 * @license MIT
 */
import { BooleanLike } from "common/react";

interface GamePreferenceToggleProps {
  schema: GamePreferenceToggleSchema;
  enabled: BooleanLike;
  onToggle: (state?: BooleanLike) => void;
}

export interface GamePreferenceToggleSchema {
  name: string;
  desc: string;
  enabled: string;
  disabled: string;
  key: string;
  category: string;
  priority: number;
  default: BooleanLike;
}

export const GamePreferenceToggle = (props: GamePreferenceToggleProps, context) => {

};
