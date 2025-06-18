/**
 * @file
 * @license MIT
 */

import { round } from "common/math";
import { useBackend } from "../../backend";
import { NoticeBox, ProgressBar, Section, Stack } from "../../components";
import { Window } from "../../layouts";

interface ClientPlaytimeData {
  playtime: Record<string, number> | null;
}

export const ClientPlaytiem = (props, context) => {
  const { data } = useBackend<ClientPlaytimeData>(context);

  if (data.playtime === null) {
    return (
      <Window width={400} height={200} title="Playtime Viewer">
        <NoticeBox warning>Something went wrong while loading your playtime. Is the database connected?</NoticeBox>
      </Window>
    );
  }

  const itIsntNullDamnit: Record<string, number> = data.playtime as any;
  let highest: number = Object.values(data.playtime).reduce((a, b) => Math.max(a, b));
  let sorted = Object.keys(data.playtime).toSorted((a, b) => itIsntNullDamnit[a] - itIsntNullDamnit[b]);

  return (
    <Window width={400} height={800} title="Playtime Viewer">
      <Window.Content>
        <Section title="Tracked Playtime">
          <Stack vertical fill>
            {sorted.map((key) => (
              <Stack.Item key={key}>
                <ProgressBar value={itIsntNullDamnit[key]} maxValue={highest}>{`${round(itIsntNullDamnit[key] / 60, 0.1)}h`}</ProgressBar>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
