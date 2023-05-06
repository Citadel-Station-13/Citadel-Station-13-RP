import { BooleanLike } from "common/react";
import { AccessId } from "./Access";

export enum SupplyPackFlags {
  CONTRABAND = (1<<0),
  HARDLOCK = (1<<1),
}

export interface SupplyPack {
  name: string;
  cost: number;
  category: string;
  flags: SupplyPackFlags;
  ref: string;
  isRandom: BooleanLike;
  contains: Record<string, number>;
  containerName: string;
}

export enum SupplyItemFlags {
  CONTRABAND = (1<<0),
  HARDLOCK = (1<<1),
}

export interface SupplyItem {
  name: string;
  desc: string;
  category: string;
  max: number;
  flags: SupplyItemFlags;
  ref: string;
  cost: number;
  access: AccessId;
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
