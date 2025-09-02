import { Fragment } from 'react';
import { useBackend } from "../../backend";
import { Box, Button, NoticeBox } from 'tgui-core/components';

export const MiningUser = (props) => {
  const { act, data } = useBackend<any>();
  const {
    insertIdText,
  } = props;
  const {
    has_id,
    id,
  } = data;
  return (
    <NoticeBox success={has_id}>
      {has_id ? (
        <Fragment>
          <Box
            verticalAlign="middle"
            style={{
              display: "inline-block",
              float: 'left',
            }}>
            Logged in as {id.name}.<br />
            You have {id.points.toLocaleString('en-US')} points.
          </Box>
          <Button
            icon="eject"
            content="Eject ID"
            style={{
              float: 'right',
            }}
            onClick={() => act('logoff')}
          />
          <Box
            style={{
              clear: "both",
            }}
          />
        </Fragment>
      ) : insertIdText}
    </NoticeBox>
  );
};
