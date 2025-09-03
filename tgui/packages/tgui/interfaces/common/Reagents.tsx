/**
 * Collection of common reagent things.
 *
 * todo: make array a dict instead for fast lookup?
 *
 * @file
 * @license MIT
 */

import { ReactNode } from "react";
import { LabeledList, NoticeBox, Section } from "tgui-core/components";

import { SectionProps } from "../../components";

export const REAGENT_STORAGE_UNIT_NAME = "u";

interface ReagentContentsProps extends SectionProps {
  readonly buttons?: ReactNode;
  readonly reagentButtons?: Function; // called to generate buttons with (id)
  readonly reagents: ReagentContentsData;
}

export type ReagentContentsData = Array<ReagentContentsEntry>;

interface ReagentContentsEntry {
  id: string;
  name: string;
  amount: number;
}

export const ReagentContents = (props: ReagentContentsProps) => {
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
