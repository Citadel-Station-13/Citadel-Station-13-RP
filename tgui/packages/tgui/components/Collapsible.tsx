/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike } from 'common/react';
import { Component, InfernoNode } from 'inferno';
import { Box, BoxProps } from './Box';
import { Button } from './Button';

interface CollapsibleProps extends BoxProps {
  buttons?: InfernoNode;
  color?: string;
  title?: string;
  open?: BooleanLike;
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
    return (
      <Box mb={1}>
        <div className="Collapsible">
          <div className="Collapsible__head">
            <div className="Collapsible__toggle">
              <Button
                fluid
                color={color} w
                icon={open ? 'chevron-down' : 'chevron-right'}
                onClick={() => this.setState({ open: !open })}
                {...rest}>
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
