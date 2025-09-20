/**
 * @file
 * @license MIT
 */
import { keyCodeToByond } from "common/keycodes";
import { Component, ReactNode } from "react";
import { Box, Button, Dimmer, Section, Stack, Table, Tooltip } from "tgui-core/components";
import { KeyEvent } from "tgui-core/events";
import { listenForKeyEvents } from "tgui-core/hotkeys";
import { KEY_ALT, KEY_CTRL, KEY_ESCAPE, KEY_SHIFT } from "tgui-core/keycodes";
import { BooleanLike } from "tgui-core/react";

import { useLocalState } from "../../backend";

export interface GamePreferenceKeybindMiddlware {
  readonly hotkeyMode: BooleanLike;
  readonly bindings: Record<string, string[]>;
  // maximum keys for a keybinding
  // eslint-disable-next-line react/no-unused-prop-types
  readonly maxBinds: number;
  // maximum bindings per key
  // eslint-disable-next-line react/no-unused-prop-types
  readonly maxPerKey: number;
  readonly keybinds: GamePreferenceKeybind[];
}

interface GamePreferenceKeybindDescriptor {
  key: string | null;
  alt: boolean;
  shift: boolean;
  ctrl: boolean;
  numpad: boolean;
}

interface GamePreferenceKeybindScreenProps extends GamePreferenceKeybindMiddlware {
  readonly addBind: (id: string, key: GamePreferenceKeybindDescriptor, replacingKey: string | null) => void;
  readonly removeBind: (id: string, key: string | null) => void;
  readonly setHotkeyMode: (on: boolean) => void;
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

const HOTKEY_MODE_DESCRIPTION = (
  <>
    Keybindings mode controls how the game behaves with tab and map/input focus.<br />
    If it is on <b>Hotkeys</b>, the game will always attempt to force you to map focus,
    meaning keypresses are sent  directly to the map instead of the input.
    You will still be able to use the command bar,
    but you need to tab to do it every time you click on the game map.<br />
    If it is on <b>Input</b>, the game will not force focus away from the input bar,
    and you can switch focus using TAB between these two modes:
    If the input bar is pink, that means that you are in non-hotkey mode,
    sending all keypresses of the normal
    alphanumeric characters, punctuation, spacebar, backspace, enter, etc, typing keys into the input bar.
    If the input bar is white, you are in hotkey mode,
    meaning all keypresses go into the game&apos;s keybind handling system unless you
    manually click on the input bar to shift focus there.<br />
    Input mode is the closest thing to the old input system.<br />
    <b>IMPORTANT:</b> While in input mode&apos;s non hotkey setting (tab toggled),
    Ctrl + KEY will send KEY to the keybind system as the key itself, not as Ctrl + KEY.
    This means Ctrl + T/W/A/S/D/all your familiar stuff still works, but you
    won&apos;t be able to access any regular Ctrl binds.<br />
  </>
);

export const GamePreferenceKeybindScreen = (props: GamePreferenceKeybindScreenProps) => {
  // keybinds are naturally sorted by compile order thanks to typesof()
  // let's not unnecessarily smash that.
  const sortedByCategory = preprocessKeybinds(props.keybinds);
  // unfortunately this can't be cached
  // damnit
  const keysByKeybind: Record<string, string[]> = computeBoundKeys(props.bindings);
  // maybe this shouldn't be a function component
  // and we should do a window event handler
  // instead of using a lazy-ass modal
  // that would probably be smart.
  // oh well! problems for later.
  // (we all know no one's touching this again)
  const [activeCapture, setActiveCapture] = useLocalState<ReactNode | null>('keybindCapture', null);

  return (
    <Section fill scrollable>
      <Stack vertical>
        <Stack.Item>
          <Section title="Basic">
            <Stack>
              <Stack.Item grow>
                <Tooltip content={HOTKEY_MODE_DESCRIPTION}>
                  <Box width="100%" height="100%" style={{ display: "flex", alignContent: "center" }}>
                    <Box>
                      Hotkey Mode
                    </Box>
                  </Box>
                </Tooltip>
              </Stack.Item>
              <Stack.Item grow>
                <Button content="On" selected={props.hotkeyMode}
                  color="transparent" fluid
                  onClick={() => props.setHotkeyMode(true)} />
              </Stack.Item>
              <Stack.Item grow>
                <Button content="Off" selected={!props.hotkeyMode}
                  color="transparent" fluid
                  onClick={() => props.setHotkeyMode(false)} />
              </Stack.Item>
            </Stack>
          </Section>
          {Object.entries(sortedByCategory).sort(
            ([c1, k1], [c2, k2]) => c1.localeCompare(c2)
          ).map(([category, keybinds]) => (
            <Stack.Item key={category}>
              <h2 style={{ textAlign: "center" }}>{category}</h2>
              <Table style={{
                borderBottom: "1px solid #999999",
              }}>
                {keybinds.map((keybind) => {
                  let boundKeys: string[] = keysByKeybind[keybind.id] || [];
                  return (
                    <Table.Row key={keybind.id}
                      height={KEYBIND_ROW_HEIGHT_I_FUCKING_HATE_TABLES_WEBVIEW_WHEN}
                      style={{
                        borderTop: "1px solid #999999",
                      }}>
                      <Table.Cell width="40%" maxWidth="40%">
                        <Tooltip content={keybind.desc}>
                          <Box width="100%"
                            height={KEYBIND_ROW_HEIGHT_I_FUCKING_HATE_TABLES_WEBVIEW_WHEN}
                            style={{
                              display: "flex",
                              alignItems: "center",
                              margin: "0 0",
                              padding: "0 0",
                            }}>
                            <Box bold overflowX="hidden" style={{
                              whiteSpace: "nowrap",
                            }}>
                              {keybind.name}
                            </Box>
                          </Box>
                        </Tooltip>
                      </Table.Cell>
                      {[0, 1, 2].map((i) => {
                        let bind: string | null
                          = boundKeys[i] || null;
                        return (
                          <Table.Cell width="20%" key={i}
                            height={KEYBIND_ROW_HEIGHT_I_FUCKING_HATE_TABLES_WEBVIEW_WHEN}
                            style={{
                              padding: "0 0",
                              margin: "0 0",
                            }}>
                            <Box width="100%"
                              height={KEYBIND_ROW_HEIGHT_I_FUCKING_HATE_TABLES_WEBVIEW_WHEN}
                              onClick={() => {
                                setActiveCapture((
                                  <GamePreferenceKeybindCapture
                                    keybind={keybind}
                                    existing={bind}
                                    onCancel={() => setActiveCapture(null)}
                                    onErase={() => {
                                      setActiveCapture(null);
                                      props.removeBind(keybind.id, bind);
                                    }}
                                    onCapture={(descriptor) => {
                                      setActiveCapture(null);
                                      props.addBind(keybind.id, descriptor, bind);
                                    }} />
                                ));
                              }}
                              style={{
                                display: "flex",
                                alignItems: "center",
                                justifyContent: "center",
                                margin: "0 0",
                                padding: "0, 0",
                              }}>
                              <Box width="100%" overflowX="hidden"
                                italic={!bind}
                                textColor={bind ? undefined : "#777777"}>
                                {bind || "Add Bind..."}
                              </Box>
                            </Box>
                          </Table.Cell>
                        );
                      })}
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

// todo: why are we not doing KeyListener?
class GamePreferenceKeybindCapture extends Component<{
  readonly keybind: GamePreferenceKeybind,
  readonly existing: string | null,
  readonly onCapture: (descriptor: GamePreferenceKeybindDescriptor) => void;
  readonly onErase: () => void;
  readonly onCancel: () => void;
}, {
  alt: boolean;
  ctrl: boolean;
  shift: boolean;
  numpad: boolean;
  terminal: number | null;
}> {
  keydownHandler: (e: KeyEvent) => void;
  keyupHandler: (e: KeyEvent) => void;
  state = {
    alt: false,
    ctrl: false,
    shift: false,
    numpad: false,
    terminal: null,
  };
  unmountHook?: Function;

  constructor(props) {
    super(props);
    this.keydownHandler = (e) => {
      e.event.preventDefault();
      this.setState((prev) => {
        let towards = { ...prev };
        switch (e.code) {
          case KEY_SHIFT:
            towards.shift = true;
            break;
          case KEY_CTRL:
            towards.ctrl = true;
            break;
          case KEY_ALT:
            towards.alt = true;
            break;
          case KEY_ESCAPE:
            if (this.props.existing) {
              this.props.onErase();
            }
            else {
              this.props.onCancel();
            }
            break;
          default:
            towards.terminal = e.code;
            break;
        }
        return towards;
      });
    };
    this.keyupHandler = (e) => {
      e.event.preventDefault();
      this.props.onCapture({
        alt: this.state.alt,
        shift: this.state.shift,
        ctrl: this.state.ctrl,
        numpad: this.state.numpad,
        key: this.state.terminal ? keyCodeToByond(this.state.terminal) : null,
      });
    };
  }

  componentDidMount(): void {
    this.unmountHook = listenForKeyEvents((e) => {
      if (e.isDown()) {
        this.keydownHandler(e);
      }
      if (e.isUp()) {
        this.keyupHandler(e);
      }
    });
  }
  componentWillUnmount(): void {
    this.unmountHook?.();
  }

  render() {
    return (
      <Dimmer>
        <Section>
          <Stack vertical>
            <Stack.Item>
              <Box textAlign="center">
                Capturing key-binding for <b>{this.props.keybind.name}</b>.<br />
                {!!this.props.existing && (
                  <>
                    Existing keybind is <b>{this.props.existing}.</b><br />
                  </>
                )}
                Press <b>Esc</b> to {this.props.existing ? "removing existing bind" : "cancel"}.
              </Box>
            </Stack.Item>
            <Stack.Item>
              {this.state.alt && "Alt-"}{this.state.ctrl && "Ctrl-"}{this.state.shift && "Shift-"}
              {this.state.numpad && "Numpad"}{this.state.terminal ? keyCodeToByond(this.state.terminal) : ""}
            </Stack.Item>
          </Stack>
        </Section>
      </Dimmer>
    );
  }
}
