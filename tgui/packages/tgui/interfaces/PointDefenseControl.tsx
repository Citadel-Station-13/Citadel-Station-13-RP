import { Box, Button, LabeledList, Section } from "tgui-core/components";

import { useBackend } from "../backend";
import { Window } from "../layouts";

export const PointDefenseControl = (props) => {
  const { act, data } = useBackend<any>();
  const {
    id,
    turrets,
  } = data;
  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <Section title={"Fire Assist Mainframe: " + (id || "[no tag]")}>
          {turrets.length && turrets.map(pd => (
            <Section title={pd.id} key={pd.id} buttons={
              <Button
                selected={pd.active}
                icon="power-off"
                onClick={() => act("toggle_active", { target: pd.ref })}>
                {pd.active ? "Online" : "Offline"}
              </Button>
            }>
              <LabeledList>
                <LabeledList.Item label="Effective range">
                  {pd.effective_range}
                </LabeledList.Item>
                <LabeledList.Item label="Reaction wheel delay">
                  {pd.reaction_wheel_delay}
                </LabeledList.Item>
                <LabeledList.Item label="Recharge time">
                  {pd.recharge_time}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          )) || (
              <Box color="bad">
                Error: No weapon systems detected.
                Please check network connection.
              </Box>
            )}
        </Section>
      </Window.Content>
    </Window>
  );
};
