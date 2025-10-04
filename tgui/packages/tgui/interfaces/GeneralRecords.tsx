import { Fragment, useState } from 'react';
import { Box, Button, Icon, Input, LabeledList, Section, Tabs } from "tgui-core/components";
import { createSearch } from 'tgui-core/string';

import { useBackend } from '../backend';
import { Window } from "../layouts";
import { ComplexModal, modalOpen } from "./common/ComplexModal";
import { LoginInfo } from './common/LoginInfo';
import { LoginScreen } from './common/LoginScreen';
import { TemporaryNotice } from './common/TemporaryNotice';

const doEdit = (field) => {
  modalOpen('edit', {
    field: field.edit,
    value: field.value,
  });
};

export const GeneralRecords = (_properties) => {
  const { data } = useBackend<any>();
  const {
    authenticated,
    screen,
  } = data;
  if (!authenticated) {
    return (
      <Window
        width={800}
        height={380}
      >
        <Window.Content>
          <LoginScreen />
        </Window.Content>
      </Window>
    );
  }

  let body;
  if (screen === 2) { // List Records
    body = <GeneralRecordsList />;
  } else if (screen === 3) { // Record Maintenance
    body = <GeneralRecordsMaintenance />;
  } else if (screen === 4) { // View Records
    body = <GeneralRecordsView />;
  }

  return (
    <Window
      width={800}
      height={640}
    >
      <ComplexModal />
      <Window.Content className="Layout__content--flexColumn" scrollable>
        <LoginInfo />
        <TemporaryNotice />
        <GeneralRecordsNavigation />
        <Section height="calc(100% - 5rem)" flexGrow>
          {body}
        </Section>
      </Window.Content>
    </Window>
  );
};

/**
 * Record selector.
 *
 * Filters records, applies search terms and sorts the alphabetically.
 */
const selectRecords = (records: any, searchText = '') => {
  const nameSearch = createSearch<any>(searchText, record => record.name);
  const idSearch = createSearch<any>(searchText, record => record.id);
  const dnaSearch = createSearch<any>(searchText, record => record.b_dna);
  return records
    .filter((record) => !searchText || nameSearch(record) || idSearch(record) || dnaSearch(record));
};

const GeneralRecordsList = (_properties) => {
  const { act, data } = useBackend<any>();

  const [
    searchText,
    setSearchText,
  ] = useState<string>('something');

  const records = selectRecords(data.records, searchText);
  return (
    <>
      <Box mb="0.2rem">
        <Button
          icon="pen"
          content="New Record"
          onClick={() => act('new')} />
      </Box>
      <Input
        fluid
        placeholder="Search by Name, DNA, or ID"
        onChange={(value) => setSearchText(value)} />
      <Box mt="0.5rem">
        {records.map((record, i) => (
          <Button
            key={i}
            icon="user"
            mb="0.5rem"
            content={record.id + ": " + record.name}
            onClick={() => act('d_rec', { d_rec: record.ref })}
          />
        ))}
      </Box>
    </>
  );
};

const GeneralRecordsMaintenance = (_properties) => {
  const { act } = useBackend<any>();
  return (
    <Button.Confirm
      icon="trash"
      content="Delete All Employment Records"
      onClick={() => act('del_all')}
    />
  );
};

const GeneralRecordsView = (_properties) => {
  const { act, data } = useBackend<any>();
  const {
    general,
    printing,
  } = data;
  return (
    <>
      <Section title="General Data" mt="-6px">
        <GeneralRecordsViewGeneral />
      </Section>
      <Section title="Actions">
        <Button.Confirm
          icon="trash"
          disabled={!!general.empty}
          content="Delete Employment Record"
          color="bad"
          onClick={() => act('del_r')}
        />
        <Button
          icon={printing ? 'spinner' : 'print'}
          disabled={printing}
          iconSpin={!!printing}
          content="Print Entry"
          ml="0.5rem"
          onClick={() => act('print_p')}
        /><br />
        <Button
          icon="arrow-left"
          content="Back"
          mt="0.5rem"
          onClick={() => act('screen', { screen: 2 })}
        />
      </Section>
    </>
  );
};

const GeneralRecordsViewGeneral = (_properties) => {
  const { act, data } = useBackend<any>();
  const {
    general,
  } = data;
  if (!general || !general.fields) {
    return (
      <Box color="bad">
        General record lost!
        <Button
          icon="pen"
          content="New Record"
          ml="0.5rem"
          onClick={() => act('new')} />
      </Box>
    );
  }
  return (
    <>
      <Box width="50%" style={{
        float: "left",
      }}>
        <LabeledList>
          {general.fields.map((field, i) => (
            <LabeledList.Item key={i} label={field.field}>
              <Box height="20px" style={{ display: "inline-block" }}>
                {field.value}
              </Box>
              {!!field.edit && (
                <Button
                  icon="pen"
                  ml="0.5rem"
                  onClick={() => doEdit(field)}
                />
              )}
            </LabeledList.Item>
          ))}
        </LabeledList>
        <Section title="Employment/Skills Summary" preserveWhitespace>
          {general.skills || "No data found."}
        </Section>
        <Section title="Comments/Log">
          {general.comments.length === 0 ? (
            <Box color="label">
              No comments found.
            </Box>
          )
            : general.comments.map((comment, i) => (
              <Box key={i}>
                <Box color="label" inline>
                  {comment.header}
                </Box><br />
                {comment.text}
                <Button
                  icon="comment-slash"
                  color="bad"
                  ml="0.5rem"
                  onClick={() => act('del_c', { del_c: i + 1 })}
                />
              </Box>
            ))}

          <Button
            icon="comment"
            content="Add Entry"
            color="good"
            mt="0.5rem"
            mb="0"
            onClick={() => modalOpen('add_c')}
          />
        </Section>
      </Box>
      <Box width="50%" style={{ float: "right" }} textAlign="right">
        {!!general.has_photos && (
          general.photos.map((p, i) => (
            <Box
              key={i}
              style={{ display: "inline-block" }}
              textAlign="center"
              color="label">
              <img
                src={p.substr(1, p.length - 1)}
                style={{
                  width: '96px',
                  marginBottom: "0.5rem",
                  imageRendering: "crisp-edges",
                }}
              /><br />
              Photo #{i + 1}
            </Box>
          ))
        )}
      </Box>
    </>
  );
};

const GeneralRecordsNavigation = (_properties) => {
  const { act, data } = useBackend<any>();
  const {
    screen,
  } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={screen === 2}
        onClick={() => act('screen', { screen: 2 })}>
        <Icon name="list" />
        List Records
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 3}
        onClick={() => act('screen', { screen: 3 })}>
        <Icon name="wrench" />
        Record Maintenance
      </Tabs.Tab>
    </Tabs>
  );
};
