import { Section, Flex, Box, Dropdown, ProgressBar, Slider } from "../components";
import { Window } from "../layouts";
import { useBackend } from "../backend";
import { toFixed } from 'common/math';

interface TeleporterConsoleContext {
  "disabled",
  "locked"
  "teleporterid",
  "projector_charge",
  "projector_charge_max",
  "projector_recharge_rate",
  "projector_recharge_max",
  "valid_destinations",
}

export const TeleporterConsole = (props, context) => {
  const { act, data } = useBackend<TeleporterConsoleContext>(context);
  const {
    locked,
  } = data;
  return (
    <Window
      width={550}
      height={700}
      resizable>
      {data.disabled ? (<Box color="bad">No sensors detected</Box>):(<TeleporterConsoleOperational locked={locked} />)}
    </Window>
  );
};

export const TeleporterConsoleOperational = (props, context) => {
  const { act, data } = useBackend<TeleporterConsoleContext>(context);
  const {
    locked,
    projector_charge,
    projector_charge_max,
    projector_recharge_rate,
    projector_recharge_max,
    valid_destinations,
  } = data;
  return (
    <Section title="Teleporter Control Console">
      <Flex>
        <Section title="Destination Selection">
          <Dropdown
            options={valid_destinations}
            selected={locked || "No Destination"}
            onSelected={(value) => act('set_destination', {
              new_locked: value,
            })} />
        </Section>
        <Section title="Projector Power Status">
          Charge
          <ProgressBar
            value={projector_charge}
            minValue={0}
            maxValue={projector_charge_max}
            color="teal">
            {toFixed(projector_charge) + ' kJ'}
          </ProgressBar>
          Recharge Rate
          <Slider
            color="teal"
            value={projector_recharge_rate}
            minValue={0}
            maxValue={projector_recharge_max}
            unit="kW"
            suppressFlicker={500}
            onDrag={(e, value) => act('set_recharge', {
              target: value })} />
        </Section>
      </Flex>
    </Section>);
};
