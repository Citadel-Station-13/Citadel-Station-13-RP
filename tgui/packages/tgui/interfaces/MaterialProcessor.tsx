import { Fragment } from "react";
import { AnimatedNumber, Button, LabeledList, Section } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";
import { capitalize } from "tgui-core/string";

import { useBackend } from "../backend";
import { Window } from '../layouts';

enum MaterialProcessorMode {
  None = 0,
  Smelt = 1,
  Compress = 2,
  Alloy = 3,
}

const COLOR_PROCESSING = {
  [MaterialProcessorMode.None]: false,
  [MaterialProcessorMode.Smelt]: "orange",
  [MaterialProcessorMode.Compress]: "blue",
  [MaterialProcessorMode.Alloy]: "purple",
};

type OreData =
  {
    name: string,
    displayName: string,
    processing: number,
    amount: number,
    ref: string,
  }

type MaterialProcessorData =
  {
    on: BooleanLike,
    fast: BooleanLike,
    ores: OreData[],
    unclaimedPoints: number,
    idName: string,
    idPoints: number,
  }

export const MaterialProcessor = (props) => {
  const { act, data } = useBackend<MaterialProcessorData>();
  const {
    on,
    fast,
    ores,
    unclaimedPoints,
    idName,
    idPoints,
  } = data;

  return (
    <Window
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
                disabled={!(idName && unclaimedPoints > 0)}
                onClick={() => act("claim_points", {})}
              />
            }>
              <AnimatedNumber value={unclaimedPoints} />

            </LabeledList.Item>
            {idName && (
              <LabeledList.Item label={idName + "'s Points"} buttons={
                <Button
                  content="Eject ID"
                  icon="eject"
                  onClick={() => act("eject_id", {})}
                />
              }>
                <AnimatedNumber value={idPoints} />
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
          <>
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
          </>
        }>
          <LabeledList>
            {ores.map(ore => (
              <LabeledList.Item
                label={capitalize(ore.displayName)}
                key={ore.ref}
                color={COLOR_PROCESSING[ore.processing]}
                buttons={
                  <>
                    <Button
                      icon="layer-group"
                      tooltip={"Alloy " + ore.displayName}
                      tooltipPosition="top"
                      selected={ore.processing === MaterialProcessorMode.Alloy}
                      onClick={() => act("change_mode", { ore: ore.name, mode: MaterialProcessorMode.Alloy })}
                    />
                    <Button
                      icon="fire"
                      tooltip={"Smelt " + ore.displayName}
                      tooltipPosition="top"
                      selected={ore.processing === MaterialProcessorMode.Smelt}
                      onClick={() => act("change_mode", { ore: ore.name, mode: MaterialProcessorMode.Smelt })}
                    />
                    <Button
                      icon="stamp"
                      tooltip={"Compress " + ore.displayName}
                      tooltipPosition="top"
                      selected={ore.processing === MaterialProcessorMode.Compress}
                      onClick={() => act("change_mode", { ore: ore.name, mode: MaterialProcessorMode.Compress })}
                    />
                    <Button
                      icon="ban"
                      tooltip={"No processing " + ore.displayName}
                      tooltipPosition="top"
                      selected={ore.processing === MaterialProcessorMode.None}
                      onClick={() => act("change_mode", { ore: ore.name, mode: MaterialProcessorMode.None })}
                    />
                  </>
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
