import { useDispatch } from 'common/redux';
import type { Page } from '../chat/types';
import { importSettings } from './actions';

export function exportChatSettings(
  settings: Record<string, any>,
  pages: Record<string, Page>[],
) {
  const opts: SaveFilePickerOptions = {
    id: `ss13-chatprefs-${Date.now()}`,
    suggestedName: `ss13-chatsettings-${new Date().toJSON().slice(0, 10)}.json`,
    types: [
      {
        description: 'SS13 file',
        accept: { 'application/json': ['.json'] },
      },
    ],
  };

  const pagesEntry: Record<string, Page>[] = [];
  pagesEntry['chatPages'] = pages;

  const exportObject = Object.assign(settings, pagesEntry);

  window
    .showSaveFilePicker(opts)
    .then((fileHandle) => {
      fileHandle.createWritable().then((writableHandle) => {
        writableHandle.write(JSON.stringify(exportObject));
        writableHandle.close();
      });
    })
    .catch((e) => {
      // Log the error if the error has nothing to do with the user aborting the download
      if (e.name !== 'AbortError') {
        console.error(e);
      }
    });
}

export async function importChatSettings(context, settings: FileList) {
  if (!settings.length) {
    return;
  }

  // its a blob...
  const fileSetting = await settings[0].text();

  const dispatch = useDispatch(context);
  const ourImport = JSON.parse(fileSetting);
  if (!ourImport?.version) {
    return;
  }
  const pageRecord = ourImport['chatPages'];
  delete ourImport['chatPages'];

  dispatch(importSettings(ourImport, pageRecord));
}
