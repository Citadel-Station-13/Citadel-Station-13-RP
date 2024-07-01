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

export interface NewsData {
  author?: string; // poster name
  ckey?: string; // poster ckey
  hidden?: boolean; // hidden by own poster
  censored?: boolean; // censored by d-notice
  deleted?: boolean; // deleted by moderator
}

export interface NewsComment extends NewsData {
  message: string;
}

export interface NewsPost extends NewsData {
  title: string;
  message: string;
  locked?: boolean; // no comments from other people
  picture?: string; // picture hash
}

export interface NewsChannel extends NewsData {
  name: string;
  locked?: boolean; // only posts from creator
}

export interface NewsNetwork {
  name: string;
  writelocked?: boolean; // read-only
}

export interface NewsTrace {
  author: string; // name
  ckey?: string; // ckey - only given to admin interfaces
  action: string; // log line
}
