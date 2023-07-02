/**
 * todo: implement ingredients
 *
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { ModuleData, useLocalState, useModule } from "../../backend";
import { Button, Collapsible, Dropdown, NumberInput, Stack, Table, Tabs } from "../../components";
import { Section, SectionProps } from "../../components/Section";
import { Modular } from "../../layouts/Modular";
import { WindowProps } from "../../layouts/Window";
import { Design } from "../common/Design";
import { IngredientsAvailable, IngredientsSelected } from "../common/Ingredients";
import { MaterialsContext, MaterialStorage, MATERIAL_STORAGE_UNIT_NAME } from "../common/Materials";
import { ReagentContents, ReagentContentsData, REAGENT_STORAGE_UNIT_NAME } from "../common/Reagents";

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
        <Section>
          <MaterialStorage horizontal stored={data.materials} context={data.materialsContext}
            eject={(id, amount) => act('ejectMaterial', { id: id, amount: amount })} />
        </Section>
      );
      break;
    case "Reagents":
      resourceRender = (
        <Section>
          <ReagentContents
            reagents={data.reagents}
            reagentButtons={(id) => (
              [1, 5, 10, 20, 50].map(
                (n) => (
                  <Button
                    icon="minus"
                    key={n}
                    content={`-${n}`}
                    onClick={() => act('disposeReagent', { id: id, amonut: n })} />

                )
              )
            )} />
        </Section>
      );
      break;
    case "Items":
      resourceRender = (
        <>
          Unimplemented
        </>
      );
      break;
  }

  return (
    <Modular window={windowProps} scrollable>
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
                  Object.values(data.designs.instances).filter((d) => d.category === category).sort((d1, d2) =>
                    d1.name.localeCompare(d2.name)
                  ).map((d) => (
                    <LatheDesign
                      key={d.id}
                      design={d} />
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
                <Stack vertical>
                  {
                    data.queue.map((entry, index) => (
                      <Stack.Item key={`${index}-${entry.amount}-${entry.design}`}>
                        <LatheQueued
                          entry={entry} design={data.designs[entry.design]} index={index} />
                      </Stack.Item>
                    ))
                  }
                </Stack>
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
  index: number;
}

const LatheQueued = (props: LatheQueuedProps, context) => {
  let { act } = useModule<TGUILatheControlData>(context);
  return (
    <Collapsible
      title={`${props.entry.amount}x ${props.design.name}`}
      buttons={
        <>
          <Button
            color="transparent"
            icon="plus"
            onClick={() => act('modqueue', { index: props.index, amount: props.entry.amount + 1 })} />
          <NumberInput minValue={1} maxValue={100} step={1}
            value={props.entry.amount} onChange={(e, v) => act('modqueue', { index: props.index, amount: v })} />
          <Button
            color="transparent"
            icon="minus"
            onClick={() => act('modqueue', { index: props.index, amount: props.entry.amount - 1 })} />
          <Button
            color="transparent"
            icon="multiply"
            onClick={() => act('dequeue', { index: props.index })} />
        </>
      }>
      tested
    </Collapsible>
  );
};

interface LatheDesignProps {
  design: Design;
}

const areMaterialsChosen = (mats: Record<string, number>, chosen: Record<string, string>) => {
  return Object.keys(mats).every((mat) => (mat in chosen));
};

const LatheDesign = (props: LatheDesignProps, context) => {
  const { data, act, moduleID } = useModule<TGUILatheControlData>(context);

  // materials: key = material id
  let [mats, setMats] = useLocalState<Record<string, string>>(context, `${moduleID}-${props.design.id}-mats`, {});
  // ingredients: key = ingredient id/value
  let [inds, setInds] = useLocalState<Record<string, string>>(context, `${moduleID}-${props.design.id}-inds`, {});

  // ingredients are currently unspported.
  let awaitingSelections = !areMaterialsChosen(props.design.material_parts || {}, mats)
  || !!props.design.ingredients;

  return (
    <Collapsible
      title={props.design.name}
      color="transparent"
      buttons={awaitingSelections? (
        <Button
          color="transparent"
          textColor="red"
          content="Selections required." />
      ) : (
        <>
          {[1, 5, 10].map((n) => (
            <Button
              key={n}
              icon="plus"
              content={`${n}`}
              onClick={() => act('enqueue', {
                id: props.design.id,
                amount: n,
                immediate: false,
                materials: mats,
                items: [],
              })} />
          ))}
          {
            data.printing? (
              <Button
                icon="play"
                content="Busy"
                disabled />
            ) : (
              <Button.Confirm
                icon="play"
                content="Print"
                onClick={() => act('enqueue', {
                  id: props.design.id,
                  amount: 1,
                  immediate: true,
                  materials: mats,
                  items: [],
                })} />
            )
          }
        </>
      )}>
      <Stack>
        <Stack.Item grow={1}>
          { (!!props.design.materials || !!props.design.material_parts || !!props.design.reagents) && (
            <Table width="100%">
              <Table.Row>
                <Table.Cell width="33%" />
                <Table.Cell width="33%" />
                <Table.Cell width="33%" />
              </Table.Row>
              {
                props.design.materials
                    && Object.entries(props.design.materials).map(([id, amt]) => (
                      <Table.Row key={id}>
                        <Table.Cell />
                        <Table.Cell>
                          <div style={{
                            "display": "inline-block",
                            "padding-left": "0.5em",
                            "width": "base em(100px)",
                            "line-height": "base.em(17px)",
                            "font-family": "Verdana, sans-serif",
                            "font-size": "base.em(12px)",
                          }}>
                            {data.materialsContext.materials[id].name}
                          </div>
                        </Table.Cell>
                        <Table.Cell textAlign="center" color={data.materials[id] >= amt? null : "bad"}>
                          {`${amt}${MATERIAL_STORAGE_UNIT_NAME}`}
                        </Table.Cell>
                      </Table.Row>
                    ))
              }
              {props.design.material_parts && Object.entries(props.design.material_parts).map(([name, amt]) => {
                let selected = mats[name];
                let selectedName = (selected && data.materialsContext[selected]?.name) || "Select";
                return (
                  <Table.Row key={name}>
                    <Table.Cell textAlign="center">
                      {name}
                    </Table.Cell>
                    <Table.Cell>
                      <Dropdown
                        width="100%"
                        color="transparent"
                        selected={selectedName}
                        onSelected={(val) => {
                          let newMats = { ...mats };
                          newMats[name] = val;
                          setMats(newMats);
                        }}
                        options={
                          Object.keys(data.materials).map((id) => data.materialsContext.materials[id].name)
                        } />
                    </Table.Cell>
                    <Table.Cell textAlign="center"
                      color={!selected || data.materials[selected] >= amt? null : "bad"}>
                      {`${amt}${MATERIAL_STORAGE_UNIT_NAME}`}
                    </Table.Cell>
                  </Table.Row>
                );
              })}
              {props.design.reagents && (
                Object.entries(props.design.reagents).map(([id, amt]) => (
                  <Table.Row key={id}>
                    <Table.Cell />
                    <Table.Cell>
                      {id}
                    </Table.Cell>
                    <Table.Cell textAlign="center"
                      color={(data.reagents.find((r) => r.id === id)?.amount || 0) >= amt? null : "bad"}>
                      {`${amt}${REAGENT_STORAGE_UNIT_NAME}`}
                    </Table.Cell>
                  </Table.Row>
                ))
              )}
            </Table>
          )}
        </Stack.Item>
      </Stack>
    </Collapsible>
  );
};
