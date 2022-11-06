/* eslint-disable react/jsx-max-depth */
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Section, Flex, Icon, NoticeBox, Collapsible } from '../components';
import { COLORS } from '../constants';
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
// LateChoices
export const JoinMenu = (props, context) => {
  const { act, data } = useBackend<JoinMenuData>(context);

  return (
    <Window width={400} height={800}>
      <Window.Content>
        <Flex fill direction="column">
          {/* Top bar */}
          <Flex.Item mb={1}>
            <Flex direction="column">
              <Flex.Item grow>
                <Section fill>
                  Round Duration: {data.duration}
                </Section>
              </Flex.Item>
              <Flex.Item grow>
                <Section fill>
                  <NoticeBox
                    success={data.security_level === "green"}
                    info={data.security_level === "blue"}
                    warning={data.security_level === "yellow" || data.security_level === "violet"
                    || data.security_level === "orange"}
                    danger={data.security_level === "red" || data.security_level === "delta"}>
                    Security Level: {data.security_level.charAt(0).toUpperCase()
                      + data.security_level.slice(1)}
                  </NoticeBox>
                  {!!data.evacuated && (
                    <NoticeBox
                      info={data.evacuated === 2}
                      warning={data.evacuated === 1 || data.evacuated === 3}>
                      The shuttle has {data.evacuated === 3 ? "left the station." : "been called."}
                    </NoticeBox>
                  )}
                </Section>
              </Flex.Item>
            </Flex>
          </Flex.Item>
          {/* Join things */}
          <Flex.Item mb={1}>
            {
              Object.entries(data.jobs).map(([k, v]) => (
                <RoleList faction={k} joinableJobs={v} key={k} />
              ))
            }
          </Flex.Item>
          {/* Latejoin */}
          <Flex.Item mb={1}>
            {/* Ghostroles */}
            <Section title="Ghostroles">
              {data.ghostroles.map(
                (role) => (
                  <Collapsible key={role.id} title={role.name} color="transparent" buttons={
                    <>
                      {(role.slots === -1)? '' : role.slots} <Icon name="user-friends" />
                      <Button.Confirm
                        icon="sign-in-alt"
                        content="Join"
                        color="transparent"
                        onClick={() => act('join', { id: role.id, type: "ghostrole" })}
                      />
                    </>
                  }>
                    <Box mt={1}>
                      {role.desc}
                    </Box>
                  </Collapsible>
                ))}
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

/**
 * stupid way of recasting the department into colors
 */
const recast_this_stupid_shit = {
  supply: "cargo",
  command: "captain",
  service: "other",
  civillian: "other",
  miscellaneous: "other",
  medical: "medbay",
  engineering: "engineering",
  science: "science",
  security: "security",
};

/**
 * EXPECTED ORDER:
 * command silicon medical
 * supply service science
 * engineering msic security
 */
const sortWeight = {
  command: 12,
  civillian: 11,
  medical: 10,
  supply: 9,
  service: 8,
  science: 7,
  engineering: 6,
  miscellaneous: 5,
  security: 4,
  silicons: 3,
};

interface IRoleListProps {
  faction: string;
  joinableJobs: {
    [key: string]: JoinableJob[]
  }
}

const RoleList = (props: IRoleListProps, context) => {
  const { act } = useBackend(context);

  const orderedData = Object.keys(props.joinableJobs).sort((a, b) => {
    const depA = a.toLowerCase();
    const depB = b.toLowerCase();
    if (!(depB in sortWeight) || !(depA in sortWeight)) {
      return 0;
    }
    return sortWeight[depB] - sortWeight[depA];
  });

  return (
    <Section title={`${props.faction} Roles`}>
      <Flex
        justify="space-evenly"
        align="baseline"
        wrap
        grow
      >
        {orderedData.map(name => {
          const data: JoinableJob[] = props.joinableJobs[name];

          return (
            <Flex.Item ml={2} mr={2} mt={2} key={name} basis="22%" grow>
              <Section
                title={name}
                borderHexColor={
                  COLORS.department[recast_this_stupid_shit[name.toLowerCase()]]
                }>
                {data.map(dat => (
                  <Button.Confirm
                    fluid
                    key={dat.id}
                    tooltip={dat.desc}
                    content={`${dat.real_name} - ${dat.slots === -1 ? "Unlimited" : dat.slots}`}
                    confirmContent={`Play as ${dat.real_name}?`}
                    onClick={() => act('join', { 'id': dat.id, 'type': 'job' })}
                  />
                ))}
              </Section>
            </Flex.Item>
          );
        })}
      </Flex>
    </Section>);
};
