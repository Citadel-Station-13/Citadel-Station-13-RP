import { Section, Stack, Divider, Table, Collapsible, Box, Flex } from "../components";
import { Window } from "../layouts";
import { useBackend, useLocalState } from "../backend";
import { Tabs } from "../components";

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
}

export const CharacterProfile = (props, context) => {
  const { act, data } = useBackend<CharacterProfileContext>(context);
  const [selectedTab, setSelectedTab] = useLocalState<number>(
    context,
    "selectedTab",
    1
  );
  let combinedspeciesname : string = "";
  combinedspeciesname = combinedspeciesname.concat("Species - ", data.species_name);

  return (
    <Window resizable width={950} height={800}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab onClick={() => setSelectedTab(1)}>
            Visual Overview/Description
          </Tabs.Tab>
          <Tabs.Tab onClick={() => setSelectedTab(2)}>
            Character Directory
          </Tabs.Tab>
        </Tabs>
        {selectedTab === 1 && (
          <Stack>
            <Stack.Item pl="10px">
              <CharacterProfileImageElement />
            </Stack.Item>
            <Stack.Item Stack-direction="column" pl="10px">
              <Collapsible title={combinedspeciesname}>
                <Section>
                  {data.species_text}
                </Section>
              </Collapsible>
              <Collapsible title="Flavor Text">
                <Section>
                  <CharacterProfileDescElement />
                </Section>
              </Collapsible>
              <Collapsible title="OOC Notes">
                <Section>
                  {data.oocnotes}
                </Section>
              </Collapsible>
            </Stack.Item>
          </Stack>
        )}
        {selectedTab === 2 && (
          <Stack>
            <Divider vertical />
            <Stack.Item>
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
            </Stack.Item>
            <Divider vertical />
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};

const CharacterProfileImageElement = (props, context) => {
  const { act, data } = useBackend<CharacterProfileContext>(context);

  if (data.fullref_toggle && data.fullref_url) return (<Section title="Full Reference" pb="12" textAlign="center"><img src={data.fullref_url} style={{ "max-width": "500px", "max-height": "900px" }} /></Section>);
  if (!data.fullref_toggle && data.headshot_url) return (<Section title="Headshot Reference" pb="12" textAlign="center"><img src={data.headshot_url} height="256px" width="256px" /></Section>);
  return (<Box />);
};


const CharacterProfileDescElement = (props, context) => {
  const { act, data } = useBackend<CharacterProfileContext>(context);

  return (
    <Flex flex-direction="column">
      {data.flavortext_general !== "" ? (<Flex.Item><Divider /><b>General</b><br />{data.flavortext_general}<Divider /></Flex.Item>): (<Box />) }
      {data.flavortext_head !== "" ? (<Flex.Item><Divider /><b>General</b><br />{data.flavortext_head}<Divider /></Flex.Item>): (<Box />) }
      {data.flavortext_face !== "" ? (<Flex.Item><Divider /><b>General</b><br />{data.flavortext_face}<Divider /></Flex.Item>): (<Box />) }
      {data.flavortext_eyes !== "" ? (<Flex.Item><Divider /><b>General</b><br />{data.flavortext_eyes}<Divider /></Flex.Item>): (<Box />) }
      {data.flavortext_torso !== "" ? (<Flex.Item><Divider /><b>General</b><br />{data.flavortext_torso}<Divider /></Flex.Item>): (<Box />) }
      {data.flavortext_arms !== "" ? (<Flex.Item><Divider /><b>General</b><br />{data.flavortext_arms}<Divider /></Flex.Item>): (<Box />) }
      {data.flavortext_hands !== "" ? (<Flex.Item><Divider /><b>General</b><br />{data.flavortext_hands}<Divider /></Flex.Item>): (<Box />) }
      {data.flavortext_legs !== "" ? (<Flex.Item><Divider /><b>General</b><br />{data.flavortext_legs}<Divider /></Flex.Item>): (<Box />) }
      {data.flavortext_feet !== "" ? (<Flex.Item><Divider /><b>General</b><br />{data.flavortext_feet}<Divider /></Flex.Item>): (<Box />) }
    </Flex>
  ); };
