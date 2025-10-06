import { NtosWindow } from '../layouts';
import { CameraConsoleNTOS } from './CameraConsole';

export const NtosCameraConsole = () => {
  return (
    <NtosWindow
      width={870}
      height={708}
      resizable>
      <NtosWindow.Content>
        <CameraConsoleNTOS />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
