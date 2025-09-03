//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { Button, LabeledList, NumberInput } from "tgui-core/components";
import { Section } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { useBackend } from "../../backend";
import { SectionProps } from "../../components";
import { AtmosComponent, AtmosComponentData } from "../common/AtmosMachine";

interface AtmosTrinaryMolarFilterControlProps extends SectionProps {
  readonly invert: BooleanLike;
  readonly lower: number;
  readonly upper: number;
  readonly setLower: (mass: number) => void;
  readonly setUpper: (mass: number) => void;
  readonly toggleInvert: (on: boolean) => void;
}

export const AtmosTrinaryMolarFilterControl = (props: AtmosTrinaryMolarFilterControlProps) => {
  return (
    <Section title="Filter" {...props}>
      <LabeledList>
        <LabeledList.Item label="Upper Bound">
          <NumberInput width="50px" value={props.upper} step={0.5} minValue={0} maxValue={100000000}
            onChange={(val) => props.setUpper(val)}
            unit="g/mol" />
        </LabeledList.Item>
        <LabeledList.Item label="Lower Bound">
          <NumberInput width="50px" value={props.lower} step={0.5} minValue={0} maxValue={100000000}
            onChange={(val) => props.setLower(val)}
            unit="g/mol" />
        </LabeledList.Item>
        <LabeledList.Item label="Inversion">
          <Button.Checkbox content={props.invert ? "Inverted" : "Normal"}
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

export const AtmosTrinaryMolarFilter = (props) => {
  const { act, data } = useBackend<AtmosTrinaryMolarFilterData>();

  return (
    <AtmosComponent
      title="Mass Filter"
      additionalListItems={(
        <LabeledList.Item label="Flow">
          <NumberInput minValue={0} maxValue={data.maxRate} step={0.001}
            value={data.rate} onChange={(val) => act('rate', { rate: val })}
            unit="L/s" />
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
