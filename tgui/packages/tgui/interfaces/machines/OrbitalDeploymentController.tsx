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
  maxOvermapPixelDist: number;
}

export const OrbitalDeploymentController = (props) => {
  const { act, data } = useBackend<OrbitalDeploymentControllerData>();
  const [selectedTarget, setSelectedTarget] = useState<[string, string] | null>(
    null,
  );

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
    let t = setTimeout(() => {
      act('refreshSignals');
    }, 3000);
    return () => {
      clearTimeout(t);
    };
  });

  return (
    <Window title="Orbital Deployment Controller">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Status">
              {data.zone ? (
                <LabeledList>
                  <LabeledList.Item label="Status">
                    {data.zone.launchOnCooldown ? 'Recharging' : 'Ready'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Range">
                    {data.zone.maxOvermapPixelDist / 32}
                  </LabeledList.Item>
                </LabeledList>
              ) : (
                <Dimmer>
                  <NoticeBox danger>Controller has no linked zone.</NoticeBox>
                </Dimmer>
              )}
            </Section>
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
                  <Table.Cell>Name</Table.Cell>
                  <Table.Cell>Sector Name</Table.Cell>
                  <Table.Cell>Sector Coords</Table.Cell>
                  <Table.Cell>Sector Dist</Table.Cell>
                  <Table.Cell />
                </Table.Row>
              </Table>
              {data.flares.map((f) => {
                let isSelectedTarget =
                  selectedTarget &&
                  selectedTarget[0] === 'flare' &&
                  selectedTarget[1] === f.ref;
                return (
                  <Table.Row key={f.ref}>
                    <Table.Cell>{f.name}</Table.Cell>
                    <Table.Cell>{f.overmapName}</Table.Cell>
                    <Table.Cell>
                      {f.coords[0]}, {f.coords[1]}, {f.coords[2]}
                    </Table.Cell>
                    <Table.Cell>{f.overmapDist}</Table.Cell>
                    <Table.Cell>
                      <Button
                        icon="target"
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
                  <Table.Row key={f.ref}>
                    <Table.Cell>{f.name}</Table.Cell>
                    <Table.Cell>{f.overmapName}</Table.Cell>
                    <Table.Cell>
                      {f.coords[0]}, {f.coords[1]}, {f.coords[2]}
                    </Table.Cell>
                    <Table.Cell>{f.overmapDist / 32}</Table.Cell>
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
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Stack fill>
                <Stack.Item grow>
                  <Button.Confirm
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
                        : 'transparent'
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
                    fluid
                    disabled={!data.zone?.armed || !targetValid}
                    onClick={() =>
                      act('launch', {
                        targetType: selectedTarget?.[0],
                        targetRef: selectedTarget?.[1],
                      })
                    }
                  >
                    Launch
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
