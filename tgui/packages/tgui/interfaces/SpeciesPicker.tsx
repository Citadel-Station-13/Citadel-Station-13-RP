import { BooleanLike } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Section, Stack, Button, Box, NoticeBox } from '../components';
import { Window } from '../layouts';
import { sanitizeText } from '../sanitize';

// todo: this stuff should be generic constants somewhere for species manip

type SpeciesPickerContext = {
  whitelisted: string[],
  species: [String: Species[]],
  default: string,
  admin: BooleanLike,
};

type Species = {
  id: string,
  spawn_flags: SpeciesSpawnFlags,
  name: string,
  desc: string,
  appearance_flags: number,
  flags: number,
  category: string,
};

enum SpeciesSpawnFlags {
  Special = (1<<0),
  Character = (1<<1),
  Whitelisted = (1<<2),
  Secret = (1<<3),
  Restricted = (1<<4),
}

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
  const hasWhitelist = (s: Species) => (
    (whitelisted.findIndex((str) => str === s.id) !== -1)
  );
  const hasAdminWhitelist = !!data.admin;
  const isWhitelisted = (s: Species) => (
    (s.spawn_flags & SpeciesSpawnFlags.Whitelisted)
  );
  const isHidden = (s: Species) => (
    (s.spawn_flags & SpeciesSpawnFlags.Secret)
    && !hasWhitelist(s)
  );
  const isRestricted = (s: Species) => (
    (s.spawn_flags & SpeciesSpawnFlags.Restricted)
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
                      species.filter((s) => s.category === selectedCategory && !isHidden(s)).map((s) => (
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
                    <Box dangerouslySetInnerHTML={{ __html: sanitizeText(selected.desc) }} />
                    <Box
                      bottom="10px"
                      left="10px"
                      right="10px"
                      width="auto"
                      position="absolute"
                      textAlign="center"
                    >
                      {!!isRestricted(selected) && (
                        <NoticeBox danger textAlign="center">
                          This is a restricted species.
                          You can select it, but cannot join the game with it in most normal roles.
                        </NoticeBox>
                      )}
                      {!!isWhitelisted(selected) && (hasWhitelist(selected)
                        ?(
                          <NoticeBox success textAlign="center">
                            You have the whitelist to play this species.
                          </NoticeBox>
                        ) : (hasAdminWhitelist? (
                          <NoticeBox success textAlign="center">
                            You have administrative override for this species whitelist.
                            Please play responsibly.
                          </NoticeBox>
                        ) : (
                          <NoticeBox warning textAlign="center">
                            This is a whitelisted species.
                            You can select it, but cannot join the game with it without a whitelist.
                          </NoticeBox>
                        )
                        ))}
                      <Button color="transparent"
                        textAlign="center"
                        width="100% "
                        onClick={() => act('pick', { id: selected?.id })}
                      >
                        Select
                      </Button>
                    </Box>
                  </Section>
                )
            }
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

