/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes, pureComponentHooks } from 'common/react';
import { BoxProps, computeBoxClassName, computeBoxProps, unit } from './Box';

export type FlexProps = BoxProps & {
  direction?: CSSWideKeyword | "column" | "row" | "row-reverse" | "column-reverse" | undefined;
  wrap?: CSSWideKeyword | "wrap" | "nowrap" | "wrap-reverse" | boolean | undefined;
  align?: CSSWideKeyword | "flex-start" | "flex-end" | "center" | "baseline" | "stretch" | undefined;
  justify?: CSSWideKeyword | "flex-start" | "flex-end" | "center" | "stretch" | "space-between" | "space-around" | "space-evenly" | undefined;
  inline?: BooleanLike;
};

export const computeFlexClassName = (props: FlexProps) => {
  return classes([
    'Flex',
    props.inline && 'Flex--inline',
    Byond.IS_LTE_IE10 && 'Flex--iefix',
    Byond.IS_LTE_IE10 && props.direction === 'column' && 'Flex--iefix--column',
    computeBoxClassName(props),
  ]);
};

export const computeFlexProps = (props: FlexProps) => {
  const {
    className,
    wrap,
    inline,
    ...rest
  } = props;
  return computeBoxProps({
    style: {
      ...rest.style,
      'flex-direction': props.direction,
      'flex-wrap': wrap === true ? 'wrap' : (wrap === false? undefined : wrap),
      'align-items': props.align,
      'justify-content': props.justify,
    },
    ...rest,
  });
};

export const Flex = props => {
  const { className, ...rest } = props;
  return (
    <div
      className={classes([
        className,
        computeFlexClassName(rest),
      ])}
      {...computeFlexProps(rest)}
    />
  );
};

Flex.defaultHooks = pureComponentHooks;

export type FlexItemProps = BoxProps & {
  grow?: number | CSSWideKeyword | undefined;
  order?: number;
  shrink?: number | CSSWideKeyword | undefined;
  basis?: string | BooleanLike;
  align?: CSSWideKeyword | "flex-start" | "flex-end" | "center" | "baseline" | "stretch" | "auto" | undefined;
};

export const computeFlexItemClassName = (props: FlexItemProps) => {
  return classes([
    'Flex__item',
    Byond.IS_LTE_IE10 && 'Flex__item--iefix',
    computeBoxClassName(props),
  ]);
};

export const computeFlexItemProps = (props: FlexItemProps) => {
  const {
    className,
    style,
    basis,
    ...rest
  } = props;
  const computedBasis = basis
    // IE11: Set basis to specified width if it's known, which fixes certain
    // bugs when rendering tables inside the flex.
    ?? props.width
    // If grow is used, basis should be set to 0 to be consistent with
    // flex css shorthand `flex: 1`.
    ?? (props.grow !== undefined ? 0 : undefined);
  return computeBoxProps({
    style: {
      ...style,
      'flex-grow': props.grow,
      'flex-shrink': props.shrink,
      'flex-basis': unit(computedBasis),
      'order': props.order,
      'align-self': props.align,
    },
    ...rest,
  });
};

const FlexItem = props => {
  const { className, ...rest } = props;
  return (
    <div
      className={classes([
        className,
        computeFlexItemClassName(props),
      ])}
      {...computeFlexItemProps(rest)}
    />
  );
};

FlexItem.defaultHooks = pureComponentHooks;

Flex.Item = FlexItem;
