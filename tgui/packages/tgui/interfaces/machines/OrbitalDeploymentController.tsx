import { useEffect, useState } from 'react';
import {
  Button,
  Dimmer,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';

interface OrbitalDeploymentControllerData {
  zone: OrbitalDeploymentZoneData | null;
  lasers: OrbitalDeploymentLaserData[];
  flares: OrbitalDeploymentFlareData[];
  refreshOnCooldown: BooleanLike;
}

interface OrbitalDeploymentTargetData {
  name: string;
  // virtual x (m), virtual y (m), elevation (m)
  coords: [number, number, number];
  overmapDist: number;
  overmapName: string;
}

interface OrbitalDeploymentFlareData extends OrbitalDeploymentTargetData {
  ref: string;
}
interface OrbitalDeploymentLaserData extends OrbitalDeploymentTargetData {
  ref: string;
}

interface OrbitalDeploymentZoneData {
  armed: BooleanLike;
  arming: BooleanLike;
  launchOnCooldown: BooleanLike;
  armToggleOnCooldown: BooleanLike;
  maxOvermapPixelDist: number;
}

export const OrbitalDeploymentController = (props) => {
  const { act, data } = useBackend<OrbitalDeploymentControllerData>();
  const [selectedTarget, setSelectedTarget] = useState<[string, string] | null>(
    null,
  );
  const [launchDir, setLaunchDir] = useState(1);

  let targetValid = false;
  if (selectedTarget) {
    if (selectedTarget[0] === 'laser') {
      if (data.lasers.find((a) => a.ref === selectedTarget[1])) {
        targetValid = true;
      }
    }
    if (selectedTarget[0] === 'flare') {
      if (data.flares.find((a) => a.ref === selectedTarget[1])) {
        targetValid = true;
      }
    }
  }

  // start auto-refreshing
  useEffect(() => {
    let t = setInterval(() => {
      act('refreshSignals');
    }, 10000);
    return () => {
      clearInterval(t);
    };
  }, []);

  return (
    <Window title="Orbital Deployment Controller" width={450} height={450}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Stack fill>
              <Stack.Item grow>
                <Section fill title="Status">
                  {data.zone ? (
                    <LabeledList>
                      <LabeledList.Item label="Status">
                        {data.zone.launchOnCooldown ? 'Recharging' : 'Ready'}
                      </LabeledList.Item>
                      <LabeledList.Item label="Range">
                        {data.zone.maxOvermapPixelDist / 32} Tiles
                      </LabeledList.Item>
                    </LabeledList>
                  ) : (
                    <Dimmer>
                      <NoticeBox danger>
                        Controller has no linked zone.
                      </NoticeBox>
                    </Dimmer>
                  )}
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section fill title="Orientation">
                  <Stack>
                    <Stack.Item grow={1}>
                      <Button
                        width="100%"
                        content="(CW 0°)"
                        icon="arrow-down"
                        color="transparent"
                        onClick={() => setLaunchDir(1)}
                        selected={launchDir === 1}
                      />
                    </Stack.Item>
                    <Stack.Item grow={1}>
                      <Button
                        width="100%"
                        content="(CW 90°)"
                        icon="arrow-left"
                        color="transparent"
                        onClick={() => setLaunchDir(4)}
                        selected={launchDir === 4}
                      />
                    </Stack.Item>
                  </Stack>
                  <Stack>
                    <Stack.Item grow={1}>
                      <Button
                        width="100%"
                        content="(CW 180)"
                        icon="arrow-up"
                        color="transparent"
                        onClick={() => setLaunchDir(2)}
                        selected={launchDir === 2}
                      />
                    </Stack.Item>
                    <Stack.Item grow={1}>
                      <Button
                        width="100%"
                        content="(CW 270°)"
                        icon="arrow-right"
                        color="transparent"
                        onClick={() => setLaunchDir(8)}
                        selected={launchDir === 8}
                      />
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              title="Signals"
              fill
              scrollable
              buttons={
                <Button
                  icon="refresh"
                  color="transparent"
                  onClick={() => act('refreshSignals')}
                  selected={data.refreshOnCooldown}
                  iconSpin={data.refreshOnCooldown}
                >
                  Refresh
                </Button>
              }
            >
              <Table>
                <Table.Row>
                  <Table.Cell
                    textAlign="center"
                    style={{ borderRight: 'solid 1px #ffffff66' }}
                  >
                    Name
                  </Table.Cell>
                  <Table.Cell
                    textAlign="center"
                    style={{ borderRight: 'solid 1px #ffffff66' }}
                  >
                    Sector Name
                  </Table.Cell>
                  <Table.Cell
                    textAlign="center"
                    style={{ borderRight: 'solid 1px #ffffff66' }}
                  >
                    Sector Coords
                  </Table.Cell>
                  <Table.Cell
                    textAlign="center"
                    style={{ borderRight: 'solid 1px #ffffff66' }}
                  >
                    Sector Dist
                  </Table.Cell>
                  <Table.Cell minWidth={1} />
                </Table.Row>
                {data.flares.map((f) => {
                  let isSelectedTarget =
                    selectedTarget &&
                    selectedTarget[0] === 'flare' &&
                    selectedTarget[1] === f.ref;
                  return (
                    <Table.Row
                      key={f.ref}
                      style={{ borderTop: 'solid 1px #ffffff66' }}
                    >
                      <Table.Cell
                        style={{ borderRight: 'solid 1px #ffffff66' }}
                      >
                        {f.name}
                      </Table.Cell>
                      <Table.Cell
                        style={{ borderRight: 'solid 1px #ffffff66' }}
                      >
                        {f.overmapName}
                      </Table.Cell>
                      <Table.Cell
                        style={{ borderRight: 'solid 1px #ffffff66' }}
                      >
                        {f.coords[0]}, {f.coords[1]}, {f.coords[2]}
                      </Table.Cell>
                      <Table.Cell
                        style={{ borderRight: 'solid 1px #ffffff66' }}
                      >
                        {f.overmapDist / 32} Tiles
                      </Table.Cell>
                      <Table.Cell>
                        <Button
                          icon="bullseye"
                          color={isSelectedTarget ? undefined : 'transparent'}
                          selected={isSelectedTarget}
                          onClick={() =>
                            isSelectedTarget
                              ? setSelectedTarget(null)
                              : setSelectedTarget(['flare', f.ref])
                          }
                        />
                      </Table.Cell>
                    </Table.Row>
                  );
                })}
                {data.lasers.map((f) => {
                  let isSelectedTarget =
                    selectedTarget &&
                    selectedTarget[0] === 'laser' &&
                    selectedTarget[1] === f.ref;
                  return (
                    <Table.Row
                      key={f.ref}
                      style={{ borderTop: 'solid 1px #ffffff66' }}
                    >
                      <Table.Cell
                        style={{ borderRight: 'solid 1px #ffffff66' }}
                      >
                        {f.name}
                      </Table.Cell>
                      <Table.Cell
                        style={{ borderRight: 'solid 1px #ffffff66' }}
                      >
                        {f.overmapName}
                      </Table.Cell>
                      <Table.Cell
                        style={{ borderRight: 'solid 1px #ffffff66' }}
                      >
                        {f.coords[0]}, {f.coords[1]}, {f.coords[2]}
                      </Table.Cell>
                      <Table.Cell
                        style={{ borderRight: 'solid 1px #ffffff66' }}
                      >
                        {f.overmapDist / 32} Tiles
                      </Table.Cell>
                      <Table.Cell>
                        <Button
                          icon="target"
                          selected={isSelectedTarget}
                          onClick={() =>
                            isSelectedTarget
                              ? setSelectedTarget(null)
                              : setSelectedTarget(['laser', f.ref])
                          }
                        />
                      </Table.Cell>
                    </Table.Row>
                  );
                })}
              </Table>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Stack fill>
                <Stack.Item grow>
                  <Button.Confirm
                    disabled={data.zone?.armToggleOnCooldown}
                    textAlign="center"
                    fluid
                    onClick={() => {
                      if (data.zone?.arming) {
                        act('disarm');
                      } else {
                        act('arm');
                      }
                    }}
                    color={
                      data.zone?.arming
                        ? data.zone.armed
                          ? 'red'
                          : 'yellow'
                        : undefined
                    }
                  >
                    {data.zone?.arming
                      ? data.zone.armed
                        ? 'Armed'
                        : 'Arming'
                      : 'Arm'}
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item grow>
                  <Button.Confirm
                    textAlign="center"
                    fluid
                    disabled={
                      !data.zone?.armed ||
                      !targetValid ||
                      data.zone.launchOnCooldown
                    }
                    onClick={() =>
                      act('launch', {
                        targetType: selectedTarget?.[0],
                        targetRef: selectedTarget?.[1],
                        dir: launchDir,
                      })
                    }
                  >
                    {data.zone?.launchOnCooldown ? 'Recharging' : 'Launch'}
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
