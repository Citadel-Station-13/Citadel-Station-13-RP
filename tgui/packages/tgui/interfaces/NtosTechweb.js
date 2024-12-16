import { useBackend } from '../backend';
import { createLogger } from '../logging';
import { AppTechweb } from './Techweb.js';

const logger = createLogger('backend');

export const NtosTechweb = (props, context) => {
  const { config, data, act } = useBackend(context);
  logger.log(config.AppTechweb);
  return (
    <AppTechweb />
  );
};
