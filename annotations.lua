---@meta

---@class REC_Utils.Client.Modules.Framework
---@
---@field setOnPlayerLoaded fun(self: REC_Utils.Client.Modules.Framework, onPlayerLoaded: fun() )
---@field setOnPlayerUnLoaded fun(self: REC_Utils.Client.Modules.Framework, onPlayerUnLoaded: fun() )

---@class REC_Utils.Client.Modules.Inventory
---@field items fun(self: REC_Utils.Client.Modules.Inventory, name?: string): REC_Utils.Client.Modules.Inventory.Items.Return|nil
---@field getItemCount fun(self: REC_Utils.Client.Modules.Inventory, item: string, ): integer
---@field setIsBusy fun(self: REC_Utils.Client.Modules.Inventory, isBusy: boolean, ): boolean

---@class REC_Utils.Client.Modules.Inventory.Items.Return
---@field name string
---@field label string
---@field weight number
---@field stack boolean

---@class REC_Utils.Client.Modules.Medical
---@field isLastStand fun(self: REC_Utils.Client.Modules.Medical, ): boolean
---@field isDead fun(self: REC_Utils.Client.Modules.Medical, ): boolean
---@field kill fun(self: REC_Utils.Client.Modules.Medical, ): boolean

---@class REC_Utils.Client.Modules.Target
---@field addModel fun(self: REC_Utils.Client.Modules.Target, model: integer|integer[]|string|string[], options: REC_Utils.Client.Modules.Target.TargetOptionsConfig, ): boolean
---@field removeModel fun(self: REC_Utils.Client.Modules.Target, model: integer|integer[]|string|string[], ): boolean
---@field addLocalEntity fun(self: REC_Utils.Client.Modules.Target, entity: integer|integer[], options: REC_Utils.Client.Modules.Target.TargetOptionsConfig, ): boolean
---@field removeLocalEntity fun(self: REC_Utils.Client.Modules.Target, entity: integer|integer[], ): boolean

---@class REC_Utils.Client.Modules.VehicleFuel
---@field getFuel fun(self: REC_Utils.Client.Modules.VehicleFuel, vehicle: integer, ): integer
---@field setFuel fun(self: REC_Utils.Client.Modules.VehicleFuel, vehicle: integer, fuel: integer, ): boolean

---@class REC_Utils.Client.Modules.Notify
---@field trigger fun(self: REC_Utils.Client.Modules.Notify, notifyType: "success" | "info" | "warning" | "error", titile: string, msg: string, duration?: integer, playSound: boolean, ): boolean

---@class REC_Utils.Client.Modules.Status
---@field get fun(self: REC_Utils.Client.Modules.Status, name: "hunger" | "thirst" | "stress", ): number|nil # 0 to 100, 100 is full (stress 100 is the worst), nil when the framework has no such status

---@class REC_Utils.Client.Modules.Clothing
---@field getClothing fun(self: REC_Utils.Client.Modules.Clothing, ): table current ped components/props, shape depends on the adapter
---@field setClothing fun(self: REC_Utils.Client.Modules.Clothing, clothingData: table, ): boolean
---@field openMenu fun(self: REC_Utils.Client.Modules.Clothing, cb?: fun(clothingData: table|false), fullCustomization?: boolean, ): boolean opens the clothing customization menu for the local player, cb receives false when cancelled
---@field saveOutfit fun(self: REC_Utils.Client.Modules.Clothing, name: string, ): boolean persists the current clothing under name (per citizenId, resolved server side)
---@field loadOutfit fun(self: REC_Utils.Client.Modules.Clothing, name: string, ): boolean requests a previously saved outfit and applies it once it comes back

---@class REC_Utils.Server.Modules.Framework.DoesRequiredJobsExist.Args.Job
---@field ranks table<integer, true>
---@field onDutyOnly boolean
---@

