export enum JournalismUsermode {
  // write / comment to your own feeds / posts
  WRITE = (1<<0),
  // write / comment to others' feeds / posts who restrict acccess
  BYPASS = (1<<1),
  // hit things with D-notices
  CENSOR = (1<<2),
  // flat out mark stuff as fully deleted
  DELETE = (1<<3),
  // see deleted content
  AUDIT = (1<<4),
}

export enum JournalismGlobalmode {
  // un/block networks
  CENSOR = (1<<0),
  // trace network actions
  TRACE = (1<<1),
  // un / restrict individual users
  RESTRICT = (1<<2),
}

export interface JournalismProps {

}

export interface JournalismData {

}

export interface NewsComment {
  author: string;
  message: string;
  ckey?: string;
}

export interface NewsPost {
  author: string;
  title: string;
  message: string;
  locked?: boolean; // no comments
  picture?: string; // picture hash
  ckey?: string;
}

export interface NewsChannel {
  author: string;
  name: string;
  locked?: boolean; // only posts from author
  ckey?: string;
}

export interface NewsNetwork {
  name: string;
}
