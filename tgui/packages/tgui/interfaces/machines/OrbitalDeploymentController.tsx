import { useEffect, useState } from 'react';
import {
  Button,
  Dimmer,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
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

interface OrbitalDeploymentFlareData extends OrbitalDeploymentTargetData {}
interface OrbitalDeploymentLaserData extends OrbitalDeploymentTargetData {}

interface OrbitalDeploymentZoneData {
  armed: BooleanLike;
  arming: BooleanLike;
  launchOnCooldown: BooleanLike;
  maxOvermapPixelDist: number;
}

export const OrbitalDeploymentController = (props) => {
  const { act, data } = useBackend<OrbitalDeploymentControllerData>();
  const [selectedTarget, setSelectedTarget] = useState<[string | null, string | null]>([null, null]);

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
    <Window>
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
                    {data.zone.maxOvermapPixelDist}
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
              <Stack vertical>
                {data.}
                test
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Stack fill>
              <Stack.Item grow>
                <Button.Confirm>Arm</Button.Confirm>
              </Stack.Item>
              <Stack.Item grow>
                <Button.Confirm>Launch</Button.Confirm>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
