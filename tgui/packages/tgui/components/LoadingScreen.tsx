/**
 * @file
 * @license MIT
 */

import { Dimmer } from "./Dimmer";

export const LoadingScreen = (props: {}, context) => {
  return (
    <Dimmer width="100%" height="100%">
      {/* TODO: actually good icon */}
      Loading...
    </Dimmer>
  );
};
