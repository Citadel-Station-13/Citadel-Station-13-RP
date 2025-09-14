import { Box, Section, Table } from "tgui-core/components";

/**
 * Re-exports props from tgui-core so we can freely use them in our wrappers.
 */

export type BoxProps = React.ComponentProps<typeof Box>;
export type SectionProps = React.ComponentProps<typeof Section>;
export type TableProps = React.ComponentProps<typeof Table>;
export type TableRowProps = React.ComponentProps<typeof Table.Row>;
export type TableCellProps = React.ComponentProps<typeof Table.Cell>;

/**
 * Re-exports everything from this folder
 */

export { Sprite } from './Sprite';
export { VSplitTooltipList } from './VSplitTooltipList';
export { VStaticScrollingWindower as VScrollingWindower } from './VStaticScrollingWindower';
export { WorldTypepathDropdown } from './WorldTypepathDropdown';
