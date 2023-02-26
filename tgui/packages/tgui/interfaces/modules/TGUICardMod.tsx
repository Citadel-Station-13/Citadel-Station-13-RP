/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { ModuleProps, ModuleData, useModule, useLocalState } from "../../backend";
import { Button, Flex, Input, LabeledList, Section, Tabs } from "../../components";
import { AccessRegions, AccessTypes } from "../../constants/access";
import { Modular } from "../../layouts/Modular";
import { Access, AccessId, AccessListMod } from "../common/Access";


interface CardModContext extends ModuleData {
  access: Array<Access>, // all avail access
  ranks: Array<Department>, // all avail rank
  can_demote: BooleanLike, // can we demote?
  can_rename: BooleanLike, // can we rename?
  granted?: Array<AccessId>, // access ids on card
  modify_account: BooleanLike, // can modify card bank account id
  card_account?: number, // card bank account id
  modify_region: AccessRegions, // what we can modify
  modify_type: AccessTypes, // what we can modify
  modify_ids: Array<AccessId>, // what we can specifically edit regardless of region / type
  card_name?: string, // card name as string
  card_rank?: string, // card rank as string
  card_assignment?: string,
}

interface Department {
  name: string;
  ranks: [string];
}

interface CardModProps extends ModuleProps {
  // nothing
}

export const TGUICardMod = (props: CardModProps, context) => {
  const { data, act } = useModule<CardModContext>(context);
  const [mode, setMode] = useLocalState<number>(context, 'mode', 0);
  const [department, setDepartment] = useLocalState<string | null>(context, 'dept', null);
  const windowProps = {
    width: 500,
    height: 500,
  };
  const sectionProps ={
    fill: true,
  };
  return (
    <Modular window={windowProps} section={sectionProps}>
      <Section title="Data Fields">
        <LabeledList>
          <LabeledList.Item
            label="Owner">
            {data.can_rename? (
              <Input
                value={data.card_name}
                onEnter={(e, val) => { act('name', { set: val }); }} />
            ) : (
              data.card_name || "-----"
            )}
          </LabeledList.Item>
          <LabeledList.Item
            label="Account Number">
            {data.modify_account? (
              <Input
                value={data.card_account}
                onEnter={(e, val) => { act('account', { set: val }); }} />
            ) : (
              data.card_account || "-----"
            )}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Tabs>
        <Tabs.Tab onClick={() => setMode(0)} selected={mode === 0}>
          Access
        </Tabs.Tab>
        <Tabs.Tab onClick={() => setMode(1)} selected={mode === 1}>
          Rank
        </Tabs.Tab>
      </Tabs>
      {mode === 0 && (
        <AccessListMod
          access={data.access}
          selected={data.granted || (new Array<number>())}
          set={(id) => { act('toggle', { access: id }); }}
          grant={(cat) => { act('grant', { cat: cat }); }}
          deny={(cat) => { act('deny', { cat: cat }); }} />
      )}
      {mode === 1 && (
        <Section
          title="Rank Modification"
          buttons={
            data.can_demote
              && <Button.Confirm
                content="Demote"
                className="bad"
                onClick={() => act('demote')} />
          }>
          <LabeledList>
            <LabeledList.Item
              label="Rank">
              <Input
                value={data.card_rank}
                onEnter={(e, val) => { act('rank_custom', { rank: val }); }} />
            </LabeledList.Item>
            <LabeledList.Item
              label="Assignment / Title">
              <Input
                value={data.card_assignment}
                onEnter={(e, val) => { act('assignment', { rank: val }); }} />
            </LabeledList.Item>
          </LabeledList>
          <Section title="Reassign Rank">
            <Flex
              direction="column">
              <Flex.Item>
                <Tabs>
                  {data.ranks.map((dept) => {
                    return (
                      <Tabs.Tab key={dept} onClick={setDepartment(dept.name)}>
                        {dept}
                      </Tabs.Tab>
                    );
                  })}
                </Tabs>
              </Flex.Item>
              <Flex.Item grow={1}>
                {!!department && data.ranks.find((dept) => dept.name === department)?.ranks.map((rank) => {
                  <Button.Confirm
                    content={rank}
                    onClick={() => { act('rank', { rank: rank }); }} />;
                })}
              </Flex.Item>
            </Flex>
          </Section>
        </Section>
      )}
    </Modular>
  );
};
