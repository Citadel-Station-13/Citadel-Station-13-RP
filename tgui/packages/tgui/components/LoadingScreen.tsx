/**
 * @file
 * @license MIT
 */

import { Dimmer } from "./Dimmer";
import { Stack } from "./Stack";

export const LoadingScreen = (props: {}, context) => {
  return (
    <Dimmer width="100%" height="100%">
      {/* TODO: actually good icon */}
      <Stack fill>
        <Stack.Item grow={1} />
        <Stack.Item>
        <h1 style={{ "text-align": "center" }}>
        Loading...
        </h1>
        </Stack.Item>
        <Stack.Item grow={1} />
      </Stack>
    </Dimmer>
  );
};
