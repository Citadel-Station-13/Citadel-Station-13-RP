import { BooleanLike } from "../../../common/react";

export interface StackRecipeData {
  sortOrder: number;
  name: string;
  category: string;
  resultType: string;
  resultAmt: number;
  time: number;
  noAutoSanity: BooleanLike;
  isStack: BooleanLike;
}
