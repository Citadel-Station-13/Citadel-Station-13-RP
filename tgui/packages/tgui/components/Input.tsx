/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes } from 'common/react';
import { Component, createRef, RefObject } from 'inferno';
import { Box, BoxProps } from './Box';
import { KEY_ESCAPE, KEY_ENTER } from 'common/keycodes';

export interface InputProps extends BoxProps {
  // clear after hitting enter
  readonly selfClear?: BooleanLike;
  // fired when commiting text by unfocusing or pressing enter
  readonly onChange?: (e, value: string) => void;
  // fired on change (keypress)
  readonly onInput?: (e, value: string) => void;
  // fired specifically on enter only
  readonly onEnter?: (e, value: string) => void;
  // fill all available horizontal space
  readonly fluid?: BooleanLike;
  // text seen in input when empty
  readonly placeholder?: string;
  // current value
  readonly value?: string;
  // max length in characters
  readonly maxLength?: number;
}

interface InputState {
  editing: boolean;
}

export const toInputValue = value => (
  typeof value !== 'number' && typeof value !== 'string'
    ? ''
    : String(value)
);

export class Input extends Component<InputProps, InputState> {
  inputRef: RefObject<HTMLInputElement>;

  handleInput: (e: any) => void = e => {
    const { editing } = this.state;
    const { onInput } = this.props;
    if (!editing) {
      this.setEditing(true);
    }
    if (onInput) {
      onInput(e, e.target.value);
    }
  };

  handleFocus: (e: any) => void = e => {
    const { editing } = this.state;
    if (!editing) {
      this.setEditing(true);
    }
  };

  handleBlur: (e: any) => void = e => {
    const { editing } = this.state;
    const { onChange } = this.props;
    if (editing) {
      this.setEditing(false);
      if (onChange) {
        onChange(e, e.target.value);
      }
    }
  };

  handleKeyDown: (e: any) => void = e => {
    const { onInput, onChange, onEnter } = this.props;
    if (e.keyCode === KEY_ENTER) {
      this.setEditing(false);
      if (onChange) {
        onChange(e, e.target.value);
      }
      if (onInput) {
        onInput(e, e.target.value);
      }
      if (onEnter) {
        onEnter(e, e.target.value);
      }
      if (this.props.selfClear) {
        e.target.value = '';
      } else {
        e.target.blur();
      }
      return;
    }
    if (e.keyCode === KEY_ESCAPE) {
      if (this.props.onEscape) {
        this.props.onEscape(e);
        return;
      }

      this.setEditing(false);
      e.target.value = toInputValue(this.props.value);
      e.target.blur();
      return;
    }
  };

  state = {
    editing: false,
  };

  constructor() {
    super();
    this.inputRef = createRef();
  }

  componentDidMount() {
    const nextValue = this.props.value;
    const input = this.inputRef.current;
    if (input) {
      input.value = toInputValue(nextValue);
      if (this.props.autoFocus || this.props.autoSelect) {
        setTimeout(() => {
          input.focus();

          if (this.props.autoSelect) {
            input.select();
          }
        }, 1);
      }
    }
  }

  componentDidUpdate(prevProps, prevState) {
    const { editing } = this.state;
    const prevValue = prevProps.value;
    const nextValue = this.props.value;
    const input = this.inputRef.current;
    if (input && !editing && prevValue !== nextValue) {
      input.value = toInputValue(nextValue);
    }
  }

  setEditing(editing) {
    this.setState({ editing });
  }

  render() {
    return (
      <Box
        className={classes([
          'Input',
          this.props.fluid && 'Input--fluid',
          this.props.monospace && 'Input--monospace',
          this.props.className,
        ])}
        {...this.props.rest}>
        <div className="Input__baseline">
          .
        </div>
        <input
          ref={this.inputRef}
          className="Input__input"
          placeholder={this.props.placeholder}
          onInput={this.handleInput}
          onFocus={this.handleFocus}
          onBlur={this.handleBlur}
          onKeyDown={this.handleKeyDown}
          maxLength={this.props.maxLength} />
      </Box>
    );
  }
}
