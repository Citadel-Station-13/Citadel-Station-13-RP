import { useState } from "react";
import { Box, Collapsible, Divider, Flex, Section, Table } from "tgui-core/components";
import { Tabs } from "tgui-core/components";

import { useBackend } from "../backend";
import { Window } from "../layouts";

const getTagColor = (erptag) => {
  switch (erptag) {
    case "Unset":
      return "label";
    case "Top":
      return "red";
    case "Switch":
      return "orange";
    case "Bottom":
      return "blue";
    case "No ERP":
      return "green";
  }
};

// I am aware that the following context with all these vars is messy, but this isn't particularly
// 'hot' code given it's static data.

interface CharacterProfileContext {
  oocnotes: string;
  headshot_url: string;
  fullref_url: string;
  fullref_toggle: boolean;
  directory_visible: boolean;
  erp_tag: string;
  vore_tag: string;
  species_name: string;
  species_text: string;
  flavortext_general: string;
  flavortext_head: string;
  flavortext_face: string;
  flavortext_eyes: string;
  flavortext_torso: string;
  flavortext_arms: string;
  flavortext_hands: string;
  flavortext_legs: string;
  flavortext_feet: string;
  vore_digestable: string;
  vore_devourable: string;
  vore_feedable: string;
  vore_leaves_remains: string;
  vore_healbelly: string;
  vore_spontaneous_prey: string;
  vore_spontaneous_pred: string;
}

export const CharacterProfile = (props) => {
  const { act, data } = useBackend<CharacterProfileContext>();
  const [selectedTab, setSelectedTab] = useState<number>(1);
  let combinedspeciesname: string = "";
  combinedspeciesname = combinedspeciesname.concat("Species - ", data.species_name);

  return (
    <Window width={950} height={800}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab onClick={() => setSelectedTab(1)}>
            Visual Overview / Description
          </Tabs.Tab>
          <Tabs.Tab onClick={() => setSelectedTab(2)}>
            Character Directory / Vore Preferences
          </Tabs.Tab>
        </Tabs>
        {selectedTab === 1 && (
          <Flex>
            <Flex.Item pl="10px">
              <CharacterProfileImageElement />
            </Flex.Item>
            <Flex.Item Flex-direction="column" pl="10px" width="100%">
              <Collapsible title={combinedspeciesname} open>
                <Section style={{ whiteSpace: "pre-line" }}>
                  {data.species_text}
                </Section>
              </Collapsible>
              <Collapsible title="Flavor Text" open>
                <Section>
                  <CharacterProfileDescElement />
                </Section>
              </Collapsible>
              <Collapsible title="OOC Notes" open>
                <Section style={{ whiteSpace: "pre-line" }}>
                  {data.oocnotes}
                </Section>
              </Collapsible>
            </Flex.Item>
          </Flex>
        )}
        {selectedTab === 2 && (
          <Flex>
            <Divider vertical />
            <Flex.Item>
              {data.directory_visible ? (
                <Section title="Character Directory Info" width="100%">
                  <Table backgroundColor={getTagColor(data.erp_tag)}>
                    <Table.Row>
                      <Table.Cell>ERP Tag -</Table.Cell>
                      <Table.Cell>{data.erp_tag}</Table.Cell>
                    </Table.Row>
                    <Table.Row>
                      <Table.Cell>Vore Tag -</Table.Cell>
                      <Table.Cell>{data.vore_tag}</Table.Cell>
                    </Table.Row>
                  </Table>
                </Section>
              ) : (
                <Divider vertical />
              )}
            </Flex.Item>
            <Divider vertical />
            <Section title="Mechanical Vore Preferences">
              <Flex.Item direction="column">
                <Flex.Item>Digestable: {data.vore_digestable}</Flex.Item>
                <Flex.Item>Devourable: {data.vore_devourable}</Flex.Item>
                <Flex.Item>Feedable: {data.vore_feedable}</Flex.Item>
                <Flex.Item>Leaves Remains: {data.vore_leaves_remains}</Flex.Item>
                <Flex.Item>Belly Healing: {data.vore_healbelly}</Flex.Item>
                <Flex.Item>Drop Vore Prey: {data.vore_spontaneous_prey}</Flex.Item>
                <Flex.Item>Drop Vore Pred: {data.vore_spontaneous_pred}</Flex.Item>
              </Flex.Item>
            </Section>
          </Flex>

        )}
      </Window.Content>
    </Window>
  );
};

const CharacterProfileImageElement = (props) => {
  const { act, data } = useBackend<CharacterProfileContext>();

  if (data.fullref_toggle && data.fullref_url) return (<Section title="Full Reference" pb="12" textAlign="center"><img src={data.fullref_url} style={{ maxWidth: "500px", maxHeight: "900px" }} /></Section>);
  if (!data.fullref_toggle && data.headshot_url) return (<Section title="Headshot Reference" pb="12" textAlign="center"><img src={data.headshot_url} height="256px" width="256px" /></Section>);
  return (<Box />);
};


const CharacterProfileDescElement = (props) => {
  const { act, data } = useBackend<CharacterProfileContext>();

  return (
    <Flex direction="column">
      {data.flavortext_general !== "" ? (<Flex.Item style={{ whiteSpace: "pre-line" }}><Divider /><b>General</b><br />{data.flavortext_general}</Flex.Item>) : (<Box />)}
      {data.flavortext_head !== "" ? (<Flex.Item style={{ whiteSpace: "pre-line" }}><Divider /><b>Head</b><br />{data.flavortext_head}</Flex.Item>) : (<Box />)}
      {data.flavortext_face !== "" ? (<Flex.Item style={{ whiteSpace: "pre-line" }}><Divider /><b>Face</b><br />{data.flavortext_face}</Flex.Item>) : (<Box />)}
      {data.flavortext_eyes !== "" ? (<Flex.Item style={{ whiteSpace: "pre-line" }}><Divider /><b>Eyes</b><br />{data.flavortext_eyes}</Flex.Item>) : (<Box />)}
      {data.flavortext_torso !== "" ? (<Flex.Item style={{ whiteSpace: "pre-line" }}><Divider /><b>Torso</b><br />{data.flavortext_torso}</Flex.Item>) : (<Box />)}
      {data.flavortext_arms !== "" ? (<Flex.Item style={{ whiteSpace: "pre-line" }}><Divider /><b>Arms</b><br />{data.flavortext_arms}</Flex.Item>) : (<Box />)}
      {data.flavortext_hands !== "" ? (<Flex.Item style={{ whiteSpace: "pre-line" }}><Divider /><b>Hands</b><br />{data.flavortext_hands}</Flex.Item>) : (<Box />)}
      {data.flavortext_legs !== "" ? (<Flex.Item style={{ whiteSpace: "pre-line" }}><Divider /><b>Legs</b><br />{data.flavortext_legs}</Flex.Item>) : (<Box />)}
      {data.flavortext_feet !== "" ? (<Flex.Item style={{ whiteSpace: "pre-line" }}><Divider /><b>Feet</b><br />{data.flavortext_feet}</Flex.Item>) : (<Box />)}
    </Flex>
  );
};
