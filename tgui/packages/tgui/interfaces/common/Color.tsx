import { DecodeRGBString, EncodeRGBAString, EncodeRGBString, RGBtoHSV } from "common/color";
import { Component } from "inferno";
import { Box, ColorBox, Input, Slider, Stack, Tabs } from "../../components";
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

export type ByondColorMatrix =
  ByondColorMatrixRGB |
  ByondColorMatrixRGBA |
  ByondColorMatrixRGBAC |
  ByondColorMatrixRGBC;

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

export const ConvertByondColorMatrixtoRGBAC = (
  matrix: ByondColorMatrixRGB | ByondColorMatrixRGBA | ByondColorMatrixRGBAC | ByondColorMatrixRGBC)
  : ByondColorMatrixRGBAC => {
  switch (matrix.length) {
    case 9:
      return [
        matrix[0],
        matrix[1],
        matrix[2],
        0,
        matrix[3],
        matrix[4],
        matrix[5],
        0,
        matrix[6],
        matrix[7],
        matrix[8],
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
      ];
    case 12:
      return [
        matrix[0],
        matrix[1],
        matrix[2],
        0,
        matrix[3],
        matrix[4],
        matrix[5],
        0,
        matrix[6],
        matrix[7],
        matrix[8],
        0,
        0,
        0,
        0,
        1,
        matrix[9],
        matrix[10],
        matrix[11],
        0,
      ];
    case 16:
      matrix = matrix.slice() as ByondColorMatrixRGBA;
      matrix.push(0, 0, 0, 0);
      return matrix as unknown as ByondColorMatrixRGBAC;
    case 20:
      return matrix;
    default:
      throw new Error("invalid matrix length");
  }
};

export class ColorPicker extends Component<ColorPickerProps, ColorPickerState> {
  assembleState = (): ColorPickerState => {
    if ((typeof this.props.currentColor) !== 'string') {
      // matrix
      return {
        mode: ColorPickerMode.Matrix,
        cRed: 1,
        cGreen: 1,
        cBlue: 1,
        cAlpha: 1,
        cMatrix: ConvertByondColorMatrixtoRGBAC(this.props.currentColor as ByondColorMatrix),
      };
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
    throw new Error("not matrix or string");
  };

  state: ColorPickerState = this.assembleState();

  render() {
    let colorAsString = this.props.allowAlpha ? EncodeRGBAString(
      this.state.cRed,
      this.state.cGreen,
      this.state.cBlue,
      this.state.cAlpha,
      true) : EncodeRGBString(
      this.state.cRed,
      this.state.cGreen,
      this.state.cBlue,
      true);
    let [cHue, cSat, cVal] = RGBtoHSV(this.state.cRed, this.state.cGreen, this.state.cBlue);
    return (
      <Box {...this.props}>
        <Stack vertical>
          <Tabs>
            <Tabs.Tab
              selected={this.state.mode === ColorPickerMode.Normal}
              onClick={() => {
                this.setState((prev) => ({ ...prev, mode: ColorPickerMode.Normal }));
                this.props.setColor(
                  this.props.allowAlpha
                    ? EncodeRGBAString(this.state.cRed, this.state.cGreen, this.state.cBlue, this.state.cAlpha, true)
                    : EncodeRGBString(this.state.cRed, this.state.cGreen, this.state.cBlue, true));
              }}>Basic
            </Tabs.Tab>
            <Tabs.Tab
              selected={this.state.mode === ColorPickerMode.Matrix}
              onClick={() => {
                this.setState((prev) => ({ ...prev, mode: ColorPickerMode.Matrix }));
                this.props.setColor(this.state.cMatrix);
              }}>Matrix
            </Tabs.Tab>
          </Tabs>
          <Stack.Item>
            {this.state.mode === ColorPickerMode.Normal && (
              <Box>
                <Stack>
                  <Stack.Item>
                    <Stack vertical textAlign="center">
                      <Stack.Item>
                        Red
                        <Slider
                          minValue={0}
                          maxValue={360}
                          step={1}
                          value={this.state.cRed}
                          onDrag={(e, val) => {

                          }} />
                      </Stack.Item>
                      <Stack.Item>
                        Green
                        <Slider
                          minValue={0}
                          maxValue={100}
                          step={1}
                          value={this.state.cGreen}
                          onDrag={(e, val) => {

                          }} />
                      </Stack.Item>
                      <Stack.Item>
                        Blue
                        <Slider
                          minValue={0}
                          maxValue={100}
                          step={1}
                          value={this.state.cBlue}
                          onDrag={(e, val) => {

                          }} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  <Stack.Item>
                    <Stack vertical>
                      <Stack.Item textAlign="center">
                        Hue
                        <Slider
                          minValue={0}
                          maxValue={360}
                          step={1}
                          value={cHue}
                          onDrag={(e, val) => {

                          }} />
                      </Stack.Item>
                      <Stack.Item textAlign="center">
                        Saturation
                        <Slider
                          minValue={0}
                          maxValue={100}
                          step={1}
                          value={cSat}
                          onDrag={(e, val) => {

                          }} />
                      </Stack.Item>
                      <Stack.Item textAlign="center">
                        Value
                        <Slider
                          minValue={0}
                          maxValue={100}
                          step={1}
                          value={cVal}
                          onDrag={(e, val) => {

                          }} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  <Stack.Item>
                    <Stack vertical>
                      {this.props.allowAlpha && (
                        <Stack.Item textAlign="center">
                          Alpha
                          <Slider
                            minValue={0}
                            maxValue={255}
                            step={1}
                            value={this.state.cAlpha}
                            onDrag={(e, val) => {

                            }} />
                        </Stack.Item>
                      )}
                      <Stack.Item>
                        <Input value={colorAsString} onChange={(e, val) => {
                          try {
                            let [r, g, b, a] = DecodeRGBString(val);
                            this.setState((prev) => ({
                              ...prev,
                              cAlpha: a,
                              cRed: r,
                              cBlue: b,
                              cGreen: g,
                            }));
                            this.props.setColor(val);
                          }
                          finally {}
                        }} minWidth="45px" />
                      </Stack.Item>
                      <Stack.Item>
                        <ColorBox width="100px" height="100px" color={colorAsString} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                </Stack>
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