---@class REC_Utils.Server.Modules.Framework
---@field getPlayers fun(self: REC_Utils.Server.Modules.Framework,  ): REC_Utils.Server.Modules.Framework.GetPlayers.Return[]
---@field getPlayerData fun(self: REC_Utils.Server.Modules.Framework, playerId: integer): REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData|nil
---@field getCitizenIdByPlayerId fun(self: REC_Utils.Server.Modules.Framework, playerId: integer): string|nil
---@field getMoneys fun(self: REC_Utils.Server.Modules.Framework, playerId: integer): table<REC_Utils.Server.Modules.Framework.MoneyTypes, integer>|nil
---@field getMoney fun(self: REC_Utils.Server.Modules.Framework, playerId: integer, moneyType: REC_Utils.Server.Modules.Framework.MoneyTypes, ): integer|nil
---@field addMoney fun(self: REC_Utils.Server.Modules.Framework, playerId: integer, amount: integer, moneyType?: REC_Utils.Server.Modules.Framework.MoneyTypes, ): boolean moneyType defaults to "bank"
---@field removeMoney fun(self: REC_Utils.Server.Modules.Framework, playerId: integer, amount: integer, moneyType?: REC_Utils.Server.Modules.Framework.MoneyTypes, ): boolean moneyType defaults to "bank"
---@field hasJob fun(self: REC_Utils.Server.Modules.Framework, playerId: integer, job: string|string[], grades?: table<integer, true>, onDutyOnly: boolean, ): boolean
---@field getJobs fun(self: REC_Utils.Server.Modules.Framework): table<string, REC_Utils.Server.Modules.Framework.GetJobs.Return>
---@field hasGang fun(self: REC_Utils.Server.Modules.Framework, playerId: integer, gang: string|string[], ranks?: table<integer, true>): boolean
---@field getGangs fun(self: REC_Utils.Server.Modules.Framework): table<string, REC_Utils.Server.Modules.Framework.GetJobs.Return>
---@field getResourceName fun(self: REC_Utils.Server.Modules.Framework): string|nil resource the adapter calls into, nil when it cannot be named
---@field isReady fun(self: REC_Utils.Server.Modules.Framework): boolean whether that resource has started
---@field waitUntilReady fun(self: REC_Utils.Server.Modules.Framework, timeoutMs?: integer): boolean blocks until it has, false on timeout
---@field doesRequiredJobsExist fun(self: REC_Utils.Server.Modules.Framework, requiredJobs: table<string, REC_Utils.Server.Modules.Framework.DoesRequiredJobsExist.Args.Job>, needed: integer): boolean
---@field setOnPlayerLoaded fun(self: REC_Utils.Server.Modules.Framework, onPlayerLoaded: fun(playerId: integer, ) )
---@field setOnPlayerUnLoaded fun(self: REC_Utils.Server.Modules.Framework, onPlayerUnLoaded: fun(playerId: integer, ) )
---@field setOnMoneyChange fun(self: REC_Utils.Server.Modules.Framework, onMoneyChange: REC_Utils.Server.Modules.Framework.OnMoneyChange )
---@field characterSchema fun(self: REC_Utils.Server.Modules.Framework): REC_Utils.Server.Modules.Framework.CharacterSchema|nil
---@field vehicleSchema fun(self: REC_Utils.Server.Modules.Framework): REC_Utils.Server.Modules.Framework.VehicleSchema|nil

---@class REC_Utils.Server.Modules.Framework.GetPlayers.Return
---@field PlayerData REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData
---@

---@class REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData
---@field source integer
---@field citizenId string
---@field charinfo REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData.CharInfo
---@field job REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData.Job

---@class REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData.CharInfo
---@field firstname string
---@field lastname string

---@class REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData.Job
---@field name string
---@field label string
---@field grade REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData.Job.Grade
---@field onduty boolean

---@class REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData.Job.Grade
---@field level integer
---@

---@class REC_Utils.Server.Modules.Framework.GetJobs.Return
---@field label string
---@field type? string
---@

---[[
---     Currency kinds normalized across frameworks
---     getMoneys only returns the kinds the framework actually holds, so read with `or 0`
---]]
---@alias REC_Utils.Server.Modules.Framework.MoneyTypes "cash" | "bank" | "black_money" | "crypto"

