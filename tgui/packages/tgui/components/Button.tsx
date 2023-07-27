/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { Placement } from '@popperjs/core';
import { KEY_ENTER, KEY_ESCAPE, KEY_SPACE } from 'common/keycodes';
import { BooleanLike, classes, pureComponentHooks, StrictlyStringLike } from 'common/react';
import { Component, createRef } from 'inferno';
import { createLogger } from '../logging';
import { Box, BoxProps, computeBoxClassName, computeBoxProps } from './Box';
import { Icon } from './Icon';
import { Tooltip } from './Tooltip';

const logger = createLogger('Button');

type ButtonProps = BoxProps & {
  fluid?: BooleanLike;
  icon?: string | BooleanLike;
  iconRotation?: number;
  iconSpin?: BooleanLike;
  iconColor?: any;
  iconPosition?: 'right' | 'left';
  color?: string | BooleanLike;
  disabled?: BooleanLike;
  selected?: BooleanLike;
  tooltip?: StrictlyStringLike;
  tooltipPosition?: Placement;
  ellipsis?: BooleanLike;
  circular?: BooleanLike;
  content?: any;
  onClick?: any;
  verticalAlignContent?: 'top' | 'middle' | 'bottom';
}

export const Button = (props: ButtonProps) => {
  const {
    className,
    fluid,
    icon,
    iconRotation,
    iconSpin,
    iconColor,
    iconPosition,
    color,
    disabled,
    selected,
    tooltip,
    tooltipPosition,
    ellipsis,
    compact,
    circular,
    content,
    children,
    onclick,
    onClick,
    verticalAlignContent,
    ...rest
  } = props;
  const hasContent = !!(content || children);
  // A warning about the lowercase onclick
  if (onclick) {
    logger.warn(
      `Lowercase 'onclick' is not supported on Button and lowercase`
      + ` prop names are discouraged in general. Please use a camelCase`
      + `'onClick' instead and read: `
      + `https://infernojs.org/docs/guides/event-handling`);
  }
  rest.onClick = e => {
    if (!disabled && onClick) {
      onClick(e);
    }
  };
  // IE8: Use "unselectable" because "user-select" doesn't work.
  if (Byond.IS_LTE_IE8) {
    rest.unselectable = true;
  }
  let buttonContent = (
    <div
      className={classes([
        'Button',
        fluid && 'Button--fluid',
        disabled && 'Button--disabled',
        selected && 'Button--selected',
        hasContent && 'Button--hasContent',
        ellipsis && 'Button--ellipsis',
        circular && 'Button--circular',
        compact && 'Button--compact',
        iconPosition && 'Button--iconPosition--' + iconPosition,
        verticalAlignContent && "Button--flex",
        (verticalAlignContent && fluid) && "Button--flex--fluid",
        verticalAlignContent && 'Button--verticalAlignContent--' + verticalAlignContent,
        (color && typeof color === 'string')
          ? 'Button--color--' + color
          : 'Button--color--default',
        className,
        computeBoxClassName(rest),
      ])}
      tabIndex={0}
      onKeyDown={e => {
        if (props.captureKeys === false) {
          return;
        }
        const keyCode = window.event ? e.which : e.keyCode;
        // Simulate a click when pressing space or enter.
        if (keyCode === KEY_SPACE || keyCode === KEY_ENTER) {
          e.preventDefault();
          if (!disabled && onClick) {
            onClick(e);
          }
          return;
        }
        // Refocus layout on pressing escape.
        if (keyCode === KEY_ESCAPE) {
          e.preventDefault();
          return;
        }
      }}
      {...computeBoxProps(rest)}>
      <div className="Button__content">
        {icon && iconPosition !== 'right' && (
          <Icon
            name={icon}
            color={iconColor}
            rotation={iconRotation}
            spin={iconSpin}
          />
        )}
        {content}
        {children}
        {icon && iconPosition === 'right' && (
          <Icon
            name={icon}
            color={iconColor}
            rotation={iconRotation}
            spin={iconSpin}
          />
        )}
      </div>
    </div>
  );

  if (tooltip) {
    buttonContent = (
      <Tooltip content={tooltip} position={tooltipPosition}>
        {buttonContent}
      </Tooltip>
    );
  }

  return buttonContent;
};

