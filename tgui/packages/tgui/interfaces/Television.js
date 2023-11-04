import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Television = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    channels
  } = data;
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Channels">
			<LabeledList>
				<LabeledList.Item label="Current Channel">
				{channel}
				</LabeledList.Item>
				<LabeledList.Item label="Previous Channel">
				<Button
					content="Previous Channel"
					onClick={() => act('previous_channel')} />
				</LabeledList.Item>
				<LabeledList.Item label="Next Channel">
				<Button
					content="Next Channel"
					onClick={() => act('next_channel')} />
				</LabeledList.Item>
			</LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
