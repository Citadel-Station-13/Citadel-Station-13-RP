import { __initWindowUpdateHandler } from "./UpdateHandler";


/**
  * Parses BYOND JSON.
  *
  * Uses a special encoding to preserve `Infinity` and `NaN`.
  */
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

  /**
   * debugging function
   * @param type
   * @param payload
   */
  injectUpdate(type: any, payload: any): void {
    window.update(JSON.stringify({ type: type, payload: payload }));
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
  winget(id: string): Promise<object>;
  /**
   * returns object with k-v of all properties
   * @param id
   */
  // eslint-disable-next-line no-dupe-class-members
  winget(id: string, property: "*"): Promise<object>;
  /**
   * returns value of property
   * @param id
   * @param property
   */
  // eslint-disable-next-line no-dupe-class-members
  winget(id: string, property: string): Promise<any>;
  /**
   * returns key-value of requested properties
   * @param id
   * @param property
   */
  // eslint-disable-next-line no-dupe-class-members
  winget(id: string, property: string[]): Promise<object>;
  /**
   * todo: what does this return?
   * @param id
   * @param property
   */
  // eslint-disable-next-line no-dupe-class-members
  winget(
    id: null,
    property: 'focus' | 'window' | 'panes' | 'menus' | 'macros' | 'sound' | 'hwmode' | 'url',
  )
  // eslint-disable-next-line no-dupe-class-members
  winget(id: string | null, property?: string | string[] | null): Promise<any> {
    if (!id) {
      id = '';
    }
    let isArray = property instanceof Array;
    let isSpecific = property && property !== "*" && !isArray;
    let promise = this.callAsync('winget', {
      id: id,
      property: isArray? (property as Array<string>).join(',') : property || '*',
    });
    if (isSpecific) {
      promise = promise.then((props) => { return props[(property as string)]; });
    }
    return promise;
  }

  /**
   * Runs a command or a verb.
   */
  command(command: string): void {
    return this.call('winset', { command: command });
  }

  /**
   * Makes a Topic() call
   * You can reference a specific datum by setting the 'src' parameter,
   * or special global datums in client/Topic() via the '_src_' parameter.
   */
  topic(params: Object): void {
    return this.call('', params);
  }

  /**
   * Sends a message to `/datum/tgui_window` which hosts this window instance
   */
  sendMessage(type: string, payload?: any): void {
    let message: {
      type: string,
      payload: any,
      [key: string]: string | number | null | undefined,
    } = typeof type === 'string'? {
      type: type,
      payload: payload,
    } : type;
    // JSON encode
    if (message.payload !== null && message.payload !== undefined) {
      message.payload = JSON.stringify(message.payload);
    }
    // set identification header
    message.tgui = 1;
    message.window_id = this.windowId;
    this.topic(message);
  }
}
