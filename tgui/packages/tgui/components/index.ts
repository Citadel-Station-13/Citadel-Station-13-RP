import { Box, Section } from "tgui-core/components";

/**
 * Re-exports props from tgui-core so we can freely use them in our wrappers.
 */

export type BoxProps = React.ComponentProps<typeof Box>;
export type SectionProps = React.ComponentProps<typeof Section>;

/**
 * Re-exports everything from this folder
 */

export { Sprite } from './Sprite';
