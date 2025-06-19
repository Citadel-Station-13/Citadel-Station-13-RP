/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, canRender, classes } from 'common/react';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';
import { Icon } from './Icon';
import { InfernoNode } from 'inferno';

interface TabsProps extends BoxProps {
  readonly vertical?: BooleanLike;
  readonly fill?: BooleanLike;
  readonly fluid?: BooleanLike;
}

export const Tabs = (props: TabsProps) => {
  const {
    className,
    vertical,
    fill,
    fluid,
    children,
    ...rest
  } = props;
  return (
    <div
      className={classes([
        'Tabs',
        vertical
          ? 'Tabs--vertical'
          : 'Tabs--horizontal',
        fill && 'Tabs--fill',
        fluid && 'Tabs--fluid',
        className,
        computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      {children}
    </div>
  );
};

interface TabProps extends BoxProps {
  readonly selected?: BooleanLike;
  readonly color?: string | null | undefined;
  readonly icon?: string;
  readonly leftSlot?: InfernoNode;
  readonly rightSlot?: InfernoNode;
}

const Tab = (props: TabProps) => {
  const {
    className,
    selected,
    color,
    icon,
    leftSlot,
    rightSlot,
    children,
    ...rest
  } = props;
  return (
    <div
      className={classes([
        'Tab',
        'Tabs__Tab',
        'Tab--color--' + color,
        selected && 'Tab--selected',
        className,
        computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      {canRender(leftSlot) && (
        <div className="Tab__left">
          {leftSlot}
        </div>
      ) || !!icon && (
        <div className="Tab__left">
          <Icon name={icon} />
        </div>
      )}
      <div className="Tab__text">
        {children}
      </div>
      {canRender(rightSlot) && (
        <div className="Tab__right">
          {rightSlot}
        </div>
      )}
    </div>
  );
};

Tabs.Tab = Tab;
