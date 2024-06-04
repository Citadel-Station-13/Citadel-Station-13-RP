/**
 * Basic CSS box.
 * This is the basic component used for formatting/whatnot.
 * You should use this instead of <div> unless you're doing very low level work.
 *
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes, pureComponentHooks } from 'common/react';
import { createVNode } from 'inferno';
import { ChildFlags, VNodeFlags } from 'inferno-vnode-flags';
import { CSS_COLORS } from '../constants';
import { ComponentProps } from './Component';

// a css value for a numerical unit,
// or a number to translate into units automatically,
export type BoxUnit = string | number;
// a box unit, or none to have the box automatically sized
// boolean is included so the pattern of '!!truthy && 5' can work; boolean values are simply ignored
export type BoxUnitProp = BoxUnit | null | undefined | boolean;
// a box string prop, so BoxUnit but without number
export type BoxStringProp = string | null | undefined | boolean;

/**
 * Box props basically have all the HTML / CSS props, thanks to being the base
 * definition of, well, everything given this is a wrapper class.
 *
 * Things that use Box often can/should override/'augment' some of these,
 * but all of this is here so typescript knows what is/isn't valid.
 */
export type BoxProps = ComponentProps & {
  [key: string]: any;
  as?: keyof InfernoHTML;
  className?: string | undefined;
  position?: string | BooleanLike;
  overflow?: string | BooleanLike;
  overflowX?: string | BooleanLike;
  overflowY?: string | BooleanLike;
  top?: BoxUnitProp;
  bottom?: BoxUnitProp;
  left?: BoxUnitProp;
  right?: BoxUnitProp;
  width?: BoxUnitProp;
  minWidth?: BoxUnitProp;
  maxWidth?: BoxUnitProp;
  height?: BoxUnitProp;
  minHeight?: BoxUnitProp;
  maxHeight?: BoxUnitProp;
  fontSize?: BoxUnitProp;
  fontFamily?: string | null;
  lineHeight?: BoxUnitProp;
  opacity?: number;
  textAlign?: BoxStringProp;
  verticalAlign?: string;
  inline?: BooleanLike;
  bold?: BooleanLike;
  italic?: BooleanLike;
  nowrap?: BooleanLike;
  preserveWhitespace?: BooleanLike;
  m?: BoxUnitProp;
  mx?: BoxUnitProp;
  my?: BoxUnitProp;
  mt?: BoxUnitProp;
  mb?: BoxUnitProp;
  ml?: BoxUnitProp;
  mr?: BoxUnitProp;
  p?: BoxUnitProp;
  px?: BoxUnitProp;
  py?: BoxUnitProp;
  pt?: BoxUnitProp;
  pb?: BoxUnitProp;
  pl?: BoxUnitProp;
  pr?: BoxUnitProp;
  color?: BoxStringProp;
  textColor?: BoxStringProp;
  backgroundColor?: BoxStringProp;
  fillPositionedParent?: BooleanLike;
  //* baseline DOM / InfernoNode properties start *//
  // anything put in here is directly injected into the element as a style
  // this overrides provided style variables
  style?: CSSProperties;
}

/**
 * Coverts our rem-like spacing unit into a CSS unit.
 */
export const unit = (value: unknown): string | undefined => {
  if (typeof value === 'string') {
    // Transparently convert pixels into rem units
    if (value.endsWith('px') && !Byond.IS_LTE_IE8) {
      return parseFloat(value) / 12 + 'rem';
    }
    return value;
  }
  if (typeof value === 'number') {
    if (Byond.IS_LTE_IE8) {
      return value * 12 + 'px';
    }
    return value + 'rem';
  }
};

/**
 * Same as `unit`, but half the size for integers numbers.
 */
export const halfUnit = (value: unknown): string | undefined => {
  if (typeof value === 'string') {
    return unit(value);
  }
  if (typeof value === 'number') {
    return unit(value * 0.5);
  }
};

const isColorCode = (str: unknown) => !isColorClass(str);

const isColorClass = (str: unknown): boolean => {
  return typeof str === "string" && CSS_COLORS.includes(str);
};

const mapRawPropTo = attrName => (style, value) => {
  if (typeof value === 'number' || typeof value === 'string') {
    style[attrName] = value;
  }
};

const mapUnitPropTo = (attrName, unit) => (style, value) => {
  if (typeof value === 'number' || typeof value === 'string') {
    style[attrName] = unit(value);
  }
};

const mapBooleanPropTo = (attrName, attrValue) => (style, value) => {
  if (value) {
    style[attrName] = attrValue;
  }
};

const mapDirectionalUnitPropTo = (attrName, unit, dirs) => (style, value) => {
  if (typeof value === 'number' || typeof value === 'string') {
    for (let i = 0; i < dirs.length; i++) {
      style[attrName + '-' + dirs[i]] = unit(value);
    }
  }
};

const mapColorPropTo = attrName => (style, value) => {
  if (isColorCode(value)) {
    style[attrName] = value;
  }
};

