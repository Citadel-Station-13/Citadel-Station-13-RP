import { __initWindowUpdateHandler } from "./UpdateHandler";

// todo: what the fuck does this do?
const ByondJsonReviver = (key, value) => {
  if (typeof value === 'object' && value !== null && value.__number__) {
    return parseFloat(value.__number__);
  }
  return value;
};

class ByondAPI {
  // our window id
  windowId: string | null;
  // info on the engine this window is running on
  Engine: {
    Trident: number | null,
    Blink: number | null,
  };
  // registered update handlers
  updateHandlers: ((type: string, payload: any) => void)[];
  // ready? if not, updates go into queue
  updateReady: boolean;
  // queued update messages
  updateQueue: {type: string, payload: any}[];

  // whether or not we BSOD on error, or ignore it
  strictMode: boolean;

  constructor() {
    this.windowId = null;
    this.Engine = {
      Trident: null,
      Blink: null,
    };
    this.initialize();
    this.updateHandlers = [];
    this.updateReady = false;
    this.updateQueue = [];
    this.strictMode = true;
  }

  initialize() {
    this.windowId = this.parseMetaTag('tgui:windowId');
    this.Engine.Trident = this.getTridentVersion();
    this.Engine.Blink = this.getBlinkVersion();
    __initWindowUpdateHandler();
  }

  onUpdate(type: string, payload: any): void {
    if (this.updateReady) {
      this.updateHandlers.forEach((handler) => handler(type, payload));
      return;
    }
    this.updateQueue.push({ type: type, payload: payload });
  }

  flushUpdates(): void {
    this.updateReady = true;
    this.updateQueue.forEach(
      (update) => this.updateHandlers.forEach(
        (handler) => handler(update.type, update.payload)
      )
    );
    this.updateQueue = [];
  }

  parseJson(json): Object {
    try {
      return JSON.parse(json, ByondJsonReviver);
    }
    catch (err) {
      throw new Error('JSON parsing error: ' + (err && err.message));
    }
  }

  /**
   * Gets the string content of a <meta> tag, or null if it isn't there.
   * Compatible <meta> tags should be in the format of '[key]' as content by
   * default so BYOND-side can perform the replacement,
   * and have an id of 'key'.
   *
   * todo: get rid of all meta tags. they're slow as sin to perform replacement
   * todo: in SStgui, and we should stop using them.
   *
   * @param name
   */
  parseMetaTag(name): string | null {
    let content = document.getElementById(name)?.getAttribute('content');
    if (content === `[${name}]`) {
      return null;
    }
    return content || null;
  }

  getTridentVersion(): number | null {

  }

  getBlinkVersion(): number | null {

  }

  /**
   * returns object with k-v of all properties
   * @param id id of target, if any
   */
  winget(id: string | null): Promise<object>;
  winget(id: string | null, property: "*"): Promise<object>;
  winget(id: string | null, property: string): Promise<any>;
  winget(id: string | null, property: string[]): Promise<object>;
  winget(id: string | null, property?: string | string[] | null): Promise<any> {

  }

  command(command: string) {

  }
}
