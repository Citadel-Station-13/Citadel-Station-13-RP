import { DecodeRGBString } from "common/color";
import { Component } from "inferno";
import { Box, Stack, Tabs } from "../../components";
import { BoxProps } from "../../components/Box";

// full, 20-value RGBA matrix with constants
export type ByondColorMatrixRGBAC = [
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
];

export const IdentityByondMatrixRGBAC = (): ByondColorMatrixRGBAC => {
  return [
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
    0, 0, 0, 0,
  ];
};

// partial, 16-value RGBA matrix without constants
export type ByondColorMatrixRGBA = [
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
];

export const IdentityByondMatrixRGBA = (): ByondColorMatrixRGBA => {
  return [
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
  ];
};

// full, 12-value RGB matrix with constants
export type ByondColorMatrixRGBC = [
  number, number, number,
  number, number, number,
  number, number, number,
  number, number, number,
];

export const IdentityByondMatrixRGBC = (): ByondColorMatrixRGBC => {
  return [
    1, 0, 0,
    0, 1, 0,
    0, 0, 1,
    0, 0, 0,
  ];
};

// full, 20-value matrix
export type ByondColorMatrixRGB = [
  number, number, number,
  number, number, number,
  number, number, number,
];

export const IdentityByondMatrixRGB = (): ByondColorMatrixRGB => {
  return [
    1, 0, 0,
    0, 1, 0,
    0, 0, 1,
  ];
};

// RGB or RGBA string, usually used to do color multiply operations / set color vars.
export type ByondColorString = string;

// byond color var compatible
export type ByondAtomColor =
  ByondColorString |
  ByondColorMatrixRGB |
  ByondColorMatrixRGBA |
  ByondColorMatrixRGBAC |
  ByondColorMatrixRGBC;

interface ColorPickerProps extends BoxProps {
  allowMatrix?: boolean;
  allowAlpha?: boolean;
  currentColor: ByondAtomColor;
  setColor: (ByondAtomColor) => void;
}

interface ColorPickerState {
  mode: ColorPickerMode;
  cRed: number;
  cGreen: number;
  cBlue: number;
  cAlpha: number;
  cMatrix: ByondColorMatrixRGBAC;
}

enum ColorPickerMode {
  Normal = 0,
  Matrix = 1,
}

export class ColorPicker extends Component<ColorPickerProps, ColorPickerState> {
  assembleState = (): ColorPickerState => {
    if ((typeof this.props.currentColor) !== 'string') {
      // matrix
    }
    else {
      // string
      let [r, g, b, a] = DecodeRGBString(this.props.currentColor as string);
      return {
        mode: ColorPickerMode.Normal,
        cRed: r,
        cGreen: g,
        cBlue: b,
        cAlpha: a,
        cMatrix: IdentityByondMatrixRGBAC(),
      };
    }
  };

  state: ColorPickerState = this.assembleState();

  render() {
    return (
      <Box {...this.props}>
        <Stack vertical>
          <Tabs>
            <Tabs.Tab
              selected={this.state.mode === ColorPickerMode.Normal}
              onClick={() => this.setState((prev) => ({ ...prev, mode: ColorPickerMode.Normal }))}>Basic
            </Tabs.Tab>
            <Tabs.Tab
              selected={this.state.mode === ColorPickerMode.Matrix}
              onClick={() => this.setState((prev) => ({ ...prev, mode: ColorPickerMode.Matrix }))}>Matrix
            </Tabs.Tab>
          </Tabs>
          <Stack.Item>
            {this.state.mode === ColorPickerMode.Normal && (
              <Box>
                Unimplemented
              </Box>
            )}
            {this.state.mode === ColorPickerMode.Matrix && (
              <Box>
                Unimplemented
              </Box>
            )}
          </Stack.Item>
        </Stack>
      </Box>
    );
  }
}
