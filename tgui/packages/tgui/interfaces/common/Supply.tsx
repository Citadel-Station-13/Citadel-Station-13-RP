import { BooleanLike } from "common/react";

export enum SupplyPackFlags {
  CONTRABAND = (1<<0),
}

export interface SupplyPack {
  name: string;
  cost: number;
  category: string;
  flags: SupplyPackFlags;
  ref: string;
  isRandom: BooleanLike;
  contains: Record<string, number>;
}

export interface SupplySystem {

}

export interface SupplyOrder {

}

export interface SupplyShipment {

}

export interface SupplyFaction {

}

export interface SupplyBounty {

}
