import { Section, Flex, Box, Dropdown, ProgressBar, NumberInput } from "../components";
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
  "valid_destinations",
}

export const TeleporterConsole = (props, context) => {
  const { act, data } = useBackend<TeleporterConsoleContext>(context);
  const {
    locked,
  } = data;
  return (
    <Window
      width={600}
      height={400}
      resizable>
      {data.disabled ? (<Box color="bad">TELEPORTER PAD OR PROJECTOR NOT FOUND. PLEASE CONTACT YOUR SYSTEM ADMINISTRATOR.</Box>):(<TeleporterConsoleOperational locked={locked} />)}
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
    valid_destinations,
  } = data;
  return (
    <Section title="Teleporter Control Console">
      <Flex justify="space-around">
        <Section title="Destination Selection">
          <Dropdown
            options={valid_destinations}
            selected={locked || "No Destination"}
            width="200px"
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
          <br />
          <NumberInput
            value={projector_recharge_rate}
            unit="kW"
            width="100px"
            minValue={0}
            maxValue={100000}
            suppressFlicker={250}
            onChange={(e, value) => act('set_recharge', {
              target: value,
            })} />
        </Section>
      </Flex>
    </Section>);
};
