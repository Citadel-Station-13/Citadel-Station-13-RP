/**
 * Generic helpers for accesses.
 *
 * @file
 * @license MIT
 */

import { useLocalState } from "../../backend";
import { Button, Flex, LabeledList, Section, Tabs } from "../../components";
import { AccessRegions, AccessTypes } from "../../constants/access";

export enum AccessListMode {
  AuthMode = "auth", // req, req_one
  SelectMode = "select", // select one
  ModMode = "modify", // modify all
}

export enum AccessListSet {
  All = "all",
  One = "one",
}

export interface AccessListProps {
  access: Array<Access>, // all available accesses
}

interface AccessListSelectProps extends AccessListProps {
  select?(id: AccessId): void,
  selected: AccessId,
}

interface AccessListModProps extends AccessListProps {
  selected: Array<AccessId>,
  set?(id: AccessId): void,
  grant?(category?: string): void,
  deny?(category?: string): void,
}

interface AccessListAuthProps extends AccessListProps {
  set?(id: AccessId, mode: AccessListSet): void,
  wipe?(category?: string): void,
  req_access?: Array<AccessId>,
  req_one_access?: Array<AccessId>,
}

export type AccessId = number;

export interface Access {
  value: number,
  name: string,
  category: string,
  region: AccessRegions,
  type: AccessTypes,
}

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

export const AccessListMod = (props: AccessListModProps, context) => {
  const [selectedCategory, setSelectedCategory] = useLocalState<string | null>(context, 'selectedCategory', null);
  let categories: string[] = [];
  let lookup = new Map<number, Access>();
  props.access.forEach((a) => {
    if (!categories.includes(a.category)) {
      categories.push(a.category);
    }
    lookup.set(a.value, a);
  });
  categories.sort();
  const checkCategory = (cat: string) => {
    let needed: number[] = [];
    props.access.forEach((a) => {
      if (a.category === cat) {
        needed.push(a.value);
      }
    });
    let any = false;
    needed.forEach((n) => {
      if (props.selected.find((_n) => _n === n)) {
        any = true;
      }
      else {
        return any? 1 : 0;
      }
    });
    return 2;
  };
  return (
    <Section
      title="Access Modification"
      buttons={
        <>
          test1
          <Button
            icon="check-double"
            content="Grant All"
            color="good"
            onClick={() => props.grant && props.grant()} />
          <Button
            icon="undo"
            content="Deny All"
            color="bad"
            onClick={() => props.deny && props.deny()} />
        </>
      }>
      <Flex>
        <Flex.Item pr={2}>
          <Tabs vertical>
            {
              categories.map((cat) => {
                const { icon, color } = diffMap[checkCategory(cat)];
                return (
                  <Tabs.Tab
                    key={cat}
                    altSelection
                    color={color}
                    icon={icon}
                    selected={cat === selectedCategory}
                    onClick={() => setSelectedCategory(cat)}>
                    {cat}
                  </Tabs.Tab>
                );
              })
            }
          </Tabs>
        </Flex.Item>
        <Flex.Item grow={1}>
          <Flex direction="row" justify="flex-end">
            {
              !!selectedCategory && (
                <>
                  test2
                  <Flex.Item>
                    <Button
                      icon="check"
                      content="Grant Category"
                      color="good"
                      onClick={() => props.grant && props.grant(selectedCategory)}
                      fluid />
                  </Flex.Item>
                  <Flex.Item>
                    <Button
                      icon="times"
                      content="Deny Category"
                      color="bad"
                      onClick={() => props.deny && props.deny(selectedCategory)}
                      fluid />
                  </Flex.Item>
                </>
              )
            }
          </Flex>
          {
            props.access.filter((_a) => _a.category === selectedCategory).map((a) => {
              return (
                <Button.Checkbox
                  key={a.value}
                  fluid
                  checked={props.selected.includes(a.value)}
                  content={a.name}
                  onClick={() => props.set && props.set(a.value)} />
              );
            })
          }
        </Flex.Item>
      </Flex>
    </Section>
  );
};

export const AccessListAuth = (props: AccessListAuthProps, context) => {
  const [selectedCategory, setSelectedCategory] = useLocalState<string | null>(context, 'selectedCategory', null);
  let categories: string[] = [];
  let lookup = new Map<number, Access>();
  props.access.forEach((a) => {
    if (!categories.includes(a.category)) {
      categories.push(a.category);
    }
    lookup.set(a.value, a);
  });
  categories.sort();
  const checkCategory = (cat: string) => {
    if (props.req_access) {
      for (let a of props.req_access) {
        if (lookup.get(a)?.category === cat) {
          return 2;
        }
      }
    }
    if (props.req_one_access) {
      for (let a of props.req_one_access) {
        if (lookup.get(a)?.category === cat) {
          return 2;
        }
      }
    }
    return 0;
  };
  return (
    <Section>
      <Flex>
        <Flex.Item>
          <Tabs vertical />
          {
            categories.map((cat) => {
              const { icon, color } = diffMap[checkCategory(cat)];
              return (
                <Tabs.Tab
                  key={cat}
                  altSelection
                  color={color}
                  icon={icon}
                  selected={cat === selectedCategory}
                  onClick={() => setSelectedCategory(cat)}>
                  {cat}
                </Tabs.Tab>
              );
            })
          }
        </Flex.Item>
        <Flex.Item grow={1}>
          {
            !!selectedCategory && (
              <Button
                icon="times"
                content="Wipe Category"
                color="bad"
                onClick={() => props.wipe && props.wipe(selectedCategory)}
                fluid />
            )
          }
          <LabeledList>
            {
              props.access.filter((_a) => _a.category === selectedCategory).map((a) => {
                return (
                  <LabeledList.Item
                    key={a.value}
                    buttons={
                      <>
                        <Button
                          selected={props.req_access?.includes(a.value)}
                          onClick={() => props.set && props.set(a.value, AccessListSet.All)}
                          content="All" />
                        <Button
                          selected={props.req_one_access?.includes(a.value)}
                          onClick={() => props.set && props.set(a.value, AccessListSet.One)}
                          content="All" />
                      </>
                    }>
                    {a.name}
                  </LabeledList.Item>
                );
              })
            }
          </LabeledList>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

export const AccessListSelect = (props: AccessListSelectProps, context) => {
  const [selectedCategory, setSelectedCategory] = useLocalState<string | null>(context, 'selectedCategory', null);
  let categories: string[] = [];
  props.access.forEach((a) => {
    if (!categories.includes(a.category)) {
      categories.push(a.category);
    }
  });
  categories.sort();

  return (
    <Section>
      <Flex>
        <Flex.Item>
          <Tabs vertical />
          {
            categories.map((cat) => {
              const { icon, color } = diffMap[
                props.selected && (props.access.find((a) => a.value === props.selected))?2 : 0];
              return (
                <Tabs.Tab
                  key={cat}
                  altSelection
                  color={color}
                  icon={icon}
                  selected={cat === selectedCategory}
                  onClick={() => setSelectedCategory(cat)}>
                  {cat}
                </Tabs.Tab>
              );
            })
          }
        </Flex.Item>
        <Flex.Item grow={1}>
          {props.access.filter((_a) => _a.category === selectedCategory).map((a) => {
            return (
              <Button
                fluid
                key={a.value}
                content={a.name}
                color={props.selected === a.value? "good" : "transparent"}
                onClick={() => props.select && props.select(a.value)} />
            );
          })}
        </Flex.Item>
      </Flex>
    </Section>
  );
};
