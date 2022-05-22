// power balancing file
// basics
/// power flow unit
#define POWER_FLOW_UNIT				"kW"
/// power energy unit
#define POWER_ENERGY_UNIT			"kJ"
/// default power storage unit
#define POWER_STORAGE_UNIT			"Wh"
/// energy used for x seconds of power flow
#define FLOW_TO_ENERGY(f, t)				(f * t)
/// energy used for x delta_time of power flow
#define FLOW_TO_ENERGY_DT(p, dt)			(dt * p)
/// constant - right now this is J per Wh
#define STORAGE_UNIT_AMOUNT(s)				(s)
/// storage used for x units of energy drained
#define ENERGY_TO_STORAGE(e)				(e / STORAGE_UNIT_AMOUNT)
/// storage used for x seconds of power flow
#define FLOW_TO_STORAGE

// units
#define KILOWATTS			* 1000
#define KILOJOULES			* 1000
#define MEGAWATTS			* 1000000
#define MEGAJOULES			* 1000000
#define GIGAWATTS			* 1000000000
#define GIGAJOULES			* 1000000000
#define TERAWATTS			* 1000000000000
#define TERAJOULES			* 1000000000000

// cell

// smes
#define SMES_COIL_STORAGE_BASIC				(250 KILOJOULES)
#define SMES_COIL_FLOW_BASIC				(250 KILOWATTS)
#define SMES_COIL_STORAGE_WEAK				(50 KILOJOULES)
#define SMES_COIL_FLOW_WEAK					(150 KILOWATTS)
#define SMES_COIL_STORAGE_TRANSMISSION		(100 KILOJOULES)
#define SMES_COIL_FLOW_TRANSMISSION			(1000 KILOWATTS)
#define SMES_COIL_STORAGE_CAPACITANCE		(1000 KILOJOULES)
#define SMES_COIL_FLOW_CAPACITANCE			()

///translates Watt into Kilowattminutes with respect to machinery schedule_interval ~(2s*1W*1min/60s)
#define SMESRATE 0.03333
#define SMESMAXCHARGELEVEL 250000
#define SMESMAXOUTPUT 250000

	ChargeCapacity = 1000				// 1 kWm


/obj/item/smes_coil
	name = "superconductive magnetic coil"
	desc = "The standard superconductive magnetic coil, with average capacity and I/O rating."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"			// Just few icons patched together. If someone wants to make better icon, feel free to do so!
	w_class = ITEMSIZE_LARGE 						// It's LARGE (backpack size)
	var/ChargeCapacity = 6000000		// 100 kWh
	var/IOCapacity = 250000				// 250 kW

// 20% Charge Capacity, 60% I/O Capacity. Used for substation/outpost SMESs.
/obj/item/smes_coil/weak
	name = "basic superconductive magnetic coil"
	desc = "A cheaper model of superconductive magnetic coil. Its capacity and I/O rating are considerably lower."
	ChargeCapacity = 1200000			// 20 kWh
	IOCapacity = 150000					// 150 kW

// 1000% Charge Capacity, 20% I/O Capacity
/obj/item/smes_coil/super_capacity
	name = "superconductive capacitance coil"
	desc = "A specialised type of superconductive magnetic coil with a significantly stronger containment field, allowing for larger power storage. Its IO rating is much lower, however."
	ChargeCapacity = 60000000			// 1000 kWh
	IOCapacity = 50000					// 50 kW

// 10% Charge Capacity, 400% I/O Capacity. Technically turns SMES into large super capacitor.Ideal for shields.
/obj/item/smes_coil/super_io
	name = "superconductive transmission coil"
	desc = "A specialised type of superconductive magnetic coil with reduced storage capabilites but vastly improved power transmission capabilities, making it useful in systems which require large throughput."
	ChargeCapacity = 600000				// 10 kWh
	IOCapacity = 1000000				// 1000 kW


/// Multiplier for watts per tick <> cell storage (e.g., 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
// = 50Ws/u
// 1000u -> 50000Ws -> 138.889 Wh
// 1200u -> 166.667 Wh
#define CELLRATE 0.002 // It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided


#define KILOWATTS *1000
#define MEGAWATTS *1000000
#define GIGAWATTS *1000000000
