import { useBackend } from '../backend';
import { Input, Section, Stack } from '../components';
import { NtosWindow } from '../layouts';

export const NtosNotepad = (props, context) => {
  const { act, data } = useBackend(context);
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
