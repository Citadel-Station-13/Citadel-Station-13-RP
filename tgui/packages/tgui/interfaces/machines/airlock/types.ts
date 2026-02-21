/**
 * @file
 * @license MIT
 */

import { BooleanLike } from 'tgui-core/react';

export interface AirlockTaskData {
  startedAt: number;
  reason: string;
  ref: string;
}

export interface AirlockCyclingData {
  tasks: AirlockTaskData[];
  phaseVerb: string;
  cyclingDesc: string;
}

export enum AirlockSide {
  Interior = 'interior',
  Exterior = 'exterior',
  Neither = 'neither',
  Both = 'both',
}

export const airlockSideToName = (side: AirlockSide) => {
  switch (side) {
    case AirlockSide.Interior:
      return 'Interior';
    case AirlockSide.Exterior:
      return 'Exterior';
    case AirlockSide.Both:
      return 'Fully Open';
    case AirlockSide.Neither:
      return 'Sealed';
  }
};

export const airlockSealedStateToName = (state: BooleanLike) => {
  if (state === null) {
    return 'Unlocked';
  } else if (state) {
    return 'Open';
  } else {
    return 'Closed';
  }
};
