type setNumberFunction = (v: number) => void;

interface HSVColorPickerProps {
  hue: number;
  sat: number;
  val: number;
  onHue: setNumberFunction;
  onSat: setNumberFunction;
  onVal: setNumberFunction;
}

export const HSVColorPicker = (props: HSVColorPickerProps, context) => {

};

interface RGBColorPickerProps {
  rVal: number;
  gVal: number;
  bVal: number;
  onRed: number;
  onGreen: number;
  onBlue: number;
}

export const RGBColorPicker = (props: RGBColorPickerProps, context) => {

};


