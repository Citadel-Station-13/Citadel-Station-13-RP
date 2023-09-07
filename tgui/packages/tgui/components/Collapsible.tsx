/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike } from 'common/react';
import { Component, InfernoNode } from 'inferno';
import { Box, BoxProps } from './Box';
import { Button, ButtonProps } from './Button';
import { ComponentProps } from './Component';

interface CollapsibleProps extends ComponentProps{
  buttons?: InfernoNode;
  color?: string;
  title?: string | InfernoNode;
  open?: BooleanLike;
  captureKeys?: BooleanLike;
  more?: InfernoNode;
  boxProps?: BoxProps;
  headerProps?: ButtonProps;
}

interface CollapsibleState {
  open: boolean;
}

export class Collapsible extends Component<CollapsibleProps, CollapsibleState> {
  state: CollapsibleState = {
    open: false,
  }

  constructor(props) {
    super(props);
    const { open } = props;
    this.state = {
      open: !!open || false,
    };
  }

  render() {
    const { props } = this;
    const { open } = this.state;
    const {
      children,
      color = 'default',
      title,
      buttons,
      ...rest
    } = props;
    return props.more? (
      <Box {...props.boxProps}>
        <div className="Collapsible__alt">
          <div className="Collapsible__alt-more">
            {props.more}
          </div>
          <div className="Collapsible__alt-head">
            <div className="Collapsible__toggle">
              <Button
                captureKeys={props.captureKeys === undefined? false : props.captureKeys}
                color={color}
                selected={!!props.more && open}
                icon={open ? 'chevron-down' : 'chevron-right'}
                onClick={() => this.setState({ open: !open })}
                height="100%"
                {...props.headerProps}>
                {title}
              </Button>
            </div>
            {buttons && (
              <div className="Collapsible__buttons">
                {buttons}
              </div>
            )}
          </div>
        </div>
        {open && (
          <div className="Collapsible__content">
            {children}
          </div>
        )}
      </Box>
    ): (
      <Box {...props.boxProps}>
        <div className="Collapsible">
          <div className="Collapsible__head">
            <div className="Collapsible__toggle">
              <Button
                fluid
                captureKeys={props.captureKeys === undefined? false : props.captureKeys}
                color={color}
                icon={open ? 'chevron-down' : 'chevron-right'}
                onClick={() => this.setState({ open: !open })}
                {...props.headerProps}>
                {title}
              </Button>
            </div>
            {buttons && (
              <div className="Collapsible__buttons">
                {buttons}
              </div>
            )}
          </div>
        </div>
        {open && (
          <div className="Collapsible__content">
            {children}
          </div>
        )}
      </Box>
    );
  }
}
