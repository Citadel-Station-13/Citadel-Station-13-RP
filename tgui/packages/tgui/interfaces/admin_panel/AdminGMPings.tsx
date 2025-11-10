import { Component, ReactNode } from "react";
import { Button, Collapsible, LabeledList, Section, Stack } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { ActFunctionType, useBackend } from "../../backend";
import { Window } from "../../layouts";
import { sanitizeHTML } from "../../sanitize";

interface GMPingPanelData {
  pingIds: string[];
  ghostAllowed: BooleanLike;
}

interface GMPing {
  ref: string;
  lazyUid: string;
  playerCkey: string;
  playerKey: string;
  messageAsHtml: string;
  pingOrigination: GMPingOrigination | null;
  pingContext: GMPingContext | null;
  pingLocation: GMPingLocation;
}

interface GMPingLocation {
  name: string;
  location: PingLocation;
}

interface PingLocation {
  coords: { name: string, x: number, y: number, z: number } | null;
  sector: { id: string, name: string } | null;
  overmap: { entity: string, map: string | null, x: number, y: number } | null;
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
  ref: string,
  location: PingLocation;
}

enum GMPingSortMode {
  None,
  Ckey,
  Target,
}

interface AdminGMPingsState {
  sortMode: GMPingSortMode;
  refreshing: boolean;
}

export class AdminGMPings extends Component<{}, AdminGMPingsState> {
  constructor(props) {
    super(props);
    this.state = {
      sortMode: GMPingSortMode.None,
      refreshing: false,
    };
  }

  globalRefreshHandle: any;

  componentDidMount(): void {
    if (!this.globalRefreshHandle) {
      this.globalRefreshHandle = setInterval(() => {
        this.triggerGlobalRefresh();
      }, 10000);
    }
  }

  componentWillUnmount(): void {
    if (this.globalRefreshHandle) {
      clearInterval(this.globalRefreshHandle);
    }
  }

  triggerGlobalRefresh() {
    const { act } = useBackend<GMPingPanelData>();
    if (this.state.refreshing) {
      return;
    }
    act('refreshPings');
    this.setState((s) => ({ ...s, refreshing: true }));
    setTimeout(() => this.setState((s) => ({ ...s, refreshing: false })), 2000);
  }

