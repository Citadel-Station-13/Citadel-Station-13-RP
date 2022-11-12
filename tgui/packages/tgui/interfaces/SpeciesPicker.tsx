import { BooleanLike } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Section, Stack, Button, Box } from '../components';
import { Window } from '../layouts';

type SpeciesPickerContext = {
  whitelisted: string[],
  species: [String: Species[]],
  default: String,
  admin: BooleanLike,
};

type Species = {
  id: String,
  whitelisted: BooleanLike,
  name: String,
  desc: String,
  appearance_flags: Number,
  flags: Number,
  category: String,
};

// We currently do NOT render species appearance flags/numbers!

export const SpeciesPicker = (props, context) => {
  const { act, data } = useBackend<SpeciesPickerContext>(context);
  const [selectedCategory, setSelectedCategory] = useLocalState<String | null>(context, 'selectedCategory', null);
  const [selectedSpecies, setSelectedSpecies] = useLocalState<String | null>(context, 'selectedSpecies', data.default);
  const { whitelisted = [] } = data;
  let categories: String[] = [];
  let species: Species[] = [];
  let selected: Species | undefined;
  Object.entries(data.species).forEach(([k, v]) => {
    if (categories.indexOf(k) === -1) {
      categories.push(k);
    }
    v.forEach((s) => {
      species.push(s);
      if (s.id === selectedSpecies) {
        selected = s;
      }
    });
  });
  categories.sort();
  const isWhitelisted = (id) => (
    !(species.find((s) => s.id === id)?.whitelisted) || (whitelisted.findIndex((s) => s === id) !== -1) || !!data.admin
  );

  return (
    <Window width={800} height={400}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="25%">
            <Section fill scrollable title="Categories">
              {
                categories.map((k) => (
                  <Button key={k} color="transparent"
                    fluid
                    selected={selectedCategory===k}
                    onClick={() => setSelectedCategory(k)}>
                    {k}
                  </Button>
                ))
              }
            </Section>
          </Stack.Item>
          <Stack.Item width="25%">
            {
              (selectedCategory === null)
                ? (
                  <Section fill />
                ) : (
                  <Section fill scrollable title="Species">
                    {
                      species.filter((s) => s.category === selectedCategory).map((s) => (
                        <Button fluid color="transparent"
                          key={s.id}
                          selected={selectedSpecies === s.id}
                          onClick={() => setSelectedSpecies(s.id)}>
                          {s.name}
                        </Button>
                      ))
                    }
                  </Section>
                )
            }
          </Stack.Item>
          <Stack.Item width="50%">
            {
              (selected === undefined)
                ? (
                  <Section fill />
                ) : (
                  <Section fill title={selected.name}>
                    {selected.desc}
                    {isWhitelisted(selected.id)
                      ? (
                        <Button color="transparent"
                          bottom="10px"
                          left="10px"
                          right="10px"
                          width="auto"
                          position="absolute"
                          textAlign="center"
                          onClick={() => act('pick', { id: selected?.id })}
                        >
                          Select
                        </Button>
                      ) : (
                        <Box
                          bottom="10px"
                          left="10px"
                          right="10px"
                          width="auto"
                          position="absolute"
                          textAlign="center"
                        >
                          Whitelisted
                        </Box>
                      )}
                  </Section>
                )
            }
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

