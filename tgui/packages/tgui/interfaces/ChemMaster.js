import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, Section } from "../components";
import { Window } from "../layouts";
import { BeakerContents } from './common/BeakerContents';
import { ComplexModal, modalOpen, modalRegisterBodyOverride } from './common/ComplexModal';

const transferAmounts = [1, 5, 10, 30, 60];

const analyzeModalBodyOverride = (modal, context) => {
  const { act, data } = useBackend(context);
  const result = modal.args.analysis;
  return (
    <Section
      level={2}
      m="-1rem"
      pb="1rem"
      title={data.condi ? "Condiment Analysis" : "Reagent Analysis"}>
      <Box mx="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Name">
            {result.name}
          </LabeledList.Item>
          <LabeledList.Item label="Description">
            {(result.desc || "").length > 0 ? result.desc : "N/A"}
          </LabeledList.Item>
          {result.blood_type && (
            <Fragment>
              <LabeledList.Item label="Blood type">
                {result.blood_type}
              </LabeledList.Item>
              <LabeledList.Item
                label="Blood DNA"
                className="LabeledList__breakContents">
                {result.blood_dna}
              </LabeledList.Item>
            </Fragment>
          )}
          {!data.condi && (
            <Button
              icon={data.printing ? 'spinner' : 'print'}
              disabled={data.printing}
              iconSpin={!!data.printing}
              ml="0.5rem"
              content="Print"
              onClick={() => act('print', {
                idx: result.idx,
                beaker: modal.args.beaker,
              })}
            />
          )}
        </LabeledList>
      </Box>
    </Section>
  );
};

export const ChemMaster = (props, context) => {
  const { data } = useBackend(context);
  const {
    condi,
    beaker,
    beaker_reagents = [],
    buffer_reagents = [],
    mode,
  } = data;
  return (
    <Window
      width={575}
      height={495}
      resizable>
      <ComplexModal />
      <Window.Content className="Layout__content--flexColumn">
        <ChemMasterBeaker
          beaker={beaker}
          beakerReagents={beaker_reagents}
          bufferNonEmpty={buffer_reagents.length > 0} />
        <ChemMasterBuffer
          mode={mode}
          beaker={beaker}
          bufferReagents={buffer_reagents} />
        <ChemMasterProduction
          isCondiment={condi}
          bufferNonEmpty={buffer_reagents.length > 0} />
        {/* <ChemMasterCustomization /> */}
      </Window.Content>
    </Window>
  );
};

const ChemMasterBeaker = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    beaker,
    beakerReagents,
    bufferNonEmpty,
  } = props;

  let headerButton = bufferNonEmpty ? (
    <Button.Confirm
      icon="eject"
      disabled={!beaker}
      content="Eject and Clear Buffer"
      onClick={() => act('eject')}
    />
  ) : (
    <Button
      icon="eject"
      disabled={!beaker}
      content="Eject and Clear Buffer"
      onClick={() => act('eject')}
    />
  );

  return (
    <Section
      title="Beaker"
      buttons={headerButton}>
      {beaker
        ? (
          <BeakerContents
            beakerLoaded
            beakerContents={beakerReagents}
            buttons={(chemical, i) => (
              <Box mb={(i < beakerReagents.length - 1) && "2px"}>
                <Button
                  content="Analyze"
                  mb="0"
                  onClick={() => modalOpen(context, 'analyze', {
                    idx: i + 1,
                    beaker: 1,
                  })}
                />
                {transferAmounts.map((am, j) =>
                  (<Button
                    key={j}
                    content={am}
                    mb="0"
                    onClick={() => act('add', {
                      id: chemical.id,
                      amount: am,
                    })}
                  />)
                )}
                <Button
                  content="All"
                  mb="0"
                  onClick={() => act('add', {
                    id: chemical.id,
                    amount: chemical.volume,
                  })}
                />
                <Button
                  content="Custom.."
                  mb="0"
                  onClick={() => modalOpen(context, 'addcustom', {
                    id: chemical.id,
                  })}
                />
              </Box>
            )}
          />
        )
        : (
          <Box color="label">
            No beaker loaded.
          </Box>
        )}
    </Section>
  );
};

