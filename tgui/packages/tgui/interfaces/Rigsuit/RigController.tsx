import { RigsuitData } from ".";
import { LabeledList, NoticeBox, ProgressBar, Section, Stack } from "../../components";

export interface RigControllerProps {
  rig: RigsuitData;
}

export const RigController = (props: RigControllerProps, context) => {
  return (
    <Section fill>
      <Stack fill vertical>
        <Stack.Item>
          <Stack fill>
            <Stack.Item grow={1}>
              <Section title="Pieces">
                <Stack vertical>
                {props.rig.pieceRefs.map((ref) => {
                  <Stack.Item key={ref}>
                    {ref}
                  </Stack.Item>
                })}
                </Stack>
              </Section>
            </Stack.Item>
            <Stack.Item grow={1}>
              <Section title="Systems">
              <LabeledList>
                <LabeledList.Item label="Systems">
                  <div color='red'>Unknown</div>
                </LabeledList.Item>
                <LabeledList.Item label="Energy">
                  <ProgressBar value={1}>100%</ProgressBar>
                </LabeledList.Item>
              </LabeledList>
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow={1}>
          <Section fill>
            <NoticeBox warning>Module system currently under construction.</NoticeBox>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
