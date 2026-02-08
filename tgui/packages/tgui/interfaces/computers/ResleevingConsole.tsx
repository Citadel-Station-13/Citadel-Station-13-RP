/**
 * @file
 * @license MIT
 */

import { BooleanLike } from 'tgui-core/react';
import {
  ResleevingBodyRecordData,
  ResleevingMirror,
  ResleevingMirrorData,
} from '../common/Resleeving';
import { Window } from '../../layouts';
import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Dimmer,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { useState } from 'react';
import { recallWindowGeometry } from '../../drag';
import { round } from 'tgui-core/math';

interface ResleevingDiskData {
  valid: BooleanLike;
  name: string;
}

interface LinkedSleever {
  ref: string;
  name: string;
  occupied: null | {
    name: string;
    hasMind: BooleanLike;
    compatibleWithMirror: BooleanLike;
    stat: 'conscious' | 'dead' | 'unconscious';
  };
  mirror: null | ResleevingMirrorData;
}

interface LinkedPrinter {
  ref: string;
  name: string;
  busy: null | {
    record: ResleevingBodyRecordData;
    progressRatio: number;
  };
  allowOrganic: BooleanLike;
  allowSynthetic: BooleanLike;
}

interface BodyRecord {
  name: string;
  synthetic: BooleanLike;
  ref: string;
  source: string;
}

interface ResleevingConsoleContext {
  insertedMirror: ResleevingMirrorData | null;
  insertedDisk: ResleevingDiskData | null;
  relinkOnCooldown: BooleanLike;
  bodyRecords: BodyRecord[];
  sleevePods: LinkedSleever[];
  bodyPrinters: LinkedPrinter[];
}

