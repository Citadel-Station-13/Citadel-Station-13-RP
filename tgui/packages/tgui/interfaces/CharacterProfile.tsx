import { Section, Flex, Divider } from "../components";
import { Window } from "../layouts";
import { useBackend, useLocalState } from "../backend";
import { Tabs } from "../components";
import { resolveAsset } from "../assets";
import headshot_not_found from '../assets/headshot_not_found.png';

interface CharacterProfileContext {
  oocnotes: String;
  flavortext: String;
  profiletext: String;
  headshot_url: string;
}

export const CharacterProfile = (props, context) => {
  const { act, data } = useBackend<CharacterProfileContext>(context);
  const [selectedTab, setSelectedTab] = useLocalState<number>(
    context,
    "selectedTab",
    1
  );
  const preview_image = resolveAsset("character_preview.png");

  return (
    <Window resizable width={800} height={700}>
      <Tabs>
        <Tabs.Tab onClick={() => setSelectedTab(1)}>
          Visual Overview/Description
        </Tabs.Tab>
        <Tabs.Tab onClick={() => setSelectedTab(2)}>Flavor Text</Tabs.Tab>
        <Tabs.Tab onClick={() => setSelectedTab(3)}>OOC Notes</Tabs.Tab>
      </Tabs>
      {selectedTab === 1 && (
        <Flex>
          <Divider vertical />
          <Flex.Item width="35%">
            <Section title="Headshot" pb="12" textAlign="center">
              {data.headshot_url? (
                <img src={data.headshot_url} height="256px" width="256px" />
              ) : (
                <img src={headshot_not_found} height="256px" width="256px" />
              )}
            </Section>
            <Section title="Character Preview" pt="12" textAlign="center">
              <img
                src={preview_image}
                height="250px"
                width="250px"
                style={{ "-ms-interpolation-mode": "nearest-neighbor" }}
              />
            </Section>
          </Flex.Item>
          <Divider vertical />
          <Flex.Item width="65%">
            <Section title="Profile Text" scrollable fill>
              {data.profiletext}
            </Section>
          </Flex.Item>
          <Divider vertical />
        </Flex>
      )}
      {selectedTab === 2 && (
        <Section title="Flavor Text">{data.flavortext}</Section>
      )}
      {selectedTab === 3 && (
        <Section title="OOC Notes">{data.oocnotes}</Section>
      )}
    </Window>
  );
};
