/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { capitalize } from "common/string";
import { ModuleProps, ModuleData, useModule, useLocalState } from "../../backend";
import { Button, Flex, Input, LabeledList, Section, Tabs } from "../../components";
import { SectionProps } from "../../components/Section";
import { AccessRegions, AccessTypes } from "../../constants/access";
import { Modular } from "../../layouts/Modular";
import { WindowProps } from "../../layouts/Window";
import { Access, AccessId, AccessListMod } from "../common/Access";


interface CardModContext extends ModuleData {
  access: Array<Access>, // all avail access
  ranks: Array<Department>, // all avail rank
  can_demote: BooleanLike, // can we demote?
  can_rename: BooleanLike, // can we rename?
  can_rank: BooleanLike, // can we change ranks at all?
  granted?: Array<AccessId>, // access ids on card
  modify_account: BooleanLike, // can modify card bank account id
  card_account?: number, // card bank account id
  modify_region: AccessRegions, // what we can modify
  modify_type: AccessTypes, // what we can modify
  modify_ids: Array<AccessId>, // what we can specifically edit regardless of region / type
  modify_cats: Array<string>, // what categories we can edit
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
  const [mode, setMode] = useLocalState<number>(context, `${props.id}_mode`, 0);
  const [department, setDepartment] = useLocalState<string | null>(context, 'dept', null);
  const windowProps: WindowProps = {
    width: 500,
    height: 500,
    title: "Card Modify",
  };
  const sectionProps: SectionProps = {
  };
  const modifiable: Array<Access> = data.access.filter((a) => (
    (
      (a.region & data.modify_region)
      && (a.type & data.modify_type)
    ) || (
      data.modify_cats.includes(a.category)
    ) || (
      data.modify_ids.includes(a.value)
    )
  ));
  return (
    <Modular window={windowProps} section={sectionProps}>
      <Section title="Data Fields">
        <LabeledList>
          <LabeledList.Item
            label="Owner">
            {data.can_rename? (
              <Input
                value={data.card_name}
                onChange={(e, val) => act('name', { set: val })} />
            ) : (
              data.card_name || "-----"
            )}
          </LabeledList.Item>
          <LabeledList.Item
            label="Account Number">
            {data.modify_account? (
              <Input
                value={data.card_account}
                onChange={(e, val) => act('account', { set: val })} />
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
          uid={props.id}
          access={modifiable}
          selected={data.granted || (new Array<number>())}
          set={(id) => act('toggle', { access: id })}
          grant={(cat) => act('grant', { cat: cat })}
          deny={(cat) => act('deny', { cat: cat })} />
      )}
      {mode === 1 && (
        <Section
          title="Rank Modification"
          buttons={
            <Button.Confirm
              disabled={!data.can_demote}
              content="Demote"
              className="bad"
              onClick={() => act('demote')} />
          }>
          <LabeledList>
            <LabeledList.Item
              label="Rank">
              {data.can_rank? (
                <Input
                  value={data.card_rank}
                  onChange={(e, val) => act('rank_custom', { rank: val })} />
              ) : (
                data.card_rank || "-----"
              )}
            </LabeledList.Item>
            <LabeledList.Item
              label="Assignment / Title">
              {data.can_rank? (
                <Input
                  value={data.card_assignment}
                  onChange={(e, val) => act('assignment', { set: val })} />
              ) : (
                data.card_assignment || "-----"
              )}
            </LabeledList.Item>
          </LabeledList>
          {!!data.can_rank && (
            <Section title="Reassign Rank">
              <Flex
                direction="row">
                <Flex.Item grow={0.35}>
                  <Tabs vertical>
                    {data.ranks.sort((a, b) => (a.name.localeCompare(b.name))).map((dept) => (
                      <Tabs.Tab
                        selected={department === dept.name}
                        key={dept.name}
                        onClick={() => setDepartment(dept.name)}>
                        {capitalize(dept.name)}
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Flex.Item>
                <Flex.Item grow={1}>
                  {!!department && data.ranks.find((dept) => dept.name === department)?.ranks.map((rank) => (
                    <Button.Confirm
                      key={rank}
                      color="transparent"
                      selected={rank === data.card_rank}
                      fluid
                      content={rank}
                      onClick={() => act('rank', { rank: rank })} />
                  )
                  )}
                </Flex.Item>
              </Flex>
            </Section>
          )}
        </Section>
      )}
    </Modular>
  );
};