export const ResleevingConsole = (props) => {
  const { act, data } = useBackend<ResleevingConsoleContext>();
  const [selectedBodyRecord, setSelectedBodyRecord] = useState<string | null>(
    null,
  );
  const isSelectedBodyRecordValid = !!data.bodyRecords.find(
    (v) => v.ref === selectedBodyRecord,
  );
  return (
    <Window title="Resleeving Console" width={500} height={400}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow={1}>
            <Stack vertical fill>
              <Stack.Item>
                <Section
                  fill
                  title="Inserted Mirror"
                  buttons={
                    <Button.Confirm
                      disabled={!data.insertedMirror}
                      onClick={() => act('removeMirror')}
                    >
                      Eject
                    </Button.Confirm>
                  }
                >
                  {data.insertedMirror ? (
                    <ResleevingMirror
                      data={data.insertedMirror}
                    ></ResleevingMirror>
                  ) : (
                    <NoticeBox>No mirror inserted</NoticeBox>
                  )}
                </Section>
              </Stack.Item>
              <Stack.Item grow={1}>
                <Section fill title="Available Body Records" scrollable>
                  <Stack vertical>
                    {data.bodyRecords.map((rec) => (
                      <Stack.Item key={rec.ref}>
                        <Box>
                          <Stack vertical>
                            <Stack.Item>
                              <LabeledList>
                                <LabeledList.Item label="Name">
                                  {rec.name}
                                </LabeledList.Item>
                                <LabeledList.Item label="Source">
                                  {rec.source}
                                </LabeledList.Item>
                                <LabeledList.Item label="Type">
                                  {rec.synthetic ? 'Synthetic' : 'Organic'}
                                </LabeledList.Item>
                              </LabeledList>
                            </Stack.Item>
                            <Stack.Item>
                              <Button
                                onClick={() => setSelectedBodyRecord(rec.ref)}
                                selected={selectedBodyRecord === rec.ref}
                                fluid
                              >
                                {selectedBodyRecord === rec.ref
                                  ? 'Selected'
                                  : 'Select'}
                              </Button>
                            </Stack.Item>
                          </Stack>
                        </Box>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Stack vertical fill>
              <Stack.Item>
                <Stack.Item>
                  <Section
                    fill
                    title="Inserted Disk"
                    buttons={
                      <Button.Confirm
                        disabled={!data.insertedDisk}
                        onClick={() => act('removeDisk')}
                      >
                        Eject
                      </Button.Confirm>
                    }
                  >
                    {data.insertedDisk ? (
                      <Box>
                        <LabeledList>
                          <LabeledList.Item label="Name">
                            {data.insertedDisk.name}
                          </LabeledList.Item>
                          <LabeledList.Item label="Printable">
                            {data.insertedDisk.valid}
                          </LabeledList.Item>
                        </LabeledList>
                      </Box>
                    ) : (
                      <NoticeBox>No DNA disk inserted</NoticeBox>
                    )}
                  </Section>
                </Stack.Item>
              </Stack.Item>
              <Stack.Item grow>
                <Section
                  fill
                  title="Machines"
                  buttons={
                    <Button.Confirm
                      disabled={data.relinkOnCooldown}
                      onClick={() => act('relink')}
                    >
                      Relink
                    </Button.Confirm>
                  }
                  scrollable
                >
                  <Stack vertical>
                    {data.bodyPrinters.map((printer) => {
                      return (
                        <Stack.Item key={printer.ref}>
                          <Box
                            style={{
                              borderLeft: '1px solid #ffffff',
                              borderRight: '1px solid #ffffff',
                            }}
                          >
                            <Stack vertical fill>
                              <Stack.Item>
                                <Stack>
                                  <Stack.Item grow>
                                    <h3 style={{ textAlign: 'center' }}>
                                      {printer.name}
                                    </h3>
                                  </Stack.Item>
                                  <Stack.Item>
                                    <Button.Confirm
                                      onClick={() =>
                                        act('unlink', {
                                          unlinkRef: printer.ref,
                                        })
                                      }
                                      icon="trash"
                                    ></Button.Confirm>
                                  </Stack.Item>
                                </Stack>
                              </Stack.Item>
                              <Stack.Item>
                                <LabeledList>
                                  <LabeledList.Item label="Status">
                                    {printer.busy
                                      ? `Producing record of species ${printer.busy.record.speciesName} %${round(printer.busy.progressRatio * 100, 0.1)}`
                                      : 'Standby'}
                                  </LabeledList.Item>
                                  <LabeledList.Item label="Supports Organics">
                                    {printer.allowOrganic ? 'Yes' : 'No'}
                                  </LabeledList.Item>
                                  <LabeledList.Item label="Supports Syntehtics">
                                    {printer.allowSynthetic ? 'Yes' : 'No'}
                                  </LabeledList.Item>
                                </LabeledList>
                              </Stack.Item>
                              <Stack.Item>
                                <Button.Confirm
                                  fluid
                                  disabled={
                                    !!printer.busy || !isSelectedBodyRecordValid
                                  }
                                >
                                  {printer.busy
                                    ? 'Busy'
                                    : !isSelectedBodyRecordValid
                                      ? 'Select Body Record'
                                      : 'Print'}
                                </Button.Confirm>
                              </Stack.Item>
                            </Stack>
                          </Box>
                        </Stack.Item>
                      );
                    })}
                    {data.sleevePods.map((pod) => {
                      return (
                        <Stack.Item key={pod.ref}>
                          <Box
                            style={{
                              borderLeft: '1px solid #ffffff',
                              borderRight: '1px solid #ffffff',
                            }}
                          >
                            <Stack vertical fill>
                              <Stack.Item>
                                <Stack>
                                  <Stack.Item grow>
                                    <h3 style={{ textAlign: 'center' }}>
                                      {pod.name}
                                    </h3>
                                  </Stack.Item>
                                  <Stack.Item>
                                    <Button.Confirm
                                      onClick={() =>
                                        act('unlink', { unlinkRef: pod.ref })
                                      }
                                      icon="trash"
                                    ></Button.Confirm>
                                  </Stack.Item>
                                </Stack>
                              </Stack.Item>
                              <Stack.Item>
                                {pod.occupied ? (
                                  <LabeledList>
                                    <LabeledList.Item label="Occupant">
                                      {pod.occupied.name}
                                    </LabeledList.Item>
                                    <LabeledList.Item label="Mind Imprinted">
                                      {pod.occupied.hasMind
                                        ? 'Active'
                                        : 'Empty'}
                                    </LabeledList.Item>
                                    <LabeledList.Item label="Supports Mirrors">
                                      {pod.occupied.compatibleWithMirror
                                        ? 'Yes'
                                        : 'No'}
                                    </LabeledList.Item>
                                    <LabeledList.Item label="Status">
                                      {pod.occupied.stat === 'conscious'
                                        ? 'Conscious'
                                        : pod.occupied.stat === 'dead'
                                          ? 'Dead'
                                          : 'Unconscious'}
                                    </LabeledList.Item>
                                  </LabeledList>
                                ) : (
                                  <Dimmer>
                                    <NoticeBox>No inserted occupant</NoticeBox>
                                  </Dimmer>
                                )}
                              </Stack.Item>
                              <Stack.Item>
                                <Button.Confirm
                                  fluid
                                  disabled={!pod.mirror || !pod.occupied}
                                >
                                  {!pod.mirror
                                    ? 'Insert Mirror'
                                    : !pod.occupied
                                      ? 'Insert Occupant'
                                      : 'Sleeve'}
                                </Button.Confirm>
                              </Stack.Item>
                            </Stack>
                          </Box>
                        </Stack.Item>
                      );
                    })}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
