import { filter, sortBy } from 'common/collections';
import { BooleanLike, classes } from 'common/react';
import { createSearch } from 'common/string';

import { useBackend, useLocalState } from '../backend';
import { Button, ByondUi, Input, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  activeCamera: Camera & { status: BooleanLike };
  cameras: Camera[];
  // can_spy: BooleanLike;
  mapRef: string;
  allNetworks: string[];
};

type Camera = {
  name: string;
  // ref: string; we dont store ref
};

/**
 * Returns previous and next camera names relative to the currently
 * active camera.
 */
const prevNextCamera = (
  cameras: Camera[],
  activeCamera: Camera & { status: BooleanLike },
) => {
  if (!activeCamera || cameras.length < 2) {
    return [];
  }

  const index = cameras.findIndex((camera) => camera.name === activeCamera.name);

  switch (index) {
    case -1: // Current camera is not in the list
      return [cameras[cameras.length - 1].name, cameras[0].name];

    case 0: // First camera
      if (cameras.length === 2) return [cameras[1].name, cameras[1].name]; // Only two

      return [cameras[cameras.length - 1].name, cameras[index + 1].name];

    case cameras.length - 1: // Last camera
      if (cameras.length === 2) return [cameras[0].name, cameras[0].name];

      return [cameras[index - 1].name, cameras[0].name];

    default:
      // Middle camera
      return [cameras[index - 1].name, cameras[index + 1].name];
  }
};

/**
 * Camera selector.
 *
 * Filters cameras, applies search terms and sorts the alphabetically.
 */
const selectCameras = (cameras: Camera[], searchText = ''): Camera[] => {
  let queriedCameras = filter((camera: Camera) => !!camera.name)(cameras);
  if (searchText) {
    const testSearch = createSearch(
      searchText,
      (camera: Camera) => camera.name,
    );
    queriedCameras = filter(testSearch)(queriedCameras);
  }
  queriedCameras = sortBy((camera: Camera) => camera.name)(queriedCameras);

  return queriedCameras;
};

export const CameraConsole = (props) => {
  return (
    <Window width={850} height={708}>
      <Window.Content>
        <CameraContent />
      </Window.Content>
    </Window>
  );
};

export const CameraContent = (props, context) => {
  const [searchText, setSearchText] = useLocalState(context, 'cameraSearchText', '');

  return (
    <Stack fill>
      <Stack.Item grow>
        <CameraSelector searchText={searchText} setSearchText={setSearchText} />
      </Stack.Item>
      <Stack.Item grow={3}>
        <CameraControls searchText={searchText} />
      </Stack.Item>
    </Stack>
  );
};

const CameraSelector = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { searchText, setSearchText } = props;
  const { activeCamera } = data;
  const cameras = selectCameras(data.cameras, searchText);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Input
          autoFocus
          expensive
          fluid
          mt={1}
          placeholder="Search for a camera"
          onInput={(e, value) => setSearchText(value)}
          value={searchText}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          {cameras.map((camera) => (
            // We're not using the component here because performance
            // would be absolutely abysmal (50+ ms for each re-render).
            <div
              key={camera.name}
              title={camera.name}
              className={classes([
                'Button',
                'Button--fluid',
                'Button--color--transparent',
                'Button--ellipsis',
                activeCamera?.name === camera.name
                  ? 'Button--selected'
                  : 'candystripe',
              ])}
              onClick={() =>
                act('switch_camera', {
                  name: camera.name,
                })
              }
            >
              {camera.name}
            </div>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const CameraControls = (props: { searchText: string }, context) => {
  const { act, data } = useBackend<Data>(context);
  const { activeCamera, mapRef } = data;
  const { searchText } = props;

  const cameras = selectCameras(data.cameras, searchText);

  const [prevCamera, nextCamera] = prevNextCamera(cameras, activeCamera);

  return (
    <Section fill>
      <Stack fill vertical>
        <Stack.Item>
          <Stack fill>
            <Stack.Item grow>
              {activeCamera?.status ? (
                <NoticeBox info>{activeCamera.name}</NoticeBox>
              ) : (
                <NoticeBox danger>No input signal</NoticeBox>
              )}
            </Stack.Item>

            <Stack.Item>
              <Button
                icon="chevron-left"
                disabled={!prevCamera}
                onClick={() =>
                  act('switch_camera', {
                    name: prevCamera,
                  })
                }
              />
            </Stack.Item>

            <Stack.Item>
              <Button
                icon="chevron-right"
                disabled={!nextCamera}
                onClick={() =>
                  act('switch_camera', {
                    name: nextCamera,
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow>
          <ByondUi
            height="100%"
            width="100%"
            params={{
              id: mapRef,
              type: 'map',
            }}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
