class ByondAPI {
  windowId: string | null;
  Engine: {
    Trident: number | null,
    Blink: number | null,
  };

  constructor() {
    this.windowId = null;
    this.Engine = {
      Trident: null,
      Blink: null,
    };
    this.initialize();
  }

  initialize() {
    this.windowId = this.parseMetaTag('tgui:windowId');
    this.Engine.Trident = this.getTridentVersion();
    this.Engine.Blink = this.getBlinkVersion();
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
}
