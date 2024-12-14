import { filter, sortBy } from 'common/collections';
import { BooleanLike, classes } from 'common/react';
import { createSearch } from 'common/string';
import { Fragment } from 'inferno';

import { useBackend, useLocalState } from '../backend';
import { Button, ByondUi, Flex, Input, Section } from '../components';
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

export const CameraConsole = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { mapRef, activeCamera } = data;
  const cameras = selectCameras(data.cameras);
  const [
    prevCameraName,
    nextCameraName,
  ] = prevNextCamera(cameras, activeCamera);

  return (
    <Window
      width={850}
      height={708}>
      <div className="CameraConsole__left">
        <Window.Content scrollable>
          <CameraConsoleContent />
        </Window.Content>
      </div>
      <div className="CameraConsole__right">
        <div className="CameraConsole__toolbar">
          <b>Camera: </b>
          {activeCamera
            && activeCamera.name
            || '—'}
        </div>
        <div className="CameraConsole__toolbarRight">
          <Button
            icon="chevron-left"
            disabled={!prevCameraName}
            onClick={() => act('switch_camera', {
              name: prevCameraName,
            })} />
          <Button
            icon="chevron-right"
            disabled={!nextCameraName}
            onClick={() => act('switch_camera', {
              name: nextCameraName,
            })} />
        </div>
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: mapRef,
            type: 'map',
          }} />
      </div>
    </Window>
  );
};

export const CameraConsoleContent = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  const { activeCamera } = data;
  const cameras = selectCameras(data.cameras, searchText);

  return (
    <Flex
      direction={"column"}
      height="100%">
      <Flex.Item>
        <Input
          autoFocus
          expensive
          fluid
          mt={1}
          placeholder="Search for a camera"
          onInput={(e, value) => setSearchText(value)}
          value={searchText} />
      </Flex.Item>
      <Flex.Item
        height="100%">
        <Section fill scrollable>
          {cameras.map(camera => (
          // We're not using the component here because performance
          // would be absolutely abysmal (50+ ms for each re-render)
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
              onClick={() => act('switch_camera', {
                name: camera.name,
              })}>
              {camera.name}
            </div>
          ))}
        </Section>
      </Flex.Item>
    </Flex>
  );
};

export const CameraConsoleNTOS = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { mapRef, activeCamera } = data;
  const cameras = selectCameras(data.cameras);
  const [
    prevCameraName,
    nextCameraName,
  ] = prevNextCamera(cameras, activeCamera);

  return (
    <Fragment>
      <div className="CameraConsole__left">
        <Window.Content scrollable>
          <CameraConsoleContent />
        </Window.Content>
      </div>
      <div className="CameraConsole__right">
        <div className="CameraConsole__toolbar">
          <b>Camera: </b>
          {activeCamera
            && activeCamera.name
            || '—'}
        </div>
        <div className="CameraConsole__toolbarRight">
          <Button
            icon="chevron-left"
            disabled={!prevCameraName}
            onClick={() => act('switch_camera', {
              name: prevCameraName,
            })} />
          <Button
            icon="chevron-right"
            disabled={!nextCameraName}
            onClick={() => act('switch_camera', {
              name: nextCameraName,
            })} />
        </div>
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: mapRef,
            type: 'map',
          }} />
      </div>
    </Fragment>
  );
};
