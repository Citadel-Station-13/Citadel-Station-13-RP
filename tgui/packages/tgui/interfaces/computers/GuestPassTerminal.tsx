/**
 * @file
 * @license MIT
 */

import { useBackend, useLocalState } from "../../backend";
import { Button, Input, LabeledList, NoticeBox, NumberInput, Section, Stack } from "../../components";
import { Window } from "../../layouts";
import { Access, AccessId, AccessListMod } from "../common/Access";
import { IDCard, IDCardOrDefault, IDSlot } from "../common/IDCard";

interface GuestPassTerminalData {
  auth?: IDCard;
  access: Access[];
  selected: AccessId[];
  allowed: AccessId[];
  guestReason: string;
  guestName: string;
  durationMin: number;
  duration: number;
  durationMax: number;
  printsLeft: number;
}

export const GuestPassTerminal = (props, context) => {
  const { data, act } = useBackend<GuestPassTerminalData>(context);
  const [tab, setTab] = useLocalState<number>(context, 'tab', 1);
  return (
    <Window width={500} height={700}>
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Authentication">
              <IDSlot card={IDCardOrDefault(data.auth)} onClick={() => act('eject')} />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Guest">
              <LabeledList>
                <LabeledList.Item label="Name">
                  <Input width="100%" value={data.guestName} placeholder="Name"
                    onInput={(e, val) => act('name', { value: val })} />
                </LabeledList.Item>
                <LabeledList.Item label="Reason">
                  <Input width="100%" value={data.guestReason} placeholder="Reason"
                    onInput={(e, val) => act('reason', { value: val })} />
                </LabeledList.Item>
                <LabeledList.Item label="Duration (minutes)">
                  <NumberInput width="100%" step={1} value={data.duration}
                    minValue={data.durationMin} maxValue={data.durationMax}
                    onChange={(e, val) => act('duration', { value: val })} />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          {!!data.auth && (
            data.allowed.length > 0? (
              <>
                <Stack.Item grow>
                  <AccessListMod
                    accessShown={data.allowed}
                    selected={data.selected} access={data.access} uid="1"
                    fill set={(id) => act('toggle', { value: id })}
                    grant={(cat) => act('grant', { category: cat })}
                    deny={(cat) => act('deny', { category: cat })} />
                </Stack.Item>
                <Stack.Item>
                  <Section>
                    <Button.Confirm textAlign="center"
                      color="transparent" fluid disabled={data.printsLeft <= 0 || !data.auth}
                      content={data.printsLeft > 0? "Issue" : "Printer Recharging"}
                      onClick={() => act('issue')} />
                  </Section>
                </Stack.Item>
              </>
            ) : (
              <Stack.Item grow>
                <Section fill>
                  <NoticeBox>No access found on card.</NoticeBox>
                </Section>
              </Stack.Item>
            )
          )}
          {!data.auth && (
            <Stack.Item grow>
              <Section fill>
                <NoticeBox>Awaiting authentication.</NoticeBox>
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
