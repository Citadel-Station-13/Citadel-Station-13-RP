import { sortBy } from 'common/collections';
import { Button, Collapsible, Flex, LabeledList, Section } from "tgui-core/components";
import { toTitleCase } from 'tgui-core/string';

import { useBackend } from "../backend";
import { Window } from "../layouts";

export const SeedStorage = (props) => {
  const { act, data } = useBackend<any>();

  const {
    scanner,
    seeds,
  } = data;

  const sortedSeeds = sortBy(seeds, (seed: any) => seed.name.toLowerCase());

  return (
    <Window width={600} height={760}>
      <Window.Content scrollable>
        <Section title="Seeds">
          {sortedSeeds.map(seed => (
            <Flex spacing={1} mt={-1} key={seed.name + seed.uid}>
              <Flex.Item basis="60%">
                <Collapsible title={toTitleCase(seed.name) + " #" + seed.uid}>
                  <Section width="165%" title="Traits">
                    <LabeledList>
                      {Object.keys(seed.traits).map(key => (
                        <LabeledList.Item label={toTitleCase(key)} key={key}>
                          {seed.traits[key]}
                        </LabeledList.Item>
                      ))}
                    </LabeledList>
                  </Section>
                </Collapsible>
              </Flex.Item>
              <Flex.Item mt={0.4}>
                {seed.amount} Remaining
              </Flex.Item>
              <Flex.Item grow={1}>
                <Button
                  fluid
                  icon="download"
                  onClick={() => act("vend", { id: seed.id })}>
                  Vend
                </Button>
              </Flex.Item>
              <Flex.Item grow={1}>
                <Button.Confirm
                  fluid
                  icon="trash"
                  onClick={() => act("purge", { id: seed.id })}>
                  Purge
                </Button.Confirm>
              </Flex.Item>
            </Flex>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
