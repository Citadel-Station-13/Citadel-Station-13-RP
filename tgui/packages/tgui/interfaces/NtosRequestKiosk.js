import { NtosWindow } from '../layouts';
import { RequestKioskContent } from './RequestKiosk';

export const NtosRequestKiosk = (props, context) => {
  return (
    <NtosWindow
      width={550}
      height={600}
      resizable>
      <NtosWindow.Content scrollable>
        <RequestKioskContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
