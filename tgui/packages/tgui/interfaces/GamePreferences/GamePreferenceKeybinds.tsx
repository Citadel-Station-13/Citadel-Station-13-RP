/**
 * @file
 * @license MIT
 */
import { BooleanLike } from "common/react";
import { NoticeBox, Section, Stack } from "../../components";

export interface GamePreferenceKeybindMiddlware {
  readonly hotkeyMode: BooleanLike;
  readonly bindings: Record<string, string[]>;
  // maximum keys for a keybinding
  readonly maxBinds: number;
  // maximum bindings per key
  readonly maxPerKey: number;
  readonly keybinds: GamePreferenceKeybind[];
}

interface GamePreferenceKeybindDescriptor {
  key: string;
  alt?: BooleanLike;
  shift?: BooleanLike;
  ctrl?: BooleanLike;
  numpad?: BooleanLike;
}

interface GamePreferenceKeybindScreenProps extends GamePreferenceKeybindMiddlware {
  readonly addBind: (id: string, key: GamePreferenceKeybindDescriptor, replacingKey: string) => void;
  readonly removeBind: (id: string, key: string) => void;
}

interface GamePreferenceKeybind {
  id: string;
  name: string;
  desc: string;
  category: string;
}

const HOTKEY_MODE_DESCRIPTION = "Keybindings mode controls how the game behaves with tab and map/input focus.<br>If it is on <b>Hotkeys</b>, the game will always attempt to force you to map focus, meaning keypresses are sent \
directly to the map instead of the input. You will still be able to use the command bar, but you need to tab to do it every time you click on the game map.<br>\
If it is on <b>Input</b>, the game will not force focus away from the input bar, and you can switch focus using TAB between these two modes: If the input bar is pink, that means that you are in non-hotkey mode, sending all keypresses of the normal \
alphanumeric characters, punctuation, spacebar, backspace, enter, etc, typing keys into the input bar. If the input bar is white, you are in hotkey mode, meaning all keypresses go into the game's keybind handling system unless you \
manually click on the input bar to shift focus there.<br>\
Input mode is the closest thing to the old input system.<br>\
<b>IMPORTANT:</b> While in input mode's non hotkey setting (tab toggled), Ctrl + KEY will send KEY to the keybind system as the key itself, not as Ctrl + KEY. This means Ctrl + T/W/A/S/D/all your familiar stuff still works, but you \
won't be able to access any regular Ctrl binds.<br>";

export const GamePreferenceKeybindScreen = (props: GamePreferenceKeybindScreenProps, context) => {
  return (
    <Stack fill vertical>
      <Stack.Item>
        <NoticeBox>
          Changes made on this page are applied to the game immediately,
          but are not saved to storage until you press &apos;Save&apos;.
        </NoticeBox>
      </Stack.Item>
      <Stack.Item grow={1}>
        <Section fill>
          Test
        </Section>
      </Stack.Item>
    </Stack>
  );
};
