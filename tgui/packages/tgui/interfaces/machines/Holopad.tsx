/**
 * @file
 * @license MIT
 */
import { BooleanLike } from "common/react";
import { useBackend, useLocalState } from "../../backend";
import { Box, Button, LabeledList, NoticeBox, Section, Stack, Table, Tabs } from "../../components";
import { Window } from "../../layouts";

enum HolopadCalling {
  None = "none",
  Source = "source",
  Destination = "destination",
}

// holopad_uid
type HolopadId = string;

// window data
interface HolopadContext {
  isAI: BooleanLike; // ai user?
  holopadName: string;
  isAIProjecting: BooleanLike; // we are currently projecting at this pad
  aiRequested: BooleanLike; // recently requested ai?
  aiEnabled: BooleanLike; // are ais allowed to use this?
  aiRequestAllowed: BooleanLike;
  canCall: BooleanLike; // if we can call at all
  toggleVisibility: BooleanLike; // if we can toggle call visibility
  callVisibility: BooleanLike; // are we visible in call list?
  sectorCall: BooleanLike; // if we can go across sectors
  connectivity: Array<ReachableHolopad>; // reachable holopads
  calling: null | HolopadCalling; // call status
  calldata: null | OutgoingCallContext | IncomingCallsContext; // call data
  videoEnabled: BooleanLike; // if inbound video calling is enabled
  videoToggle: BooleanLike; // if we can toggle inbound video calling
  ringerEnabled: BooleanLike; // if audio ringer is enabled
  ringerToggle: BooleanLike; // if audio ringer is toggleable
  autoPickup: BooleanLike; // if we auto accept calls
  autoToggle: BooleanLike; // if we can toggle auto accepting calls
  sectorAnonymous: BooleanLike;
  sectorAnonymousToggle: BooleanLike;
  ringing: Array<TargetHolopad>; // incoming rings
}

// reachable holopads
type ReachableHolopad = {
  id: HolopadId;
  name: string;
  category?: string;
  sector?: string;
}

type TargetHolopad = {
  name: string;
  sector?: string;
  id: HolopadId;
}

// all calls have this
type BaseCallContext = {
  // nothing right now
}

// outgoing calls have this
type OutgoingCallContext = BaseCallContext & {
  target: HolopadId; // calling to id
  remoting: BooleanLike; // are we projecting to the other side?
  remotingAllowed: BooleanLike; // is other side allowing remoting?
  ringing: BooleanLike; // are we connected or still ringing
  connected: [TargetHolopad]; // all pads connected
  destination: TargetHolopad;
}

// incoming calls have this
type IncomingCallsContext = BaseCallContext & {
  callers: [TargetHolopad]; // calling ids
  projecting: [HolopadId]; // who's projecting over here right now
}

