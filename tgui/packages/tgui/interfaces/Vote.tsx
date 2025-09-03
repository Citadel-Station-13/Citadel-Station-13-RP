import {
  Box,
  Button,
  Collapsible,
  Icon,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
} from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { useBackend } from "../backend";
import { Window } from "../layouts";

interface VoteContext {
  admin: BooleanLike;
  selected_choice: string;
  vote_happening: BooleanLike;
  choices: VoteChoice[];
  question: string;
  time_remaining: number;
  secret: BooleanLike;
  ghost: BooleanLike;
  ghost_weight: number;
}

interface VoteChoice {
  name: string;
  votes: number;
}

export const Vote = (props) => {
  const { act, data } = useBackend<VoteContext>();
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
              <VoteConfig />
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

const StartVoteOptions = (props) => {
  const { act, data } = useBackend<VoteContext>();
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
                <Button
                  disabled={vote_happening}
                  onClick={() => act("custom")}
                >
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

const VoteConfig = (props) => {
  const { act, data } = useBackend<VoteContext>();
  const { ghost_weight, secret } = data;
  return (
    <Stack.Item>
      <Collapsible title="Vote settings">
        <Stack justify="space-between">
          <Stack.Item>
            <Stack vertical>
              <Stack.Item>
                Ghost weight:
                <NumberInput
                  unit={'%'}
                  step={1}
                  value={ghost_weight}
                  minValue={-1}
                  maxValue={100}
                  onChange={(value) => act('ghost_weight', { ghost_weight: value })}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  color={secret ? "green" : "red"}
                  onClick={() => act("hide")}
                  icon={secret ? 'lock' : 'unlock'}
                >
                  {secret ? 'Show' : 'Hide'} Votes
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
const ChoicesPanel = (props) => {
  const { act, data } = useBackend<VoteContext>();
  const { ghost_weight, ghost, admin, choices, selected_choice, question, secret } = data;

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
                      disabled={choice.name === selected_choice || (ghost_weight === 0 && ghost)}
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
                      style={{ alignSelf: "right" }}
                      mr={2}
                      color="green"
                      name="vote-yea"
                    />
                  )}
                  {(!admin && secret) ? "?" : choice.votes} Votes
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
const TimePanel = (props) => {
  const { act, data } = useBackend<VoteContext>();
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
