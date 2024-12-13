/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { isEscape, KEY } from 'common/keys';
import { classes } from 'common/react';
import { debounce } from 'common/timer';
import { Component, createRef, InfernoKeyboardEvent, SemiSyntheticEvent } from 'inferno';

import { Box, BoxProps } from './Box';

type ConditionalProps =
  | {
      /**
       * Mark this if you want to debounce onInput.
       *
       * This is useful for expensive filters, large lists etc.
       *
       * Requires `onInput` to be set.
       */
      expensive?: boolean;
      /**
       * Fires on each key press / value change. Used for searching.
       *
       * If it's a large list, consider using `expensive` prop.
       */
      onInput: (event: SemiSyntheticEvent<HTMLInputElement>, value: string) => void;
    }
  | {
      /** This prop requires onInput to be set */
      expensive?: never;
      onInput?: never;
    };

type OptionalProps = Partial<{
  /** Automatically focuses the input on mount */
  autoFocus: boolean;
  /** Automatically selects the input value on focus */
  autoSelect: boolean;
  /** The class name of the input */
  className: string;
  /** Disables the input */
  disabled: boolean;
  /** Mark this if you want the input to be as wide as possible */
  fluid: boolean;
  /** The maximum length of the input value */
  maxLength: number;
  /** Mark this if you want to use a monospace font */
  monospace: boolean;
  /** Fires when user is 'done typing': Clicked out, blur, enter key */
  onChange: (event: SemiSyntheticEvent<HTMLInputElement>, value: string) => void;
  /** Fires once the enter key is pressed */
  onEnter?: (event: SemiSyntheticEvent<HTMLInputElement>, value: string) => void;
  /** Fires once the escape key is pressed */
  onEscape: (event: SemiSyntheticEvent<HTMLInputElement>) => void;
  /** The placeholder text when everything is cleared */
  placeholder: string;
  /** Clears the input value on enter */
  selfClear: boolean;
  /** Auto-updates the input value on props change */
  updateOnPropsChange: boolean;
  /** The state variable of the input. */
  value: string | number;
}>;

type Props = OptionalProps & ConditionalProps & BoxProps;

export function toInputValue(value: string | number | undefined) {
  return typeof value !== 'number' && typeof value !== 'string'
    ? ''
    : String(value);
}

const inputDebounce = debounce((onInput: () => void) => onInput(), 250);

export class Input extends Component<Props> {
  inputRef = createRef<HTMLInputElement>();

  constructor(props) {
    super(props);
  }

  handleInput = (event: SemiSyntheticEvent<HTMLInputElement>) => {
    const { onInput, expensive } = this.props;
    if (!onInput) return;

    const value = event.currentTarget?.value;

    if (expensive) {
      inputDebounce(() => onInput(event, value));
    } else {
      onInput(event, value);
    }
  };

  handleKeyDown = (event: InfernoKeyboardEvent<HTMLInputElement>) => {
    const { onEscape, onChange, onEnter, selfClear, value } = this.props;
    if (event.key === KEY.Enter) {
      onEnter?.(event, event.currentTarget.value);
      if (selfClear) {
        event.currentTarget.value = '';
      } else {
        event.currentTarget.blur();
        onChange?.(event, event.currentTarget.value);
      }

      return;
    }

    if (isEscape(event.key)) {
      onEscape?.(event);

      event.currentTarget.value = toInputValue(value);
      event.currentTarget.blur();
    }
  };

  componentDidMount() {
    const { value, autoFocus, autoSelect } = this.props;
    const input = this.inputRef.current;
    /** Focuses the input on mount */
    if (input) {
      const newValue = toInputValue(value);

      if (input.value !== newValue) input.value = newValue;

      if (!autoFocus && !autoSelect) return;

      setTimeout(() => {
        input.focus();

        if (autoSelect) {
          input.select();
        }
      }, 1);
    }
  }

  componentDidUpdate(prevProps, prevState) {
    const { updateOnPropsChange, value } = this.props;
    if (updateOnPropsChange) {
      const input = this.inputRef.current;
      if (!input) return;

      const newValue = toInputValue(value);
      if (input.value === newValue) return;

      input.value = newValue;
    }
  }

  render() {
    const {
      fluid,
      monospace,
      className,
      disabled,
      maxLength,
      placeholder,
      onChange,
      ...rest
    } = this.props;
    return (
      <Box
        className={classes([
          'Input',
          fluid && 'Input--fluid',
          monospace && 'Input--monospace',
          className,
        ])}
        {...rest}
      >
        <div className="Input__baseline">.</div>
        <input
          className="Input__input"
          disabled={disabled}
          maxLength={maxLength}
          onBlur={(event) => onChange?.(event, (event.target as HTMLInputElement).value)}
          onChange={this.handleInput}
          onKeyDown={this.handleKeyDown}
          placeholder={placeholder}
          ref={this.inputRef}
        />
      </Box>
    );
  }
}
