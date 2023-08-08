import { decodeHtmlEntities } from 'common/string';
import { useBackend } from '../../backend';
import { Button, LabeledList, Section } from '../../components';

export const Scrubber = (props, context) => {
  const { scrubber } = props;
  const { act } = useBackend(context);
  const {
    long_name,
    power,
    scrubbing,
    id_tag,
    widenet,
    filters,
  } = scrubber;
  return (
    <Section
      level={2}
      title={decodeHtmlEntities(long_name)}
      buttons={(
        <Button
          icon={power ? 'power-off' : 'times'}
          content={power ? 'On' : 'Off'}
          selected={power}
          onClick={() => act('power', {
            id_tag,
            val: Number(!power),
          })} />
      )}>
      <LabeledList>
        <LabeledList.Item label="Mode">
          <Button
            icon={scrubbing ? 'filter' : 'sign-in-alt'}
            color={scrubbing || 'danger'}
            content={scrubbing ? 'Scrubbing' : 'Siphoning'}
            onClick={() => act('scrubbing', {
              id_tag,
              val: Number(!scrubbing),
            })} />
        </LabeledList.Item>
        <LabeledList.Item label="Filters">
          {scrubbing
            && filters.map(filter => (
              <Button key={filter.name}
                icon={filter.val ? 'check-square-o' : 'square-o'}
                content={filter.name}
                title={filter.name}
                selected={filter.val}
                onClick={() => act(filter.command, {
                  id_tag,
                  val: !filter.val,
                })} />
            ))
            || 'N/A'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
