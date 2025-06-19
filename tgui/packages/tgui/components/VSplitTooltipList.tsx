/**
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";
import { BoxProps } from "./Box";
import { Table, TableCellProps } from "./Table";
import { Button } from "./Button";

/**
 * A vertical list to render a split left-right set of options, with an optional
 * aligned description on the left. Very useful for things like configuration lists.
 */
export const VSplitTooltipList = (props: {
  leftSideWidthPercent: number;
} & BoxProps, context) => {
  const {
    leftSideWidthPercent,
    children,
    ...rest
  } = props;

  let remainingWidthPercent = 100 - leftSideWidthPercent;

  return (
    <Table {...rest}>
      <Table.Row>
        <Table.Cell width={`${leftSideWidthPercent}%`} />
        <Table.Cell width="0%" />
        <Table.Cell width={`${remainingWidthPercent}%`} />
      </Table.Row>
      {children}
    </Table>
  );
};

const VSplitTooltipListEntry = (props: {
    tooltip?: string;
    label: InfernoNode;
    labelProps?: TableCellProps;
    valueProps?: TableCellProps;
} & BoxProps, context) => {
  const {
    tooltip,
    label,
    labelProps,
    valueProps,
    children,
    ...rest
  } = props;

  return (
    <Table.Row {...rest}>
      <Table.Cell {...labelProps}>{label}</Table.Cell>
      <Table.Cell><Button icon="question" tooltip={tooltip} /></Table.Cell>
      <Table.Cell {...valueProps}>{children}</Table.Cell>
    </Table.Row>
  );
};

VSplitTooltipList.Entry = VSplitTooltipListEntry;

