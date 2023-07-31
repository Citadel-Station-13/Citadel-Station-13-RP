import { BooleanLike } from "../../../common/react";
import { useBackend } from "../../backend";
import { Section, Stack } from "../../components";
import { ComponentProps } from "../../components/Component";
import { Window } from "../../layouts";

enum AtmosPortableUIFlags {
  None = (0),
  ViewFlow = (1<<0),
  TogglePower = (1<<1),
}

interface AtmosPortableControlProps {
  // portable data
  data: AtmosPortableData;
  // toggle on/off act ; also determines if it's allowed to toggle
  toggleAct?: () => void;
}

export const AtmosPortableControl = (props: AtmosPortableControlProps, context) => {
  return (
    <Section>
      test
    </Section>
  );
};



export interface AtmosPortableData {
  // UI control flgas
  controlFlags: AtmosPortableUIFlags;
  // on
  on: BooleanLike;
  // uses charge
  useCharge: BooleanLike;
  // cell maxcharge
  maxCharge: number;
  // cell charge
  charge: number;
  // flow rate
  flow: number;
}

interface AtmosPortableProps extends ComponentProps{
  extraHeight?: number;
}

export const AtmosPortable = (props: AtmosPortableProps, context) => {
  const { data, act } = useBackend<AtmosPortableData>(context);
  return (
    <Window width={500} height={300 + (props.extraHeight || 0)}>
      <Window.Content>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <AtmosPortableControl
                data={data} />
            </Stack.Item>
            {props.children && (
              <Stack.Item grow>
                {props.children}
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
