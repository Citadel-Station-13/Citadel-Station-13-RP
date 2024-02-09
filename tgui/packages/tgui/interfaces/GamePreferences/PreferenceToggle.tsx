import { BooleanLike } from "common/react";

interface PreferenceToggleProps {
  schema: PreferenceToggleSchema;
  enabled: BooleanLike;
  onToggle: (state?: BooleanLike) => void;
}

export interface PreferenceToggleSchema {

}

export const PreferenceToggle = (props: PreferenceToggleProps, context) => {

};
