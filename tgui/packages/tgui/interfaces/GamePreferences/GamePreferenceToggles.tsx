/**
 * @file
 * @license MIT
 */
import { BooleanLike } from "common/react";
import { useComputedOnce } from "../../backend";
import { Button, Section, Stack, Table } from "../../components";

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

export const GamePreferenceToggleScreen = (props: GamePreferenceToggleScreenProps, context) => {
  const collected: Record<string, string[]> = useComputedOnce(context, 'gamePreferenceToggleCollect', () => collectPreferenceToggles(props.toggles));
  return (
    <Section fill>
      {Object.entries(collected).map(([category, keys]) => (
        <Table key={category}>
          {keys.map((key) => {
            const toggle = props.toggles[key];
            return (
              <>
                {props.toggles[key]}
                <br />
                {key}
              </>
            );
            return (
              <Table.Row key={toggle.key}>
                <Table.Cell>
                  <b>{toggle.name}</b>
                </Table.Cell>
                <Table.Cell>
                  <Stack fill>
                    <Stack.Item grow={1}>
                      <Button selected={props.states[toggle.key]} onClick={() => props.toggleAct(toggle.key, true)}
                        content={toggle.enabled} />
                    </Stack.Item>
                    <Stack.Item grow={1}>
                      <Button selected={!props.states[toggle.key]} onClick={() => props.toggleAct(toggle.key, false)}
                        content={toggle.disabled} />
                    </Stack.Item>
                  </Stack>
                </Table.Cell>
              </Table.Row>
            );
          })}
        </Table>
      ))}
    </Section>
  );
};
