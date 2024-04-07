interface Window {
  update: (rawMessage: string) => void;
}

type ByondUpdate = {
  type: string;
  payload?: any;
}
