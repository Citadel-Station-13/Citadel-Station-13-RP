import { BooleanLike } from "../../common/react";
import { useBackend } from "../backend";
import {
  Box,
  Icon,
  Stack,
  Button,
  Section,
  NoticeBox,
  LabeledList,
  Collapsible,
} from "../components";
import { Window } from "../layouts";

interface VoteContext {
  admin : BooleanLike;
  selected_choice : string;
  vote_happening : BooleanLike;
  choices : VoteChoice[];
  question: string;
  time_remaining : number;
}

interface VoteChoice {
  name : string;
  votes : number;
}

export const Vote = (props, context) => {
  const { act, data } = useBackend<VoteContext>(context);
  const { admin, selected_choice } = data;

  // Adds the voting type to title if there is an ongoing vote
  let windowTitle = "Vote";

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
          <Button
            color={"green"}
            disabled={!selected_choice}
            onClick={() => {
              act("unvote");
            }}
          >
            Unvote
          </Button>
          <TimePanel />
        </Stack>
      </Window.Content>
    </Window>
  );
};

const StartVoteOptions = (props, context) => {
  const { act, data } = useBackend<VoteContext>(context);
  const { vote_happening } = data;
  return (
    <Stack.Item>
      <Collapsible title="Start a vote">
        <Stack justify="space-between">
          <Stack.Item>
            <Stack vertical>
              <Stack.Item>
                <Button
                  disabled={vote_happening}
                  onClick={() => act("transfer")}
                >
                  Start Transfer Vote
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  disabled={vote_happening}
                  onClick={() => act("restart")}
                >
                  Restart
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button disabled={vote_happening} onClick={() => act("custom")}>
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
  const { act, data } = useBackend<VoteContext>(context);
  const { choices, selected_choice, question } = data;

  return (
    <Stack.Item grow>
      <Section fill scrollable title={question}>
        {choices.length !== 0 ? (
          <LabeledList>
            {choices.map((choice, i) => (
              <Box key={i}>
                <LabeledList.Item
                  label={choice.name}
                  textAlign="right"
                  buttons={
                    <Button
                      color={
                        selected_choice !== choice.name ? "green" : "grey"
                      }
                      disabled={choice.name === selected_choice}
                      onClick={() => {
                        act("vote", { index: i + 1 });
                      }}
                    >
                      Vote
                    </Button>
                  }
                >
                  {selected_choice === choice.name && (
                    <Icon
                      alignSelf="right"
                      mr={2}
                      color="green"
                      name="vote-yea"
                    />
                  )}
                  {choice.votes} Votes
                </LabeledList.Item>
                <LabeledList.Divider />
              </Box>
            ))}
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
  const { act, data } = useBackend<VoteContext>(context);
  const { admin, time_remaining, vote_happening } = data;

  return (
    <Stack.Item mt={1}>
      <Section>
        <Stack justify="space-between">
          <Box fontSize={1.5}>Time Remaining: {time_remaining || 0}s</Box>
          {!!admin && (
            <Button color="red" onClick={() => act("cancel")} disabled={!vote_happening}>
              Cancel Vote
            </Button>
          )}
        </Stack>
      </Section>
    </Stack.Item>
  );
};
