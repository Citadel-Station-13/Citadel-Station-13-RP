import { Box, Button, NoticeBox } from 'tgui-core/components';

import { useBackend } from '../../backend';

/**
 * Displays a notice box showing the
 * `authenticated` and `rank` data fields if they exist.
 *
 * Also gives an option to log off (calls `logout` TGUI action)
 * @param {object} _properties
 * @param {object} context
 */
export const LoginInfo = (_properties) => {
  const { act, data } = useBackend<any>();
  const {
    authenticated,
    rank,
  } = data;
  if (!data) {
    return;
  }
  return (
    <NoticeBox info>
      <Box style={{ display: "inline-block" }} verticalAlign="middle">
        Logged in as: {authenticated} ({rank})
      </Box>
      <Button
        icon="sign-out-alt"
        content="Logout and Eject ID"
        color="good"
        style={{ float: "right" }}
        onClick={() => act('logout')}
      />
      <Box style={{ clear: "both" }} />
    </NoticeBox>
  );
};
