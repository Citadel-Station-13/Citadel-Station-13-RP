import { round } from 'common/math';
import { BooleanLike } from 'common/react';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, NoticeBox, LabeledList, Section, Collapsible } from "../components";
import { formatTime } from '../format';
import { Window } from "../layouts";

interface TelecommsLogBrowserContext {
  universal_translate: BooleanLike;
  network: string;
  temp: UITemporaryMessage;
  servers: [TelecommsServer];
  selectedServer: TelecommsServerSelected;
}

interface TelecommsServer {
  id: string;
  name: string;
}

interface TelecommsServerSelected {
  id: string;
  totalTraffic: number;
  logs: [MessageLog];
  triangulating: BooleanLike;
  triangulation: [TriangulationEntry];
}

interface TriangulationEntry {
  name: string;
  x: number;
  y: number;
  z: string;
  accuracy: number;
  last: number;
  tag: string;
}

interface MessageLog {
  name: string;
  input_type: string;
  id: number;
  parameters: [Record<string, string>];
}

interface UITemporaryMessage {
  color: string;
  text: string;
}

export const TelecommsLogBrowser = (props, context) => {
  const { act, data } = useBackend<TelecommsLogBrowserContext>(context);

  return (
    <Window
      width={575}
      height={450}
      resizable>
      <Window.Content scrollable>
        {!!data.temp && (
          <NoticeBox warning>
            <Box display="inline-box" verticalAlign="middle">
              {data.temp.text}
            </Box>
            <Button
              icon="times-circle"
              float="right"
              onClick={() => act('cleartemp')} />
            <Box clear="both" />
          </NoticeBox>
        )}
        <Section title="Network Control">
          <LabeledList>
            <LabeledList.Item
              label="Current Network"
              buttons={(
                <Fragment>
                  <Button
                    icon="search"
                    content="Refresh"
                    onClick={() => act("scan")} />
                  <Button
                    color="bad"
                    icon="exclamation-triangle"
                    content="Flush Buffer"
                    disabled={!!data.servers.length}
                    onClick={() => act('release')} />
                </Fragment>
              )}>
              <Button
                content={data.network}
                icon="pen"
                onClick={() => act('network')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {data.selectedServer
          ? (
            <TelecommsSelectedServer
              server={data.selectedServer}
              universal_translate={data.universal_translate} />
          ) : (
            <TelecommsServerSelection
              network={data.network}
              servers={data.servers} />
          )}
      </Window.Content>
    </Window>
  );
};

const TelecommsServerSelection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    network,
    servers,
  } = props;

  if (!servers || !servers.length) {
    return (
      <Section title="Detected Telecommunications Servers">
        <Box color="bad">
          No servers detected.
        </Box>
        <Button
          fluid
          content="Scan"
          icon="search"
          onClick={() => act('scan')} />
      </Section>
    );
  }

  return (
    <Section title="Detected Telecommunication Servers">
      <LabeledList>
        {servers.map(server => (
          <LabeledList.Item
            key={server.id}
            label={server.name+ " (" + server.id + ")"}>
            <Button
              content="View"
              icon="eye"
              onClick={() => act('view', { id: server.id })} />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

interface TelecommsSelectedServerProps {
  server: TelecommsServerSelected;
  universal_translate: BooleanLike;
}

const TelecommsSelectedServer = (props: TelecommsSelectedServerProps, context) => {
  const { act, data } = useBackend<TelecommsLogBrowserContext>(context);

  return (
    <Section
      title={"Server (" + props.server.id + ")"}
      buttons={
        <Button
          content="Return"
          icon="undo"
          onClick={() => act("mainmenu")} />
      }>
      <Section title="System">
        <LabeledList>
          <LabeledList.Item label="Total Recorded Traffic">
            {props.server.totalTraffic >= 1024
              ? round(props.server.totalTraffic / 1024, 1) + " Terrabytes"
              : props.server.totalTraffic + " Gigabytes"}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section>
        <Collapsible
          title="Triangulation"
          color="transparent"
          buttons={
            <Button
              content={props.server.triangulating? "Enabled" : "Disabled"}
              selected={!!props.server.triangulating}
              onClick={() => act('toggle_triangulation')} />
          }>
          {props.server.triangulation.sort((a, b) => (a.last - b.last)).map((data) => (
            <Collapsible key={data.tag} title={data.name}>
              <LabeledList>
                <LabeledList.Item label="Estimated Location">
                  {data.z} - {data.x} / {data.y}
                </LabeledList.Item>
                <LabeledList.Item label="Accuracy">
                  ~{data.accuracy}m
                </LabeledList.Item>
                <LabeledList.Item label="Last Voice Pattern">
                  {data.name}
                </LabeledList.Item>
                <LabeledList.Item label="Last Detected">
                  {formatTime(data.last)} ago.
                </LabeledList.Item>
              </LabeledList>
            </Collapsible>
          ))}
        </Collapsible>
      </Section>
      <Section title="Stored Logs" mt="4px">
        <Flex wrap="wrap">
          {(!props.server.logs || !props.server.logs.length)
            ? "No Logs Detected."
            : props.server.logs.map(log => (
              <Flex.Item m="2px" key={log.id} basis="49%" grow={log.id % 2}>
                <Section
                  title={(props.universal_translate
                      || log.parameters["uspeech"]
                      || log.parameters["intelligible"]
                      || log.input_type === "Execution Error")
                    ? log.input_type
                    : "Audio File"}
                  buttons={
                    <Button.Confirm
                      confirmContent="Delete Log?"
                      color="bad"
                      icon="trash"
                      confirmIcon="trash"
                      onClick={() => act('delete', { id: log.id })} />
                  }>
                  {log.input_type === "Execution Error" ? (
                    <LabeledList>
                      <LabeledList.Item label="Data type">
                        Error
                      </LabeledList.Item>
                      <LabeledList.Item label="Output">
                        {log.parameters["message"]}
                      </LabeledList.Item>
                      <LabeledList.Item label="Delete">
                        <Button
                          icon="trash"
                          onClick={() => act('delete', { id: log.id })} />
                      </LabeledList.Item>
                    </LabeledList>
                  ) : (props.universal_translate
                      || log.parameters["uspeech"]
                      || log.parameters["intelligible"])
                    ? <TelecommsLog log={log} />
                    : <TelecommsLog error />}
                </Section>
              </Flex.Item>
            )) }
        </Flex>
      </Section>
    </Section>
  );
};


const TelecommsLog = (props, context) => {
  const { act, data } = useBackend<TelecommsLogBrowserContext>(context);
  const {
    log,
    error,
  } = props;

  const {
    timecode,
    name,
    race,
    job,
    message,
  } = (log && log.parameters) || { "none": "none" };

  if (error) {
    return (
      <LabeledList>
        <LabeledList.Item label="Time Recieved">
          {timecode}
        </LabeledList.Item>
        <LabeledList.Item label="Source">
          Unidentifiable
        </LabeledList.Item>
        <LabeledList.Item label="Class">
          {race}
        </LabeledList.Item>
        <LabeledList.Item label="Contents">
          Unintelligible
        </LabeledList.Item>
      </LabeledList>
    );
  }

  return (
    <LabeledList>
      <LabeledList.Item label="Time Recieved">
        {timecode}
      </LabeledList.Item>
      <LabeledList.Item label="Source">
        {name} (Job: {job})
      </LabeledList.Item>
      <LabeledList.Item label="Class">
        {race}
      </LabeledList.Item>
      <LabeledList.Item label="Contents" className="LabeledList__breakContents">
        {message}
      </LabeledList.Item>
    </LabeledList>
  );
};
