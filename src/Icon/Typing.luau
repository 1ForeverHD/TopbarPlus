-- TYPINGS

------------ Janitor -----------

export type Janitor = {
	ClassName: "Janitor",
	CurrentlyCleaning: boolean,
	SuppressInstanceReDestroy: boolean,

	new: () -> Janitor,

	--------------------------------------

	Is: (obj: unknown) -> boolean,

	Add: <T>(self: Janitor, Object: T, MethodName: (boolean | string)?, Index: any?) -> T,
	AddPromise: <T>(self: Janitor, PromiseObject: T) -> T,
	AddObject: <T>(self: Janitor, Object: T) -> T,

	Give: <T>(self: Janitor, Object: T, MethodName: (boolean | string)?, Index: any?) -> T,
	GivePromise: <T>(self: Janitor, PromiseObject: T) -> T,
	GiveObject: <T>(self: Janitor, Object: T) -> T,

	Remove: (self: Janitor, Index: any) -> Janitor,
	Get: (self: Janitor, Index: any) -> { [any]: any },

	Clean: (self: Janitor) -> (),
	Cleanup: (self: Janitor) -> (),
	Destroy: (self: Janitor) -> (),

	LinkToInstance: (self: Janitor, Object: Instance, AllowMultiple: boolean?) -> RBXScriptConnection,
	LinkToInstances: (self: Janitor, ...Instance) -> Janitor,

	-------------------------------------

	is: (obj: unknown) -> boolean,

	add: <T>(self: Janitor, Object: T, MethodName: (boolean | string)?, Index: any?) -> T,
	addPromise: <T>(self: Janitor, PromiseObject: T) -> T,
	addObject: <T>(self: Janitor, Object: T) -> T,

	give: <T>(self: Janitor, Object: T, MethodName: (boolean | string)?, Index: any?) -> T,
	givePromise: <T>(self: Janitor, PromiseObject: T) -> T,
	giveObject: <T>(self: Janitor, Object: T) -> T,

	remove: (self: Janitor, Index: any) -> Janitor,
	get: (self: Janitor, Index: any) -> any,

	clean: (self: Janitor) -> (),
	cleanup: (self: Janitor) -> (),
	destroy: (self: Janitor) -> (),

	linkToInstance: (self: Janitor, Object: Instance, AllowMultiple: boolean?) -> RBXScriptConnection,
	linkToInstances: (self: Janitor, ...Instance) -> Janitor,
}

------ Strict Good Signal ------

-- Not that accurate, but works for now.

export type StrictGoodSignalConnection<Variant... = ...any> = {
	new: (signal: StrictGoodSignal<Variant...>, fn: (Variant...) -> ()) -> StrictGoodSignalConnection<Variant...>,

	_connected: boolean,
	_signal: StrictGoodSignal<Variant...>,
	_fn: (Variant...) -> (),
	_next: boolean,

	Disconnect: (self: StrictGoodSignalConnection<Variant...>) -> (),
	Destroy: (self: StrictGoodSignalConnection<Variant...>) -> (),
}

export type StrictGoodSignal<Variant... = ...any> = {
	new: () -> StrictGoodSignal<Variant...>,

	Connect: (StrictGoodSignal<Variant...>, func: (Variant...) -> ()) -> StrictGoodSignalConnection<Variant...>,
	DisconnectAll: (StrictGoodSignal<Variant...>) -> (),
	Destroy: (StrictGoodSignal<Variant...>) -> (),

	Fire: (StrictGoodSignal<Variant...>, Variant...) -> (),
	Wait: (StrictGoodSignal<Variant...>) -> Variant...,
	Once: (StrictGoodSignal<Variant...>, func: (Variant...) -> ()) -> StrictGoodSignalConnection<Variant...>,
}

------------- ICON -------------

export type ThemeData = { any }
export type Theme = { ThemeData }

export type IconDictionary = { [string]: Icon }
export type StateName = "Deselected" | "Selected" | "Viewing"
export type Alignment = "Mid" | "Centre" | "Left" | "Center" | "Right"

export type Container = {
	TopbarStandard: ScreenGui,
	TopbarCentered: ScreenGui,
	TopbarStandardClipped: ScreenGui,
	TopbarCenteredClipped: ScreenGui,
}

