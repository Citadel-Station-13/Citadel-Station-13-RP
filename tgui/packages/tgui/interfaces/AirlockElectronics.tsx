import { useBackend } from "../backend";
import { Window } from "../layouts";
import { Access, AccessId, AccessListAuth } from "./common/Access";

interface AirlockElectronicsData {
  access: [Access],
  req_access: [AccessId],
  req_one_access: [AccessId],
}

export const AirlockElectronics = (props, context) => {
  const { act, data } = useBackend<AirlockElectronicsData>(context);
  return (
    <Window
      title="Airlock Electronics"
      width={450}
      height={600}>
      <Window.Content>
        <AccessListAuth
          fill
          uid="AccessListAuth"
          access={data.access}
          req_access={data.req_access}
          req_one_access={data.req_one_access}
          set={(id, mode) => {
            act('set', { id: id, mode: mode });
          }}
          wipe={(category) => {
            act('wipe', { category: category });
          }} />
      </Window.Content>
    </Window>
  );
};
