import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';

interface OrbitalDeploymentControllerData {
  zone: OrbitalDeploymentZoneData | null;
  cMinArmingTime: number;
  cMaxOvermapsDist: number;
  lasers: OrbitalDeploymentLaserData[];
  flares: OrbitalDeploymentFlareData[];
}

interface OrbitalDeploymentTargetData {
  name: string;
  // virtual x (m), virtual y (m), elevation (m)
  coords: [number, number, number];
  overmapDist: number;
  overmapName: string;
}

interface OrbitalDeploymentFlareData extends OrbitalDeploymentTargetData {}
interface OrbitalDeploymentLaserData extends OrbitalDeploymentTargetData {}

interface OrbitalDeploymentZoneData {
  armed: BooleanLike;
  armedTime: number;
}

export const OrbitalDeploymentController = (props) => {
  const { act, data } = useBackend<OrbitalDeploymentControllerData>();

  return (
    <Window>
      <Window.Content>Test</Window.Content>
    </Window>
  );
};
