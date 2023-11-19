/**
 * Reagents guidebook section.
 *
 * Reactions were originally going to be separate, but was included because
 * they require reagent context to be rendered properly.
 *
 * The interfaces here are intentionally distinct from the normal reagent interfaces/classes,
 * because the guidebook system is meant to be maintainable and modular - which means it's
 * unable to directly hook the main systems for reagents.
 *
 * @file
 * @license MIT
 */

export interface TGUIGuidebookReagentsData {

}

interface TGUIGuidebookReagent {
  /// id string
  id: string;
  /// reagent flags: currently untyped because there are none
  flags: number;
  /// name string
  name: string;
  /// description string
  desc: string;

  /// alcohol strength
  alcoholStrength: number;
}

interface TGUIGuidebookReaction {
  /// id string
  id: string;
  /// reaction flags: currently untyped because there are none
  flags: number;
  /// name string
  name: string;
  /// description string
  desc: string;
  /// required reagent ids
  requiredReagents: string[];
  /// result reagent id
  resultReagent: string;
  /// result reagent amount
  resultAmount: number;
}

export const TGUIGuidebookReagents = (props: TGUIGuidebookReagentsData, context) => {

}
