/**
 * Direct component used for ID slot, with data passed in via props.
 *
 * @file
 * @license MIT
 */

import { Button } from "../../components";

export interface IDCard {
  // entity name of the id card itself
  name?: string;
  // actual role name
  rank?: string;
  // actual role name, or alt title
  title?: string;
  // who it belongs to
  owner?: string;
}

export const IDCardOrDefault = (card: IDCard | null | undefined) => {
  return card || IDCARD_BLANK;
};

const IDCARD_BLANK = {
  name: "-----",
  rank: "Unassigned",
  owner: "",
};

export interface IDSlotProps {
  readonly card: IDCard;
  readonly onClick: (e) => void;
}

export const IDSlot = (props: IDSlotProps, context) => {
  return (
    <Button
      icon="eject"
      fluid
      content={props.card.name || "-----"}
      onClick={(e) => props.onClick(e)} />
  );
};
