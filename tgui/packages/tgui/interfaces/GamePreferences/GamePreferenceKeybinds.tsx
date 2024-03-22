/**
 * @file
 * @license MIT
 */
import { BooleanLike } from "common/react";
import { useComputedOnce } from "../../backend";
import { Box, Section, Stack, Table, Tooltip } from "../../components";

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

const preprocessKeybinds = (keybinds: GamePreferenceKeybind[]):
  Record<string, GamePreferenceKeybind[]> => {
  let collected: Record<string, GamePreferenceKeybind[]> = {};
  keybinds.forEach((bind) => {
    if (!collected[bind.category]) {
      collected[bind.category] = [];
    }
    collected[bind.category].push(bind);
  });
  return collected;
};

const computeBoundKeys = (keysBound: Record<string, string[]>): Record<string, string[]> => {
  let computed: Record<string, string[]> = {};
  Object.entries(keysBound).forEach(([key, bindings]) => {
    bindings.forEach((bindId) => {
      if (!computed[bindId]) {
        computed[bindId] = [];
      }
      computed[bindId].push(key);
    });
  });
  return computed;
};

const HOTKEY_MODE_DESCRIPTION = "Keybindings mode controls how the game behaves with tab and map/input focus.<br>If it is on <b>Hotkeys</b>, the game will always attempt to force you to map focus, meaning keypresses are sent \
directly to the map instead of the input. You will still be able to use the command bar, but you need to tab to do it every time you click on the game map.<br>\
If it is on <b>Input</b>, the game will not force focus away from the input bar, and you can switch focus using TAB between these two modes: If the input bar is pink, that means that you are in non-hotkey mode, sending all keypresses of the normal \
alphanumeric characters, punctuation, spacebar, backspace, enter, etc, typing keys into the input bar. If the input bar is white, you are in hotkey mode, meaning all keypresses go into the game's keybind handling system unless you \
manually click on the input bar to shift focus there.<br>\
Input mode is the closest thing to the old input system.<br>\
<b>IMPORTANT:</b> While in input mode's non hotkey setting (tab toggled), Ctrl + KEY will send KEY to the keybind system as the key itself, not as Ctrl + KEY. This means Ctrl + T/W/A/S/D/all your familiar stuff still works, but you \
won't be able to access any regular Ctrl binds.<br>";

export const GamePreferenceKeybindScreen = (props: GamePreferenceKeybindScreenProps, context) => {
  // keybinds are naturally sorted by compile order thanks to typesof()
  // let's not unnecessarily smash that.
  const sortedByCategory = useComputedOnce(context, 'gamePreferenceKeybindCollect', () => preprocessKeybinds(props.keybinds));
  // unfortunately this can't be cached
  // damnit
  const keysByKeybind: Record<string, string[]> = computeBoundKeys(props.bindings);

  return (
    <Section fill scrollable>
      <Stack vertical>
        <Stack.Item>
          <Section title="Basic">
            test
          </Section>
          {Object.entries(sortedByCategory).sort(
            ([c1, k1], [c2, k2]) => c1.localeCompare(c2)
          ).map(([category, keybinds]) => (
            <Stack.Item key={category}>
              <h2 style={{ "text-align": "center" }}>{category}</h2>
              <hr />
              <Table>
                {keybinds.map((keybind) => {
                  return (
                    <Table.Row key={keybind.id} minHeight={2} backgroundColor="#ff0000">
                      <Table.Cell width="40%" backgroundColor="#00ff00"
                        style={{ padding: "0 0", "padding-bottom": 0 }}>
                        <Tooltip content={keybind.desc}>
                          <Box height="100%" width="100%" backgroundColor="#0000ff"
                            style={{ border: "1px solid", "border-color": "#ffffff77",
                              position: "relative", top: 0, bottom: 0, left: 0, right: 0 }}>
                            <Box bold>
                              {keybind.name}
                            </Box>
                          </Box>
                        </Tooltip>
                      </Table.Cell>
                      {[0, 1, 2].map((i) => (
                        <Table.Cell width="20%" key={i}>
                          <Box height="100%" width="100%"
                            style={{ border: "1px solid", "border-color": "#ffffff77", "border-left": "0px" }}>
                            test
                          </Box>
                        </Table.Cell>
                      ))}
                    </Table.Row>
                  );
                })}
              </Table>
            </Stack.Item>
          ))}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
