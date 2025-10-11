import { Component, ReactNode, useState } from "react";
import { Button, Section, Stack } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { useBackend } from "../../backend";
import { Window } from "../../layouts";

interface GMPingPanelData {

}

interface GMPing {
  ref: string;
  lazyUid: number;
  playerCkey: string;
  messageAsHtml: string;
  pingOrigination: GMPingOrigination;
  pingContext: GMPingContext;
  pingLocation: GMPingLocation;
}

interface GMPingLocation {
  name: string;
  data: PingLocation;
}

interface PingLocation {
  coords: { name: string, x: number, y: number, z: number } | null;
  sector: { name: string } | null;
  overmap: { entity: string, map: string, x: number, y: number } | null;
}

interface GMPingOrigination {
  deleted: BooleanLike;
  data: GMPingOriginationData;
}

interface GMPingOriginationData {
  name: string;
  visibleName: string;
  location: PingLocation;
}

interface GMPingContext {
  deleted: BooleanLike;
  data: GMPingContextData;
}

interface GMPingContextData {
  name: string;
  location: PingLocation;
}

// eslint-disable-next-line react/prefer-stateless-function
export class AdminGMPings extends Component {
  render() {
    const { act, data } = useBackend<GMPingPanelData>();
    const [modal, setModal] = useState<ReactNode>();
    return (
      <Window>
        {modal}
        <Window.Content>
          <Stack fill vertical>
            <Stack.Item>
              <Section title="Filter" fill>
                Test
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section title="Pings" fill>
                Test
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Section title="Controller" fill>
                {/* TODO: Purge by ckey/mob once we're higher pop and need it. */}
                {/* <Button color="transparent" fluid
                  onClick={() => {
                    setModal();
                  }}>Purge all pings from ckey
                </Button>
                <Button color="transparent" fluid
                  onClick={() => {
                    setModal();
                  }}>Purge all pings from mob
                </Button> */}
                <Button.Confirm color="transparent" confirmColor="red" fluid
                  onClick={() => act('purgeAll')}>
                  Purge all pings (DANGER)
                </Button.Confirm>
              </Section>
            </Stack.Item>
          </Stack>
        </Window.Content>
      </Window>
    );
  }
}
