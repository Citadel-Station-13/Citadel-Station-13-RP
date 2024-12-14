import { NtosWindow } from '../layouts';
import { CameraContent } from './CameraConsole';

export const NtosCameraConsole = () => {
  return (
    <NtosWindow
      width={870}
      height={708}
      resizable>
      <NtosWindow.Content>
        <CameraContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