export type IconImpl = {
	__index: IconImpl,

	-- PUBLIC FUNCTIONS
	new: () -> Icon,

	getIcons: () -> IconDictionary,
	getIconByUID: (uid: string) -> Icon?,
	getIcon: (nameOrUid: string) -> Icon?,
	setTopbarEnabled: (enabled: boolean?, isInternal: boolean?) -> (),
	modifyBaseTheme: (modification: { { unknown } }) -> (),

	-- INSTANCE FUNCTIONS
	setName: (self: Icon, name: string) -> Icon,
	setState: (self: Icon, incomingStateName: StateName?, fromInput: Icon?) -> (),
	getInstance: (self: Icon, name: string) -> Instance,
	getCollective: (self: Icon, name: string) -> { Instance },
	getInstanceOrCollective: (self: Icon, collectiveOrInstanceName: string) -> { Instance },
	-- TODO: Type this
	getStateGroup: (self: Icon, iconState: StateName?) -> unknown,
	refreshAppearance: (self: Icon, instance: Instance, specificProperty: string?) -> Icon,
	refresh: (self: Icon) -> Icon,
	updateParent: (self: Icon) -> (),
	setBehaviour: (
		self: Icon,
		collectiveOrInstanceName: string,
		property: string,
		callback: () -> (),
		refreshAppearance: boolean?
	) -> (),
	modifyTheme: (self: Icon, modifications: ThemeData | { ThemeData }, modificationUID: string?) -> (Icon, string),
	modifyChildTheme: (self: Icon, modifications: ThemeData | { ThemeData }, modificationUID: string) -> (),
	removeModification: (self: Icon, modificationUID: string) -> Icon,
	removeModificationWith: (self: Icon, instanceName: string, property: unknown, state: StateName?) -> Icon,
	setTheme: (self: Icon, theme: Theme) -> Icon,
	setEnabled: (self: Icon, bool: boolean) -> Icon,
	select: (self: Icon, fromInput: Icon?) -> Icon,
	deselect: (self: Icon, fromInput: Icon?) -> Icon,
	notify: (self: Icon, customClearSignal: StrictGoodSignal?, noticeId: string?) -> Icon,
	clearNotices: (self: Icon) -> Icon,
	disableOverlay: (self: Icon, bool: boolean) -> Icon,
	setImage: (self: Icon, imageId: string, iconState: StateName?) -> Icon,
	setLabel: (self: Icon, text: string, iconState: StateName?) -> Icon,
	setOrder: (self: Icon, int: number, iconState: StateName?) -> Icon,
	setCornerRadius: (self: Icon, udim: UDim, iconState: StateName?) -> Icon,
	align: (self: Icon, leftCenterOrRight: Alignment?, isFromParentIcon: boolean?) -> Icon,
	setLeft: (self: Icon) -> Icon,
	setMid: (self: Icon) -> Icon,
	setRight: (self: Icon) -> Icon,
	setWidth: (self: Icon, offsetMinimum: number, iconState: unknown?) -> Icon,
	setImageScale: (self: Icon, number: number, iconState: StateName?) -> Icon,
	setImageRatio: (self: Icon, number: number, iconState: StateName?) -> Icon,
	setTextSize: (self: Icon, number: number, iconState: StateName?) -> Icon,
	setTextFont: (
		self: Icon,
		fontNameOrAssetId: string,
		fontWeight: Enum.FontWeight,
		fontStyle: Enum.FontStyle,
		iconState: StateName?
	) -> Icon,
	bindToggleItem: (self: Icon, guiObjectOrLayerCollector: GuiObject | LayerCollector) -> Icon,
	unbindToggleItem: (self: Instance, guiObjectOrLayerCollector: GuiObject | LayerCollector) -> Icon,
	_updateSelectionInstances: (self: Icon) -> (),
	_setToggleItemsVisible: (self: Icon, bool: boolean, fromInput: Icon?) -> (),
	bindEvent: (self: Icon, iconEventName: string, eventFunction: (...any) -> ()) -> Icon,
	unbindEvent: (self: Icon, iconEventName: string) -> Icon,
	bindToggleKey: (self: Icon, keyCodeEnum: Enum.KeyCode) -> Icon,
	unbindToggleKey: (self: Icon, keyCodeEnum: Enum.KeyCode) -> Icon,
	call: <T...>(self: Icon, callback: (Icon, T...) -> (), T...) -> Icon,
	addToJanitor: (self: Icon, callback: unknown) -> Icon,
	lock: (self: Icon) -> Icon,
	unlock: (self: Icon) -> Icon,
	debounce: (self: Icon, seconds: number) -> Icon,
	autoDeselect: (self: Icon, bool: boolean?) -> Icon,
	oneClick: (self: Icon, bool: boolean?) -> Icon,
	setCaption: (self: Icon, text: string?) -> Icon,
	leave: (self: Icon) -> Icon,
	joinMenu: (self: Icon, parentIcon: Icon) -> Icon,
	setMenu: (self: Icon, arrayOfIcons: { Icon }) -> Icon,
	setFrozenMenu: (self: Icon, arrayOfIcons: { Icon }) -> (),
	freezeMenu: (self: Icon) -> (),
	joinDropdown: (self: Icon, parentIcon: Icon) -> Icon,
	getDropdown: (self: Icon) -> Frame,
	setDropdown: (self: Icon, arrayOfIcons: { Icon }) -> (),
	clipOutside: (self: Icon, instance: GuiObject) -> (Icon, GuiObject),
	setIndicator: (self: Icon, keyCode: Enum.KeyCode) -> (),

	Destroy: (self: Icon) -> (),

	-- alias
	destroy: (self: Icon) -> (),
	setAlignment: (self: Icon, leftCenterOrRight: Alignment?, isFromParentIcon: boolean?) -> Icon,
	disableStateOverlay: (self: Icon, bool: boolean) -> Icon,
}

