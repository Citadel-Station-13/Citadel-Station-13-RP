import { Box, Button, NoticeBox } from "tgui-core/components";
import { decodeHtmlEntities } from 'tgui-core/string';

import { useBackend } from "../../backend";

/**
 * Displays a notice box with text and style dictated by the
 * `temp` data field if it exists.
 *
 * A valid `temp` object contains:
 *
 * - `style` — The style of the NoticeBox
 * - `text` — The text to display
 *
 * Allows clearing the notice through the `cleartemp` TGUI act
 * @param {object} _properties
 * @param {object} context
 */
export const TemporaryNotice = (_properties) => {
  const {
    decode,
  } = _properties;
  const { act, data } = useBackend<any>();
  const { temp } = data;
  if (!temp) {
    return;
  }
  const temporaryProperty = { [temp.style]: true };
  return (
    <NoticeBox {...temporaryProperty}>
      <Box style={{ display: "inline-block" }} verticalAlign="middle">
        {decode ? decodeHtmlEntities(temp.text) : temp.text}
      </Box>
      <Button
        icon="times-circle"
        style={{ float: "right" }}
        onClick={() => act('cleartemp')} />
      <Box style={{ clear: "both" }} />
    </NoticeBox>
  );
};
