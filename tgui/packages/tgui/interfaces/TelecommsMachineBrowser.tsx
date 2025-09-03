import { Fragment } from 'react';
import { Box, Button, LabeledList, NoticeBox, Section } from "tgui-core/components";

import { useBackend } from "../backend";
import { Window } from "../layouts";

export const TelecommsMachineBrowser = (props) => {
  const { act, data } = useBackend<any>();

  const {
    network,
    temp,
    machinelist,
    selectedMachine,
  } = data;

  return (
    <Window
      width={575}
      height={450}
    >
      <Window.Content scrollable>
        {(temp && temp.length) ? (
          <NoticeBox>
            <Box style={{ display: "inline-box" }} verticalAlign="middle">
              {temp}
            </Box>
            <Button
              icon="times-circle"
              style={{ float: "right" }}
              onClick={() => act('cleartemp')} />
            <Box style={{ clear: "both" }} />
          </NoticeBox>
        ) : null}
        <Section title="Network Control">
          <LabeledList>
            <LabeledList.Item
              label="Current Network"
              buttons={(
                <>
                  <Button
                    icon="search"
                    content="Probe Network"
                    onClick={() => act("scan")} />
                  <Button
                    color="bad"
                    icon="exclamation-triangle"
                    content="Flush Buffer"
                    disabled={machinelist.length === 0}
                    onClick={() => act('release')} />
                </>
              )}>
              <Button
                content={network}
                icon="pen"
                onClick={() => act('network')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {(machinelist && machinelist.length) ? (
          <TelecommsBrowser
            title={selectedMachine
              ? selectedMachine.name
              + " (" + selectedMachine.id + ")"
              : "Detected Network Entities"}
            list={selectedMachine ? selectedMachine.links : machinelist}
            showBack={selectedMachine} />
        ) : (
          <Section title="No Devices Found">
            <Button
              icon="search"
              content="Probe Network"
              onClick={() => act("scan")} />
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

const TelecommsBrowser = (props) => {
  const { act, data } = useBackend<any>();

  const {
    list,
    title,
    showBack,
  } = props;

  return (
    <Section
      title={title}
      buttons={showBack && (
        <Button
          icon="undo"
          content="Back to Main Menu"
          onClick={() => act("mainmenu")} />
      )}>
      <Box color="label"><u>Linked entities</u></Box>
      <LabeledList>
        {list.length ? list.map(machine => (
          <LabeledList.Item
            key={machine.id}
            label={machine.name + " (" + machine.id + ")"}>
            <Button
              content="View"
              icon="eye"
              onClick={() => act("view", { id: machine.id })} />
          </LabeledList.Item>
        )) : (
          <LabeledList.Item color="bad">
            No links detected.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
