/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { storage } from 'common/storage';

import { Button, LabeledList, NoticeBox, Section } from '../components';
import { formatSiUnit } from '../format';

export const meta = {
  title: 'Storage',
  render: () => <Story />,
};

const storageProvider = Byond.BLINK ? window.domainStorage : window.localStorage;

const Story = (props, context) => {
  const storageName = Byond.BLINK ? "byondStorage" : "localStorage";
  if (!storageProvider) {
    return (
      <NoticeBox>
        {storageName} is not available.
      </NoticeBox>
    );
  }
  return (
    <Section
      title={storageName}
      buttons={(
        <Button
          icon="recycle"
          onClick={() => {
            storageProvider.clear();
            storage.clear();
          }}>
          Clear
        </Button>
      )}>
      <LabeledList>
        <LabeledList.Item label="Keys in use">
          {storageProvider.length}
        </LabeledList.Item>
        <LabeledList.Item label="Remaining space">
          {/* remainingSpace is ie proprietary thing, this approximation is good enough. 5000000 (5mb) is chrome max idk the webview max */}
          {formatSiUnit(storageProvider?.remainingSpace ?? 5000000 - JSON.stringify(storageProvider).length, 0, 'B')}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
