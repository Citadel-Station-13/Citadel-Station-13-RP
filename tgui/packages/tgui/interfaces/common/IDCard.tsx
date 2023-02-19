/**
 * Direct component used for ID slot, with data passed in via props.
 *
 * @file
 * @license MIT
 */

import { Button } from "../../components";

export interface IDCard {
  name?: string;
  rank?: string;
  owner?: string;
}

export const IDCardOrDefault = (card: IDCard = IDCARD_BLANK) => card;

const IDCARD_BLANK = {
  name: "-----",
  rank: "Unassigned",
  owner: "",
};

export interface IDSlotProps {
  card: IDCard;
  onClick: (e) => void;
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
