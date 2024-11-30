import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { actFunctionType, useBackend } from "tgui/backend";
import { Stack } from "tgui/components";
import { Window } from "tgui/layouts";

interface ModalData {
  primed: BooleanLike;
  ready: BooleanLike;
  levels: number;
  staged: LoadComputations | null;
}

interface LoadComputations {

}

interface ModalMapData {

}

interface ModalLevelData {

}

interface ModalOvermapData {

}

export const UploadMapSector = (props, context) => {
  const { act, data, nested_data } = useBackend<ModalData>(context);

  const mapData: ModalMapData | null = nested_data["map"];

  const renderedLevels: InfernoNode[] = [];

  for (let i = 1; i <= data.levels; i++) {
    renderedLevels.push((
      <Stack.Item>
        <MapLevelPane data={nested_data[`level-${i}`]} act={act} />
      </Stack.Item>
    ));
  }

  return (
    <Window width={400} height={680} title="Upload Map Sector">
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <MapPane data={mapData} act={act} />
          </Stack.Item>
          <Stack.Item>
            <Stack vertical>
              {renderedLevels}
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

interface MapProps {
  data: ModalMapData | null;
  act: actFunctionType;
}

const MapPane = (props, context) => {

};

interface MapLevelProps {
  data: ModalLevelData | null;
  act: actFunctionType;
}

const MapLevelPane = (props, context) => {

};
