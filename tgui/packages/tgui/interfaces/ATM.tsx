import { useState } from "react";
import { Box, Button, Collapsible, Divider, Flex, Input, LabeledList, NumberInput, Section } from "tgui-core/components";

import { useBackend } from "../backend";
import { Window } from "../layouts";

const ACCOUNT_SECURITY_DESCRIPTIONS: AccountSecurityDescription[] = [{ "level": 0, "desc": "Only account number required, automatically scanned from ID in proximity." },
{ "level": 1, "desc": "Account number and PIN required; ID autoscan disabled." },
{ "level": 2, "desc": "Inserted ID card, Account number, and PIN required." }];

enum AccountSecurityLevels {
  SECURITY_LEVEL_MIN = 0,
  SECURITY_LEVEL_MED = 1,
  SECURITY_LEVEL_MAX = 2
}

interface AccountSecurityDescription {
  level: number,
  desc: String
}

type AccountTransactionLog = Record<string, AccountTransactionEntry>;

interface AccountTransactionEntry {
  target_name: string;
  purpose: string;
  amount: number;
  date: string;
  time: string;
  source_terminal: string;
}

interface ATMContext {
  "incorrect_attempts": number,
  "max_pin_attempts": number,
  "ticks_left_locked_down": number,
  "emagged": boolean,
  "authenticated_acc": boolean,
  "account_name": String,
  "transaction_log": AccountTransactionLog,
  "account_security_level": number,
  "current_account_security_level": number,
  "acc_suspended": boolean,
  "balance": number,
  "machine_id": String
  "card_inserted": boolean,
  "inserted_card_name": String,
  "logout_time": String,
}

export const ATM = (props) => {
  const { act, data } = useBackend<ATMContext>();
  if (!data.authenticated_acc) {
    return (
      <Window width={400} height={400}>
        <Window.Content scrollable>
          <Section title={data.machine_id} >
            {data.ticks_left_locked_down || data.emagged ? (<LockedElement />) : (<LoginElement />)}
          </Section>
        </Window.Content>
      </Window>
    );
  }
  return (
    <Window width={400} height={400}>
      <Window.Content scrollable>
        <Section title={data.machine_id} >
          <ATMElement />
        </Section>
      </Window.Content>
    </Window>
  );
};

const LoginElement = (props) => {
  const { act, data } = useBackend<ATMContext>();
  const [epin, setPin] = useState<string>("0");
  const [eacc, setAcc] = useState<string>("0");
  return (
    <Flex width={200} ml={2} wrap>
      <Flex.Item>
        Welcome to this Nanotrasen Automatic Teller Machine.<br />
        Please authenticate yourself by inserting your ID card or<br />
        entering your account number/PIN to continue.<br /><br />
        <LabeledList>
          <LabeledList.Item label="Inserted Card">
            <Button onClick={() => act('eject_card')} textAlign="right" icon="sim-card">{data.inserted_card_name}</Button><br />
          </LabeledList.Item>
          <LabeledList.Item label="Account Number">
            <Input placeholder="Account Number" onChange={(value) => setAcc(value)} textAlign="right" /><br />
          </LabeledList.Item>
          <LabeledList.Item label="PIN">
            <Input placeholder="PIN" onChange={(value) => setPin(value)} textAlign="right" /><br /><br />
          </LabeledList.Item>
          <Button onClick={() => act('attempt_authentication', { pin: epin, acc: eacc })} icon="key"> Confirm and Authenticate </Button><br />
        </LabeledList>
      </Flex.Item>
    </Flex>
  );

};

const LockedElement = (props) => {
  const { act, data } = useBackend<ATMContext>();
  return (
    <Flex justify="space-between" direction="column" textColor="#ff000d" backgroundColor="#540004" scrollable>
      <Flex.Item><br />
        <Box textAlign="center" fontSize="32">
          <b>[ERR 1S - TERMINAL LOCKED OUT]</b>
        </Box>
      </Flex.Item><br />
      <Flex.Item>
        <Box textAlign="center" fontSize="32">
          Welcome to this Nanotrasen Automatic Teller Machine.
          Unfortunately, we are unable to service your requests at this time.
          This terminal has been taken out of service due to a security incident.
          Please contact the Command department for more information.
        </Box>
      </Flex.Item><br />
      <Flex.Item>
        <Box textAlign="center" fontSize="32">
          <b>[ERR 1S - TERMINAL LOCKED OUT]</b>
        </Box>
      </Flex.Item><br />
      <Button onClick={() => act('logout')} icon="key">Logout</Button>
    </Flex>
  );
};