---[[
---     One money movement, normalized across frameworks
---     amount is always positive, the direction is carried by isRemove.
---     reason is whatever the calling resource passed, so it doubles as the
---     faucet / sink label an economy tracker groups by.
---]]
---@class REC_Utils.Server.Modules.Framework.MoneyChange
---@field source integer
---@field moneyType REC_Utils.Server.Modules.Framework.MoneyTypes
---@field amount integer
---@field isRemove boolean
---@field reason string

---@alias REC_Utils.Server.Modules.Framework.OnMoneyChange fun(change: REC_Utils.Server.Modules.Framework.MoneyChange)

---@class REC_Utils.Server.Modules.Inventory
---@field items fun(self: REC_Utils.Server.Modules.Inventory, name?: string): REC_Utils.Server.Modules.Inventory.Items.Return|nil
---@field getInventory fun(self: REC_Utils.Server.Modules.Inventory, inv: integer|string, ): REC_Utils.Server.Modules.Inventory.GetInventory.Return|false
---@field openInventory fun(self: REC_Utils.Server.Modules.Inventory, playerId: integer, inv: integer|string, ): boolean
---@field openPlayerInventory fun(self: REC_Utils.Server.Modules.Inventory, playerId: integer, targetId: integer, ): boolean opens targetId's player inventory on playerId's screen, bypassing the inventory's own police / steal gate
---@field getItem fun(self: REC_Utils.Server.Modules.Inventory, inv: integer|string, item: string|string[], metaData?: string|table, ): REC_Utils.Server.Modules.Inventory.GetItem.Return|REC_Utils.Server.Modules.Inventory.GetItem.Return[]
---@field getItemCount fun(self: REC_Utils.Server.Modules.Inventory, playerId: integer, item: string, ):integer
---@field addItem fun(self: REC_Utils.Server.Modules.Inventory, inv: integer|string, item: string|string[], amount: integer, metaData?: string|table, slot?: integer, cb?: fun(success: boolean, response?: string) ): boolean, string?
---@field removeItem fun(self: REC_Utils.Server.Modules.Inventory, inv: integer|string|table, item: string, amount: integer, metaData?: string|table, slot?: integer, ): boolean, string?
---@field canCarryItem fun(self: REC_Utils.Server.Modules.Inventory, inv: integer|string|table, item: REC_Utils.Server.Modules.Inventory.CanCarryItem.Args.Item|REC_Utils.Server.Modules.Inventory.CanCarryItem.Args.Item[], ): boolean
---@field registerStash fun(self: REC_Utils.Server.Modules.Inventory, id: integer|string, label: string, slots: integer, maxWeight: integer, owner?: string|boolean, groups?: { [string]: integer, }[], coords?: vector3|vector3[] ): boolean
---@field createTemporaryStash fun(self: REC_Utils.Server.Modules.Inventory, properties: REC_Utils.Server.Modules.Inventory.CreateTemporaryStash.Args.Properties, ): string
---@field clearInventory fun(self: REC_Utils.Server.Modules.Inventory, id: integer|string, keep?: string|string[] )
---@field stashSchema fun(self: REC_Utils.Server.Modules.Inventory): REC_Utils.Server.Modules.Inventory.StashSchema|nil
---@field imageSource fun(self: REC_Utils.Server.Modules.Inventory): REC_Utils.Server.Modules.Inventory.ImageSource|nil
---@field itemImages fun(self: REC_Utils.Server.Modules.Inventory): table<string, string>

---@class REC_Utils.Server.Modules.Inventory.ImageSource
---@field resource string
---@field dir string

---@class REC_Utils.Server.Modules.Framework.CharacterSchema
---@field table string
---@field citizenIdColumn string
---@field inventoryColumn? string nil when the inventory resource owns the storage
---@field moneyColumn? string JSON column holding the balances, nil when the framework keeps none
---@field moneyKeys? table<string, REC_Utils.Server.Modules.Framework.MoneyTypes> key inside moneyColumn = money kind
---@field lastLoginColumn? string nil counts every row
---@field nameColumns? string[] plain columns joined with a space
---@field nameJsonColumn? string one JSON column...
---@field nameJsonKeys? string[] ...and the keys to read out of it

---@class REC_Utils.Server.Modules.Framework.VehicleSchema
---@field table string
---@field citizenIdColumn string
---@field itemColumns string[] columns holding a JSON item array

