import { ByondUi } from "../../components";

export const CharacterPreview = (props: {
  readonly height: string,
  readonly id: string,
}) => {
  return (<ByondUi
    width="220px"
    height={props.height}
    params={{
      id: props.id,
      type: "map",
    }}
  />);
};
