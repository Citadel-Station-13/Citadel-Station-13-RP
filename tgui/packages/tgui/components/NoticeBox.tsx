/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes, pureComponentHooks } from 'common/react';
import { Box, BoxProps } from './Box';

export type NoticeBoxProps = BoxProps & {
  warning?: BooleanLike;
  success?: BooleanLike;
  danger?: BooleanLike;
  info?: BooleanLike;
}

export const NoticeBox = (props: NoticeBoxProps) => {
  const {
    className,
    color,
    info,
    warning,
    success,
    danger,
    ...rest
  } = props;
  return (
    <Box
      className={classes([
        'NoticeBox',
        color && 'NoticeBox--color--' + color,
        info && 'NoticeBox--type--info',
        success && 'NoticeBox--type--success',
        danger && 'NoticeBox--type--danger',
        className,
      ])}
      {...rest} />
  );
};

NoticeBox.defaultHooks = pureComponentHooks;
