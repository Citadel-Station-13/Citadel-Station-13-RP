/**
 * @file
 * @license MIT
 */

import { Stack } from "../../../../components";
import { Window } from "../../../../layouts";

export const EldritchBook = (props, context) => {
  return (
    <Window width={800} height={800}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            test
          </Stack.Item>
          <Stack.Item grow={1}>
            test
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
