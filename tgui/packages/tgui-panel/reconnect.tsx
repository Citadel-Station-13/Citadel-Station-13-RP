import { Button } from 'tgui/components';

let url: string | null = null;

// citadel edit: we just do it once and do not do it again; otherwise the risk of this going on when the
// window should be dead is way too high.
// todo: just send it during tgchat init, don't poll for it at all, this is bad.
setTimeout(() => {
  Byond.winget('', 'url').then((currentUrl) => {
    // Sometimes, for whatever reason, BYOND will give an IP with a :0 port.
    if (currentUrl && !currentUrl.match(/:0$/)) {
      url = currentUrl;
    }
  });
}, 5000);

export const ReconnectButton = (props, context) => {
  return (
    url && (
      <>
        <Button
          color="white"
          onClick={() => {
            Byond.command('.reconnect');
          }}
        >
          Reconnect
        </Button>

        <Button
          color="white"
          onClick={() => {
            location.href = `byond://${url}`;
            Byond.command('.quit');
          }}
        >
          Relaunch game
        </Button>
      </>
    )
  );
};
