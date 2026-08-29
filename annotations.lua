---@meta

---@class REC_Utils.Client.Modules.Framework
---@
---@field setOnPlayerLoaded fun(self: REC_Utils.Client.Modules.Framework, onPlayerLoaded: fun() )
---@field setOnPlayerUnLoaded fun(self: REC_Utils.Client.Modules.Framework, onPlayerUnLoaded: fun() )

---@class REC_Utils.Client.Modules.Inventory
---@field items fun(self: REC_Utils.Client.Modules.Inventory, name?: string): REC_Utils.Client.Modules.Inventory.Items.Return|nil
---@field getItemCount fun(self: REC_Utils.Client.Modules.Inventory, item: string, ): integer

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
---@field hasJob fun(self: REC_Utils.Server.Modules.Framework, playerId: integer, job: string|string[], grades?: table<integer, true>, onDutyOnly: boolean, ): boolean
---@field getJobs fun(self: REC_Utils.Server.Modules.Framework): table<string, REC_Utils.Server.Modules.Framework.GetJobs.Return>
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

---[[
---     Locales
---]]

---@class REC_Utils.Locales
---@
