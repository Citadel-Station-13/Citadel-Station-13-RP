import { DecodeRGBString, EncodeRGBAString, EncodeRGBString, HSVtoRGB, RGBtoHSV } from "./color";

describe("RGBtoHSV", () => {
  test("RGB2HSV", () => {
    expect(RGBtoHSV(125, 179, 128).map((n) => Math.round(n))).toEqual([123, 30, 70]);
  });
});

describe("HSVtoRGB", () => {
  test("HSVtoRGB", () => {
    expect(HSVtoRGB(123, 30, 70).map((n) => Math.round(n))).toEqual([125, 179, 128]);
  });
});

describe("DecodeRGBString", () => {
  test("DecodeRGBString", () => {
    expect(DecodeRGBString("#abcdef40").map((n) => Math.round(n))).toEqual([171, 205, 239, 64]);
  });
});

describe("EncodeRGBString", () => {
  test("EncodeRGBString", () => {
    expect(EncodeRGBString(171, 205, 239, true)).toEqual("#abcdef");
  });
});

describe("EncodeRGBAString", () => {
  test("EncodeRGBAString", () => {
    expect(EncodeRGBAString(171, 205, 239, 64, true)).toEqual("#abcdef40");
  });
});
