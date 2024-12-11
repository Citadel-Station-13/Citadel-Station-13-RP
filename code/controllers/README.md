# Controllers

Backend controllers orchestrating the game.

## Globals

Many, but not all, controllers are accessible from anywhere in the code with standardized names.

- Master: As the name implies, the Master Controller performs init, shutdown, and acts as a process scheduler during a round.
- Failsafe: A controller that ensures the Master Controller is running properly.
- Configuration: A global datum that holds server configuration.
- RSname: Repository controllers storing /datum/prototype's that can be queried.
- SSname: Subsystems that handle init behavior, ticking, and other game functions..
