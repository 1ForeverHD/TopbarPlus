--[[
MIT License

Copyright (c) 2024 xhayper

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

--!strict

local GoodSignal = require(script.Parent.Packages.GoodSignal)

------------ Janitor ------------

type Janitor = {
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

---------- UTILITY ----------

type Utility = {
	copyTable: <T>(t: T) -> T,
	generateUID: (length: number?) -> string,
	setVisible: (instance: GuiObject, bool: boolean, sourceUID: string) -> (),
	formatStateName: (incomingStateName: string) -> string,
	localPlayerRespawned: (callback: () -> ()) -> (),
	getClippedContainer: (screenGui: ScreenGui) -> Folder,
	clipOutside: (icon: Icon, instance: GuiObject) -> Frame,
	joinFeature: (
		originalIcon: Icon,
		parentIcon: Icon,
		iconsArray: { string },
		scrollingFrameOrFrame: ScrollingFrame | Frame
	) -> (),
}

---------- OVERFLOW ----------

type Overflow = {
	start: (incomingIcon: Icon) -> (),
	getAvailableIcons: (alignment: Alignment) -> { Icon },
	updateAvailableIcons: (alignment: Alignment) -> { Icon },
	updateBoundary: (alignment: Alignment) -> (),
}

----------- GAMEPAD -----------

type Gamepad = {
	start: (incomingIcon: Icon) -> (),
	getIconToHighlight: () -> Icon,
	registerButton: (buttonInstance: GuiObject) -> (),
}

------------- THEME -------------

type ThemeData = { any }
type Theme = { ThemeData }
type StateGroup = Theme

type Themes = {
	getThemeValue: (stateGroup: StateGroup, instanceName: string, property: string) -> unknown,
	getInstanceValue: (instance: Instance, property: string) -> unknown?,
	getRealInstance: (instance: Instance) -> Instance?,
	getClippedClone: (instance: Instance) -> Instance?,
	refresh: (icon: Icon, instance: Instance, specificProperty: string?) -> (),
	apply: (
		icon: Icon,
		collectiveOrInstanceNameOrInstance: Instance | string,
		property: string,
		value: unknown,
		forceApply: boolean?
	) -> (),
	getModifications: (modifications: ThemeData | { ThemeData }) -> { ThemeData },
	merge: (detail: ThemeData, modification: ThemeData, callback: ((ThemeData) -> ())?) -> boolean,
	modify: (icon: Icon, modifications: ThemeData | { ThemeData }, modificationsUID: string?) -> string?,
	remove: (icon: Icon, modificationsUID: string) -> (),
	removeWith: (icon: Icon, instanceName: string, property: string, state: StateName?) -> (),
	change: (icon: Icon) -> (),
	set: (icon: Icon, theme: Theme | ModuleScript) -> (),
	statesMatch: (state1: string, state2: string) -> boolean,
	rebuild: (icon: Icon) -> (),
}

------------- ICON -------------

type IconDictionary = { [string]: Icon }
-- Maybe... Empty can be here too?
type StateName = "Deselected" | "Selected" | "Viewing"
type Alignment = "Mid" | "Centre" | "Central" | "Left" | "Center" | "Right"

type Container = {
	TopbarStandard: ScreenGui,
	TopbarCentered: ScreenGui,
	TopbarStandardClipped: ScreenGui,
	TopbarCenteredClipped: ScreenGui,
}

type IconImpl = {
	__index: IconImpl,

	-- PUBLIC FUNCTIONS
	new: () -> Icon,

	getIcons: () -> IconDictionary,
	getIconByUID: (uid: string) -> Icon?,
	getIcon: (nameOrUid: string) -> Icon?,
	setTopbarEnabled: (enabled: boolean?, isInternal: boolean?) -> (),
	modifyBaseTheme: (modification: Theme) -> (),

	-- INSTANCE FUNCTIONS
	setName: (self: Icon, name: string) -> Icon,
	setState: (self: Icon, incomingStateName: StateName?, fromInput: Icon?) -> (),
	getInstance: (self: Icon, name: string) -> Instance,
	getCollective: (self: Icon, name: string) -> { Instance },
	getInstanceOrCollective: (self: Icon, collectiveOrInstanceName: string) -> { Instance },
	getStateGroup: (self: Icon, iconState: StateName?) -> StateGroup,
	refreshAppearance: (self: Icon, instance: Instance, specificProperty: string?) -> Icon,
	refresh: (self: Icon) -> Icon,
	updateParent: (self: Icon) -> (),
	setBehaviour: (
		self: Icon,
		collectiveOrInstanceName: string,
		property: string,
		callback: ((...any) -> any?)?,
		refreshAppearance: boolean?
	) -> (),
	modifyTheme: (self: Icon, modifications: ThemeData | { ThemeData }, modificationUID: string?) -> (Icon, string),
	modifyChildTheme: (self: Icon, modifications: ThemeData | { ThemeData }, modificationUID: string) -> (),
	removeModification: (self: Icon, modificationUID: string) -> Icon,
	removeModificationWith: (self: Icon, instanceName: string, property: string, state: StateName?) -> Icon,
	setTheme: (self: Icon, theme: Theme) -> Icon,
	setEnabled: (self: Icon, bool: boolean) -> Icon,
	select: (self: Icon, fromInput: Icon?) -> Icon,
	deselect: (self: Icon, fromInput: Icon?) -> Icon,
	notify: (self: Icon, customClearSignal: GoodSignal.Signal?, noticeId: string?) -> Icon,
	clearNotices: (self: Icon) -> Icon,
	disableOverlay: (self: Icon, bool: boolean) -> Icon,
	setImage: (self: Icon, imageId: string | number, iconState: StateName?) -> Icon,
	setLabel: (self: Icon, text: string, iconState: StateName?) -> Icon,
	setOrder: (self: Icon, int: number, iconState: StateName?) -> Icon,
	setCornerRadius: (self: Icon, udim: UDim, iconState: StateName?) -> Icon,
	align: (self: Icon, leftCenterOrRight: Alignment?, isFromParentIcon: boolean?) -> Icon,
	setLeft: (self: Icon) -> Icon,
	setMid: (self: Icon) -> Icon,
	setRight: (self: Icon) -> Icon,
	setWidth: (self: Icon, offsetMinimum: number, iconState: StateName?) -> Icon,
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
	unbindToggleItem: (self: Icon, guiObjectOrLayerCollector: GuiObject | LayerCollector) -> Icon,
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

type IconProto = {
	-- PUBLIC VARIABLES
	baseTheme: Theme,
	isOldTopbar: boolean,
	iconsDictionary: IconDictionary,
	container: Container,
	topbarEnabled: boolean,

	-- PUBLIC GAMEPAD VARIABLES
	highlightIcon: (Icon | boolean)?,
	lastHighlightedIcon: Icon?,
	highlightKey: Enum.KeyCode?,

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
	selected: GoodSignal.Signal<boolean? | Icon?>,
	deselected: GoodSignal.Signal<boolean? | Icon?>,
	toggled: GoodSignal.Signal<boolean, boolean? | Icon?>,
	viewingStarted: GoodSignal.Signal<boolean>,
	viewingEnded: GoodSignal.Signal<boolean>,
	stateChanged: GoodSignal.Signal<StateName, boolean? | Icon?>,
	notified: GoodSignal.Signal<string>,
	noticeStarted: GoodSignal.Signal<GoodSignal.Signal?, string?>,
	noticeChanged: GoodSignal.Signal<number>,
	endNotices: GoodSignal.Signal,
	dropdownOpened: GoodSignal.Signal,
	dropdownClosed: GoodSignal.Signal,
	menuOpened: GoodSignal.Signal,
	menuClosed: GoodSignal.Signal,
	toggleKeyAdded: GoodSignal.Signal<Enum.KeyCode>,
	alignmentChanged: GoodSignal.Signal<Alignment>,
	updateSize: GoodSignal.Signal,
	resizingComplete: GoodSignal.Signal,
	joinedParent: GoodSignal.Signal<Icon>,
	menuSet: GoodSignal.Signal<{ Icon }>,
	dropdownSet: GoodSignal.Signal<{ Icon }>,
	updateMenu: GoodSignal.Signal,
	startMenuUpdate: GoodSignal.Signal,
	childThemeModified: GoodSignal.Signal,
	indicatorSet: GoodSignal.Signal<Enum.KeyCode>,
	dropdownChildAdded: GoodSignal.Signal<Icon>,
	menuChildAdded: GoodSignal.Signal<Icon>,

	-- INSTANCE VARIABLES
	name: string,
	isDestroyed: boolean,
	locked: boolean,
	overlayDisabled: boolean,
	childModifications: Theme,
	childModificationsUID: string,

	screenGui: ScreenGui,
	alignmentHolder: ScrollingFrame,
	captionText: string?,
	dropdown: Icon?,
	indicator: Frame?,
	caption: CanvasGroup?,
	notice: Frame?,
	widget: Frame?,

	iconModule: ModuleScript,
	UID: string,
	isEnabled: boolean,
	isSelected: boolean,
	isViewing: boolean,
	joinedFrame: boolean | Frame | ScrollingFrame,
	parentIconUID: boolean | string,
	deselectWhenOtherIconSelected: boolean,
	totalNotices: number,
	activeState: StateName,
	alignment: Alignment,
	originalAlignment: Alignment,
	appliedTheme: Theme,
	appearance: { [StateName]: StateGroup },
	cachedInstances: { [Instance]: boolean },
	cachedNamesToInstances: { [string]: Instance },
	cachedCollectives: { [string]: { Instance } },
	bindedToggleKeys: { [Enum.KeyCode]: boolean },
	customBehaviours: { [string]: ((...any) -> any?)? },
	toggleItems: { [GuiObject | LayerCollector]: TextButton | ImageButton | boolean },
	bindedEvents: { [string]: GoodSignal.Connection },
	notices: { [string]: {
		completeSignal: GoodSignal.Signal,
		clearNoticeEvent: GoodSignal.Signal,
	} },

	joinOverflowTime: number?,
	creationTime: number,
	menuIcons: { string },
	dropdownIcons: { string },
	childIconsDict: { [string]: Icon | boolean },
}

export type Icon = typeof(setmetatable({} :: IconProto, {} :: IconImpl))

return {}