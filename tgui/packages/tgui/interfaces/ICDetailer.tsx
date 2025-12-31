import { Button, Section } from "tgui-core/components";
import { toTitleCase } from 'tgui-core/string';

import { useBackend } from "../backend";
import { Window } from "../layouts";

export const ICDetailer = (props) => {
  const { act, data } = useBackend<any>();

  const {
    detail_color,
    color_list,
  } = data;

  return (
    <Window width={420} height={254}>
      <Window.Content>
        <Section>
          {Object.keys(color_list).map((key, i) => (
            <Button
              key={key}
              ml={0}
              mr={0}
              mb={-0.4}
              mt={0}
              tooltip={toTitleCase(key)}
              tooltipPosition={i % 6 === 5 ? "left" : "right"}
              height="64px"
              width="64px"
              onClick={() => act("change_color", { color: key })}
              style={color_list[key] === detail_color ? {
                border: "4px solid black",
                borderRadius: 0,
              } : {
                borderRadius: 0,
              }}
              backgroundColor={color_list[key]} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
