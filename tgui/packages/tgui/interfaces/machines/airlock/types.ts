/**
 * @file
 * @license MIT
 */

export interface AirlockTaskData {
  startedAt: number;
  reason: string;
  ref: string;
}

export interface AirlockCyclingData {
  tasks: AirlockTaskData[];
  phaseVerb: string;
}

export enum AirlockSide {
  Interior = 'interior',
  Exterior = 'exterior',
  Neither = 'neither',
  Both = 'both',
}
