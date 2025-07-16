import { AppTechweb } from './Techweb.js';
import { useBackend } from '../backend';
import { createLogger } from '../logging';

const logger = createLogger('backend');

export const NtosTechweb = (props) => {
  const { config, data, act } = useBackend(context);
  logger.log(config.AppTechweb);
  return (
    <AppTechweb />
  );
};
