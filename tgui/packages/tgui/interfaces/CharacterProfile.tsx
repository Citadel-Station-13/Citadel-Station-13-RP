import { Section, Flex, Divider, Table, Box } from "../components";
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

interface CharacterProfileContext {
  oocnotes: String;
  flavortext: String;
  headshot_url: string;
  preview_name: string;
  directory_visible: boolean;
  erp_tag: string;
  vore_tag: string;
  species_name: string;
  species_text: string;
}

export const CharacterProfile = (props, context) => {
  const { act, data } = useBackend<CharacterProfileContext>(context);
  const [selectedTab, setSelectedTab] = useLocalState<number>(
    context,
    "selectedTab",
    1
  );
  const preview_image = data.preview_name;

  return (
    <Window resizable width={800} height={700}>
      <Tabs>
        <Tabs.Tab onClick={() => setSelectedTab(1)}>
          Visual Overview/Description
        </Tabs.Tab>
        <Tabs.Tab onClick={() => setSelectedTab(2)}>
          Character Directory
        </Tabs.Tab>
      </Tabs>
      {selectedTab === 1 && (
        <Flex height="620px" scrollable>
          <Flex.Item width="35%" pl="10px">
            {data.headshot_url !== "" ? (
              <Section title="Headshot" pb="12" textAlign="center">
                <img src={data.headshot_url} height="256px" width="256px" />
              </Section>) : (<Box height="0" width="0" />)}
            <Section title="Character Preview" pt="12" textAlign="center">
              <img
                src={preview_image}
                height="250px"
                width="250px"
                style={{ "-ms-interpolation-mode": "nearest-neighbor" }}
              />
            </Section>
          </Flex.Item>
          <Flex.Item width="65%" flex-direction="column" pl="10px">
            <Section title={data.species_name} scrollable height="33%">
              {data.species_text}
            </Section>
            <Section title="Flavor Text" scrollable height="33%">
              {data.flavortext}
            </Section>
            <Section title="OOC Notes" scrollable height="33%">
              {data.oocnotes}
            </Section>
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
        </Flex>
      )}
    </Window>
  );
};
