import { useBackend } from "../../backend";
import { Window } from "../../layouts";

interface PointRedemptionVendorData {
  points: number;
  pointName: string;
}

export const PointRedemptionVendor = (props, context) => {
  const { act, data } = useBackend<PointRedemptionVendorData>(context);

  return (
    <Window>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