const ChemMasterBuffer = (props, context) => {
  const { act } = useBackend(context);
  const {
    mode,
    bufferReagents = [],
  } = props;
  return (
    <Section
      title="Buffer"
      buttons={
        <Box color="label">
          Transferring to&nbsp;
          <Button
            icon={mode ? "flask" : "trash"}
            color={!mode && "bad"}
            content={mode ? "Beaker" : "Disposal"}
            onClick={() => act('toggle')} />
        </Box>
      }>
      {(bufferReagents.length > 0)
        ? (
          <BeakerContents
            beakerLoaded
            beakerContents={bufferReagents}
            buttons={(chemical, i) => (
              <Box mb={(i < bufferReagents.length - 1) && "2px"}>
                <Button
                  content="Analyze"
                  mb="0"
                  onClick={() => modalOpen(context, 'analyze', {
                    idx: i + 1,
                    beaker: 0,
                  })}
                />
                {transferAmounts.map((am, i) =>
                  (<Button
                    key={i}
                    content={am}
                    mb="0"
                    onClick={() => act('remove', {
                      id: chemical.id,
                      amount: am,
                    })}
                  />)
                )}
                <Button
                  content="All"
                  mb="0"
                  onClick={() => act('remove', {
                    id: chemical.id,
                    amount: chemical.volume,
                  })}
                />
                <Button
                  content="Custom.."
                  mb="0"
                  onClick={() => modalOpen(context, 'removecustom', {
                    id: chemical.id,
                  })}
                />
              </Box>
            )}
          />
        )
        : (
          <Box color="label">
            Buffer is empty.
          </Box>
        )}
    </Section>
  );
};

const ChemMasterProduction = (props, context) => {
  const { act, data } = useBackend(context);
  if (!props.bufferNonEmpty) {
    return (
      <Section
        title="Production"
        flexGrow="1"
        buttons={
          <Button
            disabled={!data.loaded_pill_bottle}
            icon="eject"
            content={data.loaded_pill_bottle
              ? (
                data.loaded_pill_bottle_name
                + " ("
                + data.loaded_pill_bottle_contents_len
                + "/"
                + data.loaded_pill_bottle_storage_slots
                + ")"
              )
              : "No pill bottle loaded"}
            mb="0.5rem"
            onClick={() => act('ejectp')}
          />
        }>
        <Flex height="100%">
          <Flex.Item
            grow="1"
            align="center"
            textAlign="center"
            color="label">
            <Icon
              name="tint-slash"
              mt="0.5rem"
              mb="0.5rem"
              size="5"
            /><br />
            Buffer is empty.
          </Flex.Item>
        </Flex>
      </Section>
    );
  }

  return (
    <Section
      title="Production"
      flexGrow="1"
      buttons={
        <Button
          disabled={!data.loaded_pill_bottle}
          icon="eject"
          content={data.loaded_pill_bottle
            ? (
              data.loaded_pill_bottle_name
              + " ("
              + data.loaded_pill_bottle_contents_len
              + "/"
              + data.loaded_pill_bottle_storage_slots
              + ")"
            )
            : "No pill bottle loaded"}
          mb="0.5rem"
          onClick={() => act('ejectp')}
        />
      }>
      {!props.isCondiment ? (
        <ChemMasterProductionChemical />
      ) : (
        <ChemMasterProductionCondiment />
      )}
    </Section>
  );
};

