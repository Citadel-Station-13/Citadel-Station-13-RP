import { Box, Button, Divider } from "tgui-core/components";

import { useBackend } from "../backend";

const StockExchangeArchive = (props) => {
	const { act, data } = useBackend<any>();

	const {
		stocks = [],
	} = data;

	return (
		<Box>
			{stocks.map(stock => (
				<Box key={stock.ID}>
					<span>{stock.name}</span> <span>{stock.ID}</span>{stock.bankrupt === 1 && <b color="red">BANKRUPT</b>}<br />
					<b>Unified shares</b> {stock.Unification} ago.<br />
					<b>Current value per share:</b> {stock.Value} | <Button content="View history" onClick={() => act("stocks_history", { share: stock.REF })} /><br />
					You currently own <b>{stock.Owned}</b> shares in this company.<br />
					There are {stock.Avail} purchasable shares on the market currently.
					<br />

					{stock.bankrupt === 1
						? <span>You cannot buy or sell shares in a bankrupt company!</span>
						: <span><Button content="Buy shares" onClick={() => act("stocks_buy", { share: stock.REF })} /> | <Button content="Sell shares" onClick={() => act("stocks_sell", { share: stock.REF })} /></span>}
					<br />
					<b>Prominent products:</b><br />
					<i>{stock.Products}</i><br />
					<Button content="View news archives" onClick={() => act("stocks_archive", { share: stock.REF })} /> {/* [news ? " <span style='color:red'>(updated)</span>" : null] */}
					<Divider />
				</Box>
			))}
		</Box>
	);
};
