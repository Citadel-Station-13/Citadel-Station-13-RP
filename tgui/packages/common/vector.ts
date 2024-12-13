/**
 * N-dimensional vector manipulation functions.
 *
 * Vectors are plain number arrays, i.e. [x, y, z].
 *
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { map, reduce, zip } from './collections';

const ADD = (a: number, b: number): number => a + b;
const SUB = (a: number, b: number): number => a - b;
const MUL = (a: number, b: number): number => a * b;
const DIV = (a: number, b: number): number => a / b;

export type Vector = number[];

export const vecAdd = (...vecs: Vector[]): Vector => {
  return map((x: number[]) => reduce(x, ADD))(zip(...vecs));
};

export const vecSubtract = (...vecs: Vector[]): Vector => {
  return map((x: number[]) => reduce(x, SUB))(zip(...vecs));
};

export const vecMultiply = (...vecs: Vector[]): Vector => {
  return map((x: number[]) => reduce(x, MUL))(zip(...vecs));
};

export const vecDivide = (...vecs: Vector[]): Vector => {
  return map((x: number[]) => reduce(x, DIV))(zip(...vecs));
};

export const vecScale = (vec: Vector, n: number): Vector => {
  return map((x: number) => x * n)(vec);
};

export const vecInverse = (vec: Vector): Vector => {
  return map((x: number) => -x)(vec);
};

export const vecLength = (vec: Vector): number => {
  return Math.sqrt(reduce(vecMultiply(vec, vec), ADD));
};

export const vecNormalize = (vec: Vector): Vector => {
  const length = vecLength(vec);
  return map((c: number) => c / length)(vec);
};
