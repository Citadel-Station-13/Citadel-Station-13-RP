import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { IDCard } from "../common/IDCard";

interface PointRedemptionVendorData {
  points: number;
  pointName: string;
  insertedId: IDCard | null;
}

export const PointRedemptionVendor = (props, context) => {
  const { act, data, config } = useBackend<PointRedemptionVendorData>(context);

  return (
    <Window title={config.title}>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
