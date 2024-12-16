import { NtosWindow } from '../layouts';
import { SignalerContent } from './Signaler';

export const NtosSignaler = (props, context) => {
  return (
    <NtosWindow
      width={400}
      height={300}>
      <NtosWindow.Content>
        <SignalerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
