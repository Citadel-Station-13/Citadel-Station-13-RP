import { Fragment, useState } from 'react';
import { Box, Button, Input, LabeledList, Section, Stack, Table, Tabs } from "tgui-core/components";

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { useLegacyForceRendering } from '../legacy';

const ResearchConsoleViewResearch = (props) => {
  const { act, data } = useBackend<any>();

  const {
    tech,
  } = data;

  useLegacyForceRendering();

  return (
    <Section title="Current Research Levels" buttons={
      <Button
        icon="print"
        onClick={() => act("print", { print: 1 })}>
        Print This Page
      </Button>
    }>
      <Table>
        {tech.map(thing => (
          <Table.Row key={thing.name}>
            <Table.Cell>
              <Box color="label">{thing.name}</Box>
              <Box> - Level {thing.level}</Box>
            </Table.Cell>
            <Table.Cell>
              <Box color="label">{thing.desc}</Box>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const PaginationTitle = (props) => {
  const { data } = useBackend<any>();

  const {
    title,
    target,
  } = props;

  useLegacyForceRendering();

  let page = data[target];
  if (typeof page === "number") {
    return title + " - Page " + (page + 1);
  }

  return title;
};

const PaginationChevrons = (props) => {
  const { act } = useBackend<any>();

  const {
    target,
  } = props;

  return (
    <>
      <Button
        icon="undo"
        onClick={() => act(target, { reset: true })} />
      <Button
        icon="chevron-left"
        onClick={() => act(target, { reverse: -1 })} />
      <Button
        icon="chevron-right"
        onClick={() => act(target, { reverse: 1 })} />
    </>
  );
};

const ResearchConsoleViewDesigns = (props) => {
  const { act, data } = useBackend<any>();

  const {
    designs,
  } = data;

  useLegacyForceRendering();

  return (
    <Section title={<PaginationTitle title="Researched Technologies & Designs" target="design_page" />} buttons={
      <>
        <Button
          icon="print"
          onClick={() => act("print", { print: 2 })}>
          Print This Page
        </Button>
        <PaginationChevrons target={"design_page"} />
      </>
    }>
      <Input
        fluid
        placeholder="Search for..."
        value={data.search}
        onChange={(v) => act("search", { search: v })}
        mb={1} />
      {(designs && designs.length && (
        <LabeledList>
          {designs.map(design => (
            <LabeledList.Item label={design.name} key={design.name}>
              {design.desc}
            </LabeledList.Item>
          ))}
        </LabeledList>
      )) || (
          <Box color="warning">No designs found.</Box>
        )}
    </Section>
  );
};

const TechDisk = (props) => {
  const { act, data } = useBackend<any>();

  const {
    tech,
  } = data;

  const {
    disk,
  } = props;

  if (!disk || !disk.present) {
    return null;
  }

  const [saveDialog, setSaveDialog] = useState(false);

  if (saveDialog) {
    return (
      <Section title="Inserted Technology Disk">
        <Section title="Load Technology to Disk" buttons={
          <Button
            icon="arrow-left"
            content="Back"
            onClick={() => setSaveDialog(false)} />
        }>
          <LabeledList>
            {tech.map(level => (
              <LabeledList.Item label={level.name} key={level.name}>
                <Button
                  icon="save"
                  onClick={() => {
                    setSaveDialog(false);
                    act("copy_tech", { copy_tech_ID: level.id });
                  }}>
                  Copy To Disk
                </Button>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Section>
    );
  }

  useLegacyForceRendering();

  return (
    <Section title="Inserted Technology Disk">
      <Box>
        <LabeledList>
          <LabeledList.Item label="Disk Contents">
            (Technology Data Disk)
          </LabeledList.Item>
        </LabeledList>
        {disk.stored && (
          <Box mt={2}>
            <Box>
              {disk.name}
            </Box>
            <Box>
              Level: {disk.level}
            </Box>
            <Box>
              Description: {disk.desc}
            </Box>
            <Box mt={1}>
              <Button
                icon="save"
                onClick={() => act("updt_tech")}>
                Upload to Database
              </Button>
              <Button
                icon="trash"
                onClick={() => act("clear_tech")}>
                Clear Disk
              </Button>
              <Button
                icon="eject"
                onClick={() => act("eject_tech")}>
                Eject Disk
              </Button>
            </Box>
          </Box>
        ) || (
            <Box>
              <Box>
                This disk has no data stored on it.
              </Box>
              <Button
                icon="save"
                onClick={() => setSaveDialog(true)}>
                Load Tech To Disk
              </Button>
              <Button
                icon="eject"
                onClick={() => act("eject_tech")}>
                Eject Disk
              </Button>
            </Box>
          )}
      </Box>
    </Section>
  );
};

const DataDisk = (props) => {
  const { act, data } = useBackend<any>();

  const {
    designs,
  } = data;

  const {
    disk,
  } = props;

  if (!disk || !disk.present) {
    return null;
  }

  const [saveDialog, setSaveDialog] = useState(false);

  if (saveDialog) {
    act("push_design_data");
    return (
      <Section title={`Inserted Design Disk (${disk.design_count}/${disk.design_cap} stored)`}>
        <Section
          title={<PaginationTitle title="Load Design to Disk" target="design_page" />}
          buttons={
            <>
              <Button
                icon="arrow-left"
                content="Back"
                onClick={() => setSaveDialog(false)} />
              <PaginationChevrons target={"design_page"} />
            </>
          }>
          <Input
            fluid
            placeholder="Search for..."
            value={data.search}
            onChange={(v) => act("search", { search: v })}
            mb={1} />
          <LabeledList>
            {designs.map(item => (
              <LabeledList.Item label={item.name} key={item.name}>
                <Button
                  icon="save"
                  onClick={() => {
                    setSaveDialog(false);
                    act("copy_design", { copy_design_ID: item.id });
                  }}>
                  Copy To Disk
                </Button>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Section>
    );
  }

  useLegacyForceRendering();

  return (
    <Section title={`Inserted Design Disk (${disk.design_count}/${disk.design_cap} stored)`}>
      <Box>
        {disk.stored && (
          <Stack vertical fill>
            {disk.ids.map((disk_id) => (
              <Stack.Item key={disk_id}>
                <Box>
                  <LabeledList>
                    <LabeledList.Item label="Name">
                      {disk.names[disk_id]}
                    </LabeledList.Item>
                    <LabeledList.Item label="Lathe Type">
                      {disk.build_types[disk_id]}
                    </LabeledList.Item>
                    <LabeledList.Item label="Required Materials">
                      {Object.keys(disk.materials[disk_id]).map(mat => (
                        <Box key={mat}>
                          {mat} x {disk.materials[disk_id][mat]}
                        </Box>
                      ))}
                    </LabeledList.Item>
                  </LabeledList>
                  <Box mt={1}>
                    <Button
                      icon="save"
                      onClick={() => act("updt_design", { design: disk_id })}>
                      Upload to Database
                    </Button>
                    {(disk.design_cap < disk.design_count) &&
                      <Button
                        icon="save"
                        onClick={() => setSaveDialog(true)}>
                        Load Design To Disk
                      </Button>
                    }
                    <Button
                      icon="trash"
                      onClick={() => act("clear_design", { design: disk_id })}>
                      Clear Disk
                    </Button>
                    <Button
                      icon="eject"
                      onClick={() => act("eject_design")}>
                      Eject Disk
                    </Button>
                  </Box>
                </Box>
              </Stack.Item>
            ))}
          </Stack>
        ) || (
            <Box>
              <Box>
                <Box mb={0.5}>
                  This disk has no data stored on it.
                </Box>
                <Button
                  icon="save"
                  onClick={() => setSaveDialog(true)}>
                  Load Design To Disk
                </Button>
                <Button
                  icon="eject"
                  onClick={() => act("eject_design")}>
                  Eject Disk
                </Button>
              </Box>
              <Button
                icon="save"
                onClick={() => setSaveDialog(true)}>
                Load Design To Disk
              </Button>
              <Button
                icon="eject"
                onClick={() => act("eject_design")}>
                Eject Disk
              </Button>
            </Box>
          )}
      </Box>
    </Section >
  );
};

const ResearchConsoleDisk = (props) => {
  const { act, data } = useBackend<any>();

  const {
    d_disk,
    t_disk,
  } = data.info;

  useLegacyForceRendering();

  if (!d_disk.present && !t_disk.present) {
    return (
      <Section title="Disk Operations">
        No disk inserted.
      </Section>
    );
  }

  return (
    <Section title="Disk Operations">
      <TechDisk disk={t_disk} />
      <DataDisk disk={d_disk} />
    </Section>
  );
};

const ResearchConsoleDestructiveAnalyzer = (props) => {
  const { act, data } = useBackend<any>();

  const {
    linked_destroy,
  } = data.info;

  if (!linked_destroy.present) {
    return (
      <Section title="Destructive Analyzer">
        No destructive analyzer found.
      </Section>
    );
  }

  const {
    loaded_item,
    origin_tech,
  } = linked_destroy;

  useLegacyForceRendering();

  return (
    <Section title="Destructive Analyzer">
      {loaded_item && (
        <Box>
          <LabeledList>
            <LabeledList.Item label="Name">
              {loaded_item}
            </LabeledList.Item>
            <LabeledList.Item label="Origin Tech">
              <LabeledList>
                {origin_tech.length && origin_tech.map(tech => (
                  <LabeledList.Item label={tech.name} key={tech.name}>
                    {tech.level}&nbsp;&nbsp;{tech.current && "(Current: " + tech.current + ")"}
                  </LabeledList.Item>
                )) || (
                    <LabeledList.Item label="Error">
                      No origin tech found.
                    </LabeledList.Item>
                  )}
              </LabeledList>
            </LabeledList.Item>
          </LabeledList>
          <Button
            mt={1}
            color="red"
            icon="eraser"
            onClick={() => act("deconstruct")}>
            Deconstruct Item
          </Button>
          <Button
            icon="eject"
            onClick={() => act("eject_item")}>
            Eject Item
          </Button>
        </Box>
      ) || (
          <Box>
            No Item Loaded. Standing-by...
          </Box>
        )}
    </Section>
  );
};

const ResearchConsoleSettings = (props) => {
  const { act, data } = useBackend<any>();

  const {
    sync,
    linked_destroy,
    linked_imprinter,
    linked_lathe,
  } = data.info;

  const [settingsTab, setSettingsTab] = useState(0);

  useLegacyForceRendering();

  return (
    <Section title="Settings">
      <Tabs>
        <Tabs.Tab
          icon="cogs"
          onClick={() => setSettingsTab(0)}
          selected={settingsTab === 0}>
          General
        </Tabs.Tab>
        <Tabs.Tab
          icon="link"
          onClick={() => setSettingsTab(1)}
          selected={settingsTab === 1}>
          Device Linkages
        </Tabs.Tab>
      </Tabs>
      {settingsTab === 0 && (
        <Box>
          {sync && (
            <>
              <Button
                fluid
                icon="sync"
                onClick={() => act("sync")}>
                Sync Database with Network
              </Button>
              <Button
                fluid
                icon="unlink"
                onClick={() => act("togglesync")}>
                Disconnect from Research Network
              </Button>
            </>
          ) || (
              <Button
                fluid
                icon="link"
                onClick={() => act("togglesync")}>
                Connect to Research Network
              </Button>
            )}
          <Button
            fluid
            icon="lock"
            onClick={() => act("lock")}>
            Lock Console
          </Button>
          <Button
            fluid
            color="red"
            icon="trash"
            onClick={() => act("reset")}>
            Reset R&D Database
          </Button>
        </Box>
      ) || settingsTab === 1 && (
        <Box>
          <Button
            fluid
            icon="sync"
            mb={1}
            onClick={() => act("find_device")}>
            Re-sync with Nearby Devices
          </Button>
          <LabeledList>
            {linked_destroy.present && (
              <LabeledList.Item label="Destructive Analyzer">
                <Button
                  icon="unlink"
                  onClick={() => act("disconnect", { disconnect: "destroy" })}>
                  Disconnect
                </Button>
              </LabeledList.Item>
            ) || null}
            {linked_lathe.present && (
              <LabeledList.Item label="Protolathe">
                <Button
                  icon="unlink"
                  onClick={() => act("disconnect", { disconnect: "lathe" })}>
                  Disconnect
                </Button>
              </LabeledList.Item>
            ) || null}
            {linked_imprinter.present && (
              <LabeledList.Item label="Circuit Imprinter">
                <Button
                  icon="unlink"
                  onClick={() => act("disconnect", { disconnect: "imprinter" })}>
                  Disconnect
                </Button>
              </LabeledList.Item>
            ) || null}
          </LabeledList>
        </Box>
      ) || (
          <Box>
            Error
          </Box>
        )}
    </Section>
  );
};

export const ResearchConsoleProtolathe = (props) => {
  const { act, data } = useBackend<any>();

  const {
    sync,
    linked_destroy,
    linked_imprinter,
    linked_lathe,
  } = data.info;

  useLegacyForceRendering();

  if (!linked_lathe.present) {
    return (
      <Section title="Protolathe">
        No protolathe found.
      </Section>
    );
  }
  return (
    <Section title="Protolathe">
      <Button
        fluid
        icon="link"
        onClick={() => act("access_lathe")}>
        Open Lathe Remote Interface
      </Button>
    </Section>
  );
};

export const ResearchConsoleImprinter = (props) => {
  const { act, data } = useBackend<any>();

  const {
    sync,
    linked_destroy,
    linked_imprinter,
    linked_lathe,
  } = data.info;

  useLegacyForceRendering();

  if (!linked_imprinter.present) {
    return (
      <Section title="Circuit Imprinter">
        No circuit imprinter found.
      </Section>
    );
  }
  return (
    <Section title="Circuit Imprinter">
      <Button
        fluid
        icon="link"
        onClick={() => act("access_imprinter")}>
        Open Circuit Imprinter Remote Interface
      </Button>
    </Section>
  );
};

const menus = [
  { name: "Protolathe", icon: "wrench", template: <ResearchConsoleProtolathe name="Protolathe" /> },
  {
    name: "Circuit Imprinter",
    icon: "digital-tachograph",
    template: <ResearchConsoleImprinter name="Circuit Imprinter" />,
  },
  { name: "Destructive Analyzer", icon: "eraser", template: <ResearchConsoleDestructiveAnalyzer /> },
  { name: "Settings", icon: "cog", template: <ResearchConsoleSettings /> },
  { name: "Research List", icon: "flask", template: <ResearchConsoleViewResearch /> },
  { name: "Design List", icon: "file", template: <ResearchConsoleViewDesigns /> },
  { name: "Disk Operations", icon: "save", template: <ResearchConsoleDisk /> },
];

export const ResearchConsole = (props) => {
  const { act, data } = useBackend<any>();

  const {
    busy_msg,
    locked,
  } = data;

  const [menu, setMenu] = useState(0);

  let allTabsDisabled = false;
  if (locked) {
    allTabsDisabled = true;
  }

  return (
    <Window width={850} height={630}>
      <Window.Content scrollable>
        <Tabs>
          {menus.map((obj, i) => (
            <Tabs.Tab
              key={i}
              icon={obj.icon}
              selected={menu === i}
              onClick={() => setMenu(i)}>
              {obj.name}
            </Tabs.Tab>
          ))}
        </Tabs>
        {locked && (
          <Section title="Console Locked">
            <Button
              onClick={() => act("lock")}
              icon="lock-open">
              Unlock
            </Button>
          </Section>
        ) || menus[menu].template}
      </Window.Content>
    </Window>
  );
};
