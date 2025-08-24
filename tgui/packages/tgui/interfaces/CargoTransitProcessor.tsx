import { BooleanLike } from "common/react";
import { capitalize } from "common/string";
import { Fragment } from "inferno";
import { useBackend } from "../backend";
import { Button, LabeledList, Section, AnimatedNumber } from "../components";
import { Window } from '../layouts';

enum CargoTransitMode {
  None = 0,
  Cargoactive = 1,
}

const COLOR_PROCESSING = {
  [CargoTransitMode.None]: false,
};

type CargoTransitData =
{
  on: BooleanLike,
  fast: BooleanLike,
  cargotransits: CargoTransitData[],
  unclaimedPoints: number,
  idName: string,
  idPoints: number,
}

export const CargoTransit = (props, context) => {
  const { act, data } = useBackend<CargoTransitData>(context);
  const {
    on,
    fast,
    cargotransits,
    unclaimedPoints,
    idName,
    idPoints,
  } = data;

  return (
    <Window
      resizable
      title="Cargo transit processing Console"
      width={380}
      height={550}>
      <Window.Content scrollable>
        <Section title="Transit Points">
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
        <Section title="Cargo transit Processing" buttons={
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
            {cargotransits.map(cargotransit => (
              <LabeledList.Item
                label={capitalize(cargotransit.displayName)}
                key={cargotransit.ref}
                color={COLOR_PROCESSING[cargotransit.processing]}
                buttons={
                  <Fragment>
                    <Button
                      icon="layer-group"
                      tooltip={"Process " + cargotransit.displayName}
                      tooltipPosition="top"
                      selected={cargotransit.processing === CargoTransitMode.Process}
                      onClick={() => act("change_mode", { cargotransit: cargotransit.name, mode: CargoTransitMode.Process })}
                    />
                    <Button
                      icon="ban"
                      tooltip={"No processing " + cargotransit.displayName}
                      tooltipPosition="top"
                      selected={cargotransit.processing === CargoTransitMode.None}
                      onClick={() => act("change_mode", { cargotransit: cargotransit.name, mode: CargoTransitMode.None })}
                    />
                  </Fragment>
                }>
                <AnimatedNumber value={cargotransit.amount} />
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
