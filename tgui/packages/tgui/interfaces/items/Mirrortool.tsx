/**
 * @file
 * @license MIT
 */

import { Button, Dimmer, NoticeBox, Section } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { ResleevingMirror, ResleevingMirrorData } from '../common/Resleeving';

interface MirrortoolContext {
  mirror: ResleevingMirrorData;
}

export const Mirrortool = (props) => {
  const { act, data } = useBackend<MirrortoolContext>();
  return (
    <Window title="Mirror Tool" width={225} height={225}>
      <Window.Content>
        <Section
          fill
          scrollable
          title="Mirror"
          buttons={
            <Button onClick={() => act(data.mirror ? 'eject' : 'insert')}>
              {data.mirror ? 'Remove' : 'Insert'}
            </Button>
          }
        >
          {data.mirror ? (
            <ResleevingMirror data={data.mirror} />
          ) : (
            <Dimmer>
              <NoticeBox>Mirror slot empty</NoticeBox>
            </Dimmer>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
