/**
 * @file
 * @license MIT
 */

import { Box } from 'tgui-core/components';

import { BoxProps } from '.';

/**
 * I don't know who the fuck said "take 30 minutes to center a box in CSS"
 * but they're fucking right and I'm not doing this ever fucking again
 */
export const Centered = (props: BoxProps) => {
  return (
    <Box
      style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        width: '100%',
        height: '100%',
      }}
    >
      {props.children}
    </Box>
  );
};
