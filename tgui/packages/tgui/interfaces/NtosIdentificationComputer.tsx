import { NtosWindow } from "../layouts";
import { Module } from "../components/Module";

export const NtosIdentificationComputer = (props, context) => {
  return (
    <NtosWindow
      width={870}
      height={708}
      resizable>
      <NtosWindow.Content>
        <Module id="modify" />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
