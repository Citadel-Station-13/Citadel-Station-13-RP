import { Section, Flex, Box, Button, Input, LabeledList, Collapsible, Divider } from "../components";
import { Window } from "../layouts";
import { useBackend, useLocalState } from "../backend";

const ACCOUNT_SECURITY_DESCRIPTIONS: AccountSecurityDescription[] = [{ "level": 0, "desc": "Only account number required, automatically scanned from ID in proximity." },
  { "level": 1, "desc": "Account number and PIN required; ID autoscan disabled." },
  { "level": 2, "desc": "Inserted ID card, Account number, and PIN required." }];

enum AccountSecurityLevels {
  SECURITY_LEVEL_MIN = 0,
  SECURITY_LEVEL_MED = 1,
  SECURITY_LEVEL_MAX = 2}

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
  "incorrect_attempts" : number,
	"max_pin_attempts" : number,
	"ticks_left_locked_down": number,
	"emagged" : boolean,
	"authenticated_acc" : boolean,
	"account_name" : String,
	"transaction_log": AccountTransactionLog,
	"account_security_level" : number,
	"current_account_security_level" : number,
	"acc_suspended": boolean,
	"balance": number,
  "machine_id": String
  "card_inserted": boolean,
  "inserted_card_name": String,
  "logout_time": String,
}

export const ATM = (props, context) => {
  const { act, data } = useBackend<ATMContext>(context);
  if (!data.authenticated_acc) {
    return (
      <Window resizable width={400} height={400}>
        <Window.Content scrollable>
          <Section title={data.machine_id} >
            {data.ticks_left_locked_down || data.emagged ? (<LockedElement />) : (<LoginElement />) }
          </Section>
        </Window.Content>
      </Window>
    ); }
  return (
    <Window resizable width={400} height={400} scrollable>
      <Window.Content scrollable>
        <Section title={data.machine_id} >
          <ATMElement />
        </Section>
      </Window.Content>
    </Window>
  );
};

const LoginElement = (props, context) => {
  const { act, data } = useBackend<ATMContext>(context);
  const [epin, setPin] = useLocalState<number>(
    context,
    "epin",
    0
  );
  const [eacc, setAcc] = useLocalState<number>(
    context,
    "eacc",
    0
  );
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
            <Input placeholder="Account Number" onChange={(e, value) => setAcc(value)} textAlign="right" /><br />
          </LabeledList.Item>
          <LabeledList.Item label="PIN">
            <Input placeholder="PIN" onChange={(e, value) => setPin(value)} textAlign="right" /><br /><br />
          </LabeledList.Item>
          <Button onClick={() => act('attempt_authentication', { pin: epin, acc: eacc })} icon="key"> Confirm and Authenticate </Button><br />
        </LabeledList>
      </Flex.Item>
    </Flex>
  );

};

const LockedElement = (props, context) => {
  const { act, data } = useBackend<ATMContext>(context);
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

const ATMElement = (props, context) => {
  const { act, data } = useBackend<ATMContext>(context);
  const [TransferTarget, setTransferTarget] = useLocalState<number>(context, "TransferTarget", 1);
  const [TransferAmount, setTransferAmount] = useLocalState<number>(context, "TransferAmount", 1);
  const [TransferPurpose, setTransferPurpose] = useLocalState<String>(context, "TransferPurpose", "");
  const [WithdrawAmount, setWithdrawAmount] = useLocalState<number>(context, "WithdrawAmount", 1);
  const [EWallet, setEWallet] = useLocalState<boolean>(context, "EWallet", false);
  const [Security, setSecurity] = useLocalState<number>(context, "Security", data.current_account_security_level);

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
        <Collapsible title="Transaction Log" icon="money-bill">
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
        <Collapsible title="Transfer Funds" icon="money-check">
          <LabeledList>
            <LabeledList.Item label="Target">
              <Input placeholder="Target" onChange={(e, value) => setTransferTarget(value)} />
            </LabeledList.Item>
            <LabeledList.Item label="Purpose">
              <Input placeholder="Purpose" onChange={(e, value) => setTransferPurpose(value)} />
            </LabeledList.Item>
            <LabeledList.Item label="Amount">
              <Input placeholder="Amount" onChange={(e, value) => setTransferAmount(value)} />
            </LabeledList.Item>
            <Button onClick={() => act('transfer', { target_acc_number: TransferTarget, purpose: TransferPurpose, funds_amount: TransferAmount })} icon="check">Confirm Transfer</Button>
          </LabeledList>
        </Collapsible>
        <Divider />
        <Collapsible title="Withdraw Funds" icon="money-bill-alt">
          <LabeledList>
            <LabeledList.Item label="Amount">
              <Input placeholder="Amount" onChange={(e, value) => setWithdrawAmount(value)} />
            </LabeledList.Item>
            <LabeledList.Item label="Method Selection">
              <Button.Checkbox checked={EWallet} onClick={() => setEWallet(!EWallet)} >EWallet</Button.Checkbox>
            </LabeledList.Item>
            <Button onClick={() => act('withdrawal', { funds_amount: WithdrawAmount, form_ewallet: EWallet })}>Withdraw</Button>
          </LabeledList>
        </Collapsible>
        <Divider />
        <Flex.Item direction="column">
          <Button icon="clipboard-list" onClick={() => act('balance_statement')}>Print Statement</Button>
          <Button onClick={() => act('logout')} icon="key">Logout</Button>
        </Flex.Item>
      </Flex.Item>
    </Flex>
  );
};
