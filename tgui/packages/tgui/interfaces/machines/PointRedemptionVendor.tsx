import { Box, Button, LabeledList, Section, Stack, Tooltip } from "tgui-core/components";

import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { IDCard, IDCardOrDefault, IDSlot } from "../common/IDCard";

interface PointRedemptionVendorData {
  points: number;
  pointName: string;
  insertedId: IDCard | null;
  availableItems: {
    name: string;
    desc: string;
    cost: number;
  }[];
}

export const PointRedemptionVendor = (props) => {
  const { act, data, config } = useBackend<PointRedemptionVendorData>();

  return (
    <Window title={config.title} width={500} height={700}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Points">
              <LabeledList>
                <LabeledList.Item label="ID Card">
                  <IDSlot card={IDCardOrDefault(data.insertedId)}
                    onClick={() => act('idcard')}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Available Points">
                  {data.insertedId ? `${data.points} ${data.pointName} points` : "No ID inserted."}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Section title="Items" fill scrollable>
              <Stack vertical>
                {data.availableItems.map((item, index) => (
                  <Stack.Item key={`${item.name}-${item.desc}-${item.cost}`}>
                    <Stack fill>
                      <Stack.Item>
                        <Tooltip content={item.desc}>
                          <Button icon="question" />
                        </Tooltip>
                      </Stack.Item>
                      <Stack.Item>
                        <Box top="50%">
                          {item.name}
                        </Box>
                      </Stack.Item>
                      <Stack.Item grow={1} />
                      <Stack.Item>
                        {item.cost} points
                      </Stack.Item>
                      <Stack.Item>
                        <Button.Confirm color="transparent"
                          content="Vend" onClick={() => act('vend', {
                            name: item.name,
                            index: index + 1,
                          })} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
