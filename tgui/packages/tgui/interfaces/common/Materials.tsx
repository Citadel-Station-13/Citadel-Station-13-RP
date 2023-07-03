import { BooleanLike } from 'common/react';
import { Box, Button, NumberInput, Flex, Section, Icon } from '../../components';
import { classes } from 'common/react';
import { formatMoney, formatSiUnit } from '../../format';
import { useLocalState, useSharedState } from '../../backend';
import { BoxProps } from '../../components/Box';
import { SectionProps } from '../../components/Section';
import { InfernoNode } from 'inferno';

// the space is intentional
export const MATERIAL_STORAGE_UNIT_NAME = " cm³";
// spritesheet name
export const MATERIAL_SPRITESHEET_NAME = "sheetmaterials";
// spritesheet icon size key to use
export const MATERIAL_SPRITESHEET_SIZEKEY = "32x32";
// full spritesheet part of the .css class to use
export const MATERIAL_SPRITESHEET_CSS = `${MATERIAL_SPRITESHEET_NAME}${MATERIAL_SPRITESHEET_SIZEKEY}`;

export interface MaterialsContext {
  materials: Record<string, Material>;
  sheetAmount: number;
}

export interface FullMaterialsContext {
  materials: Record<string, DetailedMaterial>;
  sheetAmount: number;
 }

export interface Material {
  name: string;
  id: string;
  sheetAmount: number;
  iconKey: string;
}

export interface DetailedMaterial extends Material {

}

interface MaterialStorageProps extends MaterialRenderProps {
  eject: (string, number) => void; // called with (id, sheets).
}

export const MaterialStorage = (props: MaterialStorageProps, context) => {
  return (
    <MaterialRender
      {...props}
      materialButtons={(id) => {
        const [ejectAmt, setEjectAmt] = useLocalState<number>(context, `matEject-${id}`, 1);
        return (
          <>
            {props.materialButtons}
            <NumberInput value={ejectAmt} onChange={(e, v) => setEjectAmt(v)} />
            <Button
              icon="eject"
              onClick={() => props.eject(id, ejectAmt)} />
          </>
        );
      }}
    />
  );
};

interface MaterialRenderProps extends SectionProps {
  horizontal: BooleanLike;
  materialContext: MaterialsContext;
  // id to number
  materialList: Record<string, number>;
  // id map to an element to render below/to the side respectively for vertical/horizontal
  materialButtons?: (id) => InfernoNode;
}

export const MaterialRender = (props: MaterialRenderProps, context) => {
  const [fancy, setFancy] = useSharedState(context, 'materialsFancy', true);
  const isEmpty = Object.keys(props.materialList).length === 0;

  return props.horizontal? (
    <Section {...props}>
      {isEmpty? (
        <Box textAlign="center">
          <Icon size={5} name="inbox" />
          <br />
          <b>No materials loaded.</b>
        </Box>
      ) : (
        <Flex wrap>
          {Object.entries(props.materialList).sort(
            ([a1, a2], [b1, b2]) => a1.localeCompare(b1)
          ).map(([id, amt]) => {

            return (
              <Flex.Item key={id} width="80px">
                <Flex direction="column" align="center">
                  <Flex.Item>
                    <Box
                      className={classes([
                        MATERIAL_SPRITESHEET_CSS,
                        `stack-${props.materialContext.materials[id].iconKey}`,
                      ])} />
                  </Flex.Item>
                  <Flex.Item>
                    test
                  </Flex.Item>
                  <Flex.Item>
                    {props.materialButtons && props.materialButtons(id)}
                  </Flex.Item>
                </Flex>
              </Flex.Item>
            );
          })}
        </Flex>
      )}
    </Section>
  ) : (
    <Section {...props}>
      Unimplemented
    </Section>
  );
};

// * legacy below * //

export const MATERIAL_KEYS = {
  "iron": "sheet-metal_3",
  "glass": "sheet-glass_3",
  "silver": "sheet-silver_3",
  "gold": "sheet-gold_3",
  "diamond": "sheet-diamond",
  "plasma": "sheet-plasma_3",
  "uranium": "sheet-uranium",
  "bananium": "sheet-bananium",
  "titanium": "sheet-titanium_3",
  "bluespace crystal": "polycrystal",
  "plastic": "sheet-plastic_3",
} as const;

export type LegacyMaterial = {
  name: keyof typeof MATERIAL_KEYS;
  ref: string;
  amount: number;
  sheets: number;
  removable: BooleanLike;
};

interface MaterialIconProps extends BoxProps {
  material: keyof typeof MATERIAL_KEYS;
}

export const MaterialIcon = (props: MaterialIconProps) => {
  const { material, ...rest } = props;

  return (<Box
    {...rest}
    className={classes([
      'sheetmaterials32x32',
      MATERIAL_KEYS[material],
    ])} />);
};

const EjectMaterial = (props: {
  material: LegacyMaterial,
  onEject: (amount: number) => void,
}, context) => {
  const {
    name,
    removable,
    sheets,
  } = props.material;
  const [removeMaterials, setRemoveMaterials] = useSharedState(
    context, 'remove_mats_' + name, 1);
  if (removeMaterials > 1 && sheets < removeMaterials) {
    setRemoveMaterials(sheets || 1);
  }
  return (
    <>
      <NumberInput
        width="30px"
        animated
        value={removeMaterials}
        minValue={1}
        maxValue={sheets || 1}
        initial={1}
        onDrag={(e, val) => {
          const newVal = parseInt(val, 10);
          if (Number.isInteger(newVal)) {
            setRemoveMaterials(newVal);
          }
        }} />
      <Button
        icon="eject"
        disabled={!removable}
        onClick={() => {
          props.onEject(removeMaterials);
        }} />
    </>
  );
};

export const Materials = (props: {
  materials: LegacyMaterial[],
  onEject: (ref: string, amount: number) => void,
}) => {
  return (
    <Flex wrap>
      {props.materials.map(material => (
        <Flex.Item key={material.name} grow={1} shrink={1}>
          <MaterialAmount
            name={material.name}
            amount={material.amount}
            formatting={MaterialFormatting.SIUnits} />
          <Box mt={1} textAlign="center">
            <EjectMaterial material={material} onEject={(amount) => {
              props.onEject(material.ref, amount);
            }} />
          </Box>
        </Flex.Item>
      ))}
    </Flex>
  );
};

export enum MaterialFormatting {
  SIUnits,
  Money,
  Locale,
}

export const MaterialAmount = (props: {
  name: keyof typeof MATERIAL_KEYS,
  amount: number,
  formatting?: MaterialFormatting,
  color?: string,
  style?: Record<string, string>,
}) => {
  const {
    name,
    amount,
    color,
    style,
  } = props;

  let amountDisplay;

  switch (props.formatting) {
    case MaterialFormatting.SIUnits:
      amountDisplay = formatSiUnit(amount, 0);
      break;
    case MaterialFormatting.Money:
      amountDisplay = formatMoney(amount);
      break;
    case MaterialFormatting.Locale:
      amountDisplay = amount.toLocaleString();
      break;
    default:
      amountDisplay = amount;
  }

  return (
    <Flex direction="column" textAlign="center">
      <Flex.Item>
        <MaterialIcon material={name} style={style} />
      </Flex.Item>
      <Flex.Item color={color}>
        {amountDisplay}
      </Flex.Item>
    </Flex>
  );
};
