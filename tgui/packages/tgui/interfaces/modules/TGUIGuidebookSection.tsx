import { directlyRouteComponent } from "../../routes";

export interface TGUIGuidebookSectionData {
  name: string;
  tgui: string;
  data: any;
}

export const TGUIGuidebookSection = (props: TGUIGuidebookSectionData, context) => {
  return directlyRouteComponent(props.tgui);
}
