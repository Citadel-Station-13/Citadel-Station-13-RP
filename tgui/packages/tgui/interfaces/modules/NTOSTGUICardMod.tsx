import { TGUICardMod } from "./TGUICardMod";
import { NtosWindow } from "../../layouts";

export const NTOSTGUICardMod = () => {
  return (
    <NtosWindow
      width={870}
      height={708}
      resizable>
      <NtosWindow.Content>
        <TGUICardMod id="ntoscardmod" />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
