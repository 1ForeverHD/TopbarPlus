--!strict

-- GoodEvent Types

--- Connection

type ConnectionImpl<Variant... = ...any> = {
	__index: ConnectionImpl<Variant...>,

	new: (signal: Signal<Variant...>, fn: (Variant...) -> ()) -> Connection<Variant...>,

	Disconnect: (self: Connection<Variant...>) -> (),
}

type ConnectionProto<Variant... = ...any> = {
	_connected: boolean,
	_signal: Signal<Variant...>,
	_fn: (Variant...) -> (),
	_next: false | Connection<Variant...>,
}

export type Connection<Variant... = ...any> = typeof(setmetatable(
	{} :: ConnectionProto<Variant...>,
	{} :: ConnectionImpl<Variant...>
	))

--- Signal

type SignalImpl<Variant... = ...any> = {
	__index: SignalImpl<Variant...>,

	-- TODO: Implement below when luau supports this kind of recursive type
	-- TODO: <T...>() -> Signal<T...>
	new: () -> Signal<Variant...>,

	Connect: (self: Signal<Variant...>, func: (Variant...) -> ()) -> Connection<Variant...>,
	DisconnectAll: (self: Signal<Variant...>) -> (),

	Fire: (self: Signal<Variant...>, Variant...) -> (),
	Wait: (self: Signal<Variant...>) -> Variant...,
	Once: (self: Signal<Variant...>, func: (Variant...) -> ()) -> Connection<Variant...>,
}

type SignalProto<Variant... = ...any> = {
	_handlerListHead: false | Connection<Variant...>,
}

export type Signal<Variant... = ...any> = typeof(setmetatable(
	{} :: SignalProto<Variant...>,
	{} :: SignalImpl<Variant...>
	))

----------------------

export type IconState = "Deselected" | "Selected" | "Viewing"
export type Events = "selected" | "deselected" | "toggled" | "viewingStarted" | "viewingEnded" | "notified"
export type Alignment = "Left" | "Center" | "Right"
export type EventSource = "User" | "OneClick" | "AutoDeselect" | "HideParentFeature" | "Overflow"
export type Modification = { any }

export type Icon = {
	-- STATIC FUNCTIONS
	getIcons: () -> { Icon },
	getIcon: (nameOrUID: string) -> (),
	setTopbarEnabled: (enabled: boolean) -> (),
	modifyBaseTheme: (modifications: { Modification }) -> (),
	setDisplayOrder: (order: number) -> (),

    -- CLASS PROPERTIES
	name: string,
	isSelected: boolean,
	enabled: boolean,
	totalNotices: number,
	locked: boolean,

	-- CLASS EVENTS
	selected: Signal<EventSource>,
	deselected: Signal<EventSource>,
	toggled: Signal<boolean, EventSource>,
	viewingStarted: Signal,
	viewingEnded: Signal,
	notified: Signal,

	-- CLASS FUNCTIONS
	setName: (self: Icon, name: string) -> Icon,
	getInstance: (self: Icon, instanceName: string) -> Instance?,
	modifyTheme: (self: Icon, modifications: { Modification }) -> Icon,
	modifyChildTheme: (self: Icon, modifications: { Modification }) -> Icon,
	setEnabled: (self: Icon, enabled: boolean) -> Icon,
	select: (self: Icon) -> Icon,
	deselect: (self: Icon) -> Icon,
	notify: (self: Icon, clearNoticeEvent: Signal) -> Icon,
	clearNotices: (self: Icon) -> Icon,
	disableOverlay: (self: Icon, disabled: boolean) -> Icon,
	setImage: (self: Icon, imageId: string | number, iconState: IconState?) -> Icon,
	setLabel: (self: Icon, text: string, iconState: IconState?) -> Icon,
	setOrder: (self: Icon, order: number, iconState: IconState?) -> Icon,
	setCornerRadius: (self: Icon, udim: UDim2, iconState: IconState?) -> Icon,
	align: (self: Icon, alignment: Alignment?) -> Icon,
	setWidth: (self: Icon, minimumSize: number, iconState: IconState?) -> Icon,
	setImageScale: (self: Icon, scale: number, iconState: IconState?) -> Icon,
	setImageRatio: (self: Icon, ratio: number, iconState: IconState?) -> Icon,
	setTextSize: (self: Icon, textSize: number, iconState: IconState?) -> Icon,
	setTextFont: (self: Icon, font: string, fontWeight: Enum.FontWeight?, fontStyle: Enum.FontSize?, iconState: IconState?) -> Icon,
	bindToggleItem: (self: Icon, guiObjectOrLayerCollector: GuiObject | LayerCollector) -> Icon,
	unbindToggleItem: (self: Icon, guiObjectOrLayerCollector: GuiObject | LayerCollector) -> Icon,
	bindEvent: (self: Icon, event: Events, callback: (...any) -> ()) -> Icon,
	unbindEvent: (self: Icon, event: Events) -> Icon,
	bindToggleKey: (self: Icon, keycode: Enum.KeyCode) -> Icon,
	unbindToggleKey: (self: Icon, keycode: Enum.KeyCode) -> Icon,
	call: (self: Icon, func: (self: Icon) -> (...any)) -> Icon,
	addToJanitor: (self: Icon, userdata: unknown) -> Icon,
	lock: (self: Icon) -> Icon,
	unlock: (self: Icon) -> Icon,
	debounce: (self: Icon, seconds: number) -> Icon,
	autoDeselect: (self: Icon, enabled: boolean?) -> Icon,
	oneClick: (self: Icon, enabled: boolean?) -> Icon,
	setCaption: (self: Icon, text: string?) -> Icon,
	setCaptionHint: (self: Icon, keyCode: Enum.KeyCode) -> Icon,
	setDropdown: (self: Icon, icons: { Icon }) -> Icon,
	joinDropdown: (self: Icon, parent: Icon) -> Icon,
	setMenu: (self: Icon, icons: { Icon }) -> Icon,
	joinMeny: (self: Icon, icons: { Icon }) -> Icon,
	leave: (self: Icon) -> Icon,
	destroy: (self: Icon) -> Icon,
}

export type StaticIcon = {
	new: () -> Icon,

	getIcons: () -> { Icon },
	getIcon: (nameOrUID: string) -> (),
	setTopbarEnabled: (enabled: boolean) -> (),
	modifyBaseTheme: (modifications: { Modification }) -> (),
	setDisplayOrder: (order: number) -> ()
}

return {}