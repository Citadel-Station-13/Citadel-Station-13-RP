import { useBackend } from "../backend";
import { NtosWindow } from "../layouts";
import { CommunicationsConsoleContent } from "./CommunicationsConsole";

export const NtosCommunicationsConsole = (props) => {
  const { act, data } = useBackend<any>();

  return (
    <NtosWindow width={400} height={600}>
      <NtosWindow.Content scrollable>
        <CommunicationsConsoleContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
