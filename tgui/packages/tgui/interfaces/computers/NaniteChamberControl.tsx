import { BooleanLike } from "common/react";
import { useBackend } from "../../backend";
import { Button, LabeledList, NoticeBox, Section } from "../../components";
import { Window } from "../../layouts";

interface NaniteChamberControlData {
  hasChamber: BooleanLike;
  locked: BooleanLike;
  open: BooleanLike;
  operating: BooleanLike;
  hasOccupant: BooleanLike;
  occupant: OccupantData;
  hasProtean: BooleanLike;
  protean: ProteanData;
}

interface OccupantData {
  name: string;
  isProtean: BooleanLike;
}

interface ProteanData {
  name: string;
  organs: ProteanOrgans;
  materials: Record<string, number>;
}

interface ProteanOrgans {
  intact: string[];
  missing: string[];
  cost: Record<string, number>;
}

export const NaniteChamberControl = (props, context) => {
  const { act, data } = useBackend<NaniteChamberControlData>(context);

  return (
    <Window
      title="Nanite Chamber Control"
      width={380}
      height={570}>
      <Window.Content>
        <NaniteChamberControlContent />
      </Window.Content>
    </Window>
  );
};

const NaniteChamberControlContent = (props, context) => {
  const { act, data } = useBackend<NaniteChamberControlData>(context);

  return data.hasChamber? (
    <Section
      title={`Chamber`}
      fill
      buttons={
        <Button
          disabled={data.open}
          icon={data.locked? "lock" : "lock-open"}
          content={data.locked? "Locked" : "Unlocked"}
          color={data.locked? "bad" : "default"}
          onClick={() => act('lock')} />
      }>
      {
        data.open? (
          <NoticeBox>
            Chamber open
          </NoticeBox>
        ) : (
          data.operating? (
            <NoticeBox textAlign="center" fontSize="1.75em">
              Operating...
            </NoticeBox>
          ) : (
            <NaniteChamberControlOccupant />
          )
        )
      }
    </Section>
  ) : (
    <Section>
      <NoticeBox warning>
        Chamber disconnected.
      </NoticeBox>
    </Section>
  );
};


const NaniteChamberControlOccupant = (props, context) => {
  const { act, data } = useBackend<NaniteChamberControlData>(context);

  // mob occupant
  if (data.hasOccupant) {
    return (
      <Section title={`Occupant - ${data.occupant.name}`}>
        {
          <>
            {/* linter override comment as we will have more sections in the fragment later. */}
            {!!data.occupant.isProtean && (
              <Section title="Detected Swarm - Intrinsic">
                <Button
                  fluid
                  icon="tint"
                  content="Regenerate Swarm Volume"
                  onClick={() => act('protean_refresh')} />
              </Section>
            )}
          </>
        }
      </Section>
    );
  }

  // protean brain - reconstruction
  else if (data.hasProtean) {
    return (
      <Section title="Swarm Reconstruction">
        <LabeledList>
          <LabeledList.Item label="Swarm Intelligence">
            {data.protean.name}
          </LabeledList.Item>
          {
            data.protean.organs.missing.map((n) => (
              <LabeledList.Item label={n} color="bad" key={n}>
                Missing
              </LabeledList.Item>
            ))
          }
          {
            data.protean.organs.intact.map((n) => (
              <LabeledList.Item label={n} color="good" key={n}>
                Present
              </LabeledList.Item>
            ))
          }
        </LabeledList>
        <Section title="Materials Required">
          <LabeledList>
            {
              Object.entries(data.protean.organs.cost).map(([k, v]) => (
                <LabeledList.Item label={k} key={k}>
                  {data.protean.materials[k] || 0} / {v}
                </LabeledList.Item>
              ))
            }
          </LabeledList>
        </Section>
        <Button icon="wrench" fluid fontSize="2em" content="Rebuild"
          onClick={() => act('protean_reconstruct')} />
      </Section>
    );
  }

  // nothing
  return (
    <Section title="Occupant">
      <NoticeBox>
        No occupant detected.
      </NoticeBox>
    </Section>
  );
};
