import { useBackend } from "../../../../backend";
import { Box } from "tgui-core/components";
import { CrewManifestContent } from '../../../CrewManifest';

export const pda_manifest = (props) => {
  const { act, data } = useBackend(context);

  return (
    <Box color="white">
      <CrewManifestContent />
    </Box>
  );
};
