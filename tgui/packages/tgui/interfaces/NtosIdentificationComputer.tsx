import { Module } from "../components/Module";
import { NtosWindow } from "../layouts";

export const NtosIdentificationComputer = (props, context) => {
  return (
    <NtosWindow
      width={870}
      height={708}
      resizable>
      <NtosWindow.Content scrollable>
        <Module id="modify" />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
