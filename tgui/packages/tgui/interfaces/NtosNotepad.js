import { NtosWindow } from '../layouts';
import { useBackend } from '../backend';
import { Stack, Input, Section } from 'tgui-core/components';

export const NtosNotepad = (props) => {
  const { act, data } = useBackend<any>();
  const {
    note,
  } = data;
  return (
    <NtosWindow width={600} height={800}>
      <NtosWindow.Content>
        <Stack fill vertical direction="column" justify="space-between">
          <Stack.Item>
            <Stack grow>
              <Section>
                {note}
              </Section>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Section fill>
              <Input
                value={note}
                fluid
                onEnter={(e, value) => act('UpdateNote', {
                  newnote: value,
                })}
              />
            </Section>
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
