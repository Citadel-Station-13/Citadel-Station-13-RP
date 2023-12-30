import { useBackend } from "../../backend";
import { Button, Section, Stack } from "../../components";
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
  }[];
  coneSource: number | null;
  scoopSource: number | null;
}

export const IcecreamCart = (props, context) => {
  let { data, act } = useBackend<IcecreamCartData>(context);

  return (
    <Window title="Icecream Cart" width={600} height={300}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow={1}>
            <Stack fill>
              <Stack.Item>
                <Section title="Base Ingredients">
                  test
                </Section>
              </Stack.Item>
              <Stack.Item grow={1}>
                <Section title="Reagent Sources">
                  test
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm color="transparent" content="Make Cone" fluid
              onClick={() => act('produceCone')} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
