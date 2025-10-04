import { Fragment, useState } from 'react';
import { Box, Button, Icon, LabeledList, Section, Table } from "tgui-core/components";

import { useBackend } from "../backend";
import { Window } from "../layouts";

const getTagColor = erptag => {
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

export const CharacterDirectory = (props) => {
  const { act, data } = useBackend<any>();

  const {
    personalVisibility,
    personalErpTag,
    personalTag,
  } = data;

  const [overlay, setOverlay] = useState(null);

  return (
    <Window width={640} height={480}>
      <Window.Content scrollable>
        {overlay && (
          <ViewCharacter overlay={overlay} setOverlay={setOverlay} />
        ) || (
            <>
              <Section title="Controls">
                <LabeledList>
                  <LabeledList.Item label="Visibility">
                    <Button
                      fluid
                      content={personalVisibility ? "Shown" : "Not Shown"}
                      onClick={() => act("setVisible")} />
                  </LabeledList.Item>
                  <LabeledList.Item label="ERP Tag">
                    <Button
                      fluid
                      content={personalErpTag}
                      onClick={() => act("setErpTag")} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Vore Tag">
                    <Button
                      fluid
                      content={personalTag}
                      onClick={() => act("setTag")} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Advertisement">
                    <Button
                      fluid
                      content="Edit Ad"
                      onClick={() => act("editAd")} />
                  </LabeledList.Item>
                </LabeledList>
              </Section>
              <CharacterDirectoryList overlay={overlay} setOverlay={setOverlay} />
            </>
          )}
      </Window.Content>
    </Window>
  );
};

const ViewCharacter = (props) => {
  const { overlay, setOverlay } = props;

  return (
    <Section title={overlay.name} buttons={
      <Button
        icon="arrow-left"
        content="Back"
        onClick={() => setOverlay(null)} />
    }>
      <Section title="Species">
        <Box>
          {overlay.species}
        </Box>
      </Section>
      <Section title="ERP Tag">
        <Box p={1} backgroundColor={getTagColor(overlay.erptag)}>
          {overlay.erptag}
        </Box>
      </Section>
      <Section title="Vore Tag">
        <Box>
          {overlay.tag}
        </Box>
      </Section>
      <Section title="Character Ad">
        <Box style={{ wordBreak: "break-all" }} preserveWhitespace>
          {overlay.character_ad || "Unset."}
        </Box>
      </Section>
      <Section title="OOC Notes">
        <Box style={{ wordBreak: "break-all" }} preserveWhitespace>
          {overlay.ooc_notes || "Unset."}
        </Box>
      </Section>
      <Section title="Flavor Text">
        <Box style={{ wordBreak: "break-all" }} preserveWhitespace>
          {overlay.flavor_text || "Unset."}
        </Box>
      </Section>
    </Section>
  );
};

const CharacterDirectoryList = (props) => {
  const { act, data } = useBackend<any>();

  const {
    directory,
  } = data;

  const [sortId, _setSortId] = useState("name");
  const [sortOrder, _setSortOrder] = useState("name");
  const { overlay, setOverlay } = props;

  return (
    <Section title="Directory" buttons={
      <Button
        icon="sync"
        content="Refresh"
        onClick={() => act("refresh")} />
    }>
      <Table>
        <Table.Row bold>
          <SortButton id="name">Name</SortButton>
          <SortButton id="species">Species</SortButton>
          <SortButton id="erptag">ERP Tag</SortButton>
          <SortButton id="tag">Vore Tag</SortButton>
          <Table.Cell collapsing textAlign="right">View</Table.Cell>
        </Table.Row>
        {directory
          .sort((a, b) => {
            const i = sortOrder ? 1 : -1;
            return a[sortId].localeCompare(b[sortId]) * i;
          })
          .map((character, i) => (
            <Table.Row key={i} backgroundColor={getTagColor(character.erptag)}>
              <Table.Cell p={1}>{character.name}</Table.Cell>
              <Table.Cell>{character.species}</Table.Cell>
              <Table.Cell>{character.erptag}</Table.Cell>
              <Table.Cell>{character.tag}</Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Button
                  onClick={() => setOverlay(character)}
                  color="transparent"
                  icon="sticky-note"
                  mr={1}
                  content="View" />
              </Table.Cell>
            </Table.Row>
          ))}
      </Table>
    </Section>
  );
};

const SortButton = (props) => {
  const { act, data } = useBackend<any>();

  const {
    id,
    children,
  } = props;

  // Hey, same keys mean same data~
  const [sortId, setSortId] = useState("name");
  const [sortOrder, setSortOrder] = useState(true);

  return (
    <Table.Cell collapsing>
      <Button
        width="100%"
        color={sortId !== id && "transparent"}
        onClick={() => {
          if (sortId === id) {
            setSortOrder(!sortOrder);
          } else {
            setSortId(id);
            setSortOrder(true);
          }
        }}>
        {children}
        {sortId === id && (
          <Icon
            name={sortOrder ? "sort-up" : "sort-down"}
            ml="0.25rem;"
          />
        )}
      </Button>
    </Table.Cell>
  );
};
