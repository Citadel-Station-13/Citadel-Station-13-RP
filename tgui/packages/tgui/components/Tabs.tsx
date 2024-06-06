/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, canRender, classes } from 'common/react';
import { InfernoNode } from 'inferno';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';
import { Icon } from './Icon';

//* Constants

const CLICK_EVENT_FLAG_DO_NOT_TAB = "TGUI--NO-TAB";
/**
 * Mark a click event as 'do not tab'
 */
export const markClickEventNoSwitchTab = (e: MouseEvent) => {
  e[CLICK_EVENT_FLAG_DO_NOT_TAB] = true;
};
/**
 * Check if a click event should allow tabbing
 */
export const checkClickEventNoSwitchTab = (e: MouseEvent) => {
  return !!e[CLICK_EVENT_FLAG_DO_NOT_TAB];
};

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
  // directly passed to inner <div> - advanced users only!
  readonly innerStyle?: CSSProperties;
}

const Tab = (props: TabProps) => {
  // "why the hell are we using this pattern instead of just accessing props like a normal react dev"
  // well, you-who-dared-venture-into-the-components-folder,
  // one of these three caused shit to be invisible when passed into computeBoxProps
  // (probably color, maybe className, who knows)
  // i don't feel like dealing with it.
  // rip bozo.
  let {
    color,
    selected,
    className,
    textAlign,
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
      {canRender(props.leftSlot) && (
        <div className="Tab__left">
          {props.leftSlot}
        </div>
      ) || !!props.icon && (
        <div className="Tab__left">
          <Icon name={props.icon} />
        </div>
      )}
      <div className="Tab__text" style={props.innerStyle}>
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
