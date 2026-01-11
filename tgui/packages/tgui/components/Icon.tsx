/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @author Original Aleksej Komarov
 * @author Changes ThePotato97
 * @license MIT
 */

import { BooleanLike, classes, pureComponentHooks } from 'common/react';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';

const FA_OUTLINE_REGEX = /-o$/;

interface IconProps extends BoxProps {
  readonly name: string;
  readonly size?: number;
  readonly className?: string;
  readonly rotation?: number;
  readonly spin?: BooleanLike;
}

export const Icon = (props: IconProps) => {
  if (props.size) {
    if (!props.style) {
      props.style = {};
    }
    props.style['font-size'] = (props.size * 100) + '%';
  }
  if (typeof props.rotation === 'number') {
    if (!props.style) {
      props.style = {};
    }
    props.style['transform'] = `rotate(${props.rotation}deg)`;
  }

  const boxProps = computeBoxProps(props);

  let iconClass: string = "";
  if (props.name.startsWith("tg-")) {
    // tgfont icon
    iconClass = props.name;
  } else {
    // font awesome icon
    const faRegular = FA_OUTLINE_REGEX.test(props.name);
    const faName = props.name.replace(FA_OUTLINE_REGEX, '');
    iconClass = (faRegular ? 'far ' : 'fas ') + 'fa-'+ faName + (props.spin ? " fa-spin" : "");
  }
  return (
    <i
      className={classes([
        'Icon',
        iconClass,
        props.className,
        computeBoxClassName(props),
      ])}
      {...boxProps} />
  );
};

Icon.defaultHooks = pureComponentHooks;

export const IconStack = props => {
  const {
    className,
    children,
    ...rest
  } = props;
  return (
    <span
      class={classes([
        'IconStack',
        className,
        computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      {children}
    </span>
  );
};

Icon.Stack = IconStack;