---@class REC_Utils.Server.Modules.Inventory.StashSchema
---@field table string
---@field nameColumn string
---@field ownerColumn string
---@field dataColumn string
---@field updatedColumn? string

---@class REC_Utils.Server.Modules.Inventory.Items.Return
---@field name string
---@field label string
---@field weight number
---@field stack boolean

---@class REC_Utils.Server.Modules.Inventory.GetInventory.Return
---@field id string
---@field label string
---@field type string
---@field slots integer
---@field weight integer
---@field maxWeight number
---@field owner boolean
---@

---@class REC_Utils.Server.Modules.Inventory.GetItem.Return
---@field name string
---@field count integer
---@field weight number
---@field stack boolean

---@class REC_Utils.Server.Modules.Inventory.CanCarryItem.Args.Item
---@field name string
---@field amount integer

---@class REC_Utils.Server.Modules.Inventory.CreateTemporaryStash.Args.Properties
---@field label string
---@field slots integer
---@field maxWeight integer
---@field owner? integer|string|boolean
---@field groups? table<string, integer>
---@field coords? vector3
---@field items? { [number]: string, [number]: number, [number]?: table }[]

---@class REC_Utils.Server.Modules.Bank
---@field getAccount fun(self: REC_Utils.Server.Modules.Bank, society: string, ): REC_Utils.Server.Modules.Bank.GetAccount.Return

---@class REC_Utils.Server.Modules.Bank.GetAccount.Return
---@field money number

---@class REC_Utils.Server.Modules.Medical
---@field revive fun(self: REC_Utils.Server.Modules.Medical, playerId: integer, ): boolean
---@field kill fun(self: REC_Utils.Server.Modules.Medical, playerId: integer, ): boolean
---@field isLastStand fun(self: REC_Utils.Server.Modules.Medical, playerId: integer, ): boolean # first stage of the downed state, false on adapters without one
---@field isDead fun(self: REC_Utils.Server.Modules.Medical, playerId: integer, ): boolean

---@class REC_Utils.Server.Modules.Door
---@field getDoor fun(self: REC_Utils.Server.Modules.Door, doorId: integer, ): table
---@field getDoorFromName fun(self: REC_Utils.Server.Modules.Door, name: string, ): table
---@field getAllDoors fun(self: REC_Utils.Server.Modules.Door, ): table<integer, REC_Utils.Server.Modules.Door.GetAllDoors.Return>
---@field setDoorState fun(self: REC_Utils.Server.Modules.Door, doorId: integer, state: integer, ): boolean

---@class REC_Utils.Server.Modules.Door.GetAllDoors.Return
---@field id integer
---@field name string
---@field state integer
---@

---@class REC_Utils.Server.Modules.VehicleKeys
---@field hasKey fun(self: REC_Utils.Server.Modules.VehicleKeys, playerId: integer, vehicle: integer, ): boolean
---@field giveKey fun(self: REC_Utils.Server.Modules.VehicleKeys, playerId: integer, vehicle: integer, skipNotify?: boolean, ): boolean
---@field removeKey fun(self: REC_Utils.Server.Modules.VehicleKeys, playerId: integer, vehicle: integer, skipNotify?: boolean, ): boolean

---@class REC_Utils.Server.Modules.Dispatch
---@field call fun(self: REC_Utils.Server.Modules.Dispatch, config: REC_Utils.Server.modules.Dispatch.ConfigBuilder, ): boolean

---@class REC_Utils.Server.Modules.Notify
---@field trigger fun(self: REC_Utils.Server.Modules.Notify, playerId: integer, notifyType: "success" | "info" | "warning" | "error", titile: string, msg: string, duration?: integer, playSound: boolean, ): boolean

---@class REC_Utils.Server.Modules.Clothing
---@field giveClothing fun(self: REC_Utils.Server.Modules.Clothing, playerId: integer, fullCustomization?: boolean, ): boolean opens the clothing menu on the target player (tailor / dresser use case)
---@field saveOutfit fun(self: REC_Utils.Server.Modules.Clothing, citizenId: string, name: string, clothingData: table, ): boolean
---@field loadOutfit fun(self: REC_Utils.Server.Modules.Clothing, citizenId: string, name: string, ): table|nil
---@field getOutfits fun(self: REC_Utils.Server.Modules.Clothing, citizenId: string, ): string[]
---@field deleteOutfit fun(self: REC_Utils.Server.Modules.Clothing, citizenId: string, name: string, ): boolean

