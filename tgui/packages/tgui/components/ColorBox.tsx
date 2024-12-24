/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes, pureComponentHooks } from 'common/react';
import { InfernoNode } from 'inferno';

import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';

type Props = {
  content?: InfernoNode;
} & BoxProps;

export function ColorBox(props: Props) {
  const { content, children, className, ...rest } = props;

  rest.color = content ? null : 'default';
  rest.backgroundColor = props.color || 'default';

  return (
    <div
      className={classes(['ColorBox', className, computeBoxClassName(rest)])}
      {...computeBoxProps(rest)}
    >
      {content || '.'}
    </div>
  );
}

ColorBox.defaultHooks = pureComponentHooks;
