import { Component } from "react";
import { Button, Section, Stack } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { Window } from "../../layouts";

interface GMPingPanelData {

}

interface GMPing {
  pingOrigination: GMPingOrigination;
  pingContext: GMPingContext;
  pingLocation: GMPingLocation;
}

interface GMPingLocation {
  name: string;
  x: number;
  y: number;
  z: number;
  sectorName: string | null;
  overmapName: string | null;
}

interface GMPingOrigination {
  deleted: BooleanLike;
  data: GMPingOriginationData;
}

interface GMPingOriginationData {

}

interface GMPingContext {
  deleted: BooleanLike;
  data: GMPingContextData;
}

interface GMPingContextData {

}

// eslint-disable-next-line react/prefer-stateless-function
export class AdminGMPings extends Component {
  render() {
    return (
      <Window>
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
                <Button.Input color="red" fluid
                  buttonText="Purge all pings from ckey" />
                <Button.Input color="red" fluid
                  buttonText="Purge all pings from mob" />
                <Button.Confirm color="red" fluid>
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
