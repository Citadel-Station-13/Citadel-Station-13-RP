import { NtosWindow } from '../layouts';
import { CargoContent } from './Cargo.js';

export const NtosCargo = (props, context) => {
  return (
    <NtosWindow
      width={800}
      height={500}>
      <NtosWindow.Content scrollable>
        <CargoContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
