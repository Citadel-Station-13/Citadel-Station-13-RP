import { BooleanLike } from "common/react";
import { capitalize } from "common/string";
import { Fragment } from "inferno";
import { useBackend } from "../backend";
import { Button, LabeledList, Section, AnimatedNumber } from "../components";
import { Window } from '../layouts';

const PROCESS_NONE = 0;
const PROCESS_SMELT = 1;
const PROCESS_COMPRESS = 2;
const PROCESS_ALLOY = 3;
const COLOR_PROCESSING = {
  [PROCESS_NONE]: false,
  [PROCESS_SMELT]: "orange",
  [PROCESS_COMPRESS]: "blue",
  [PROCESS_ALLOY]: "purple",
};

type OreData =
{
  name: string,
  display_name: string,
  processing: number,
  amount: number,
  ref: string,
}

type MaterialProcessorData =
{
  on: BooleanLike,
  fast: BooleanLike,
  ores: OreData[],
  unclaimed_points: number,
  id_name: string,
  id_points: number,
}

export const MaterialProcessor = (props, context) => {
  const { act, data } = useBackend<MaterialProcessorData>(context);
  const {
    on,
    fast,
    ores,
    unclaimed_points,
    id_name,
    id_points,
  } = data;

  return (
    <Window
      resizable
      title="Material Processor Console"
      width={380}
      height={550}>
      <Window.Content scrollable>
        <Section title="Mining Points">
          <LabeledList>
            <LabeledList.Item label="Unclaimed Points" buttons={
              <Button
                content="Claim Points"
                icon="coins"
                disabled={!(id_name && unclaimed_points > 0)}
                onClick={() => act("claim_points", {})}
              />
            }>
              <AnimatedNumber value={unclaimed_points} />

            </LabeledList.Item>
            {id_name && (
              <LabeledList.Item label={id_name + "'s Points"} buttons={
                <Button
                  content="Eject ID"
                  icon="eject"
                  onClick={() => act("eject_id", {})}
                />
              }>
                <AnimatedNumber value={id_points} />
              </LabeledList.Item>
            ) || (
              <LabeledList.Item label="ID" buttons={
                <Button
                  content="Insert ID"
                  icon="id-card"
                  onClick={() => act("insert_id", {})} />
              }
              />
            )}
          </LabeledList>
        </Section>
        <Section title="Ore Processing" buttons={
          <Fragment>
            <Button
              icon="forward"
              tooltip="Toggle High-Speed Processing"
              tooltipPosition="bottom-end"
              selected={fast}
              onClick={() => act("toggle_speed", {})}
            />
            <Button
              icon="power-off"
              content="Power"
              tooltip="Toggle Power"
              tooltipPosition="bottom-end"
              selected={on}
              onClick={() => act("toggle_power", {})}
            />
          </Fragment>
        }>
          <LabeledList>
            {ores.map(ore => (
              <LabeledList.Item
                label={capitalize(ore.display_name)}
                key={ore.ref}
                color={COLOR_PROCESSING[ore.processing]}
                buttons={
                  <Fragment>
                    <Button
                      icon="layer-group"
                      tooltip={"Alloy " + ore.display_name}
                      tooltipPosition="top"
                      selected={ore.processing === PROCESS_ALLOY}
                      onClick={() => act("change_mode", { ore: ore.name, mode: PROCESS_ALLOY })}
                    />
                    <Button
                      icon="fire"
                      tooltip={"Smelt " + ore.display_name}
                      tooltipPosition="top"
                      selected={ore.processing === PROCESS_SMELT}
                      onClick={() => act("change_mode", { ore: ore.name, mode: PROCESS_SMELT })}
                    />
                    <Button
                      icon="stamp"
                      tooltip={"Compress " + ore.display_name}
                      tooltipPosition="top"
                      selected={ore.processing === PROCESS_COMPRESS}
                      onClick={() => act("change_mode", { ore: ore.name, mode: PROCESS_COMPRESS })}
                    />
                    <Button
                      icon="ban"
                      tooltip={"No processing " + ore.display_name}
                      tooltipPosition="top"
                      selected={ore.processing === PROCESS_NONE}
                      onClick={() => act("change_mode", { ore: ore.name, mode: PROCESS_NONE })}
                    />
                  </Fragment>
                }>
                <AnimatedNumber value={ore.amount} />
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
