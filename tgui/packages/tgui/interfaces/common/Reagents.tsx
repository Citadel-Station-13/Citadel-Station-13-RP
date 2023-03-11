/**
 * Collection of common reagent things.
 *
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";
import { LabeledList, NoticeBox, Section } from "../../components";

interface ReagentContentsProps {
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
    <Section buttons={props.buttons}>
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