  render() {
    const { act, data, nestedData } = useBackend<GMPingPanelData>();

    let assembled: ReactNode = null;
    switch (this.state.sortMode) {
      case GMPingSortMode.None:
        assembled = (
          <Stack fill vertical>
            {data.pingIds.map((id) => {
              let resolved: GMPing = nestedData[id];
              let actF: ActFunctionType = (a, b) => act(a, { ref: resolved.ref, uid: resolved.lazyUid, ...b });
              return (
                <Stack.Item key={id}>
                  <GMPingEntry ping={resolved} actFunc={actF} withOrigination withContext withLocation />
                </Stack.Item>
              );
            })}
          </Stack>
        );
        break;
      case GMPingSortMode.Ckey:
        {
          let pingsByKey: Record<string, GMPing[]> = {};
          data.pingIds.forEach((id) => {
            let ping: GMPing = nestedData[id];
            if (!pingsByKey[ping.playerKey]) {
              pingsByKey[ping.playerKey] = [];
            }
            pingsByKey[ping.playerKey].push(ping);
          });
          assembled = (
            <Stack fill vertical>
              {Object.entries(pingsByKey)
                .sort(([a1, b1], [a2, b2]) => a1.localeCompare(a2))
                .map(([a, b]) => {
                  return (
                    <Stack.Item key={a} >
                      <Collapsible title={`${a} - ${b.length}`} color="transparent">
                        <div style={{ marginLeft: "5px" }} >
                          {b.map((p) => (
                            <GMPingEntry ping={p} key={p.lazyUid} actFunc={
                              (a, b) => act(a, { ref: p.ref, uid: p.lazyUid, ...b })
                            } withContext withLocation withOrigination />
                          ))}
                        </div>
                      </Collapsible>
                    </Stack.Item>
                  );
                })}
            </Stack>
          );
        }
        break;
      case GMPingSortMode.Target:
        {
          let pingsByTarget: Record<string, GMPing[]> = {};
          const noTargetRef = "NO-TARGET-REF";
          data.pingIds.forEach((id) => {
            let ping: GMPing = nestedData[id];
            let effectiveRef = ping.pingContext?.data.ref || noTargetRef;
            if (!pingsByTarget[effectiveRef]) {
              pingsByTarget[effectiveRef] = [];
            }
            pingsByTarget[effectiveRef].push(ping);
          });
          assembled = (
            <Stack fill vertical>
              {Object.entries(pingsByTarget)
                .sort(([a1, b1], [a2, b2]) => a1.localeCompare(a2))
                .map(([a, b]) => {
                  let name: string | null = "-- No Target --";
                  // data will either all exist or all not exist if we're in pingsByTarget
                  // as it's sorted by ref and data needs to exist to get the ref.
                  if (b.length > 0 && b[0].pingContext?.data) {
                    name = b[0].pingContext.data.name;
                  }
                  return { name: name, ping: b, ref: a };
                })
                .map((a) => {
                  let name = a.name;
                  let pings = a.ping;
                  return (
                    <Stack.Item key={a.ref}>
                      <Collapsible title={`${name} - ${pings.length}`} color="transparent">
                        <div style={{ marginLeft: "5px" }} >
                          {pings.map((p) => (
                            <GMPingEntry ping={p} key={p.lazyUid} actFunc={
                              (a, b) => act(a, { ref: p.ref, uid: p.lazyUid, ...b })
                            } withContext withLocation withOrigination />
                          ))}
                        </div>
                      </Collapsible>
                    </Stack.Item>
                  );

                })
              }
            </Stack>
          );
        }
        break;
    }

    return (
      <Window width={450} height={700} title="GM Pings">
        <Window.Content>
          <Stack fill vertical>
            <Stack.Item>
              <Section title="Filter" fill>
                <LabeledList>
                  <LabeledList.Item label="Group By">
                    <Stack fill>
                      <Stack.Item grow={1}>
                        <Button color="transparent" selected={this.state.sortMode === GMPingSortMode.None}
                          onClick={() => this.setState((s) => ({ ...s, sortMode: GMPingSortMode.None }))}
                          fluid textAlign="center">
                          None
                        </Button>
                      </Stack.Item>
                      <Stack.Item grow={1}>
                        <Button color="transparent" selected={this.state.sortMode === GMPingSortMode.Ckey}
                          onClick={() => this.setState((s) => ({ ...s, sortMode: GMPingSortMode.Ckey }))}
                          fluid textAlign="center">
                          Ckey
                        </Button>
                      </Stack.Item>
                      <Stack.Item grow={1}>
                        <Button color="transparent" selected={this.state.sortMode === GMPingSortMode.Target}
                          onClick={() => this.setState((s) => ({ ...s, sortMode: GMPingSortMode.Target }))}
                          fluid textAlign="center">
                          Target
                        </Button>
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Stack.Item>
            <Stack.Item grow={1}>
              <Section title="Pings" fill scrollable buttons={
                <Button icon="refresh" color="transparent" onClick={() => this.triggerGlobalRefresh()}
                  selected={this.state.refreshing} iconSpin={this.state.refreshing}>
                  Refresh
                </Button>
              }>
                {assembled}
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Section title="Controller" fill>
                <Button color={data.ghostAllowed ? "green" : "red"}
                  fluid textAlign="center"
                  onClick={() => act('toggleGhostAllowed', { enabled: !data.ghostAllowed })}>
                  {data.ghostAllowed ? "Observers are allowed to ping" : "Observers are not allowed to ping"}
                </Button>
                <Button.Confirm color="transparent" confirmColor="red" fluid textAlign="center"
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

interface GMPingEntryProps {
  ping: GMPing;
  actFunc: ActFunctionType;
  withOrigination?: boolean;
  withContext?: boolean;
  withLocation?: boolean;
}

const GMPingEntry = (props: GMPingEntryProps) => {
  let html = sanitizeHTML(props.ping.messageAsHtml);
  // eslint-disable-next-line react/no-danger
  let dangerousRender = (<div dangerouslySetInnerHTML={{ __html: html }} />);
  let shortRender = (
    // eslint-disable-next-line react/no-danger
    <div dangerouslySetInnerHTML={{ __html: `${props.ping.playerKey}${!!props.ping.pingContext && ` --> ${props.ping.pingContext.data?.name || "!missing!"}`}: ${html}` }}
      style={{ display: "inline-block", position: "absolute", textOverflow: "ellipsis", width: "100%" }} />
  );
  return (
    <Collapsible color="transparent"
      title={shortRender}
      buttons={(
        <Button.Confirm icon="trash" confirmContent={null} confirmIcon="trash"
          onClick={() => props.actFunc("delPing")} />
      )} >
      <div style={{ border: "1px solid #ffffffaa", padding: "4px" }}>
        <Stack vertical>
          <Stack.Item>
            <Stack vertical>
              <Stack.Item >
                {props.withOrigination && props.ping.pingOrigination && (
                  <GMPingOriginationRender origination={props.ping.pingOrigination} actF={props.actFunc} />
                )}
                {props.withLocation && props.ping.pingLocation && (
                  <GMPingLocationRender location={props.ping.pingLocation} actF={props.actFunc} />
                )}
                {props.withContext && props.ping.pingContext && (
                  <GMPingContextRender context={props.ping.pingContext} actF={props.actFunc} />
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            {dangerousRender}
          </Stack.Item>
        </Stack>
      </div>
    </Collapsible>
  );
};

const GMPingLocationRender = (props: {
  location: GMPingLocation
  actF?: ActFunctionType,
}) => {
  return (
    <Collapsible color="transparent" title={`@ ${renderPingLocationAsShortened(props.location.location)}`}
      buttons={
        !!props.actF && (
          <Button.Confirm color="transparent" textAlign="center" fluid
            onClick={() => props.actF?.("jmpPingLocation")}
            confirmContent="JMP">JMP
          </Button.Confirm>
        )
      }>
      <div style={{ borderColor: "#ffffffaa", borderStyle: "solid none", borderWidth: "1px" }}>
        <Section >
          <Stack vertical>
            <Stack.Item>
              <Stack fill>
                <Stack.Item>
                  Name
                </Stack.Item>
                <Stack.Item grow={1} textAlign="right">
                  {props.location.name}
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <PingLocationAsStackItems location={props.location.location} />
          </Stack>
        </Section>
      </div>
    </Collapsible>
  );
};

const GMPingOriginationRender = (props: {
  origination: GMPingOrigination
  actF?: ActFunctionType,
}) => {
  return (
    <Collapsible color="transparent" title={`From ${props.origination.data.name} @ ${renderPingLocationAsShortened(props.origination.data.location)}`}
      buttons={
        props.origination.data && !props.origination.deleted && !!props.actF && (
          <Button.Confirm color="transparent" textAlign="center" fluid
            confirmContent="JMP"
            onClick={() => props.actF?.("jmpPingOrigin")}>JMP
          </Button.Confirm>
        )
      }>
      <div style={{ borderColor: "#ffffffaa", borderStyle: "solid none", borderWidth: "1px" }}>
        <Section>
          <Stack vertical>
            {!!props.origination.deleted && (
              <Stack.Item>
                <div style={{ width: "100%", textAlign: "center", color: "red" }}>Deleted</div>
              </Stack.Item>
            )}
            {props.origination.data && (
              <>
                <Stack.Item>
                  <Stack fill>
                    <Stack.Item>
                      Name
                    </Stack.Item>
                    <Stack.Item grow={1} textAlign="right">
                      {props.origination.data.name}
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                {props.origination.data.visibleName !== props.origination.data.name && (
                  <Stack.Item>
                    <Stack fill>
                      <Stack.Item>
                        Visible Name
                      </Stack.Item>
                      <Stack.Item grow={1} textAlign="right">
                        {props.origination.data.visibleName}
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                )}
                <PingLocationAsStackItems location={props.origination.data.location} />
              </>
            )}
          </Stack>
        </Section>
      </div>
    </Collapsible>
  );
};

const GMPingContextRender = (props: {
  context: GMPingContext,
  actF?: ActFunctionType,
}) => {
  return (
    <Collapsible color="transparent" title={`--> ${props.context.data.name} @ ${renderPingLocationAsShortened(props.context.data.location)}`}
      buttons={
        props.context.data && !props.context.deleted && !!props.actF && (
          <Button.Confirm color="transparent" textAlign="center" fluid confirmContent="JMP"
            onClick={() => props.actF?.("jmpPingContext")}>JMP
          </Button.Confirm>
        )
      }>
      <div style={{ borderColor: "#ffffffaa", borderStyle: "solid none", borderWidth: "1px" }}>
        <Section>
          <Stack vertical>
            {!!props.context.deleted && (
              <Stack.Item>
                <div style={{ width: "100%", textAlign: "center", color: "red" }}>Deleted</div>
              </Stack.Item>
            )}
            {props.context.data && (
              <>
                <Stack.Item>
                  <Stack fill>
                    <Stack.Item>
                      Name
                    </Stack.Item>
                    <Stack.Item grow={1} textAlign="right">
                      {props.context.data.name}
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <PingLocationAsStackItems location={props.context.data.location} />
              </>
            )}
          </Stack>
        </Section>
      </div>
    </Collapsible>
  );
};

const renderPingLocationAsShortened = (loc: PingLocation): string => {
  let overmapString = loc.overmap ? loc.overmap.entity : null;
  let sectorString = loc.sector ? loc.sector.name : null;
  let coordString = loc.coords ? `${loc.coords.x}, ${loc.coords.y}, ${loc.coords.z}` : null;
  if (coordString) {
    if (overmapString) {
      return `${coordString} in ${overmapString}`;
    } else if (sectorString) {
      return `${coordString} on ${sectorString}`;
    }
    return `${coordString}`;
  } else {
    if (overmapString) {
      return `somewhere in ${overmapString}`;
    } else if (sectorString) {
      return `somewhere in ${sectorString}`;
    }
    return `nowhere (?)`;
  }
};

const PingLocationAsStackItems = (props: { location: PingLocation }) => {
  if (!props.location) {
    return (
      <>
        Location was unexepectedly null. This is a bug.
      </>
    );
  }
  return (
    <>
      {props.location.coords && (
        <Stack.Item>
          <Stack>
            <Stack.Item>
              Coords
            </Stack.Item>
            <Stack.Item grow={1} textAlign="right">
              {props.location.coords.name} - {props.location.coords.x}, {props.location.coords.y}, {props.location.coords.z}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}
      {props.location.sector && (
        <Stack.Item>
          <Stack>
            <Stack.Item>
              Sector
            </Stack.Item>
            <Stack.Item grow={1} textAlign="right">
              {props.location.sector.id} - {props.location.sector.name}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}
      {props.location.overmap && (
        <Stack.Item>
          <Stack>
            <Stack.Item>
              Overmap
            </Stack.Item>
            <Stack.Item grow={1} textAlign="right">
              {props.location.overmap.entity} - {props.location.overmap.x}, {props.location.overmap.y} @ {props.location.overmap.map}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}
    </>
  );
};

