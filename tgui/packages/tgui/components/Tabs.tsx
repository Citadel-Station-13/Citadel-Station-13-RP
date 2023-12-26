/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, canRender, classes } from 'common/react';
import { InfernoNode } from 'inferno';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';
import { Icon } from './Icon';

interface TabsProps extends BoxProps {
  readonly vertical?: BooleanLike;
  readonly fill?: BooleanLike;
  readonly fluid?: BooleanLike;
}

export const Tabs = (props: TabsProps) => {
  return (
    <div
      className={classes([
        'Tabs',
        props.vertical
          ? 'Tabs--vertical'
          : 'Tabs--horizontal',
        props.fill && 'Tabs--fill',
        props.fluid && 'Tabs--fluid',
        props.className,
        computeBoxClassName(props),
      ])}
      {...computeBoxProps(props)}>
      {props.children}
    </div>
  );
};

interface TabProps extends BoxProps {
  readonly leftSlot?: InfernoNode;
  readonly rightSlot?: InfernoNode;
  readonly selected: BooleanLike;
  readonly icon?: string;
}

const Tab = (props: TabProps) => {
  return (
    <div
      className={classes([
        'Tab',
        'Tabs__Tab',
        'Tab--color--' + props.color,
        props.selected && 'Tab--selected',
        props.className,
        ...computeBoxClassName(props).split(" "),
      ])}
      {...computeBoxProps(props)}>
      {canRender(props.leftSlot) && (
        <div className="Tab__left">
          {props.leftSlot}
        </div>
      ) || !!props.icon && (
        <div className="Tab__left">
          <Icon name={props.icon} />
        </div>
      )}
      <div className="Tab__text">
        {props.children}
      </div>
      {canRender(props.rightSlot) && (
        <div className="Tab__right">
          {props.rightSlot}
        </div>
      )}
    </div>
  );
};

Tabs.Tab = Tab;
