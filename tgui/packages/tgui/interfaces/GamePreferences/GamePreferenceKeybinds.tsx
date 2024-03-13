import { Section } from "../../components";

interface GamePreferenceKeybindScreenProps {

}

interface GamePreferenceKeybind {
  id: string;
  name: string;
  desc: string;
  category: string;
}

export const GamePreferenceKeybindScreen = (props: GamePreferenceKeybindScreenProps, context) => {
  return (
    <Section fill>
      Test
    </Section>
  );
};