Button.defaultHooks = pureComponentHooks;

interface ButtonCheckboxProps extends ButtonProps {
  checked?: BooleanLike;
}

export const ButtonCheckbox = (props: ButtonCheckboxProps) => {
  const { checked, ...rest } = props;
  return (
    <Button
      color="transparent"
      icon={checked ? 'check-square-o' : 'square-o'}
      selected={checked}
      {...rest} />
  );
};

Button.Checkbox = ButtonCheckbox;

type ButtonConfirmProps = ButtonProps & {
  confirmContent?: string;
  confirmColor?: string;
}

type ButtonConfirmState = {
  clicked: boolean;
}

export class ButtonConfirm extends Component<ButtonConfirmProps, ButtonConfirmState> {
  state: ButtonConfirmState = {
    clicked: false,
  };

  handleClick = () => {
    if (this.state.clicked) {
      this.setClickedOnce(false);
    }
  }

  setClickedOnce(clickedOnce) {
    this.setState({ clicked: clickedOnce });
    if (clickedOnce) {
      setTimeout(() => window.addEventListener('click', this.handleClick));
    }
    else {
      window.removeEventListener('click', this.handleClick);
    }
  }

  render() {
    const {
      confirmContent = "Confirm?",
      confirmColor = "bad",
      confirmIcon,
      icon,
      color,
      content,
      onClick,
      ...rest
    } = this.props;
    return (
      <Button
        content={this.state.clicked ? confirmContent : content}
        icon={this.state.clicked ? confirmIcon : icon}
        color={this.state.clicked ? confirmColor : color}
        onClick={(e) => this.state.clicked
          ? onClick?.(e)
          : this.setClickedOnce(true)}
        {...rest}
      />
    );
  }
}

Button.Confirm = ButtonConfirm;

type ButtonInputProps = BoxProps & {
  fluid?: BooleanLike;
  onCommit?: (e, value) => void;
  currentValue: string;
  defaultValue: string;
}

export class ButtonInput<T extends ButtonInputProps> extends Component<T, {}> {
  inputRef: any;
  inputting: boolean = false;

  constructor() {
    super();
    this.inputRef = createRef();
  }

  setInInput(inInput: boolean) {
    this.inputting = inInput;
    if (this.inputRef) {
      const input = this.inputRef.current;
      if (inInput) {
        input.value = this.props.currentValue || "";
        try {
          input.focus();
          input.select();
        }
        catch {}
      }
    }
  }

  commitResult(e) {
    if (this.inputRef) {
      const input = this.inputRef.current;
      const hasValue = (input.value !== "");
      if (hasValue) {
        this.props.onCommit?.(e, input.value);
        return;
      } else {
        if (!this.props.defaultValue) {
          return;
        }
        this.props.onCommit?.(e, this.props.defaultValue);
      }
    }
  }

  render() {
    const {
      fluid,
      content,
      icon,
      iconRotation,
      iconSpin,
      tooltip,
      tooltipPosition,
      color = 'default',
      placeholder,
      maxLength,
      ...rest
    } = this.props;

    let buttonContent = (
      <Box
        className={classes([
          'Button',
          fluid && 'Button--fluid',
          'Button--color--' + color,
        ])}
        {...rest}
        onClick={() => this.setInInput(true)}>
        {icon && (
          <Icon name={icon} rotation={iconRotation} spin={iconSpin} />
        )}
        <div>
          {content}
        </div>
        <input
          ref={this.inputRef}
          className="NumberInput__input"
          style={{
            'display': !this.inputting ? 'none' : undefined,
            'text-align': 'left',
          }}
          onBlur={e => {
            if (!this.inputting) {
              return;
            }
            this.setInInput(false);
            this.commitResult(e);
          }}
          onKeyDown={e => {
            if (e.keyCode === KEY_ENTER) {
              this.setInInput(false);
              this.commitResult(e);
              return;
            }
            if (e.keyCode === KEY_ESCAPE) {
              this.setInInput(false);
            }
          }}
        />
      </Box>
    );

    if (tooltip) {
      buttonContent = (
        <Tooltip
          content={tooltip}
          position={tooltipPosition}
        >
          {buttonContent}
        </Tooltip>
      );
    }

    return buttonContent;
  }
}

Button.Input = ButtonInput;