export const Holopad = (props, context) => {
  const { act, data } = useBackend<HolopadContext>(context);
  const [tab, setTab] = useLocalState<number>(context, 'tab', 1);

  return (
    <Window
      title="Holopad"
      width={650}
      height={400}>
      <Window.Content>
        <Section
          fill
          scrollable
          title={data.holopadName}
          buttons={data.isAI? (
            <Button
              content={data.aiEnabled
                ?(data.isAIProjecting? "Stop Projecting" : "Start Projecting")
                : "AI Disabled"}
              disabled={!data.aiEnabled}
              icon={data.aiEnabled && (data.isAIProjecting? `stop` : `phone`)}
              selected={data.aiEnabled && data.isAIProjecting}
              onClick={() => act('ai_project', { mode: !data.isAIProjecting })} />
          ) : (
            !!data.aiRequestAllowed && <Button.Confirm
              content={data.aiEnabled
                ?(data.aiRequested? "AI Requested" : "Request AI")
                : "AI Disabled"}
              icon={data.aiRequested? `wifi` : `wifi`}
              selected={data.aiRequested}
              onClick={() => act('ai_request')} />
          )}>
          <HolopadRinging />
          <Tabs>
            <Tabs.Tab
              width="50%"
              selected={tab === 1}
              onClick={() => setTab(1)}>
              Communications
            </Tabs.Tab>
            <Tabs.Tab
              width="50%"
              selected={tab === 2}
              onClick={() => setTab(2)}>
              Settings
            </Tabs.Tab>
          </Tabs>
          {tab === 1 && (
            !!data.canCall && (
              data.calling === HolopadCalling.None? (
                <HolopadDirectory />
              ) : (
                data.calling === HolopadCalling.Destination? (
                  <HolopadCallIncoming />
                ) : (
                  data.calling === HolopadCalling.Source && <HolopadCallOutgoing />
                )
              )
            )
          )}
          {tab === 2 && (
            <HolopadSettings />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const HolopadCallOutgoing = (props, context) => {
  const { data, act } = useBackend<HolopadContext>(context);
  const callContext: OutgoingCallContext = data.calldata as OutgoingCallContext;
  return (
    <Section
      title={`Outgoing Call - ${`${callContext.destination.sector}: `} ${callContext.destination.name}`}
      buttons={
        <Button.Confirm
          content="Disconnect"
          icon="stop"
          onClick={() => act('disconnect')} />
      }>
      {
        callContext.ringing? (
          <NoticeBox>
            Ringing...
          </NoticeBox>
        ) : (
          <>
            <Section title="Remote Presence">
              {
                <Button
                  disabled={!callContext.remotingAllowed}
                  content={callContext.remotingAllowed? (callContext.remoting? "Projecting" : "Not Projecting") : "Destination Disabled"}
                  selected={callContext.remoting}
                  onClick={() => act(callContext.remoting? 'stop_remote' : 'start_remote')} />
              }
            </Section>
            <Section title="Connected Pads">
              <LabeledList>
                {callContext.connected.map((pad) => (
                  <LabeledList.Item
                    label={`${pad.name} - ${pad.sector}${pad.id === callContext.target? " (Host)" : ""}`}
                    key={pad.id} />
                ))}
              </LabeledList>
            </Section>
          </>
        )
      }
    </Section>
  );
};

const HolopadCallIncoming = (props, context) => {
  const { data, act } = useBackend<HolopadContext>(context);
  const callContext: IncomingCallsContext = data.calldata as IncomingCallsContext;
  return (
    <Section title="Active Calls"
      buttons={
        <Button.Confirm
          content="Disconnect All"
          icon="stop"
          onClick={() => act('disconnect')} />
      }>
      <LabeledList>
        <>
          {callContext.callers.map((pad) => (
            <LabeledList.Item
              key={pad.id}
              label={`${pad.name} - ${pad.sector}`}
              buttons={
                <>
                  <Button
                    content={callContext.projecting.includes(pad.id)? "Projecting" : "Not Projecting"}
                    color="transparent"
                    selected={callContext.projecting.includes(pad.id)} />
                  <Button.Confirm
                    content="Disconnect"
                    icon="stop"
                    onClick={() => act('disconnect', { id: pad.id })} />
                </>
              } />
          ))}
        </>
      </LabeledList>
    </Section>
  );
};

const HolopadRinging = (props, context) => {
  const { data, act } = useBackend<HolopadContext>(context);
  return (
    <>
      {
        data.ringing.map((pad) => (
          <NoticeBox key={pad.id}>
            <Stack>
              <Stack.Item grow={1}>
                Incoming call from {pad.name} - {pad.sector}
              </Stack.Item>
              <Stack.Item>
                <Button.Confirm
                  disabled={data.calling === HolopadCalling.Source}
                  content={data.calling === HolopadCalling.Source? "Already In Call" : "Connect"}
                  onClick={() => act('connect', { id: pad.id })} />
              </Stack.Item>
            </Stack>
          </NoticeBox>
        ))
      }
    </>
  );
};

const MISC_SECTOR = "Other";
const MISC_CATEGORY = "Misc";

const HolopadDirectory = (props, context) => {
  const { data, act } = useBackend<HolopadContext>(context);
  const cats = {};
  const sectors = {};
  const [sector, setSector] = useLocalState<string | null>(context, 'sector', null);
  const [category, setCategory] = useLocalState<string | null>(context, 'category', null);
  data.connectivity.forEach((pad: ReachableHolopad) => {
    let effectiveSector = pad.sector || MISC_SECTOR;
    sectors[effectiveSector] = 1;
    if (effectiveSector === sector) {
      cats[pad.category || MISC_CATEGORY] = 1;
    }
  });
  return (
    <Stack>
      <Stack.Item width="20%">
        <Box height="100%">
          <Tabs vertical>
            {
              Object.keys(sectors).sort((a, b) => (a.localeCompare(b))).map((key: string) => (
                <Tabs.Tab
                  selected={sector === key}
                  key={key}
                  onClick={() => setSector(key)}>
                  {key}
                </Tabs.Tab>
              ))
            }
          </Tabs>
        </Box>
      </Stack.Item>
      <Stack.Item width="20%">
        <Box height="100%">
          <Tabs vertical>
            {Object.keys(cats).sort((a, b) => (a.localeCompare(b))).map((cat) => (
              <Tabs.Tab
                key={cat}
                selected={cat === category}
                onClick={() => setCategory(cat)}>
                {cat}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Box>
      </Stack.Item>
      <Stack.Item width="60%">
        <Section height="100%">
          <Stack vertical>
            {(data.connectivity.filter((pad) => (
              pad.category? (pad.category === category) : (category === MISC_CATEGORY)
              && pad.sector? (pad.sector === sector) : (sector === MISC_SECTOR)
            )).map((pad) => (
              <Stack.Item key={pad.id}>
                <Stack>
                  <Stack.Item grow={1}>
                    {pad.name}
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      fluid
                      content="Call"
                      onClick={() => act('call', { id: pad.id })} />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))) || undefined}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const HolopadSettings = (props, context) => {
  let { data, act } = useBackend<HolopadContext>(context);
  return (
    <Table>
      <Table.Row>
        <Table.Cell>
          Ringer
        </Table.Cell>
        <Table.Cell width="25%">
          <Button fluid
            content={data.ringerEnabled? "Enabled" : "Disabled"}
            selected={data.ringerEnabled}
            disabled={!data.ringerToggle}
            onClick={() => act('toggle_ringer')} />
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.Cell>
          Visibility
        </Table.Cell>
        <Table.Cell>
          <Button fluid
            content={data.callVisibility? "Visible" : "Invisible"}
            selected={data.callVisibility}
            disabled={!data.toggleVisibility}
            onClick={() => act('toggle_visibility')} />
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.Cell>
          Anonymous Sector Calls
        </Table.Cell>
        <Table.Cell>
          <Button fluid
            content={data.sectorAnonymous? "Mask Identity" : "Broadcast Identity"}
            selected={data.sectorAnonymous}
            disabled={!data.sectorAnonymousToggle}
            onClick={() => act('toggle_anonymous_sector')} />
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.Cell>
          Auto Pickup
        </Table.Cell>
        <Table.Cell>
          <Button fluid
            content={data.autoPickup? "Enabled" : "Disabled"}
            selected={data.autoPickup}
            disabled={!data.autoToggle}
            onClick={() => act('toggle_auto')} />
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.Cell>
          Inbound Video
        </Table.Cell>
        <Table.Cell>
          <Button fluid
            content={data.videoEnabled? "Enabled" : "Disabled"}
            selected={data.videoEnabled}
            disabled={!data.videoToggle}
            onClick={() => act('toggle_video')} />
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};
