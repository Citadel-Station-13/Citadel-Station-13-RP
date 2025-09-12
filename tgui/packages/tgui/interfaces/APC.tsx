import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const APC = (props) => {
  return (
    <Window width={450} height={445}>
      <Window.Content scrollable>
        <ApcContent />
      </Window.Content>
    </Window>
  );
};

const powerStatusMap = {
  2: {
    color: 'good',
    externalPowerText: 'External Power',
    chargingText: 'Fully Charged',
  },
  1: {
    color: 'average',
    externalPowerText: 'Low External Power',
    chargingText: 'Charging: ',
  },
  0: {
    color: 'bad',
    externalPowerText: 'No External Power',
    chargingText: 'Not Charging',
  },
};

const malfMap = {
  1: {
    icon: 'terminal',
    content: 'Override Programming',
    action: 'hack',
  },
  2: {
    icon: 'caret-square-down',
    content: 'Shunt Core Process',
    action: 'occupy',
  },
  3: {
    icon: 'caret-square-left',
    content: 'Return to Main Core',
    action: 'deoccupy',
  },
  4: {
    icon: 'caret-square-down',
    content: 'Shunt Core Process',
    action: 'occupy',
  },
};

const ApcContent = (props) => {
  const { act, data } = useBackend<any>();
  const locked = data.locked && !data.siliconUser;
  const normallyLocked = data.normallyLocked;
  const externalPowerStatus =
    powerStatusMap[data.externalPower] || powerStatusMap[0];
  const chargingStatus =
    powerStatusMap[data.chargingStatus] || powerStatusMap[0];
  const channelArray = data.powerChannels || [];
  const malfStatus = malfMap[data.malfStatus] || malfMap[0];
  const adjustedCellChange = data.powerCellStatus / 100;
  if (data.failTime > 0) {
    return (
      <NoticeBox info textAlign="center" mb={0}>
        <b>
          <h3>SYSTEM FAILURE</h3>
        </b>
        I/O regulators have malfunctioned! <br />
        Awaiting system reboot.
        <br />
        Executing software reboot in {data.failTime} seconds...
        <br />
        <br />
        <Button
          icon="sync"
          content="Reboot Now"
          tooltip="Force an interface reset."
          tooltipPosition="bottom"
          onClick={() => act('reboot')}
        />
      </NoticeBox>
    );
  }
  return (
    <>
      <InterfaceLockNoticeBox
        deny={data.emagged}
        denialMessage={
          <>
            <Box color="bad" fontSize="1.5rem">
              Fault in ID authenticator.
            </Box>
            <Box color="bad">Please contact maintenance for service.</Box>
          </>
        }
      />
      <Section title="Power Status">
        <LabeledList>
          <LabeledList.Item
            label="Main Breaker"
            color={externalPowerStatus.color}
            buttons={
              <Button
                icon={data.isOperating ? 'power-off' : 'times'}
                content={data.isOperating ? 'On' : 'Off'}
                selected={data.isOperating && !locked}
                disabled={locked}
                onClick={() => act('breaker')}
              />
            }
          >
            [ {externalPowerStatus.externalPowerText} ]
          </LabeledList.Item>
          <LabeledList.Item label="Power Cell">
            <ProgressBar color="good" value={adjustedCellChange} />
          </LabeledList.Item>
          <LabeledList.Item
            label="Charge Mode"
            color={chargingStatus.color}
            buttons={
              <Button
                icon={data.chargeMode ? 'sync' : 'times'}
                content={data.chargeMode ? 'Auto' : 'Off'}
                selected={data.chargeMode}
                disabled={locked}
                onClick={() => act('charge')}
              />
            }
          >
            [ {chargingStatus.chargingText} ]
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Power Channels">
        <LabeledList>
          {channelArray.map((channel) => {
            const { topicParams } = channel;
            return (
              <LabeledList.Item
                key={channel.title}
                label={channel.title}
                buttons={
                  <>
                    <Box
                      inline
                      mx={2}
                      color={channel.status >= 2 ? 'good' : 'bad'}
                    >
                      {channel.status >= 2 ? 'On' : 'Off'}
                    </Box>
                    <Button
                      icon="sync"
                      content="Auto"
                      selected={
                        !locked &&
                        (channel.status === 1 || channel.status === 3)
                      }
                      disabled={locked}
                      onClick={() => act('channel', topicParams.auto)}
                    />
                    <Button
                      icon="power-off"
                      content="On"
                      selected={!locked && channel.status === 2}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.on)}
                    />
                    <Button
                      icon="times"
                      content="Off"
                      selected={!locked && channel.status === 0}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.off)}
                    />
                  </>
                }
              >
                {channel.powerLoad} W
              </LabeledList.Item>
            );
          })}
          <LabeledList.Item label="Total Load">
            {data.totalCharging ? (
              <b>
                {data.totalLoad} W (+ {data.totalCharging} W charging)
              </b>
            ) : (
              <b>{data.totalLoad} W</b>
            )}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Misc"
        buttons={
          !!data.siliconUser && (
            <Button
              icon="lightbulb-o"
              content="Overload"
              onClick={() => act('overload')}
            />
          )
        }
      >
        <LabeledList>
          <LabeledList.Item
            label="Cover Lock"
            buttons={
              <Button
                tooltip="APC cover can be pried open with a crowbar."
                icon={data.coverLocked ? 'lock' : 'unlock'}
                content={data.coverLocked ? 'Engaged' : 'Disengaged'}
                disabled={locked}
                onClick={() => act('cover')}
              />
            }
          />
          <LabeledList.Item
            label="Emergency Lighting"
            buttons={
              <Button
                tooltip="Lights use internal power cell when there is no power available."
                icon="lightbulb-o"
                content={data.emergencyLights ? 'Enabled' : 'Disabled'}
                disabled={locked}
                onClick={() => act('emergency_lighting')}
              />
            }
          />
          <LabeledList.Item
            label="Night Shift Lighting"
            buttons={
              <>
                <Button
                  icon="lightbulb-o"
                  content="Disabled"
                  selected={data.nightshiftSetting === 2}
                  onClick={() =>
                    act('nightshift', {
                      nightshift: 2,
                    })
                  }
                />
                <Button
                  icon="lightbulb-o"
                  content="Automatic"
                  selected={data.nightshiftSetting === 1}
                  onClick={() =>
                    act('nightshift', {
                      nightshift: 1,
                    })
                  }
                />
                <Button
                  icon="lightbulb-o"
                  content="Enabled"
                  selected={data.nightshiftSetting === 3}
                  onClick={() =>
                    act('nightshift', {
                      nightshift: 3,
                    })
                  }
                />
              </>
            }
          />
        </LabeledList>
      </Section>
    </>
  );
};
