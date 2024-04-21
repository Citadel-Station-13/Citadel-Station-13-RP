/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes, pureComponentHooks } from 'common/react';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';

interface TableProps extends BoxProps {
  readonly collapsing?: BooleanLike;
}

export const Table = (props: TableProps) => {
  const {
    className,
    collapsing,
    children,
    ...rest
  } = props;
  return (
    <table
      className={classes([
        'Table',
        collapsing && 'Table--collapsing',
        className,
        computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      <tbody>
        {children}
      </tbody>
    </table>
  );
};

Table.defaultHooks = pureComponentHooks;

interface TableRowProps extends BoxProps {
  readonly header?: BooleanLike;
}

export const TableRow = (props: TableRowProps) => {
  const {
    className,
    header,
    ...rest
  } = props;
  return (
    <tr
      className={classes([
        'Table__row',
        header && 'Table__row--header',
        className,
        computeBoxClassName(props),
      ])}
      {...computeBoxProps(rest)} />
  );
};

TableRow.defaultHooks = pureComponentHooks;

interface TableCellProps extends BoxProps {
  readonly header?: BooleanLike;
  readonly collapsing?: BooleanLike;
}

export const TableCell = (props: TableCellProps) => {
  const {
    className,
    collapsing,
    header,
    ...rest
  } = props;
  return (
    <td
      className={classes([
        'Table__cell',
        collapsing && 'Table__cell--collapsing',
        header && 'Table__cell--header',
        className,
        computeBoxClassName(props),
      ])}
      {...computeBoxProps(rest)} />
  );
};

TableCell.defaultHooks = pureComponentHooks;

Table.Row = TableRow;
Table.Cell = TableCell;
