/**
 * Collection of common reagent things.
 *
 * todo: make array a dict instead for fast lookup?
 *
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";
import { LabeledList, NoticeBox, Section } from "../../components";
import { SectionProps } from "../../components/Section";

export const REAGENT_STORAGE_UNIT_NAME = "u";

interface ReagentContentsProps extends SectionProps {
  buttons?: InfernoNode;
  reagentButtons?: Function; // called to generate buttons with (id)
  reagents: ReagentContentsData;
}

export type ReagentContentsData = Array<ReagentContentsEntry>;

interface ReagentContentsEntry {
  id: string;
  name: string;
  amount: number;
}

export const ReagentContents = (props: ReagentContentsProps, context) => {
  return (
    <Section {...props}>
      <LabeledList>
        {props.reagents.length === 0 && (
          <NoticeBox>
            Container is empty.
          </NoticeBox>
        )}
        {
          props.reagents.map((reagent) => (
            <LabeledList.Item
              label={reagent.name}
              key={reagent.id}
              buttons={!!props.reagentButtons && props.reagentButtons(reagent.id)}>
              {reagent.amount}u
            </LabeledList.Item>
          ))
        }
      </LabeledList>
    </Section>
  );
};