const styleMapperByPropName = {
  // Direct mapping
  position: mapRawPropTo('position'),
  overflow: mapRawPropTo('overflow'),
  overflowX: mapRawPropTo('overflow-x'),
  overflowY: mapRawPropTo('overflow-y'),
  top: mapUnitPropTo('top', unit),
  bottom: mapUnitPropTo('bottom', unit),
  left: mapUnitPropTo('left', unit),
  right: mapUnitPropTo('right', unit),
  width: mapUnitPropTo('width', unit),
  minWidth: mapUnitPropTo('min-width', unit),
  maxWidth: mapUnitPropTo('max-width', unit),
  height: mapUnitPropTo('height', unit),
  minHeight: mapUnitPropTo('min-height', unit),
  maxHeight: mapUnitPropTo('max-height', unit),
  fontSize: mapUnitPropTo('font-size', unit),
  fontFamily: mapRawPropTo('font-family'),
  lineHeight: (style, value) => {
    if (typeof value === 'number') {
      style['line-height'] = value;
    }
    else if (typeof value === 'string') {
      style['line-height'] = unit(value);
    }
  },
  opacity: mapRawPropTo('opacity'),
  textAlign: mapRawPropTo('text-align'),
  verticalAlign: mapRawPropTo('vertical-align'),
  // Boolean props
  inline: mapBooleanPropTo('display', 'inline-block'),
  bold: mapBooleanPropTo('font-weight', 'bold'),
  italic: mapBooleanPropTo('font-style', 'italic'),
  nowrap: mapBooleanPropTo('white-space', 'nowrap'),
  preserveWhitespace: mapBooleanPropTo('white-space', 'pre-wrap'),
  // Margins
  m: mapDirectionalUnitPropTo('margin', halfUnit, [
    'top', 'bottom', 'left', 'right',
  ]),
  mx: mapDirectionalUnitPropTo('margin', halfUnit, [
    'left', 'right',
  ]),
  my: mapDirectionalUnitPropTo('margin', halfUnit, [
    'top', 'bottom',
  ]),
  mt: mapUnitPropTo('margin-top', halfUnit),
  mb: mapUnitPropTo('margin-bottom', halfUnit),
  ml: mapUnitPropTo('margin-left', halfUnit),
  mr: mapUnitPropTo('margin-right', halfUnit),
  // Margins
  p: mapDirectionalUnitPropTo('padding', halfUnit, [
    'top', 'bottom', 'left', 'right',
  ]),
  px: mapDirectionalUnitPropTo('padding', halfUnit, [
    'left', 'right',
  ]),
  py: mapDirectionalUnitPropTo('padding', halfUnit, [
    'top', 'bottom',
  ]),
  pt: mapUnitPropTo('padding-top', halfUnit),
  pb: mapUnitPropTo('padding-bottom', halfUnit),
  pl: mapUnitPropTo('padding-left', halfUnit),
  pr: mapUnitPropTo('padding-right', halfUnit),
  // Color props
  color: mapColorPropTo('color'),
  textColor: mapColorPropTo('color'),
  backgroundColor: mapColorPropTo('background-color'),
  // Utility props
  fillPositionedParent: (style, value) => {
    if (value) {
      style['position'] = 'absolute';
      style['top'] = 0;
      style['bottom'] = 0;
      style['left'] = 0;
      style['right'] = 0;
    }
  },
};

export const computeBoxProps = (props: BoxProps) => {
  const computedProps: any = {};
  const computedStyles = {};
  // Compute props
  for (let propName of Object.keys(props)) {
    if (propName === 'style') {
      continue;
    }
    // IE8: onclick workaround
    if (Byond.IS_LTE_IE8 && propName === 'onClick') {
      computedProps.onclick = props[propName];
      continue;
    }
    const propValue = props[propName];
    const mapPropToStyle = styleMapperByPropName[propName];
    if (mapPropToStyle) {
      mapPropToStyle(computedStyles, propValue);
    }
    else {
      computedProps[propName] = propValue;
    }
  }
  // Concatenate styles
  let style = '';
  for (let attrName of Object.keys(computedStyles)) {
    const attrValue = computedStyles[attrName];
    style += attrName + ':' + attrValue + ';';
  }
  if (props.style) {
    for (let attrName of Object.keys(props.style)) {
      const attrValue = props.style[attrName];
      style += attrName + ':' + attrValue + ';';
    }
  }
  if (style.length > 0) {
    computedProps.style = style;
  }
  return computedProps;
};

export const computeBoxClassName = (props: BoxProps) => {
  const color = props.textColor || props.color;
  const backgroundColor = props.backgroundColor;
  return classes([
    isColorClass(color) && 'color-' + color,
    isColorClass(backgroundColor) && 'color-bg-' + backgroundColor,
  ]);
};

export const Box = (props: BoxProps) => {
  const {
    as = 'div',
    className,
    children,
    ...rest
  } = props;
  // Render props
  if (typeof children === 'function') {
    return children(computeBoxProps(props));
  }
  const computedClassName = typeof className === 'string'
    ? className + ' ' + computeBoxClassName(rest)
    : computeBoxClassName(rest);
  const computedProps = computeBoxProps(rest);
  // Render a wrapper element
  return createVNode(
    VNodeFlags.HtmlElement,
    as,
    computedClassName,
    children,
    ChildFlags.UnknownChildren,
    computedProps,
    undefined,
  );
};

Box.defaultHooks = pureComponentHooks;
