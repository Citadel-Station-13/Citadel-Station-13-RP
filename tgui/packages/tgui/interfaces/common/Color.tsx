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
