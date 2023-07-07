import { Component } from "inferno";
import { Box, Section, Tabs } from "../../components";
import { BoxProps } from "../../components/Box";

// full, 20-value RGBA matrix with constants
export type ByondColorMatrixRGBAC = [
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
];

// partial, 16-value RGBA matrix without constants
export type ByondColorMatrixRGBA = [
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
  number, number, number, number,
];

// full, 12-value RGB matrix with constants
export type ByondColorMatrixRGBC = [
  number, number, number,
  number, number, number,
  number, number, number,
  number, number, number,
];

// full, 20-value matrix
export type ByondColorMatrixRGB = [
  number, number, number,
  number, number, number,
  number, number, number,
];

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
  allowMatrix: boolean;
  currentColor: ByondAtomColor;
  setColor: (ByondAtomColor) => void;
}

interface ColorPickerState {
  mode: ColorPickerMode;
}

enum ColorPickerMode {
  Normal = 0,
  Matrix = 1,
}

export class ColorPicker extends Component<ColorPickerProps, ColorPickerState> {
  state = {
    mode: ColorPickerMode.Normal,
  };

  render() {
    return (
      <Box {...this.props}>
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
        <Section>
          Unimplemented
        </Section>
      </Box>
    );
  }
}
