import { BooleanLike } from "common/react";
import { useBackend, useLocalState } from "../../backend";
import { Button, Flex, LabeledList, Section, Tabs } from "../../components";

interface AccessListProps {
  access: [Access],
  authMode: BooleanLike, // on authMode, we're setting auth, meaning we read req/req_one
  setAccess: Function, // called to toggle access
  grantAll: Function, // non-auth mode
  denyAll: Function, // non-auth mode
  wipeAll: Function, // auth mode
  grantCategory: Function, // non-auth mode
  denyCategory: Function, // non-auth mode
  wipeCategory: Function, // auth mode
}

interface AccessListData {
  selected: [Number], // non-auth mode
  req_access: [Number], // auth mode
  req_one_access: [Number], // auth mode
  writable: BooleanLike,
}

interface Access {
  value: Number,
  name: String,
  category: String,
}

export const AccessList = (props: AccessListProps, context) => {
  const { act, data } = useBackend<AccessListData>(context);
  const [selectedCategory, setSelectedCategory] = useLocalState<String | null>(context, 'selectedCategory', null);

  return (
    <Section
      title="Access List"
      buttons={!!data.writable && props.authMode? (
        <Button
          icon="undo"
          content="Reset"
          color="bad"
          onClick={() => props.wipeAll()} />
      ) : (
        <>
          <Button
            icon="check-double"
            content="Grant All"
            color="good"
            onClick={() => props.grantAll()} />
          <Button
            icon="undo"
            content="Deny All"
            color="bad"
            onClick={() => props.denyAll()} />
        </>
      )}>
      <Flex>
        <Flex.Item>
          <Tabs vertical>
            {
              warn impl
            }
          </Tabs>
        </Flex.Item>
        <Flex.Item grow={1}>
          <Flex>
            <Flex.Item>
              {
                !!data.writable && props.authMode? (
                  <Button
                    fluid
                    icon="times"
                    content="Wipe Category"
                    color="times"
                    onClick={() => props.wipeCategory(selectedCategory)} />
                ) : (
                  <>
                    <Button
                      fluid
                      icon="check"
                      content="Grant Category"
                      color="good"
                      onClick={() => props.grantCategory(selectedCategory)} />
                    <Button
                      fluid
                      icon="times"
                      content="Deny Category"
                      color="bad"
                      onClick={() => props.denyCategory(selectedCategory)} />
                  </>
                )
              }
            </Flex.Item>
          </Flex>
          <LabeledList>
            {
              warn impl
            }
          </LabeledList>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

/*
import { sortBy } from 'common/collections';
import { Fragment } from 'inferno';
import { useLocalState } from '../../backend';
import { Button, Flex, Grid, Section, Tabs } from '../../components';

const diffMap = {
  0: {
    icon: 'times-circle',
    color: 'bad',
  },
  1: {
    icon: 'stop-circle',
    color: null,
  },
  2: {
    icon: 'check-circle',
    color: 'good',
  },
};

export const AccessList = (props, context) => {
  const {
    accesses = [],
    selectedList = [],
    accessMod,
    grantAll,
    denyAll,
    grantDep,
    denyDep,
  } = props;
  const [
    selectedAccessName,
    setSelectedAccessName,
  ] = useLocalState(context, 'accessName', accesses[0]?.name);
  const selectedAccess = accesses
    .find(access => access.name === selectedAccessName);
  const selectedAccessEntries = sortBy(
    entry => entry.desc,
  )(selectedAccess?.accesses || []);

  const checkAccessIcon = accesses => {
    let oneAccess = false;
    let oneInaccess = false;
    for (let element of accesses) {
      if (selectedList.includes(element.ref)) {
        oneAccess = true;
      }
      else {
        oneInaccess = true;
      }
    }
    if (!oneAccess && oneInaccess) {
      return 0;
    }
    else if (oneAccess && oneInaccess) {
      return 1;
    }
    else {
      return 2;
    }
  };

  return (
    <Section
      title="Access"
      buttons={(
        <Fragment>
          <Button
            icon="check-double"
            content="Grant All"
            color="good"
            onClick={() => grantAll()} />
          <Button
            icon="undo"
            content="Deny All"
            color="bad"
            onClick={() => denyAll()} />
        </Fragment>
      )}>
      <Flex>
        <Flex.Item>
          <Tabs vertical>
            {accesses.map(access => {
              const entries = access.accesses || [];
              const icon = diffMap[checkAccessIcon(entries)].icon;
              const color = diffMap[checkAccessIcon(entries)].color;
              return (
                <Tabs.Tab
                  key={access.name}
                  altSelection
                  color={color}
                  icon={icon}
                  selected={access.name === selectedAccessName}
                  onClick={() => setSelectedAccessName(access.name)}>
                  {access.name}
                </Tabs.Tab>
              );
            })}
          </Tabs>
        </Flex.Item>
        <Flex.Item grow={1}>
          <Grid>
            <Grid.Column mr={0}>
              <Button
                fluid
                icon="check"
                content="Grant Region"
                color="good"
                onClick={() => grantDep(selectedAccess.regid)} />
            </Grid.Column>
            <Grid.Column ml={0}>
              <Button
                fluid
                icon="times"
                content="Deny Region"
                color="bad"
                onClick={() => denyDep(selectedAccess.regid)} />
            </Grid.Column>
          </Grid>
          {selectedAccessEntries.map(entry => (
            <Button.Checkbox
              fluid
              key={entry.desc}
              content={entry.desc}
              checked={selectedList.includes(entry.ref)}
              onClick={() => accessMod(entry.ref)} />
          ))}
        </Flex.Item>
      </Flex>
    </Section>
  );
};
*/
