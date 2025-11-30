import { Fragment } from 'react';
import { Box, Button, Collapsible, Icon, Input, LabeledList, Section, Tabs } from "tgui-core/components";

import { useBackend } from "../backend";
import { Window } from "../layouts";
import { ComplexModal, modalOpen, modalRegisterBodyOverride } from "./common/ComplexModal";
import { LoginInfo } from './common/LoginInfo';
import { LoginScreen } from './common/LoginScreen';
import { TemporaryNotice } from './common/TemporaryNotice';

const severities = {
  "Minor": "good",
  "Medium": "average",
  "Dangerous!": "bad",
  "Harmful": "bad",
  "BIOHAZARD THREAT!": "bad",
};

const doEdit = (field) => {
  modalOpen('edit', {
    field: field.edit,
    value: field.value,
  });
};

const virusModalBodyOverride = (modal) => {
  const { act } = useBackend<any>();
  const virus = modal.args;
  return (
    <Section
      m="-1rem"
      title={virus.name || "Virus"}
      buttons={
        <Button
          icon="times"
          color="red"
          onClick={() => act('modal_close')} />
      }>
      <Box mx="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Spread">
            {virus.spread_text} Transmission
          </LabeledList.Item>
          <LabeledList.Item label="Possible cure">
            {virus.antigen}
          </LabeledList.Item>
          <LabeledList.Item label="Rate of Progression">
            {virus.rate}
          </LabeledList.Item>
          <LabeledList.Item label="Antibiotic Resistance">
            {virus.resistance}%
          </LabeledList.Item>
          <LabeledList.Item label="Species Affected">
            {virus.species}
          </LabeledList.Item>
          <LabeledList.Item label="Symptoms">
            <LabeledList>
              {virus.symptoms.map(s => (
                <LabeledList.Item key={s.stage} label={s.stage + ". " + s.name}>
                  <Box inline color="label">Strength:</Box> {s.strength}&nbsp;
                  <Box inline color="label">Aggressiveness:</Box> {s.aggressiveness}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Section>
  );
};

export const MedicalRecords = (_properties) => {
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
    body = <MedicalRecordsList />;
  } else if (screen === 3) { // Record Maintenance
    body = <MedicalRecordsMaintenance />;
  } else if (screen === 4) { // View Records
    body = <MedicalRecordsView />;
  } else if (screen === 5) { // Virus Database
    body = <MedicalRecordsViruses />;
  } else if (screen === 6) { // Medibot Tracking
    body = <MedicalRecordsMedibots />;
  }

  return (
    <Window
      width={800}
      height={380}
    >
      <ComplexModal maxHeight="100%" maxWidth="80%" />
      <Window.Content className="Layout__content--flexColumn" scrollable>
        <LoginInfo />
        <TemporaryNotice />
        <MedicalRecordsNavigation />
        <Section height="calc(100% - 5rem)" flexGrow>
          {body}
        </Section>
      </Window.Content>
    </Window>
  );
};

const MedicalRecordsList = (_properties) => {
  const { act, data } = useBackend<any>();
  const {
    records,
  } = data;
  return (
    <>
      <Input
        fluid
        placeholder="Search by Name, DNA, or ID"
        onChange={(value) => act('search', { t1: value })}
      />
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

const MedicalRecordsMaintenance = (_properties) => {
  const { act } = useBackend<any>();
  return (
    <>
      <Button
        icon="download"
        content="Backup to Disk"
        disabled
      /><br />
      <Button
        icon="upload"
        content="Upload from Disk"
        my="0.5rem"
        disabled
      /> <br />
      <Button.Confirm
        icon="trash"
        content="Delete All Medical Records"
        onClick={() => act('del_all')}
      />
    </>
  );
};

const MedicalRecordsView = (_properties) => {
  const { act, data } = useBackend<any>();
  const {
    medical,
    printing,
  } = data;
  return (
    <>
      <Section title="General Data" mt="-6px">
        <MedicalRecordsViewGeneral />
      </Section>
      <Section title="Medical Data">
        <MedicalRecordsViewMedical />
      </Section>
      <Section title="Actions">
        <Button.Confirm
          icon="trash"
          disabled={!!medical.empty}
          content="Delete Medical Record"
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

const MedicalRecordsViewGeneral = (_properties) => {
  const { data } = useBackend<any>();
  const {
    general,
  } = data;
  if (!general || !general.fields) {
    return (
      <Box color="bad">
        General records lost!
      </Box>
    );
  }
  return (
    <>
      <Box width="50%" style={{ float: "left" }}>
        <LabeledList>
          {general.fields.map((field, i) => (
            <LabeledList.Item key={i} label={field.field}>
              <Box height="20px" style={{ display: "inline-block" }} preserveWhitespace>
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
      </Box>
      <Box width="50%" textAlign="right" style={{ float: "right" }}>
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
                  marginBottom: '0.5rem',
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

const MedicalRecordsViewMedical = (_properties) => {
  const { act, data } = useBackend<any>();
  const {
    medical,
  } = data;
  if (!medical || !medical.fields) {
    return (
      <Box color="bad">
        Medical records lost!
        <Button
          icon="pen"
          content="New Record"
          ml="0.5rem"
          onClick={() => act('new')}
        />
      </Box>
    );
  }
  return (
    <>
      <LabeledList>
        {medical.fields.map((field, i) => (
          <LabeledList.Item
            key={i}
            label={field.field} preserveWhitespace>
            {field.value}
            <Button
              icon="pen"
              ml="0.5rem"
              mb={field.line_break ? '1rem' : 'initial'}
              onClick={() => doEdit(field)}
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Section title="Medical Notes Summary" preserveWhitespace>
        {medical.notes || "No data found."}
      </Section>
      <Section title="Comments/Log">
        {medical.comments.length === 0 ? (
          <Box color="label">
            No comments found.
          </Box>
        )
          : medical.comments.map((comment, i) => (
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
          icon="comment-medical"
          content="Add Entry"
          color="good"
          mt="0.5rem"
          mb="0"
          onClick={() => modalOpen('add_c')}
        />
      </Section>
    </>
  );
};

const MedicalRecordsViruses = (_properties) => {
  const { act, data } = useBackend<any>();
  const {
    virus,
  } = data;
  virus.sort((a, b) => a.name > b.name ? 1 : -1);
  return virus.map((vir, i) => (
    <Fragment key={i}>
      <Button
        icon="flask"
        content={vir.name}
        mb="0.5rem"
        onClick={() => act('vir', { vir: vir.D })}
      />
      <br />
    </Fragment>
  ));
};

const MedicalRecordsMedibots = (_properties) => {
  const { data } = useBackend<any>();
  const {
    medibots,
  } = data;
  if (medibots.length === 0) {
    return (
      <Box color="label">
        There are no Medibots.
      </Box>
    );
  }
  return medibots.map((medibot, i) => (
    <Collapsible
      key={i}
      open
      title={medibot.name}>
      <Box px="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Location">
            {medibot.area || 'Unknown'} ({medibot.x}, {medibot.y})
          </LabeledList.Item>
          <LabeledList.Item label="Status">
            {medibot.on ? (
              <>
                <Box color="good">
                  Online
                </Box>
                <Box mt="0.5rem">
                  {medibot.use_beaker
                    ? ("Reservoir: "
                      + medibot.total_volume + "/" + medibot.maximum_volume)
                    : "Using internal synthesizer."}
                </Box>
              </>
            ) : (
              <Box color="average">
                Offline
              </Box>
            )}
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Collapsible>
  ));
};

const MedicalRecordsNavigation = (_properties) => {
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
        selected={screen === 5}
        onClick={() => act('screen', { screen: 5 })}>
        <Icon name="database" />
        Virus Database
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 6}
        onClick={() => act('screen', { screen: 6 })}>
        <Icon name="plus-square" />
        Medibot Tracking
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

modalRegisterBodyOverride('virus', virusModalBodyOverride);
