import { LegacyModule } from "../components/LegacyModule";
import { NtosWindow } from "../layouts";

export const NtosIdentificationComputer = (props) => {
  return (
    <NtosWindow
      width={870}
      height={708}
    >
      <NtosWindow.Content scrollable>
        <LegacyModule id="modify" />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
