import { useBackend } from '../backend';
import { NoticeBox, Section } from 'tgui-core/components';
import { Window } from '../layouts';

export const Terminal = (_, context) => {
  const { act, data } = useBackend<any>();
  const { uppertext, messages } = data;
  return (
    <Window theme={data.tguitheme} title="Terminal" width={480} height={520}>
      <Window.Content scrollable>
        <NoticeBox textAlign="left">
          {uppertext}
        </NoticeBox>
        <Messages messages={messages} />
      </Window.Content>
    </Window>
  );
};

const Messages = (props) => {
  const { messages } = props;
  const { act } = useBackend<any>();
  return messages.map(message => {
    return (
      <Section key={message.key}>
        {message}
      </Section>
    );
  });
};
