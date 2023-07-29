import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { Button, Collapsible, Divider, Flex, Icon, Input, Section } from '../components';
import { Window } from '../layouts';

const PATTERN_NUMBER = / \(([0-9]+)\)$/;

const searchFor = (searchText: string) => {
  return createSearch(searchText, (thing: { name: string}) => thing.name);
};

const compareNumberedText = (
  a: { name: string },
  b: { name: string },
) => {
  const aName = a.name;
  const bName = b.name;

  // Check if aName and bName are the same except for a number at the end
  // e.g. Medibot (2) and Medibot (3)
  const aNumberMatch = aName.match(PATTERN_NUMBER);
  const bNumberMatch = bName.match(PATTERN_NUMBER);

  if (aNumberMatch
    && bNumberMatch
    && aName.replace(PATTERN_NUMBER, "") === bName.replace(PATTERN_NUMBER, "")
  ) {
    const aNumber = parseInt(aNumberMatch[1], 10);
    const bNumber = parseInt(bNumberMatch[1], 10);

    return aNumber - bNumber;
  }

  return aName.localeCompare(bName);
};

type OrbitList = {
  name: string,
  ref: string,
}

type OrbitData = {
  players: OrbitList[],
  simplemobs: OrbitList[],
  ghosts: OrbitList[],
  misc: OrbitList[],
  items_of_interest: OrbitList[],
  npcs: OrbitList[],
}

type BasicSectionProps = {
  searchText: string,
  source: OrbitList[],
  title: string,
}

type OrbitedButtonProps = {
  color: string,
  thing: OrbitList,
}

const BasicSection = (props: BasicSectionProps, context: any) => {
  const { act } = useBackend(context);
  const { searchText, source, title } = props;
  const things = source.filter(searchFor(searchText));
  things.sort(compareNumberedText);
  if (source.length <= 0) {
    return null;
  }
  return (
    <Section title={`${title} - (${source.length})`}>
      {things.map((thing: OrbitList) => (
        <Button
          key={thing.name}
          content={thing.name}
          onClick={() => act("orbit", {
            ref: thing.ref,
          })} />
      ))}
    </Section>
  );
};

const OrbitedButton = (props: OrbitedButtonProps, context: any) => {
  const { act } = useBackend(context);
  const { color, thing } = props;

  return (
    <Button
      color={color}
      onClick={() => act("orbit", {
        ref: thing.ref,
      })}>
      {thing.name}
    </Button>
  );
};

export const Orbit = (props: any, context: any) => {
  const { act, data } = useBackend<OrbitData>(context);
  const {
    players,
    simplemobs,
    items_of_interest,
    ghosts,
    misc,
    npcs,
  } = data;

  const [searchText, setSearchText] = useLocalState(context, "searchText", "");

  const orbitMostRelevant = (searchText: string) => {
    for (const source of [
      players,
      simplemobs,
    ]) {
      const member = source
        .filter(searchFor(searchText))
        .sort(compareNumberedText)[0];
      if (member !== undefined) {
        act("orbit", { ref: member.ref });
        break;
      }
    }
  };

  return (
    <Window
      title="Orbit"
      width={350}
      height={700}>
      <Window.Content scrollable>
        <Section>
          <Flex>
            <Flex.Item>
              <Icon
                name="search"
                mr={1} />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Input
                placeholder="Search..."
                autoFocus
                fluid
                value={searchText}
                onInput={(_: any, value: string) => setSearchText(value)}
                onEnter={(_: any, value: string) => orbitMostRelevant(value)} />
            </Flex.Item>
            <Flex.Item>
              <Divider vertical />
            </Flex.Item>
            <Flex.Item>
              <Button onClick={() => act("refresh")}>
                Refresh
              </Button>
            </Flex.Item>
          </Flex>
        </Section>

        <Collapsible title={`Players - (${players.length})`}>
          {players
            .filter(searchFor(searchText))
            .sort(compareNumberedText)
            .map(thing => (
              <OrbitedButton
                key={thing.name}
                color="good"
                thing={thing} />
            ))}
        </Collapsible>
        <Collapsible title={`Simple Mobs - (${simplemobs.length})`}>
          {simplemobs
            .filter(searchFor(searchText))
            .sort(compareNumberedText)
            .map(thing => (
              <OrbitedButton
                key={thing.name}
                color="good"
                thing={thing} />
            ))}
        </Collapsible>
        <Collapsible title={`Items of Interest - (${items_of_interest.length})`}>
          {items_of_interest
            .map(thing => (
              <OrbitedButton
                key={thing.name}
                color="good"
                thing={thing} />
            ))}
        </Collapsible>
        <Collapsible title={`NPCs - (${npcs.length})`}>
          {npcs
            .filter(searchFor(searchText))
            .sort(compareNumberedText)
            .map(thing => (
              <OrbitedButton
                key={thing.name}
                color="grey"
                thing={thing} />
            ))}
        </Collapsible>
        <Collapsible title={`Ghosts - (${ghosts.length})`}>
          {ghosts
            .filter(searchFor(searchText))
            .sort(compareNumberedText)
            .map(thing => (
              <OrbitedButton
                key={thing.name}
                color="grey"
                thing={thing} />
            ))}
        </Collapsible>

        <BasicSection
          title="Misc"
          source={misc}
          searchText={searchText}
        />
      </Window.Content>
    </Window>
  );
};
