import { useBackend } from "../backend";
import { Box, Icon, Stack, Button, Section, NoticeBox, LabeledList, Collapsible } from "../components";
import { Window } from "../layouts";

export const Vote = (props, context) => {
  const { data } = useBackend(context);
  const { mode, question, admin } = data;

  // Adds the voting type to title if there is an ongoing vote
  let windowTitle = "Vote";
  if (mode) {
    windowTitle += ": " + (question || mode);
  }

  return (
    <Window title={windowTitle} width={400} height={500}>
      <Window.Content>
        <Stack fill vertical>
          {!!admin && (
            <Section title="Admin Options">
              <StartVoteOptions />
            </Section>
          )}
          <ChoicesPanel />
          <TimePanel />
        </Stack>
      </Window.Content>
    </Window>
  );
};

const StartVoteOptions = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    vote_happening,
  } = data;
  return (
    <Stack.Item>
      <Collapsible title="Start a vote">
        <Stack justify="space-between">
          <Stack.Item>
            <Stack vertical>
              <Stack.Item>
                <Button
                  disabled={vote_happening}
                  onClick={() => act("transfer")}>
                  Start Transfer Vote
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  disabled={vote_happening}
                  onClick={() => act("restart")}>
                  Restart
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  disabled={vote_happening}
                  onClick={() => act("custom")}>
                  Custom Vote
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Collapsible>
    </Stack.Item>
  );
};

// Display choices
const ChoicesPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { choices, selected_choice } = data;

  return (
    <Stack.Item grow>
      <Section fill scrollable title="Choices" >
        {choices.length !== 0 ? (
          <LabeledList>
            {choices.map((choice, i) => (
              <Box key={choice.id}>
                <LabeledList.Item
                  label={choice.name}
                  textAlign="right"
                  buttons={
                    <Button
                      color={((selected_choice.name !== choice.name) ? "green" : "grey")}
                      disabled={choice.name === selected_choice}
                      onClick={() => {
                        act("vote", { index: i + 1 });
                      }}>
                      Vote
                    </Button>
                  }>
                  {(selected_choice === choice.name) && (
                    <Icon
                      alignSelf="right"
                      mr={2}
                      color="green"
                      name="vote-yea" />
                  )}
                  {choice.votes} Votes
                </LabeledList.Item>
                <LabeledList.Divider />
              </Box>
            ))}
            <Button
              color={"green"}
              disabled={!selected_choice}
              onClick={() => {
                act("unvote");
            }}>
                Unvote
            </Button>
          </LabeledList>
        ) : (
          <NoticeBox>No choices available!</NoticeBox>
        )}
      </Section>
    </Stack.Item>
  );
};

// Countdown timer at the bottom. Includes a cancel vote option for admins
const TimePanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { upper_admin, time_remaining } = data;

  return (
    <Stack.Item mt={1}>
      <Section>
        <Stack justify="space-between">
          <Box fontSize={1.5}>
            Time Remaining: {time_remaining || 0}s
          </Box>
          {!!upper_admin && (
            <Button color="red" onClick={() => act('cancel')}>
              Cancel Vote
            </Button>
          )}
        </Stack>
      </Section>
    </Stack.Item>
  );
};
