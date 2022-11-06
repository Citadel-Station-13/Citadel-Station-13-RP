/* eslint-disable react/jsx-max-depth */
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Section, Icon, NoticeBox, Collapsible, Stack } from '../components';
import { Window } from '../layouts';

interface JoinableRoles {
  /**
   * The ID of the role (typepath)
   */
  id: string;
  /**
   * The default name of the role (`initial(role.name)`)
   */
  name: string;
  /**
   * Optional description of the job
   */
  desc?: string;
  /**
   * How many slots does this role still have? `-1` is infinity
   */
  slots: number;
}

interface JoinableJob extends JoinableRoles {
  real_name: string;
}

interface JoinMenuData {
  jobs: {
    /** Factions */
    [key: string]: {
      /** Department */
      [key: string]: JoinableJob[]
    }
  };
  ghostroles: JoinableRoles[];
  security_level: "green" | "blue" | "red" | "violet" | "yellow" | "orange" | "delta";
  evacuated: 0 | 1 | 2 | 3;
  duration: string; // timetext
  charname: string;
  queue?: number;
}

interface JoinFactionProps {
  faction: string;
  departments: {
    [key: string]: JoinableJob[]
  }
}

// LateChoices
export const JoinMenu = (props, context) => {
  const { act, data } = useBackend<JoinMenuData>(context);

  return (
    <Window width={400} height={800}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section fill>
              <h1>Welcome, {data.charname}!</h1>
              Round Duration: {data.duration}
              Security Level: {data.security_level}
              {!!data.evacuated && (
                <NoticeBox
                  info={data.evacuated === 2}
                  warning={data.evacuated === 1 || data.evacuated === 3}>
                  {(data.evacuated === 2)? "A crew transfer is in progress."
                    : ((data.evacuated === 3)? "The installation has been evacuated."
                      : "An evacuation is in progress.")}
                </NoticeBox>
              )}
            </Section>
          </Stack.Item>
          <Stack.Item>
            {
              Object.entries(data.jobs).map(([k, v]) => {
                <JoinFaction faction={k} departments={v} />;
              })
            }
          </Stack.Item>
          <Stack.Item>
            <Section title="Ghost Roles">
              {
                data.ghostroles.map((role) => {
                  return (
                    <Collapsible key={role.id} title={role.name} color="transparent" buttons={
                      <>{(role.slots === -1)? '' : role.slots} <Icon name="user-friends" />
                        <Button.Confirm
                          icon="sign-in-alt"
                          content="Join"
                          color="transparent"
                          onClick={() => act('join', { id: role.id, type: "ghostrole" })} />
                      </>
                    }>
                      <Box>
                        {role.desc}
                      </Box>
                    </Collapsible>
                  );
                })
              }
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const JoinFaction = (props: JoinFactionProps, context) => {
  const { act } = useBackend(context);
  const ordered = Object.keys(props.departments).sort((a, b) => {
    const A = a.toLowerCase();
    const B = b.toLowerCase();
    let hasA = (A in sortWeight);
    let hasB = (B in sortWeight);
    if (hasA && !hasB) {
      return 1;
    }
    else if (!hasA && hasB) {
      return -1;
    }
    else if (!hasA && !hasB) {
      return 0;
    }
    else {
      return sortWeight[B] - sortWeight[A];
    }
  });

  return (
    <Collapsible title={`${props.faction} Roles`}>
      {
        ordered.map((depName) => {
          const jobs: JoinableJob[] = props.departments[depName];
          return (
            <Collapsible color="transparent" key={depName} title={depName}>
              {
                jobs.map((job) => {
                  return (
                    <Collapsible color="transparent" key={job.id} title={job.name} buttons={
                      <>{(job.slots === -1)? '' : job.slots} <Icon name="user-friends" />
                        <Button.Confirm
                          icon="sign-in-alt"
                          content="Join"
                          color="transparent"
                          onClick={() => act('join', { id: job.id, type: "job" })} />
                      </>
                    }>
                      {job.desc}
                    </Collapsible>
                  );
                })
              }
            </Collapsible>
          );
        })
      }
    </Collapsible>
  );
};

const sortWeight = {
  command: 100,
  security: 90,
  engineering: 70,
  medical: 80,
  science: 70,
  exploration: 60,
  civillian: 50,
  misc: 40,
  miscellaneous: 40,
  "off-duty": 30,
  silicons: 20,
};
