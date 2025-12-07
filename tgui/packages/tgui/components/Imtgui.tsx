/**
 * @file
 * @license MIT
 */

import { Stack } from "tgui-core/components";

import { ActFunctionType } from "../backend";

interface ImtguiProps {
  onButton: (key: string) => void;
  onSelect: (key: string, name: string) => void;
  onMultiselect: (key: string, name: string, enabled: boolean) => void;
}

export const ImtguiDefaultBindings = (act: ActFunctionType): Partial<ImtguiProps> => {
  return {
    onButton: (key: string) => act('imtguiButton', { key: key }),
    onSelect: (key: string, name: string) => act('imtguiSelect', { key: key, name: name }),
    onMultiselect: (key: string, name: string, enabled: boolean) => act('imtguiMultiselect', { key: key, name: name, enabled: enabled }),
  };
};

interface ImtguiStruct {

}

/**
 * "This is just like imgui, but laggy as shit!"
 */
export const Imtgui = (props: ImtguiProps) => {
  return (
    <Stack>
      <Stack.Item>
        Test
      </Stack.Item>
    </Stack>
  );
};
