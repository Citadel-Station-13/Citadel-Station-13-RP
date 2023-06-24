import { useBackend, useLocalState } from "../backend";
import { Button, NoticeBox, Section, Stack } from "../components";
import { Window } from "../layouts";

const MONTH_DAYS_LOOKUP: number[] = [
  31,
  28,
  31,
  30,
  31,
  30,
  31,
  31,
  30,
  31,
  30,
  31,
];

const daysInMonth = (month: number, year: number) => {
  if (Number.isNaN(month) || Number.isNaN(year)) {
    return 31;
  }
  let days = MONTH_DAYS_LOOKUP[month];
  if ((month === 2) && ((year % 4) === 0)) {
    days = 29;
  }
  return days;
};

const validYears = () => {
  let current = (new Date()).getFullYear();
  let ret: string[] = [];
  for (let i = current; i >= 1950; i--) {
    ret.push(i.toString());
  }
  return ret;
};
const VALID_YEARS = validYears();

const VALID_MONTHS = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
].map((n) => n.toString());

const validDays = (month: number, year: number) => {
  let current = daysInMonth(month, year);
  let ret: string[] = [];
  for (let i = 1; i <= current; i++) {
    ret.push(i.toString());
  }
  return ret;
};

export const AgeVerifyMenu = (props, context) => {
  let { data, act } = useBackend(context);
  let [month, setMonth] = useLocalState<string | null>(context, "month", null);
  let [day, setDay] = useLocalState<string | null>(context, "day", null);
  let [year, setYear] = useLocalState<string | null>(context, "year", null);
  return (
    <Window width={400} height={400} title="Age Verification">
      <Window.Content>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <NoticeBox warning>
                Please enter your date of birth to continue.
              </NoticeBox>
            </Stack.Item>
            <Stack.Item textAlign="center">
              <Stack height="280px">
                <Stack.Item width="33%" overflowY="scroll" overflowX="hidden">
                  {
                    validDays(
                      (month === null)? 1 : Number.parseInt(month, 10),
                      (year === null)? 1 : Number.parseInt(year, 10)
                    ).map((m) => (
                      <Button key={m} fluid content={m} color="transparent" selected={m === day}
                        onClick={() => setDay(m)} />
                    ))
                  }
                </Stack.Item>
                <Stack.Item width="33%" overflowY="scroll" overflowX="hidden">
                  {
                    VALID_MONTHS.map((m) => (
                      <Button key={m} fluid content={m} color="transparent" selected={m === month}
                        onClick={() => setMonth(m)} />
                    ))
                  }
                </Stack.Item>
                <Stack.Item width="33%" overflowY="scroll" overflowX="hidden">
                  {
                    VALID_YEARS.map((m) => (
                      <Button key={m} fluid content={m} color="transparent" selected={m === year}
                        onClick={() => setYear(m)} />
                    ))
                  }
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Button.Confirm textAlign="center" color="transparent" fluid content="Submit"
                disabled={
                  month === null
                || day === null
                || year === null
                }
                onClick={() => act('verify', {
                  month: (VALID_MONTHS.findIndex((m) => m === month) + 1),
                  year: year,
                  day: day,
                })} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
