/**
 * @file
 * @license MIT
 */

import { Box, LabeledList } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

export interface ResleevingBodyRecordData {
  gender: string | null;
  speciesName: string | null;
  synthetic: BooleanLike;
  name: string | null;
}

export interface ResleevingMindRecordData {
  recordedName: string | null;
}

export interface ResleevingMirrorData {
  activated: BooleanLike;
  bodyRecord: ResleevingBodyRecordData | null;
  mindRecord: ResleevingMindRecordData | null;
}

export const ResleevingBodyRecord = (props: {
  data: ResleevingBodyRecordData;
}) => {
  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Gender">{props.data.gender}</LabeledList.Item>
        <LabeledList.Item label="Species">
          {props.data.speciesName}
        </LabeledList.Item>
        <LabeledList.Item label="Type">
          {props.data.synthetic ? 'Synthetic' : 'Organic'}
        </LabeledList.Item>
      </LabeledList>
    </Box>
  );
};

export const ResleevingMindRecord = (props: {
  data: ResleevingMindRecordData;
}) => {
  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Name">
          {props.data.recordedName}
        </LabeledList.Item>
      </LabeledList>
    </Box>
  );
};

export const ResleevingMirror = (props: { data: ResleevingMirrorData }) => {
  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Activation">
          {props.data.activated ? 'Online' : 'Offline'}
        </LabeledList.Item>
        {props.data.bodyRecord && (
          <>
            <LabeledList.Item label="Name">
              {props.data.bodyRecord.name}
            </LabeledList.Item>
            <LabeledList.Item label="Gender">
              {props.data.bodyRecord.gender}
            </LabeledList.Item>
            <LabeledList.Item label="Species">
              {props.data.bodyRecord.speciesName}
            </LabeledList.Item>
            <LabeledList.Item label="Type">
              {props.data.bodyRecord.synthetic ? 'Synthetic' : 'Organic'}
            </LabeledList.Item>
          </>
        )}
        {props.data.mindRecord && (
          <LabeledList.Item label="Name">
              {props.data.mindRecord.recordedName}
          </LabeledList.Item>
        )}
      </LabeledList>
    </Box>
  );
};
