import { BooleanLike } from "common/react";
import { useBackend, useLocalState } from "../../backend";
import { Button, Flex, LabeledList, Section, Tabs } from "../../components";
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
  isAIProjecting: BooleanLike; // we are currently projecting at this pad
  aiRequested: BooleanLike; // recently requested ai?
  aiEnabled: BooleanLike; // are ais allowed to use this?
  aiRequestAllowed: BooleanLike;
  canCall: BooleanLike; // if we can call at all
  toggleVisibility: BooleanLike; // if we can toggle call visibility
  callVisibility: BooleanLike; // are we visible in call list?
  sectorCall: BooleanLike; // if we can go across sectors
  reachablePads: [ReachableHolopad]; // reachable holopads
  calling: null | HolopadCalling; // call status
  calldata: null | OutgoingCallContext | IncomingCallsContext; // call data
  videoEnabled: BooleanLike; // if inbound video calling is enabled
  videoToggle: BooleanLike; // if we can toggle inbound video calling
  ringerEnabled: BooleanLike; // if audio ringer is enabled
  ringerToggle: BooleanLike; // if audio ringer is toggleable
  autoPickup: BooleanLike; // if we auto accept calls
  autoToggle: BooleanLike; // if we can toggle auto accepting calls
  ringing: [TargetHolopad]; // incoming rings
}

// reachable holopads
type ReachableHolopad = {
  id: HolopadId;
  name: string;
  category: string;
  sector: string;
}

type TargetHolopad = {
  name: string;
  sector: string;
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
  ringing: BooleanLike; // are we connected or still ringing
  connected: [TargetHolopad]; // all pads connected
}

// incoming calls have this
type IncomingCallsContext = BaseCallContext & {
  callers: [TargetHolopad]; // calling ids
  projecting: [HolopadId]; // who's projecting over here right now
}

export const Holopad = (props, context) => {
  const { act, data } = useBackend<HolopadContext>(context);

  return (
    <Window
      width={600}
      height={300}>
      <Window.Content>
        <Section
          title="Holopad"
          buttons={data.isAI? (
            <Button
              title={data.aiEnabled
                ?(data.isAIProjecting? "Start Projecting" : "Stop Projecting")
                : "AI Disabled"}
              disabled={!data.aiEnabled}
              icon={data.aiEnabled && (data.isAIProjecting? `phone` : `phone-xmark`)}
              selected={data.aiEnabled && data.isAIProjecting}
              onClick={() => act('ai_project', { mode: !data.isAIProjecting })} />
          ) : (
            !!data.aiRequestAllowed && <Button
              title={data.aiEnabled
                ?(data.aiRequested? "AI Requested" : "Request AI")
                : "AI Disabled"}
              disabled={data.aiRequested}
              icon={data.aiRequested? `arrows-spin` : `megaphone`}
              selected={data.aiRequested}
              onClick={() => act('ai_request')} />
          )}>
          <Flex
            direction="column">
            <Flex.Item grow={1}>
              <Flex direction="row">
                {!!data.canCall && (
                  <Flex.Item grow={1}>
                    {data.calling === HolopadCalling.None? (
                      <HolopadDirectory />
                    ) : (
                      data.calling === HolopadCalling.Destination? (
                        <HolopadCallIncoming />
                      ) : (
                        <HolopadCallOutgoing />
                      )
                    )}
                  </Flex.Item>
                )}
                {!!data.ringing.length
                  && <HolopadRinging />}
              </Flex>
            </Flex.Item>
            <Flex.Item>
              <HolopadSettings />
            </Flex.Item>
          </Flex>
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
      title="Outgoing Call"
      buttons={
        <Button.Confirm
          title="Disconnect"
          icon="phone-xmark"
          onClick={() => act('disconnect')} />
      }>

      test
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
          title="Disconnect All"
          icon="phone-xmark"
          onClick={() => act('disconnect')} />
      }>
      <LabeledList>
        <>
          {callContext.callers.map((pad) => {
            <LabeledList.Item
              key={pad.id}
              label={`${pad.name} - ${pad.sector}`}
              buttons={
                <>
                  <Button
                    title="Projecting"
                    disabled
                    selected={callContext.projecting.includes(pad.id)} />
                  <Button.Confirm
                    title="Disconnect"
                    icon="phone-hangup"
                    onClick={() => act('disconnect', { id: pad.id })} />
                </>
              } />;
          })}
        </>
      </LabeledList>
    </Section>
  );
};

