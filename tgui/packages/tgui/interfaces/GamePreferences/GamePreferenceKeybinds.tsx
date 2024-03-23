/**
 * @file
 * @license MIT
 */
import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { useComputedOnce, useLocalState } from "../../backend";
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

const KEYBIND_ROW_HEIGHT_I_FUCKING_HATE_TABLES_WEBVIEW_WHEN = "2em";

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
  // maybe this shouldn't be a function component
  // and we should do a window event handler
  // instead of using a lazy-ass modal
  // that would probably be smart.
  // oh well! problems for later.
  // (we all know no one's touching this again)
  const [activeCapture, setActiveCapture] = useLocalState<InfernoNode | null>(context, 'activeKeyCapture', null);

  return (
    <Section fill scrollable>
      {/* inject active capture vnode */}
      {activeCapture}
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
                  let boundKeys: string[] = keysByKeybind[keybind.id] || [];
                  return (
                    <Table.Row key={keybind.id}
                      height={KEYBIND_ROW_HEIGHT_I_FUCKING_HATE_TABLES_WEBVIEW_WHEN}
                      style={{
                        border: "1px solid", "border-color": "#ffffff77",
                      }}>
                      <Table.Cell width="40%" maxWidth="40%" backgroundColor="#00ff00">
                        <Tooltip content={keybind.desc}>
                          <Box width="100%" backgroundColor="#0000ff"
                            height={KEYBIND_ROW_HEIGHT_I_FUCKING_HATE_TABLES_WEBVIEW_WHEN}
                            style={{
                              display: "flex",
                              "align-items": "center",
                              margin: "0 0",
                              padding: "0 0",
                            }}>
                            <Box bold overflowX="hidden" backgroundColor="#ffff00" style={{
                              "white-space": "nowrap",
                            }}>
                              {keybind.name}
                            </Box>
                          </Box>
                        </Tooltip>
                      </Table.Cell>
                      {[0, 1, 2].map((i) => {
                        let bind: string | null
                          = boundKeys.at(i) || null;
                        return (
                          <Table.Cell width="20%" key={i} backgroundColor="#00ff00"
                            height={KEYBIND_ROW_HEIGHT_I_FUCKING_HATE_TABLES_WEBVIEW_WHEN}
                            style={{
                              padding: "0 0",
                              margin: "0 0",
                            }}>
                            <Box width="100%" backgroundColor="#ff0000"
                              height={KEYBIND_ROW_HEIGHT_I_FUCKING_HATE_TABLES_WEBVIEW_WHEN}
                              style={{
                                display: "flex",
                                "align-items": "center",
                                "justify-content": "center",
                                margin: "0 0",
                                padding: "0, 0",
                              }}>
                              <Box width="100%" overflowX="hidden"
                                italic={!bind}
                                textColor={bind? undefined : "#777777"}
                                style={{ "background-color": "#0000ff" }}>
                                {bind || "Add Bind..."}
                              </Box>
                            </Box>
                          </Table.Cell>
                        ); })}
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

const KeybindingCaptureComponent = (props: {
  bindId: string,
  onCapture: (descriptor: GamePreferenceKeybindDescriptor) => void;
}, context) => {

};
