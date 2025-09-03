import { Button, LabeledList, ProgressBar, Section, Stack } from "tgui-core/components";

import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { ByondAtomColor } from "../common/Color";

interface IcecreamCartData {
  baseIngredients: {
    milk: number,
    flour: number,
    sugar: number,
    ice: number,
  };
  sources: {
    name: string,
    volume: number,
    maxVolume: number,
    color: ByondAtomColor,
    ref: string,
  }[];
  scoopSource: number | null;
}

export const IcecreamCart = (props) => {
  let { data, act } = useBackend<IcecreamCartData>();

  return (
    <Window title="Icecream Cart" width={450} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Stack.Item>
              <Section title="Base Ingredients">
                <LabeledList>
                  <LabeledList.Item label="Flour">
                    <ProgressBar width="100%" value={data.baseIngredients.flour / 60}>{data.baseIngredients.flour}u</ProgressBar>
                  </LabeledList.Item>
                  <LabeledList.Item label="Ice">
                    <ProgressBar width="100%" value={data.baseIngredients.ice / 60}>{data.baseIngredients.ice}u</ProgressBar>
                  </LabeledList.Item>
                  <LabeledList.Item label="Milk">
                    <ProgressBar width="100%" value={data.baseIngredients.milk / 60}>{data.baseIngredients.milk}u</ProgressBar>
                  </LabeledList.Item>
                  <LabeledList.Item label="Sugar">
                    <ProgressBar width="100%" value={data.baseIngredients.sugar / 60}>{data.baseIngredients.sugar}u</ProgressBar>
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Stack.Item>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Section title="Reagent Sources" fill>
              <Stack vertical fill>
                {data.sources.map((s, i) => (
                  <Stack.Item key={s.ref}>
                    <Stack>
                      <Stack.Item>
                        <Button selected={data.scoopSource === i + 1}
                          content="Select"
                          onClick={() => act('selectProduce', { index: i + 1 })} />
                      </Stack.Item>
                      <Stack.Item>
                        {s.name}
                      </Stack.Item>
                      <Stack.Item grow={1}>
                        <ProgressBar value={s.volume / s.maxVolume}>
                          {s.volume}u
                        </ProgressBar>
                      </Stack.Item>
                      <Stack.Item>
                        <Button.Confirm content="Eject" onClick={() => act('ejectSource', { index: i + 1 })} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Button.Confirm color="transparent" textAlign="center" content="Make Cone" fluid
                onClick={() => act('produceCone')} />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
