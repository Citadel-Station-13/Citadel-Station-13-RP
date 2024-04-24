import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, LabeledList, Section, NoticeBox } from "../components";
import { Window } from "../layouts";
import { RankIcon } from "./common/RankIcon";

export const TimeClock = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    user_name,
    card,
    assignment,
    job_datum,
    allow_change_job,
    job_choices,
  } = data;

  return (
    <Window width={500} height={520} resizable>
      <Window.Content scrollable>
        <Section title="OOC">
          <NoticeBox>
            OOC Note:
            PTO acquired is account-wide and shared across all characters.
            Info listed below is not IC information.
          </NoticeBox>
        </Section>
        <Section title="Employee Info">
          <LabeledList>
            <LabeledList.Item label="Employee ID">
              <Button
                fluid
                icon="user"
                onClick={() => act("id")}>
                {card || "Insert ID"}
              </Button>
            </LabeledList.Item>
            {!!job_datum && (
              <Fragment>
                <LabeledList.Item label="Rank">
                  <Box
                    backgroundColor={job_datum.selection_color}
                    p={0.8}>
                    <Flex justify="space-between" align="center">
                      <Flex.Item>
                        <Box ml={1}>
                          <RankIcon color="white" rank={job_datum.title} />
                        </Box>
                      </Flex.Item>
                      <Flex.Item>
                        <Box fontSize={1.5} inline mr={1}>
                          {job_datum.title}
                        </Box>
                      </Flex.Item>
                    </Flex>
                  </Box>
                </LabeledList.Item>
                <LabeledList.Item label="Departments">
                  {job_datum.departments}
                </LabeledList.Item>
                <LabeledList.Item label="Pay Scale">
                  {job_datum.economic_modifier}
                </LabeledList.Item>
                <LabeledList.Item label="PTO Elegibility">
                  {job_datum.timeoff_factor > 0 && (
                    <Box>
                      Earns PTO - {job_datum.pto_department}
                    </Box>
                  ) || job_datum.timeoff_factor < 0 && (
                    <Box>
                      Requires PTO - {job_datum.pto_department}
                    </Box>
                  ) || (
                    <Box>
                      Neutral
                    </Box>
                  )}
                </LabeledList.Item>
              </Fragment>
            )}
          </LabeledList>
        </Section>
        {!!(allow_change_job && job_datum && job_datum.timeoff_factor !== 0 && assignment !== "Dismissed") && (
          <Section title="Employment Actions">
            {!job_datum.is_off_duty && (
              true && (
                <Button
                  fluid
                  icon="exclamation-triangle"
                  onClick={() => act("switch-to-offduty")}>
                  Go Off-Duty
                </Button>
              ) || (
                <Box color="bad">
                  Warning:
                  You do not have enough accrued time off to go off-duty.
                </Box>
              )
            ) || (
              Object.keys(job_choices).length
              && Object.keys(job_choices).map(job => {
                let alt_titles = job_choices[job];

                return alt_titles.map(title => (
                  <Button
                    key={title}
                    icon="suitcase"
                    onClick={() => act("switch-to-onduty-rank", {
                      "switch-to-onduty-rank": job,
                      "switch-to-onduty-assignment": title,
                    })}>
                    {title}
                  </Button>
                ));
              }) || (
                <Box color="bad">
                  No Open Positions - See Head Of Personnel
                </Box>
              )
            )}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