export type IconProto = {
	-- PUBLIC VARIABLES
	baseTheme: { { unknown } },
	isOldTopbar: boolean,
	iconsDictionary: IconDictionary,
	container: { [unknown]: ScreenGui },
	topbarEnabled: boolean,

	-- INSTANCE VARIABLES

	-- JANITORS
	janitor: Janitor,
	themesJanitor: Janitor,
	singleClickJanitor: Janitor,
	captionJanitor: Janitor,
	joinJanitor: Janitor,
	menuJanitor: Janitor,
	dropdownJanitor: Janitor,

	-- SIGNALS
	-- TODO: Proofread these signals
	selected: StrictGoodSignal<boolean, boolean?>,
	deselected: StrictGoodSignal<boolean, boolean?>,
	toggled: StrictGoodSignal<boolean, boolean?>,
	viewingStarted: StrictGoodSignal<boolean>,
	viewingEnded: StrictGoodSignal<boolean>,
	stateChanged: StrictGoodSignal<StateName, boolean?>,
	notified: StrictGoodSignal<string>,
	noticeStarted: StrictGoodSignal<StrictGoodSignal?, string?>,
	noticeChanged: StrictGoodSignal<number>,
	endNotices: StrictGoodSignal,
	dropdownOpened: StrictGoodSignal,
	dropdownClosed: StrictGoodSignal,
	menuOpened: StrictGoodSignal,
	menuClosed: StrictGoodSignal,
	toggleKeyAdded: StrictGoodSignal<Enum.KeyCode>,
	alignmentChanged: StrictGoodSignal<Alignment>,
	updateSize: StrictGoodSignal,
	resizingComplete: StrictGoodSignal,
	joinedParent: StrictGoodSignal<Icon>,
	menuSet: StrictGoodSignal<{ Icon }>,
	dropdownSet: StrictGoodSignal<{ Icon }>,
	updateMenu: StrictGoodSignal,
	startMenuUpdate: StrictGoodSignal,
	childThemeModified: StrictGoodSignal,
	indicatorSet: StrictGoodSignal<Enum.KeyCode>,
	dropdownChildAdded: StrictGoodSignal<Icon>,
	menuChildAdded: StrictGoodSignal<Icon>,

	-- INSTANCE VARIABLES
	name: string,
	isDestroyed: boolean,
	locked: boolean,
	overlayDisabled: boolean,
	childModifications: Theme,
	childModificationsUID: string,

	screenGui: ScreenGui,
	alignmentHolder: ScreenGui,
	captionText: string?,
	dropdown: Icon?,
	indicator: Frame?,
	caption: Frame?,
	notice: Frame?,
	widget: Frame?,

	iconModule: ModuleScript,
	UID: string,
	isEnabled: boolean,
	isSelected: boolean,
	isViewing: boolean,
	joinedFrame: boolean,
	parentIconUID: boolean | string,
	deselectWhenOtherIconSelected: boolean,
	totalNotices: number,
	activeState: StateName,
	alignment: Alignment,
	originalAlignment: Alignment,
	appliedTheme: Theme,
	appearance: { [StateName]: unknown },
	cachedInstances: { [Instance]: boolean },
	cachedNamesToInstances: { [string]: Instance },
	cachedCollectives: { [string]: { Instance } },
	bindedToggleKeys: { [Enum.KeyCode]: boolean },
	customBehaviours: { [string]: () -> () },
	toggleItems: { [GuiObject | LayerCollector]: TextButton | ImageButton | boolean },
	bindedEvents: { [string]: StrictGoodSignalConnection },
	notices: { [string]: {
		completeSignal: StrictGoodSignal,
		clearNoticeEvent: StrictGoodSignal,
	} },
	-- TODO: Unsure avout this one
	menuIcons: { Icon },
	dropdownIcons: { Icon },
	childIconsDict: { [string]: Icon },
}

export type Icon = typeof(setmetatable({} :: IconProto, {} :: IconImpl))

return {}
