import { Button, Flex, LabeledList, ProgressBar, Section, Stack, Tabs } from "tgui-core/components";

import { useBackend, useSharedState } from "../backend";
import { Window } from "../layouts";

export const ICPrinter = (props) => {
  const { act, data } = useBackend<any>();

  const {
    metal,
    max_metal,
    metal_per_sheet,
    debug,
    upgraded,
    can_clone,
    program,
    categories,
  } = data;

  return (
    <Window width={800} height={630}>
      <Window.Content scrollable>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Metal">
              <ProgressBar
                value={metal}
                maxValue={max_metal}>
                {metal / metal_per_sheet} / {max_metal / metal_per_sheet} sheets
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Circuits Available">
              {upgraded ? "Advanced" : "Regular"}
            </LabeledList.Item>
            <LabeledList.Item label="Assembly Cloning">
              {can_clone ? "Available" : "Unavailable"}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <ICCloningSection />
        <ICPrinterCategories />
      </Window.Content>
    </Window>
  );
};

const canBuild = (item, data) => {
  if (!item) {
    return false;
  }

  if (!item.can_build) {
    return false;
  }

  if (item.cost > data.metal) {
    return false;
  }

  return true;
};

const ICPrinterCategories = (props) => {
  const { act, data } = useBackend<any>();

  const {
    categories,
    debug,
  } = data;

  const [categoryTarget, setcategoryTarget] = useSharedState("categoryTarget", null);

  const selectedCategory
    = categories.filter(cat => cat.name === categoryTarget)[0];

  return (
    <Section title="Circuits">
      <Stack fill>
        <Stack.Item mr={2}>
          <Tabs vertical>
            {categories.sort((a, b) => (a.name.localeCompare(b.name))).map(cat => (
              <Tabs.Tab
                selected={categoryTarget === cat.name}
                onClick={() => setcategoryTarget(cat.name)}
                key={cat.name}>
                {cat.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          {selectedCategory && (
            <Section>
              <LabeledList>
                {(selectedCategory.items).map(item => (
                  <LabeledList.Item
                    key={item.name}
                    label={item.name}
                    labelColor={item.can_build ? "good" : "bad"}
                    buttons={
                      <Button
                        disabled={!canBuild(item, data)}
                        icon="print"
                        onClick={() => act("build", { build: item.path, cost: item.cost })}>
                        Print
                      </Button>
                    }>
                    {item.desc}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          ) || "No category selected."}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
const ICCloningSection = (props) => {
  const { act, data } = useBackend<any>();
  const {
    can_clone,
    program,
  } = data;

  if (!can_clone) {
    return false;
  }
  return (
    <Section title="Cloning" >
      <Flex>
        <Flex.Item basis={"50%"}>
          <Button
            p={1}
            fluid
            icon="home"
            iconSize={2}
            tooltip="Load a program to print."
            textAlign="center"
            onClick={() => act("load_blueprint")} />
        </Flex.Item>
        <Flex.Item basis={"50%"}>
          <Button
            p={1}
            fluid
            icon="print"
            color={program ? "good" : "bad"}
            iconSize={2}
            textAlign="center"
            onClick={() => act("clone")} />
        </Flex.Item>
      </Flex>
    </Section>
  );
};