---@class REC_Utils.Server.Modules.Garage
---@field getGarages fun(self: REC_Utils.Server.Modules.Garage, ): table<string, REC_Utils.Server.Modules.Garage.GarageInfo> keyed by garage name
---@field getVehicles fun(self: REC_Utils.Server.Modules.Garage, citizenId: string, filter?: REC_Utils.Server.Modules.Garage.Filter, ): REC_Utils.Server.Modules.Garage.Vehicle[]
---@field getVehicle fun(self: REC_Utils.Server.Modules.Garage, id: string|integer, ): REC_Utils.Server.Modules.Garage.Vehicle|nil
---@field getVehicleByPlate fun(self: REC_Utils.Server.Modules.Garage, plate: string, ): REC_Utils.Server.Modules.Garage.Vehicle|nil
---@field isOwner fun(self: REC_Utils.Server.Modules.Garage, citizenId: string, plate: string, ): boolean
---@field addVehicle fun(self: REC_Utils.Server.Modules.Garage, citizenId: string, model: string, opts?: REC_Utils.Server.Modules.Garage.AddVehicle.Opts, ): string|integer|nil registers a vehicle into the player's stock without a live entity, returns its id
---@field removeVehicle fun(self: REC_Utils.Server.Modules.Garage, id: string|integer, ): boolean
---@field setOwner fun(self: REC_Utils.Server.Modules.Garage, id: string|integer, citizenId: string, ): boolean
---@field storeVehicle fun(self: REC_Utils.Server.Modules.Garage, playerId: integer, vehicle: integer, garage: string, opts?: REC_Utils.Server.Modules.Garage.StoreVehicle.Opts, ): boolean parks a live vehicle into garage on behalf of playerId and deletes the entity
---@field impoundVehicle fun(self: REC_Utils.Server.Modules.Garage, vehicle: integer, opts?: REC_Utils.Server.Modules.Garage.ImpoundVehicle.Opts, ): boolean moves a live vehicle into the impound lot and deletes the entity

---@class REC_Utils.Server.Modules.Garage.GarageInfo
---@field key string
---@field label string
---@field type "personal" | "shared" | "impound"
---@field coords vector3|nil

---@class REC_Utils.Server.Modules.Garage.Vehicle
---@field id string|integer rec: uid, qb / qbx: player_vehicles.id
---@field citizenId string|nil
---@field model string model name
---@field plate string
---@field garage string|nil
---@field state REC_Utils.Shared.Enum.GarageVehicleStates
---@field properties table|nil ox_lib vehicle properties

---@class REC_Utils.Server.Modules.Garage.Filter
---@field garage? string
---@field states? REC_Utils.Shared.Enum.GarageVehicleStates[]

---@class REC_Utils.Server.Modules.Garage.AddVehicle.Opts
---@field plate? string defaults to a generated plate
---@field garage? string defaults to the adapter's first personal garage (rec) or no garage (qb / qbx)
---@field properties? table ox_lib vehicle properties
---@field vehType? string rec only, defaults to "automobile"
---@field label? string rec only, shown in the menu instead of the model name

---@class REC_Utils.Server.Modules.Garage.StoreVehicle.Opts
---@field model? string required by rec, the server cannot reverse an entity's model hash back into a name
---@field properties? table ox_lib vehicle properties captured client side before the call
---@field vehType? string rec only, defaults to "automobile"

---@class REC_Utils.Server.Modules.Garage.ImpoundVehicle.Opts
---@field model? string required by rec
---@field garage? string defaults to the adapter's first impound garage (rec) or keeps the current garage (qb / qbx)
---@field reason? string
---@field fee? integer
---@field ownerCitizenId? string rec only, who may release it
---@field properties? table ox_lib vehicle properties captured client side before the call

---[[
---     Locales
---]]

---@class REC_Utils.Locales
---@
