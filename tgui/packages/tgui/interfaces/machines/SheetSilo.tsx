import { useState } from "react";
import { Box, Button, NumberInput, Section, Stack } from "tgui-core/components";

import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { MaterialsContext } from "../common/Materials";

interface SheetSiloData {
  materialContext: MaterialsContext;
  stored: Record<string, number>;
}

export const SheetSilo = (props) => {
  const { act, data } = useBackend<SheetSiloData>();
  const [dropAmounts, setDropAmounts] = useState<Record<string, number>>({});
  const setDropAmount = (id: string, amt: number) => {
    let corrected = { ...dropAmounts };
    corrected[id] = amt;
    setDropAmounts(corrected);
  };

  return (
    <Window width={350} height={500} title="Materials Silo">
      <Window.Content>
        <Section fill title="Storage" scrollable>
          <Stack vertical fill>
            {Object.entries(data.stored).sort(
              ([k1, v1], [k2, v2]) => (
                (data.materialContext.materials[k1]?.name || "AAAAA").localeCompare(
                  (data.materialContext.materials[k2]?.name || "AAAAA")
                )
              )
            ).map(([k, v]) => (
              <Stack.Item key={`${k}-${dropAmounts[k]}`}>
                <Stack>
                  <Stack.Item grow={1} style={{ display: "flex", border: "1px solid gray" }} pl={1}>
                    <Box style={{ alignSelf: "center" }} bold>
                      {data.materialContext.materials[k]?.name || 'UNKNOWN'} - {v}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="minus"
                      onClick={() => setDropAmount(k, (dropAmounts[k] || 1) - 1)} />
                  </Stack.Item>
                  <Stack.Item>
                    <NumberInput width={2.5} value={dropAmounts[k] || 1}
                      minValue={0} maxValue={200} step={1}
                      onChange={(val) => setDropAmount(k, Math.floor(val))} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="plus"
                      onClick={() => setDropAmount(k, (dropAmounts[k] || 1) + 1)} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="eject" onClick={() => act('eject', {
                      amount: dropAmounts[k] || 1,
                      id: k,
                    })} />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
