//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { BooleanLike } from "common/react";
import { useBackend } from "../../backend";
import { Button, LabeledList, NumberInput } from "../../components";
import { Section, SectionProps } from "../../components/Section";
import { AtmosComponent, AtmosComponentData } from "../common/AtmosMachine";

interface AtmosTrinaryMolarFilterControlProps extends SectionProps {
  invert: BooleanLike;
  lower: number;
  upper: number;
  setLower: (mass: number) => void;
  setUpper: (mass: number) => void;
  toggleInvert: (on: boolean) => void;
}

export const AtmosTrinaryMolarFilterControl = (props: AtmosTrinaryMolarFilterControlProps, context) => {
  return (
    <Section title="Filter" {...props}>
      <LabeledList>
        <LabeledList.Item label="Upper Bound">
          <NumberInput value={props.upper} step={0.5} minValue={0} maxValue={100000000}
            onChange={(e, val) => props.setUpper(val)} />
        </LabeledList.Item>
        <LabeledList.Item label="Lower Bound">
          <NumberInput value={props.lower} step={0.5} minValue={0} maxValue={100000000}
            onChange={(e, val) => props.setLower(val)} />
        </LabeledList.Item>
        <LabeledList.Item label="Inversion">
          <Button.Checkbox content={props.invert? "Inverted" : "Normal"}
            selected={props.invert}
            onClick={() => props.toggleInvert(!props.invert)} />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

interface AtmosTrinaryMolarFilterData extends AtmosComponentData {
  lower: number;
  upper: number;
  invert: BooleanLike;
  rate: number;
  maxRate: number;
}

export const AtmosTrinaryMolarFilter = (props, context) => {
  const { act, data } = useBackend<AtmosTrinaryMolarFilterData>(context);

  return (
    <AtmosComponent
      title="Mass Filter"
      additionalListItems={(
        <LabeledList.Item label="Flow">
          <NumberInput minValue={0} maxValue={data.maxRate}
            value={data.rate} onChange={(e, val) => act('rate', { rate: val })} /> L/s
        </LabeledList.Item>
      )}>
      <AtmosTrinaryMolarFilterControl
        setLower={(amt) => act('lower', { target: amt })}
        setUpper={(amt) => act('upper', { target: amt })}
        toggleInvert={() => act('invert')}
        lower={data.lower}
        upper={data.upper}
        invert={data.invert} />
    </AtmosComponent>
  );
};
