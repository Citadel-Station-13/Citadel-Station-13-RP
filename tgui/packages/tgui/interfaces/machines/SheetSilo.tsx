import { useBackend, useLocalState } from "../../backend";
import { Button, LabeledList, NumberInput, Section, Stack } from "../../components";
import { Window } from "../../layouts";
import { MaterialsContext } from "../common/Materials";

interface SheetSiloData {
  materialContext: MaterialsContext;
  stored: Record<string, number>;
}

export const SheetSilo = (props, context) => {
  const { act, data } = useBackend<SheetSiloData>(context);
  const [dropAmounts, setDropAmounts] = useLocalState<Record<string, number>>(context, 'dropAmounts', {});

  return (
    <Window width={350} height={500} title="Materials Silo">
      <Window.Content>
        <Section fill title="Storage">
          <LabeledList>
            {Object.entries(data.stored).map(([k, v]) => (
              <LabeledList.Item key={k} label={`${data.materialContext.materials[k]?.name || 'UNKNOWN'} - ${v}`}>
                <Stack>
                  <Stack.Item>
                    <Button icon="plus"
                      onClick={() => setDropAmounts({ ...dropAmounts, k: dropAmounts[k] + 1 })} />
                  </Stack.Item>
                  <Stack.Item>
                    <NumberInput width={2.5} value={dropAmounts[k] || 1}
                      onChange={(e, val) => setDropAmounts({ ...dropAmounts, k: Math.floor(val) })} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="plus"
                      onClick={() => setDropAmounts({ ...dropAmounts, k: dropAmounts[k] - 1 })} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="eject" onClick={() => act('eject', {
                      amount: dropAmounts[k] || 1,
                      id: k,
                    })} />
                  </Stack.Item>
                </Stack>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
