import { useState } from 'react';
import { Box, Button, Input, LabeledList, Section, Stack, Table } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { InputButtons } from './common/InputButtons';

type TraitSelectorInputData = {
  initial_traits: string[],
  trait_groups: Record<string, TraitGroupData>,
  available_traits: Record<string, AvailableTraitData>,
  constraints: ConstraintsData,
};

type TraitSelectorSubmissionData = {
  traits: string[],
};

type ConstraintsData = {
  max_traits: number,
  max_points: number
};

type TraitGroupData = {
  internal_name: string
  name: string
  description: string,

  sort_key?: string,

  // populated in later logic
  items?: AvailableTraitData[]
}

type AvailableTraitData = {
  internal_name: string,
  name: string,
  group?: string,
  group_short_name?: string,
  sort_key?: string,
  description: string,
  cost: number,
  forbidden_reason?: string,
  show_when_forbidden: number,

  // list of traits that this trait can't occur with
  exclusive_with: Record<string, number>,

  // populated in later logic
  display_name: string,
  show_name?: boolean,
};

export const TraitSelectorModal = (_) => {
  const { act, data } = useBackend<TraitSelectorInputData>();

  const containsLoosely = function (needle: string, haystack: string): boolean {
    if (needle === "") { return true; }

    return haystack.toLowerCase().indexOf(needle.toLowerCase().trim()) !== -1;
  };

  const [submission, setSubmission] = useState<TraitSelectorSubmissionData>(
    { traits: data.initial_traits }
  );

  const [searchQuery, setSearchQuery] = useState<string>(
    ""
  );

  const stringSubmission = JSON.stringify(submission);

  // -- build add/remove callback --
  const addRemover = (trait: string) => {
    return () => {
      let newTraits = [...submission.traits];
      let ixExisting = newTraits.indexOf(trait);
      if (ixExisting !== -1) {
        newTraits.splice(ixExisting, 1);
      } else {
        newTraits.push(trait);
      }
      setSubmission({ traits: newTraits });
    };
  };


  const generateTraitCards = () => {
    // == Build groups ==
    let groups = {};
    for (let traitPath in data.available_traits) {
      let trait = data.available_traits[traitPath];

      // -- is the trait even showable? --
      if (trait.forbidden_reason && !trait.show_when_forbidden) {
        continue;
      }

      // -- it is: find or make its group --
      let desired_group = trait.group ? data.trait_groups[trait.group] : undefined;
      if (desired_group) {
        let existing = groups[desired_group.internal_name];
        if (!existing) {
          existing = (groups[desired_group.internal_name] = {
            name: desired_group.name,
            description: desired_group.description,
            sort_key: desired_group.sort_key ?? desired_group.name,
            items: [],
          });
        }
        existing.items.push({
          ...trait,
          display_name: trait.group_short_name ?? trait.name,
          sort_key: trait.sort_key ?? trait.name,
          show_name: true,
        });
      } else {
        groups[trait.internal_name] = {
          name: trait.name,
          description: "",
          sort_key: trait.sort_key ?? trait.name,
          items: [{
            ...trait,
            display_name: trait.name,
            sort_key: trait.sort_key ?? trait.name,
            show_name: false,
          }],
        };
      }
    }

    // == Sort the items in every group ==
    for (let groupName in groups) {
      groups[groupName].items.sort(
        (x: AvailableTraitData, y: AvailableTraitData) => (x.sort_key ?? "").localeCompare(y.sort_key ?? "")
      );
    }

    // == Sort the groups ==
    let orderedGroups: TraitGroupData[] = [];
    for (let groupName in groups) {
      orderedGroups.push(groups[groupName]);
    }
    orderedGroups.sort(
      (x, y) => (x.sort_key ?? "").localeCompare(y.sort_key ?? "")
    );

    // == Build cards from groups ==
    let groupCards: any[] = [];
    for (let group of orderedGroups) {
      // -- can this group be shown? --
      let canBeShown = (() => {
        if (containsLoosely(searchQuery, group.name)) {
          return true;
        }

        for (let i of group.items ?? []) {
          if (containsLoosely(searchQuery, i.name)) {
            return true;

          }
          if (i.group_short_name && containsLoosely(searchQuery, i.group_short_name)) {
            return true;
          }
        }
        return false;
      })();

      if (!canBeShown) {
        continue;
      }

      // -- OK, it can be shown --
      let itemCards: any[] = [];

      for (let item of group.items ?? []) {
        // -- our full description --
        let description = (
          <>
            {item.show_name && <Box inline bold>{item.display_name}:</Box>} {" "}
            {item.description}
          </>
        );

        // -- whether we're selected --
        let isSelected = submission.traits.indexOf(item.internal_name) !== -1;

        // -- whether we're disabled --
        let disabledReason = item.forbidden_reason;
        if (!disabledReason) {
          for (let selectedTrait of submission.traits) {
            let rec = data.available_traits[selectedTrait];
            if (rec.exclusive_with[item.internal_name]) {
              disabledReason = "This trait is exclusive with " + rec.name + ".";
              break;
            }
          }
        }

        // -- we can always drop a trait --
        let isDisabled = !!disabledReason;
        if (isSelected) {
          isDisabled = false;
          disabledReason = undefined;
        }

        // -- build the actual button. whew! --
        let selectButton = (
          <Button
            fluid
            color="transparent-with-disabling"
            selected={isSelected}
            disabled={isDisabled}
            tooltip={disabledReason}
            tooltipPosition={"left"}
            onClick={addRemover(item.internal_name)}
          >
            {isDisabled ? (item.forbidden_reason ? "Species" : "Conflict") : (isSelected ? "Deselect" : "Select")}
          </Button>
        );

        itemCards.push(
          <Table.Row>
            <Table.Cell>
              {description}
            </Table.Cell>
            <Table.Cell bold width="2rem" textAlign="right">
              {item.cost.toString()}
            </Table.Cell>
            <Table.Cell width="7rem" textAlign="center">
              {selectButton}
            </Table.Cell>
          </Table.Row>
        );
      }

      let groupCard = (
        <Section title={group.name}>
          {group.description && <Box mb={2}>{group.description}</Box>}
          <Table width="100%">
            {itemCards}
          </Table>
        </Section>
      );
      groupCards.push(groupCard);
    }
    return groupCards;
  };

  let n_traits = 0;
  let n_points = 0;
  for (let t of submission.traits) {
    let rec = data.available_traits[t];
    if (rec.cost !== 0) { n_traits += 1; }
    n_points += rec.cost;
  }

  let max_traits = data.constraints.max_traits;
  let max_points = data.constraints.max_points;

  let traitsSatisfactory = n_traits <= max_traits;
  let pointsSatisfactory = n_points <= max_points;
  let satisfactory = traitsSatisfactory && pointsSatisfactory;

  return (
    <Window title={"Pick traits"} width={640} height={640}>
      <Window.Content
      >
        <Section className="ListInput__Section" fill>
          <Stack fill vertical>
            <Stack.Item grow>
              <Section fill scrollable>
                {generateTraitCards()}
              </Section>
            </Stack.Item>
            <Input
              autoFocus
              autoSelect
              fluid
              onChange={(value) => setSearchQuery(value)}
              placeholder="Search..."
              value={searchQuery}
            />
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Traits Left">
                  <Box>
                    <Box inline bold color={!traitsSatisfactory && "bad"} width="4em" textAlign="right">{(max_traits - n_traits).toString()}</Box>
                    {" "} (Neutral traits are free.)
                  </Box>
                </LabeledList.Item>
                <LabeledList.Item label="Points Left">
                  <Box bold color={!pointsSatisfactory && "bad"} width="4em" textAlign="right">{(max_points - n_points).toString()}</Box>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <InputButtons input={stringSubmission} disabled={!satisfactory} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
