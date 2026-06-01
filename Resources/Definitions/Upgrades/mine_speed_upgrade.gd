class_name MineSpeedUpgrade
extends Upgrade

## Subtracts this percentage of the speed from the current speed
## For example, if the current speed is 1 and this value is 10:
## 10% of 1 = 0.1
## 1 - 0.1 = 0.9
## Therefore the new speed is 0.9
@export var upgrade_val: float = 0


func apply():
	super.apply()
	Globals.player_data.mine_speed -= Globals.player_data.mine_speed * (upgrade_val / 100)
