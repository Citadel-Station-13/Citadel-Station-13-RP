import { DecodeRGBString, EncodeRGBAString, EncodeRGBString, HSVtoRGB, RGBtoHSV } from "common/color";
import { round } from "common/math";
import { Component } from "inferno";
import { Box, ColorBox, Input, NumberInput, Slider, Stack, Table, Tabs } from "../../components";
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

export const ConvertByondColorMatrixRGBACToRGBC = (
  matrix: ByondColorMatrixRGBAC
): ByondColorMatrixRGBC => {
  return [
    matrix[0], matrix[1], matrix[2],
    matrix[4], matrix[5], matrix[6],
    matrix[8], matrix[9], matrix[10],
    matrix[16], matrix[17], matrix[18],
  ];
};

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
        cRed: 255,
        cGreen: 255,
        cBlue: 255,
        cAlpha: 255,
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
    let colorAsString = () => this.props.allowAlpha ? EncodeRGBAString(
      this.state.cRed,
      this.state.cGreen,
      this.state.cBlue,
      this.state.cAlpha,
      true) : EncodeRGBString(
      this.state.cRed,
      this.state.cGreen,
      this.state.cBlue,
      true);
    let [cHue, cSat, cVal] = RGBtoHSV(this.state.cRed, this.state.cGreen, this.state.cBlue).map((n) => round(n, 2));
    return (
      <Box {...this.props}>
        <Stack vertical>
          <Tabs fluid>
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
                  <Stack.Item width="33%">
                    <Stack vertical textAlign="center">
                      <Stack.Item>
                        Red
                        <Slider
                          minValue={0}
                          maxValue={255}
                          step={1}
                          value={this.state.cRed}
                          onDrag={(e, val) => {
                            this.setState((prev) => ({
                              ...prev,
                              cRed: val,
                            }));
                            this.props.setColor(colorAsString());
                          }} />
                      </Stack.Item>
                      <Stack.Item>
                        Green
                        <Slider
                          minValue={0}
                          maxValue={255}
                          step={1}
                          value={this.state.cGreen}
                          onDrag={(e, val) => {
                            this.setState((prev) => ({
                              ...prev,
                              cGreen: val,
                            }));
                            this.props.setColor(colorAsString());
                          }} />
                      </Stack.Item>
                      <Stack.Item>
                        Blue
                        <Slider
                          minValue={0}
                          maxValue={255}
                          step={1}
                          value={this.state.cBlue}
                          onDrag={(e, val) => {
                            this.setState((prev) => ({
                              ...prev,
                              cBlue: val,
                            }));
                            this.props.setColor(colorAsString());
                          }} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  <Stack.Item width="33%">
                    <Stack vertical>
                      <Stack.Item textAlign="center">
                        Hue
                        <Slider
                          minValue={0}
                          maxValue={360}
                          step={1}
                          value={cHue}
                          onDrag={(e, val) => {
                            let [r, g, b] = HSVtoRGB(val, cSat, cVal).map((n) => round(n, 2));
                            this.setState((prev) => ({
                              ...prev,
                              cRed: r,
                              cGreen: g,
                              cBlue: b,
                            }));
                            this.props.setColor(colorAsString());
                          }} />
                      </Stack.Item>
                      <Stack.Item textAlign="center">
                        Saturation
                        <Slider
                          minValue={0}
                          maxValue={100}
                          step={0.5}
                          value={cSat}
                          onDrag={(e, val) => {
                            let [r, g, b] = HSVtoRGB(cHue, val, cVal).map((n) => round(n, 2));
                            this.setState((prev) => ({
                              ...prev,
                              cRed: r,
                              cGreen: g,
                              cBlue: b,
                            }));
                            this.props.setColor(colorAsString());
                          }} />
                      </Stack.Item>
                      <Stack.Item textAlign="center">
                        Value
                        <Slider
                          minValue={0}
                          maxValue={100}
                          step={0.5}
                          value={cVal}
                          onDrag={(e, val) => {
                            let [r, g, b] = HSVtoRGB(cHue, cSat, val).map((n) => round(n, 2));
                            this.setState((prev) => ({
                              ...prev,
                              cRed: r,
                              cGreen: g,
                              cBlue: b,
                            }));
                            this.props.setColor(colorAsString());
                          }} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  <Stack.Item width="33%">
                    <Stack vertical align="center">
                      {this.props.allowAlpha && (
                        <Stack.Item textAlign="center">
                          Alpha
                          <Slider
                            minValue={0}
                            maxValue={255}
                            step={1}
                            value={this.state.cAlpha}
                            onDrag={(e, val) => {
                              this.setState((prev) => ({
                                ...prev,
                                cAlpha: val,
                              }));
                              this.props.setColor(colorAsString());
                            }} />
                        </Stack.Item>
                      )}
                      <Stack.Item>
                        <Input value={colorAsString()} onChange={(e, val) => {
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
                        }} width="90px" />
                      </Stack.Item>
                      <Stack.Item>
                        <ColorBox width="90px" height="90px" color={colorAsString()} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                </Stack>
              </Box>
            )}
            {this.state.mode === ColorPickerMode.Matrix && (
              <Table>
                {
                  this.props.allowAlpha? [
                    ["RR", "RG", "RB", "RA"],
                    ["GR", "GG", "GB", "GA"],
                    ["BR", "BG", "BB", "BA"],
                    ["AR", "AG", "AB", "AA"],
                    ["CR", "CG", "CB", "CA"],
                  ].map((arr, i1) => (
                    <Table.Row key={i1}>
                      {arr.map((l, i2) => {
                        let ifull = (i1 * 4) + (i2);
                        return (
                          <Table.Cell key={i2}>
                            {l}: <NumberInput width="50px"
                              minValue={-10} maxValue={10}
                              step={0.01} value={this.state.cMatrix[ifull]}
                              onChange={(e, val) => {
                                this.setState((prev) => {
                                  let modified = prev.cMatrix.slice();
                                  modified[ifull] = val;
                                  return {
                                    ...prev,
                                    cMatrix: modified as ByondColorMatrixRGBAC,
                                  };
                                });
                                this.props.setColor(this.state.cMatrix);
                              }} />
                          </Table.Cell>
                        ); })}
                    </Table.Row>
                  )) : [
                    ["RR", "RG", "RB"],
                    ["GR", "GG", "GB"],
                    ["BR", "BG", "BB"],
                    ["CR", "CG", "CB"],
                  ].map((arr, i1) => (
                    <Table.Row key={i1}>
                      {arr.map((l, i2) => {
                        let ifull = ((i1 === 3? 4 : i1) * 4) + (i2);
                        return (
                          <Table.Cell key={i2}>
                            {l}: <NumberInput width="50px"
                              minValue={-10} maxValue={10}
                              step={0.01} value={round(this.state.cMatrix[ifull], 4)}
                              onChange={(e, val) => {
                                this.setState((prev) => {
                                  let modified = prev.cMatrix.slice();
                                  modified[ifull] = val;
                                  return {
                                    ...prev,
                                    cMatrix: modified as ByondColorMatrixRGBAC,
                                  };
                                });
                                this.props.setColor(ConvertByondColorMatrixRGBACToRGBC(this.state.cMatrix));
                              }} />
                          </Table.Cell>
                        ); })}
                    </Table.Row>
                  ))
                }
              </Table>
            )}
          </Stack.Item>
        </Stack>
      </Box>
    );
  }
}