const ChemMasterProductionChemical = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    condi,
    auto_condi_style,
    condi_styles = [],
    chosen_condi_style,
    pill_styles = [],
    chosen_pill_style,
    patch_styles = [],
    chosen_patch_style,
    chosen_bottle_style = [],
    bottle_styles,
  } = data;
  return (
    <LabeledList>
      {!condi && (
        <LabeledList.Item label="Pills">
          <Button
            icon="circle"
            content="One (60u max)"
            mr="0.5rem"
            onClick={() => modalOpen(context, 'create_pill')} />
          <Button
            icon="plus-circle"
            content="Multiple"
            mb="0.5rem"
            onClick={() => modalOpen(context, 'create_pill_multiple')} />
        </LabeledList.Item>
      )}
      {!condi && (
        <LabeledList.Item label="Pill type">
          {pill_styles.map((pill) => (
            <Button
              key={pill.id}
              width="30px"
              selected={pill.id === chosen_pill_style}
              textAlign="center"
              color="transparent"
              onClick={() => act('pill_style', { id: pill.id })}>
              <Box mx={-1} className={pill.class_name} />
            </Button>
          ))}
        </LabeledList.Item>
      )}
      {!condi && (
        <LabeledList.Item label="Patches">
          <Button
            icon="square"
            content="One (60u max)"
            mr="0.5rem"
            onClick={() => modalOpen(context, 'create_patch')} />
          <Button
            icon="plus-square"
            content="Multiple"
            onClick={() => modalOpen(context, 'create_patch_multiple')} />
        </LabeledList.Item>
      )}
      {!condi && (
        <LabeledList.Item label="Patch type">
          {patch_styles.map((patch) => (
            <Button
              key={patch.style}
              width="30px"
              selected={patch.style === chosen_patch_style}
              textAlign="center"
              color="transparent"
              onClick={() =>
                act('change_patch_style', { patch_style: patch.style })}>
              <Box mb={0} mt={1} className={patch.class_name} />
            </Button>
          ))}
        </LabeledList.Item>
      )}
      {!condi && (
        <LabeledList.Item label="Bottle">
          <Button
            icon="wine-bottle"
            content="One (60u max)"
            mr="0.5rem"
            mb="0.5rem"
            onClick={() => modalOpen(context, 'create_bottle')} />
          <Button
            icon="plus-square"
            content="Multiple"
            onClick={() => modalOpen(context, 'create_bottle_multiple')} />
        </LabeledList.Item>
      )}
      {!condi && (
        <LabeledList.Item label="Bottle type">
          {bottle_styles.map((bottle) => (
            <Button
              key={bottle.id}
              width="30px"
              selected={bottle.id === chosen_bottle_style}
              textAlign="center"
              color="transparent"
              onClick={() => act('bottle_style', { id: bottle.id })}>
              <Box mb={0} mt={1} className={bottle.class_name} />
            </Button>
          ))}
        </LabeledList.Item>
      )}
      {!condi && (
        <LabeledList.Item label="Lollipops">
          <Button
            icon="square"
            content="One (20u max)"
            mr="0.5rem"
            onClick={() => modalOpen(context, 'create_lollipop')} />
          <Button
            icon="plus-square"
            content="Multiple"
            onClick={() => modalOpen(context, 'create_lollipop_multiple')} />
        </LabeledList.Item>
      )}
      {!condi && (
        <LabeledList.Item label="Autoinjectors">
          <Button
            icon="square"
            content="One (5u max)"
            mr="0.5rem"
            onClick={() => modalOpen(context, 'create_autoinjector')} />
          <Button
            icon="plus-square"
            content="Multiple"
            onClick={() => modalOpen(context, 'create_autoinjector_multiple')} />
        </LabeledList.Item>
      )}
    </LabeledList>
  );
};

const ChemMasterProductionCondiment = (props, context) => {
  const { act } = useBackend(context);
  return (
    <Fragment>
      <Button
        icon="box"
        content="Create condiment pack (10u max)"
        mb="0.5rem"
        onClick={() => modalOpen(context, 'create_condi_pack')}
      /><br />
      <Button
        icon="wine-bottle"
        content="Create bottle (60u max)"
        mb="0"
        onClick={() => act('create_condi_bottle')}
      />
    </Fragment>
  );
};

// const ChemMasterCustomization = (props, context) => {
//   const { act, data } = useBackend(context);
//   if (!data.loaded_pill_bottle) {
//     return (
//       <Section title="Pill Bottle Customization">
//         <Box color="label">
//           None loaded.
//         </Box>
//       </Section>
//     );
//   }

//   return (
//     <Section title="Pill Bottle Customization">
//       <Button
//         disabled={!data.loaded_pill_bottle}
//         icon="eject"
//         content={data.loaded_pill_bottle
//           ? (
//             data.loaded_pill_bottle_name
//               + " ("
//               + data.loaded_pill_bottle_contents_len
//               + "/"
//               + data.loaded_pill_bottle_storage_slots
//               + ")"
//           )
//           : "None loaded"}
//         mb="0.5rem"
//         onClick={() => act('ejectp')}
//       />
//     </Section>
//   );
// };

modalRegisterBodyOverride('analyze', analyzeModalBodyOverride);
