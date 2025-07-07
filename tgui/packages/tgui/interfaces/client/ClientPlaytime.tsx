/**
 * @file
 * @license MIT
 */

import { round } from "common/math";
import { useBackend } from "../../backend";
import { LabeledList, NoticeBox, ProgressBar, Section } from "../../components";
import { Window } from "../../layouts";

interface ClientPlaytimeData {
  playtime: Record<string, number> | null;
}

export const ClientPlaytime = (props, context) => {
  const { data } = useBackend<ClientPlaytimeData>(context);

  if (data.playtime === null) {
    return (
      <Window width={400} height={200} title="Playtime Viewer">
        <NoticeBox warning>Something went wrong while loading your playtime. Is the database connected?</NoticeBox>
      </Window>
    );
  }

  const itIsntNullDamnit: Record<string, number> = data.playtime as any;
  const rawPlaytimeNumbers = Object.values(data.playtime);
  let highest: number = rawPlaytimeNumbers.length ? rawPlaytimeNumbers.reduce((a, b) => Math.max(a, b)) : 1;
  let sorted = Object.keys(data.playtime).toSorted((a, b) => itIsntNullDamnit[b] - itIsntNullDamnit[a]);

  return (
    <Window width={400} height={600} title="Playtime Viewer">
      <Window.Content>
        <Section title="Tracked Playtime" fill>
          <LabeledList>
            {sorted.map((key) => (
              <LabeledList.Item key={key} label={key}>
                <ProgressBar value={itIsntNullDamnit[key]} maxValue={highest}>{`${round(itIsntNullDamnit[key] / 60, 0.1)}h`}</ProgressBar>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
