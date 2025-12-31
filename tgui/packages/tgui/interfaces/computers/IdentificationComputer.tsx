/**
 * @file
 * @license MIT
 */

import { useState } from "react";
import { Button, NoticeBox, Section, Tabs } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { useBackend } from "../../backend";
import { LegacyModule } from "../../components/LegacyModule";
import { Window } from "../../layouts";
import { IDCard, IDCardOrDefault, IDSlot } from "../common/IDCard";
import { CrewManifestContent } from "../CrewManifest";

interface IdentificationComputerContext {
  printing: BooleanLike;
  auth_card?: IDCard;
  modify_card?: IDCard;
  authed_cardmod: BooleanLike;
  authed_slotmod: BooleanLike;
}

export const IdentificationComputer = (props) => {
  const { data, act } = useBackend<IdentificationComputerContext>();
  const [currentTab, setCurrentTab] = useState<number>(0);
  return (
    <Window width={500} height={700}>
      <Window.Content scrollable>
        <Section title="Authentication">
          <IDSlot card={IDCardOrDefault(data.auth_card)} onClick={() => act('auth')} />
        </Section>
        <Tabs>
          <Tabs.Tab
            selected={currentTab === 0}
            onClick={() => setCurrentTab(0)}>
            Access Modification
          </Tabs.Tab>
          <Tabs.Tab
            selected={currentTab === 1}
            onClick={() => setCurrentTab(1)}>
            Crew Manifest
          </Tabs.Tab>
        </Tabs>
        {currentTab === 0 && (
          <>
            <Section title="Target">
              <IDSlot card={IDCardOrDefault(data.modify_card)} onClick={() => act('modify')} />
            </Section>
            <Section>
              {
                data.authed_cardmod ? (
                  data.modify_card ? (
                    <LegacyModule id="modify" />
                  ) : (
                    <NoticeBox >
                      Please insert target card.
                    </NoticeBox>
                  )
                ) : (
                  <NoticeBox >
                    Authentication required for ID modification.
                  </NoticeBox>
                )
              }
            </Section>
          </>
        )}
        {currentTab === 1 && (
          <Section
            title="Manifest"
            buttons={
              <Button
                content={data.printing ? "Printing" : "Print"}
                disabled={data.printing}
                icon="print"
                onClick={() => act('print_manifest')} />
            }>
            <CrewManifestContent />
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
