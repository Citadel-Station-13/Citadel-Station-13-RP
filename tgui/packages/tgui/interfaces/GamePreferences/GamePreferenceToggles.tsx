/**
 * @file
 * @license MIT
 */
import { Button, Section, Stack, Table } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

export interface GamePreferenceTogglesMiddleware {
  readonly toggles: Record<string, GamePreferenceToggleSchema>;
  readonly states: Record<string, BooleanLike>;
}

interface GamePreferenceToggleScreenProps extends GamePreferenceTogglesMiddleware {
  readonly toggleAct: (key: string, state?: boolean) => void;
}

export interface GamePreferenceToggleSchema {
  name: string;
  desc: string;
  enabled: string;
  disabled: string;
  key: string;
  category: string;
  priority: number;
  default: BooleanLike;
}

const collectPreferenceToggles = (toggles: Record<string, GamePreferenceToggleSchema>): Record<string, string[]> => {
  let collected: Record<string, string[]> = {};
  Object.values(toggles).sort((a, b) => a.priority === b.priority
    ? a.name.localeCompare(b.name) : (b.priority - a.priority)).forEach((toggle) => {
      if (!collected[toggle.category]) {
        collected[toggle.category] = [];
      }
      collected[toggle.category].push(toggle.key);
    });
  return collected;
};

export const GamePreferenceToggleScreen = (props: GamePreferenceToggleScreenProps) => {
  const collected: Record<string, string[]> = collectPreferenceToggles(props.toggles);
  return (
    <Section fill scrollable>
      <Stack vertical>
        {Object.entries(collected).sort(
          ([c1, k1], [c2, k2]) => (
            c1.localeCompare(c2)
          )
        ).map(([category, keys]) => (
          <Stack.Item key={category}>
            <h2 style={{ textAlign: "center" }}>{category}</h2>
            <hr />
            <Table>
              {keys.map((key) => {
                const toggle = props.toggles[key];
                return (
                  <Table.Row key={toggle.key}>
                    <Table.Cell width="50%">
                      <b>{toggle.name}</b>
                    </Table.Cell>
                    <Table.Cell>
                      <Button.Checkbox checked={props.states[toggle.key]}
                        onClick={() => props.toggleAct(toggle.key, !props.states[toggle.key])}
                        content={props.states[toggle.key] ? toggle.enabled : toggle.disabled}
                        color="transparent" fluid />
                      {/* <Stack fill>
                        <Stack.Item grow={1}>
                          <Button selected={props.states[toggle.key]} onClick={() => props.toggleAct(toggle.key, true)}
                            content={toggle.enabled} color="transparent" fluid />
                        </Stack.Item>
                        <Stack.Item grow={1}>
                          <Button selected={!props.states[toggle.key]}
                            onClick={() => props.toggleAct(toggle.key, false)}
                            content={toggle.disabled} color="transparent" fluid />
                        </Stack.Item>
                      </Stack> */}
                    </Table.Cell>
                  </Table.Row>
                );
              })}
            </Table>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
