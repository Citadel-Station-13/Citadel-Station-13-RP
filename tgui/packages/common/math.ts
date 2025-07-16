/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

/**
 * Get array of bits from a bitfield
 */
export const bitfieldToBits = (field: number) => {
  let got: number[] = [];
  for (let bit = 0; bit < 24; bit++) {
    if (field & (1<<bit)) {
      got.push(1<<bit);
    }
  }
  return got;
};

/**
 * Get array of positions from a bitfield
 */
export const bitfieldToPositions = (field: number, limit: number = 24) => {
  let got: number[] = [];
  for (let bit = 0; bit < limit; bit++) {
    if (field & (1<<bit)) {
      got.push(bit);
    }
  }
  return got;
};
