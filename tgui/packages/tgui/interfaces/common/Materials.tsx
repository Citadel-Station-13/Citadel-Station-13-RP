/**
 * @file
 * @license MIT
 */
import { ReactNode } from 'react';
import { Box, Button, Icon, NumberInput, Section, Stack, Tooltip } from 'tgui-core/components';
import { formatSiUnit } from 'tgui-core/format';
import { toFixed } from 'tgui-core/math';
import { BooleanLike } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';

import { useLocalState, useSharedState } from '../../backend';
import { SectionProps, Sprite } from '../../components';

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
  relative_integrity: number;
  hardness: number;
  toughness: number;
  refraction: number;
  absorption: number;
  nullification: number;
  density: number;
  weight_multiplier: number;

  relative_conductivity: number;
  relative_reactivity: number;
  relative_permeability: number;

  melting_point: number;
  opacity: number;
  constraints: number[];
  tags: string[];
}

interface MaterialStorageProps extends MaterialRenderProps {
  readonly eject: (string, number) => void; // called with (id, sheets).
}

export const MaterialStorage = (props: MaterialStorageProps) => {
  return (
    <MaterialRender
      {...props}
      materialButtons={(id) => {
        // TODO: we can't use react hooks, which are ordered, because if an additional material is inserted we'll be rendering more hooks than the last invocation.
        const [ejectAmt, setEjectAmt] = useLocalState<number>(`mat-ejectAmt-${id}`, 1);
        return (
          <>
            {props.materialButtons}
            <NumberInput step={1} width={3} value={ejectAmt} minValue={1} maxValue={100} onChange={(v) => setEjectAmt(v)} />
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
  readonly horizontal?: BooleanLike;
  readonly materialContext: MaterialsContext;
  // id to number
  readonly materialList: Record<string, number>;
  // id map to an element to render below/to the side respectively for vertical/horizontal
  readonly materialButtons?: (id) => ReactNode;
  // icon scale factor
  readonly materialScale?: number;
}

export const MaterialRender = (props: MaterialRenderProps) => {
  const [fancy, setFancy] = useSharedState('materialsFancy', true);
  const isEmpty = Object.keys(props.materialList).length === 0;

  let scale = props.materialScale ?? 1.0;

  return props.horizontal ? (
    <Section {...props}>
      {isEmpty ? (
        <Box textAlign="center">
          <Icon size={5} name="inbox" />
          <br />
          <b>No materials loaded.</b>
        </Box>
      ) : (
        <Stack wrap>
          {Object.entries(props.materialList).sort(
            ([a1, a2], [b1, b2]) => a1.localeCompare(b1)
          ).map(([id, amt]) => {
            return (
              <Stack.Item key={id}>
                <Stack vertical align="center">
                  <Stack.Item>
                    <Tooltip position="bottom" content={`${toTitleCase(props.materialContext.materials[id].name)}`}>
                      <Sprite
                        sheet={MATERIAL_SPRITESHEET_NAME}
                        sizeKey={MATERIAL_SPRITESHEET_SIZEKEY}
                        style={{ transform: `scale(${scale})` }}
                        prefix="stack"
                        sprite={props.materialContext.materials[id].iconKey} />
                    </Tooltip>
                  </Stack.Item>
                  <Stack.Item>
                    {renderMaterialAmount(amt)}
                  </Stack.Item>
                  <Stack.Item>
                    {props.materialButtons && props.materialButtons(id)}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            );
          })}
        </Stack>
      )}
    </Section>
  ) : (
    <Section {...props}>
      Unimplemented
    </Section>
  );
};

export const renderMaterialAmount = (amt: number): string => {
  return `${(amt < 1 && amt > 0) ? toFixed(amt, 2) : formatSiUnit(amt, 0)}${MATERIAL_STORAGE_UNIT_NAME}`;
};