const HolopadRinging = (props, context) => {
  const { data, act } = useBackend<HolopadContext>(context);
  return ((
    <Flex.Item>
      <LabeledList>
        <>
          {data.ringing.map((pad) => {
            <LabeledList.Item label={`${pad.name} - ${pad.sector}`}
              buttons={
                <Button.Confirm
                  content="Connect"
                  onClick={() => act('connect', { id: pad?.id })} />
              } />;
          })}
        </>
      </LabeledList>
    </Flex.Item>
  ));
};

const HolopadDirectory = (props, context) => {
  const { data, act } = useBackend<HolopadContext>(context);
  const padMap: {[sector: string]: {[category: string]: ReachableHolopad[]}} = {};
  data.reachablePads.map((pad: ReachableHolopad) => {
    if (padMap[pad.sector] === undefined) {
      padMap[pad.sector] = {};
    }
    if (padMap[pad.sector][pad.category] === undefined) {
      padMap[pad.sector][pad.category] = new Array<ReachableHolopad>();
    }
    padMap[pad.sector][pad.category].push(pad);
  });
  const [sector, setSector] = useLocalState<string | null>(context, 'sector', null);
  const [category, setCategory] = useLocalState<string | null>(context, 'category', null);
  return (
    <Flex
      direction="column">
      <Flex.Item grow={1}>
        <Section title="Call">
          <Tabs>
            {
              Object.keys(padMap).map((key: string) => {
                <Tabs.Tab
                  selected={sector === key}
                  onClick={() => setSector(key)}>
                  {key}
                </Tabs.Tab>;
              })
            }
          </Tabs>
          <Flex
            direction="row">
            <Flex.Item>
              <Tabs>
                {sector && Object.keys(padMap[sector]).map((cat) => {
                  <Tabs.Tab
                    selected={cat === category}
                    onClick={() => setCategory(cat)}>
                    {cat}
                  </Tabs.Tab>;
                })}
              </Tabs>
            </Flex.Item>
            <Flex.Item grow={1}>
              <LabeledList>
                {(sector && category && padMap[sector][category].map((pad) => {
                  <LabeledList.Item
                    label={pad.name}
                    buttons={
                      <Button.Confirm
                        content="Call"
                        onClick={() => act('call', { id: pad.id })} />
                    }
                  />;
                })) || undefined}
              </LabeledList>
            </Flex.Item>
          </Flex>
        </Section>
      </Flex.Item>
    </Flex>
  );
};

const HolopadSettings = (props, context) => {
  let { data, act } = useBackend<HolopadContext>(context);
  return (
    <Section title="System">
      <LabeledList>
        <LabeledList.Item
          label="Ringer"
          buttons={
            <Button
              title={data.ringerEnabled? "Enabled" : "Disabled"}
              selected={data.ringerEnabled}
              disabled={data.ringerToggle}
              onClick={() => act('toggle_ringer')} />
          } />
        <LabeledList.Item
          label="Visibility"
          buttons={
            <Button
              title={data.callVisibility? "Visible" : "Invisible"}
              selected={data.callVisibility}
              disabled={data.toggleVisibility}
              onClick={() => act('toggle_visibility')} />
          } />
        <LabeledList.Item
          label="Auto Pickup"
          buttons={
            <Button
              title={data.autoPickup? "Enabled" : "Disabled"}
              selected={data.autoPickup}
              disabled={data.autoToggle}
              onClick={() => act('toggle_auto')} />
          } />
        <LabeledList.Item
          label="Inbound Video"
          buttons={
            <Button
              title={data.videoEnabled? "Enabled" : "Disabled"}
              selected={data.videoEnabled}
              disabled={data.videoToggle}
              onClick={() => act('toggle_video')} />
          } />
      </LabeledList>
    </Section>
  );
};
