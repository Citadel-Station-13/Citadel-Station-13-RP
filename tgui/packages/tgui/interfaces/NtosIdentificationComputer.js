import { useBackend } from "../backend";
import { NtosWindow } from "../layouts";
import { IdentificationComputer } from "./computers/IdentificationComputer";

export const NtosIdentificationComputer = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <NtosWindow width={600} height={700} resizable>
      <NtosWindow.Content scrollable>
        <IdentificationComputer ntos />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
