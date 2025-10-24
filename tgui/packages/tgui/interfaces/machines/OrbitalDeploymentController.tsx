import { BooleanLike } from "common/react";
import { useBackend } from "../../backend";
import { Window } from "../../layouts";

interface OrbitalDeploymentControllerData {
  zone: OrbitalDeploymentZoneData | null;
  cMinArmingTime: number;
  cMaxOvermapsDist: number;
  lasers: OrbitalDeploymentLaserData[];
  flares: OrbitalDeploymentFlareData[];
}

interface OrbitalDeploymentTargetData {
  name: string;
  coords: [number, number, number];
  overmapDist: number;
  overmapName: string;
}

interface OrbitalDeploymentFlareData extends OrbitalDeploymentTargetData {

}

interface OrbitalDeploymentLaserData extends OrbitalDeploymentTargetData {

}

interface OrbitalDeploymentZoneData {
  armed: BooleanLike;
  armedTime: number;
}

export const OrbitalDeploymentController = (props, context) => {
  const { act, data } = useBackend<OrbitalDeploymentControllerData>(context);

  return (
    <Window>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