const ATMElement = (props) => {
  const { act, data } = useBackend<ATMContext>();
  const [transferTarget, setTransferTarget] = useState<string>("1");
  const [transferAmount, setTransferAmount] = useState<number>(1);
  const [transferPurpose, setTransferPurpose] = useState<String>("");
  const [withdrawAmount, setWithdrawAmount] = useState<number>(1);
  const [EWallet, setEWallet] = useState<boolean>(false);
  const [Security, setSecurity] = useState<number>(data.current_account_security_level);

  if (data.acc_suspended) {
    return (
      <Flex justify="space-between" direction="column" textColor="#ff000d" backgroundColor="#540004" scrollable>
        <Flex.Item><br />
          <Box textAlign="center" fontSize="32">
            <b>[ERR 5Ac - ACCOUNT SUSPENDED]</b>
          </Box>
        </Flex.Item><br />
        <Flex.Item>
          <Box textAlign="center" fontSize="32">
            Welcome to this Nanotrasen Automatic Teller Machine.
            Unfortunately, we are unable to service your requests at this time.
            This account has been suspended by the authority of the authorized feduciary aboard this facility.
            Please contact the Command department for more information.
          </Box>
        </Flex.Item><br />
        <Flex.Item>
          <Box textAlign="center" fontSize="32">
            <b>[ERR 5Ac - ACCOUNT SUSPENDED]</b>
          </Box>
        </Flex.Item><br />
        <Button onClick={() => act('logout')} icon="key">Logout</Button>
      </Flex>
    );
  }

  return (
    <Flex justify="space-around" direction="column" ml={2} mr={2}>
      <Flex.Item>
        Welcome, <b>{data.account_name}</b>.<br />
        Current Funds: <b>{data.balance}</b> cr<br />
        Inserted ID: <Button onClick={() => act('eject_card')} textAlign="right" icon="sim-card">{data.inserted_card_name}</Button><br />
        For your security, you will be logged out in <b>{data.logout_time}.</b><br />
      </Flex.Item>
      <Divider />
      <Flex.Item>
        <Collapsible title="Security Controls" icon="shield-alt">
          <LabeledList>
            <LabeledList.Item label="Security Setting">
              <Button.Checkbox
                checked={Security === AccountSecurityLevels.SECURITY_LEVEL_MIN}
                onClick={() => { setSecurity(AccountSecurityLevels.SECURITY_LEVEL_MIN); act('change_security_level', { new_security_level: Security }); }} >Minimal Security
              </Button.Checkbox>
              <Button.Checkbox
                checked={Security === AccountSecurityLevels.SECURITY_LEVEL_MED}
                onClick={() => { setSecurity(AccountSecurityLevels.SECURITY_LEVEL_MED); act('change_security_level', { new_security_level: Security }); }} >Medium Security
              </Button.Checkbox>
              <Button.Checkbox
                checked={Security === AccountSecurityLevels.SECURITY_LEVEL_MAX}
                onClick={() => { setSecurity(AccountSecurityLevels.SECURITY_LEVEL_MAX); act('change_security_level', { new_security_level: Security }); }} >Maximum Security
              </Button.Checkbox>
            </LabeledList.Item>
            <LabeledList.Item label="Setting Information">
              {ACCOUNT_SECURITY_DESCRIPTIONS.find(option => option.level === Security)?.desc}
            </LabeledList.Item>
          </LabeledList>
        </Collapsible>
        <Divider />
        <Collapsible title="Transaction Log" icon="money-bill" >
          <LabeledList>
            {
              Object.entries(data.transaction_log).map(([numString, logEntry]) => {
                return (
                  <LabeledList.Item key={numString} label={numString}>
                    <Collapsible title="Transaction">
                      <LabeledList>
                        <LabeledList.Item label="Target Name">
                          {logEntry.target_name}
                        </LabeledList.Item>
                        <LabeledList.Item label="Purpose">
                          {logEntry.purpose}
                        </LabeledList.Item>
                        <LabeledList.Item label="Amount">
                          <b>{logEntry.amount}cr</b>
                        </LabeledList.Item>
                        <LabeledList.Item label="Date">
                          {logEntry.date}
                        </LabeledList.Item>
                        <LabeledList.Item label="Time">
                          {logEntry.time}
                        </LabeledList.Item>
                        <LabeledList.Item label="Source Terminal">
                          {logEntry.source_terminal}
                        </LabeledList.Item>
                      </LabeledList>
                    </Collapsible>
                  </LabeledList.Item>
                );
              })
            }
          </LabeledList>
          <Button icon="clipboard-list" onClick={() => act('print_transaction')}>Print Transactions</Button>
        </Collapsible>
        <Divider />
        <Collapsible title="Transfer Funds" icon="money-check" >
          <LabeledList>
            <LabeledList.Item label="Target">
              <Input placeholder="Target" onChange={(value) => setTransferTarget(value)} />
            </LabeledList.Item>
            <LabeledList.Item label="Purpose">
              <Input placeholder="Purpose" onChange={(value) => setTransferPurpose(value)} />
            </LabeledList.Item>
            <LabeledList.Item label="Amount">
              <NumberInput step={1} minValue={0} maxValue={Infinity} value={transferAmount} onChange={(value) => setTransferAmount(value)} />
            </LabeledList.Item>
            <Button onClick={() => act('transfer', { target_acc_number: transferTarget, purpose: transferPurpose, funds_amount: transferAmount })} icon="check">Confirm Transfer</Button>
          </LabeledList>
        </Collapsible>
        <Divider />
        <Collapsible title="Withdraw Funds" icon="money-bill-alt" >
          <LabeledList>
            <LabeledList.Item label="Amount">
              <NumberInput step={1} minValue={0} maxValue={Infinity} value={withdrawAmount} onChange={(value) => setWithdrawAmount(value)} />
            </LabeledList.Item>
            <LabeledList.Item label="Method Selection">
              <Button.Checkbox checked={EWallet} onClick={() => setEWallet(!EWallet)} >EWallet</Button.Checkbox>
            </LabeledList.Item>
            <Button onClick={() => act('withdrawal', { funds_amount: withdrawAmount, form_ewallet: EWallet })}>Withdraw</Button>
          </LabeledList>
        </Collapsible>
        <Divider />
        <Flex.Item direction="column">
          <Button icon="clipboard-list" onClick={() => act('balance_statement')}>Print Statement</Button>
          <Button onClick={() => act('logout')} icon="key">Logout</Button>
        </Flex.Item>
      </Flex.Item >
    </Flex >
  );
};
