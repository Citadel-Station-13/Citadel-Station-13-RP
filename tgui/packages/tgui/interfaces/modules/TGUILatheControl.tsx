/**
 * todo: implement ingredients
 *
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { ModuleData, useLocalState, useModule } from "../../backend";
import { Box, Button, Collapsible, Dropdown, LabeledList, NoticeBox, NumberInput, ProgressBar, Stack, Table, Tabs } from "../../components";
import { Section, SectionProps } from "../../components/Section";
import { formatSiUnit } from "../../format";
import { Modular } from "../../layouts/Modular";
import { WindowProps } from "../../layouts/Window";
import { Design } from "../common/Design";
import { IngredientsAvailable, IngredientsSelected } from "../common/Ingredients";
import { MaterialRender, MaterialsContext, MaterialStorage, MATERIAL_STORAGE_UNIT_NAME } from "../common/Materials";
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
  queue: Array<LatheQueueEntry>;
  latheName: string;
  speedMultiplier: number;
  powerMultiplier: number;
  dynamicButtons: Record<string, "off" | "on" | "disabled" | null>;
  efficiencyMultiplier: number;
  materials: Record<string, number>;
  materialsContext: MaterialsContext;
  reagents: ReagentContentsData;
  queueActive: BooleanLike;
  // current progress in deciseconds
  progress: number;
  // design ID being printed
  printing: string | null;
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
    width: 1100,
    height: 700,
  };

  const sectionProps: SectionProps = {
    title: `${data.latheName} Control`,
  };

  let resourceRender;

  switch (resourcesSelect) {
    case "Materials":
      resourceRender = (
        <MaterialStorage
          horizontal
          fitted
          m={0.5}
          materialScale={1.5}
          materialList={data.materials}
          materialContext={data.materialsContext}
          eject={(id, amount) => act('ejectMaterial', { id: id, amount: amount })} />
      );
      break;
    case "Reagents":
      resourceRender = (
        <ReagentContents
          mr={0.5}
          ml={0.5}
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

  let queuedMaterials: Record<string, number> = {};
  if (data.queue.length !== 0) {
    data.queue.forEach((entry) => {
      let design = data.designs.instances[entry.design];
      if (design === undefined) {
        return;
      }
      if (design.materials !== null) {
        Object.entries(design.materials).forEach(([id, amt]) => {
          queuedMaterials[id] = (queuedMaterials[id] ?? 0) + amt * entry.amount;
        });
      }
      if (entry.materials !== null && design.material_parts !== null) {
        Object.entries(entry.materials).forEach(([name, id]) => {
          queuedMaterials[id] = (queuedMaterials[id] ?? 0) + ((design.material_parts as {})[name] ?? 0) * entry.amount;
        });
      }
    });
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
        <Stack.Item grow>
          <Stack fluid fill>
            <Stack.Item grow={0.3}>
              <Section fill title="Categories" scrollable>
                <Tabs vertical>
                  {
                    data.designs.categories.sort((c1, c2) => c1.localeCompare(c2)).map((cat) => (
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
            <Stack.Item grow={1.15}>
              <Section fill title="Designs" scrollable>
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
            <Stack.Item grow={0.9}>
              <Stack vertical fill>
                <Stack.Item grow>
                  <Section fill title="Queue" scrollable
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
                          entry={entry} design={data.designs.instances[entry.design]} index={index + 1} />
                      ))
                    }
                  </Section>
                </Stack.Item>
                {
                  Object.keys(queuedMaterials).length !== 0 && (
                    <Stack.Item>
                      <Section title="Material Cost">
                        <MaterialRender
                          ml={0.5}
                          mr={0.5}
                          horizontal
                          materialList={queuedMaterials}
                          materialContext={data.materialsContext}
                          materialButtons={(id) => (
                            ((data.materials[id] ?? 0) < queuedMaterials[id]) && (
                              <Box textColor="bad">
                                {formatSiUnit(queuedMaterials[id] - (data.materials[id] ?? 0))}
                              </Box>
                            )
                          )} />
                      </Section>
                    </Stack.Item>
                  )
                }
              </Stack>
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
  materials: Record<string, string> | null; // key to id
  ingredients: IngredientsSelected | null; // dataset from Ingredients.tsx
}

interface LatheQueuedProps {
  entry: LatheQueueEntry;
  design?: Design;
  index: number;
}

const LatheQueued = (props: LatheQueuedProps, context) => {
  let { data, act } = useModule<TGUILatheControlData>(context);
  let progressRender;
  if (props.index === 1 && data.queueActive && props.design !== undefined) {
    progressRender = (
      <ProgressBar
        position="absolute"
        top={0}
        bottom={0}
        left={0}
        right={0}
        color="#ffffff44"
        value={data.progress / props.design.work} />
    );
  }
  return (
    <Collapsible
      color="transparent"
      title={
        <>
          {`${props.entry.amount}x ${props.design !== undefined? props.design.name : "Error - Design Unloaded"}`}
          {progressRender}
        </>
      }
      buttons={
        <>
          <Button
            color="transparent"
            icon="plus"
            onClick={() => act('modqueue', { index: props.index, amount: props.entry.amount + 1 })} />
          <NumberInput minValue={1} maxValue={100} step={1} width={3}
            value={props.entry.amount} onChange={(e, v) => act('modqueue', { index: props.index, amount: v })} />
          <Button
            color="transparent"
            icon="minus"
            onClick={() => act('modqueue', { index: props.index, amount: props.entry.amount - 1 })} />
          <Button
            color="transparent"
            icon="trash"
            onClick={() => act('dequeue', { index: props.index })} />
        </>
      }>
      {props.design?.materials && (
        <Section title="Base Materials">
          <LabeledList>
            {Object.entries(props.design.materials).map(([k, v]) => (
              <LabeledList.Item key={k} label={k}>
                {`${v}${MATERIAL_STORAGE_UNIT_NAME}`}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      )}
      {props.design?.reagents && (
        <Section title="Base Reagents">
          <LabeledList>
            {Object.entries(props.design.reagents).map(([k, v]) => (
              <LabeledList.Item key={k} label={k}>
                {`${v}${REAGENT_STORAGE_UNIT_NAME}`}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      )}
      {props.entry.materials && (
        <Section title="Material Parts">
          <LabeledList>
            {Object.entries(props.entry.materials).map(([k, v]) => (
              <LabeledList.Item key={k} label={k}>
                {`${props.design?.material_parts?.[k] || "!ERROR! "}${MATERIAL_STORAGE_UNIT_NAME} of ${v}`}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      )}
      {props.entry.ingredients && (
        <Section title="Selected Ingredients">
          <NoticeBox danger>
            Unimplemented - contact a developer!
          </NoticeBox>
        </Section>
      )}
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
            data.queueActive? (
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
                  start: true,
                  materials: mats,
                  items: [],
                })} />
            )
          }
        </>
      )}>
      { (!!props.design.materials || !!props.design.material_parts || !!props.design.reagents) && (
        <Table>
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
    </Collapsible>
  );
};
