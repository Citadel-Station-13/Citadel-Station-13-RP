export const __initWindowUpdateHandler = () => {
  window.update = (rawMessage) => {
    let parsed = window.Byond.parseJson(rawMessage);
    window.Byond.onUpdate(parsed.type, parsed.payload);
  };
};
