/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { canRender, classes } from 'common/react';
import { Component, createRef, InfernoNode, RefObject } from 'inferno';
import { addScrollableNode, removeScrollableNode } from '../events';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';

export interface SectionProps extends BoxProps {
  readonly className?: string;
  readonly title?: InfernoNode;
  readonly buttons?: InfernoNode;
  readonly fill?: boolean;
  readonly fitted?: boolean;
  readonly scrollable?: boolean;
  /** @deprecated This property no longer works, please remove it. */
  readonly level?: boolean;
  /** @deprecated Please use `scrollable` property */
  readonly overflowY?: any;
}

export class Section extends Component<SectionProps> {
  scrollableRef: RefObject<HTMLDivElement>;
  scrollable: boolean;

  constructor(props) {
    super(props);
    this.scrollableRef = createRef();
    this.scrollable = props.scrollable;
  }

  componentDidMount() {
    if (!this.scrollableRef?.current) return;
    if (!this.scrollableRef) return;

    addScrollableNode(this.scrollableRef.current);
  }

  componentWillUnmount() {
    if (!this.scrollableRef?.current) return;

    removeScrollableNode(this.scrollableRef.current);
  }

  render() {
    const {
      className,
      title,
      buttons,
      fill,
      fitted,
      scrollable,
      children,
      ...rest
    } = this.props;
    const hasTitle = canRender(title) || canRender(buttons);
    return (
      <div
        className={classes([
          'Section',
          Byond.IS_LTE_IE8 && 'Section--iefix',
          fill && 'Section--fill',
          fitted && 'Section--fitted',
          scrollable && 'Section--scrollable',
          className,
          computeBoxClassName(rest),
        ])}
        {...computeBoxProps(rest)}>
        {hasTitle && (
          <div className={title ? "Section__title" : "Section__titleHolder"}>
            <span className="Section__titleText">
              {title || "⠀"}
            </span>
            <div className="Section__buttons">
              {buttons}
            </div>
          </div>
        )}
        <div className="Section__rest">
          <div ref={this.scrollableRef} className="Section__content">
            {children}
          </div>
        </div>
      </div>
    );
  }
}
