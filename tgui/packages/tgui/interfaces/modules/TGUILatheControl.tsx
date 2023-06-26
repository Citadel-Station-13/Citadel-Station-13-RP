import { BooleanLike } from "common/react";
import { ModuleData, useLocalState, useModule } from "../../backend";
import { Button, Stack, Tabs } from "../../components";
import { Section, SectionProps } from "../../components/Section";
import { Modular } from "../../layouts/Modular";
import { WindowProps } from "../../layouts/Window";
import { Design } from "../common/Design";
import { IngredientsAvailable, IngredientsSelected } from "../common/Ingredients";
import { MaterialsContext } from "../common/Materials";
import { ReagentContentsData } from "../common/Reagents";

interface TGUILatheControlProps {

}

interface TGUILatheControlData extends ModuleData {
  designs: {
    categories: string[],
    instances: Record<string, Design>,
  };
  storesItems: BooleanLike;
  storesMaterials: BooleanLike;
  storesReagents: BooleanLike;
  queueActive: BooleanLike;
  queue: Array<LatheQueueEntry>;
  latheName: string;
  speedMultiplier: number;
  powerMultiplier: number;
  dynamicButtons: Record<string, "off" | "on" | "disabled" | null>;
  efficiencyMultiplier: number;
  materials: Record<string, number>;
  materialsContext: MaterialsContext;
  reagents: ReagentContentsData;
  printing: string;
  ingredients: IngredientsAvailable;
}

export const generateDynamicButton = (name, mode, actFunction) => {
  if (mode === null) {
    return (
      <Button fluid content={name} onClick={() => actFunction("custom", { name: name })} />
    );
  }
  else if (mode === "disabled") {
    return (
      <Button fluid content={name} disabled />
    );
  }
  else {
    return (
      <Button selected={mode === "on"} fluid content={name} />
    );
  }
};

export const TGUILatheControl = (props: TGUILatheControlProps, context) => {
  const { data, act } = useModule<TGUILatheControlData>(context);
  const [category, setCategory] = useLocalState<string>(
    context,
    `${data.$ref}-category`,
    data.designs.categories.length? data.designs.categories[1] : "General"
  );
  const [resourcesSelect, setResourcesSelect] = useLocalState<string>(
    context,
    `${data.$ref}-rSelect`,
    "Materials",
  );

  const windowProps: WindowProps = {
    title: data.latheName,
    width: 1000,
    height: 600,
  };

  const sectionProps: SectionProps = {
    title: `${data.latheName} Control`,
  };

  let resourceRender;

  switch (resourcesSelect) {
    case "Materials":
      resourceRender = (
        <>
          test
        </>
      );
      break;
    case "Reagents":
      resourceRender = (
        <>
          test
        </>
      );
      break;
    case "Items":
      resourceRender = (
        <>
          test
        </>
      );
      break;
  }

  return (
    <Modular window={windowProps}>
      <Stack vertical fill>
        <Stack.Item>
          <Stack fluid>
            <Stack.Item grow={1}>
              <Section title="Resources">
                <Stack vertical>
                  <Stack.Item>
                    <Tabs>
                      {
                        !!data.storesMaterials && (
                          <Tabs.Tab
                            content="Materials"
                            selected={resourcesSelect === "Materials"}
                            onClick={() => setResourcesSelect("Materials")}>
                            Materials
                          </Tabs.Tab>
                        )
                      }
                      {
                        !!data.storesReagents && (
                          <Tabs.Tab
                            selected={resourcesSelect === "Reagents"}
                            onClick={() => setResourcesSelect("Reagents")}>
                            Reagents
                          </Tabs.Tab>
                        )
                      }
                      {
                        !!data.storesItems && (
                          <Tabs.Tab
                            content="Items"
                            selected={resourcesSelect === "Items"}
                            onClick={() => setResourcesSelect("Items")}>
                            Items
                          </Tabs.Tab>
                        )
                      }
                    </Tabs>
                  </Stack.Item>
                  <Stack.Item>
                    {resourceRender}
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
            {
              !!Object.keys(data.dynamicButtons).length && (
                <Stack.Item>
                  <Section title="Control">
                    <Stack vertical>
                      {
                        Object.entries(data.dynamicButtons).map(([name, mode]) => {
                          return generateDynamicButton(name, mode, act);
                        })
                      }
                    </Stack>
                  </Section>
                </Stack.Item>
              )
            }
          </Stack>
        </Stack.Item>
        <Stack.Item grow={1}>
          <Stack fluid>
            <Stack.Item>
              <Section fill title="Categories">
                <Tabs vertical>
                  {
                    data.designs.categories.map((cat) => (
                      <Tabs.Tab key={cat} fluid color="transparent"
                        selected={cat === category}
                        onClick={() => setCategory(cat)}>
                        {cat}
                      </Tabs.Tab>
                    ))
                  }
                </Tabs>
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section fill title="Designs">
                {
                  Object.values(data.designs.instances).filter((d) => d.category === category).map((d) => (
                    <>
                      {d.name}
                    </>
                  ))
                }
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Section fill title="Queue"
                minWidth="250px"
                buttons={
                  <>
                    <Button.Confirm icon="minus" content="Clear" onClick={() => act('clear')}
                      color="transparent" />
                    <Button content={data.queueActive? "Stop" : "Start"}
                      icon={data.queueActive? "stop" : "play"}
                      color="transparent"
                      selected={data.queueActive}
                      onClick={() => act(data.queueActive? "stop" : "start")} />
                  </>
                }>
                {
                  data.queue.map((entry, index) => (
                    <LatheQueued key={`${index}-${entry.amount}-${entry.design}`}
                      entry={entry} design={data.designs[entry.design]} />
                  ))
                }
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Modular>
  );
};

interface LatheQueueEntry {
  design: string; // design id
  amount: number; // how many
  materials?: Record<string, string>; // key to id
  ingredients?: IngredientsSelected; // dataset from Ingredients.tsx
}

interface LatheQueuedProps {
  entry: LatheQueueEntry;
  design: Design;
}

const LatheQueued = (props: LatheQueuedProps, context) => {
  return (
    <>
      test
    </>
  );
};

interface LatheDesignProps {
  design: Design;
  materialsContext: MaterialsContext;
  printButtonAct?: (string, number) => void; // id,
  printButtonText?: string;
}

const LatheDesign = (props: LatheDesignProps, context) => {

  return (
    <>
      test
    </>
  );
};
