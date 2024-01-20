--------
## [2.9.1] - October 19th 2022
### Improved
- Improved the size adapting of captions and tips when their texts are changed via localization
- Improved the size adapting of icon labels, in particular for the selected state

### Fixed
- Fixed a bug preventing the icon cell resizing when deselected for icons with an image but only selected text



--------
## [2.9.0] - October 6th 2022
### Added
- Added ``icon:debounce(seconds)``. This is shorthand for ``icon:lock() task.wait(seconds) icon:unlock()``
- Added `` IconController.disableControllerOption(bool)``
- Added controller selection support

### Improved
- Improved the scrolling behaviour of menus and dropdowns (scrolling is no longer blocked by other scrolling items)
- Improved menu and dropdown selection when using a controller so that menu/dropdown icons are no longer skipped when the maxIconsBeforeScroll is less than the total icons within the feature
- Updated internals of localization support so that only the source language is scraped



--------
## [2.8.0] - September 29 2022
### Added
- Added Localization compatability. Icons will now update their properties (such as width) when new localized text is found or detected. This also accounts for switching languages live in-game. This resolves #38
- Added RichText compatability to Captions and Tips
- Added ``IconController.voiceChatEnabled`` (default ``false``) which now must be set to true by game developers if their experience uses VoiceChat This is also accompanied by a warning to inform developers of this. This resolves the issue outlined here: https://devforum.roblox.com/t/topbarplus-v277/1017485/681?u=foreverhd
- Added ``icon:autoDeselect(bool)`` as a shorthand alternative to ``:setProperty("deselectWhenOtherIconSelected", bool)``
- Added ``icon:call(func)`` as a more appropriate alternative to ``icon:give(object)``
- Added ``icon:setXSize(XOffset, iconState)``
- Added ``icon:setYSize(YOffset, iconState)``
- Added ``forcedIconSizeX`` and ``forcedIconSizeY`` theme settings
- Added ``icon.userSelected`` event
- Added ``icon.userDeselected`` event
- Added ``icon.userToggled`` event
- Added a variable for script and script.Parent to Icon and IconController. This resolves #47


### Improved
- Updated Contributing docs page to mention that you don't need to open issues for smaller contributions like single-line fixes
- Improved the internal behaviour of ``:setSize``
- Improved the behaviour of ``:lock`` so that the overlaps now disappear and so that ``:select`` and ``:deselect`` can still work (now only the user-input is disabled). This resolves #42

### Fixed
- Fixed an offset bug that occurred when CoreGuis PlayerList and Backpack were disabled (but not EmotesMenu) while R6. More details here: https://devforum.roblox.com/t/topbarplus-v277/1017485/684?u=foreverhd
- Fixed an error when setting the base ZIndex of an icon. More details here: https://devforum.roblox.com/t/topbarplus-v277/1017485/679?u=foreverhd
- Fixed a bug preventing dropdown icons from updating: This resolves #32 and https://devforum.roblox.com/t/topbarplus-v277/1017485/348?u=foreverhd
- Fixed a font-clipping issue by using ContentText instead and updating the icon whenever its font is changed. This resolves #60 and resolves #54
- Fixed a bug which caused the Playerlist to re-appear when toggling right-set dropdowns even if the Playerlist CoreGui was previously disabled. This resolves #57

## Removed
- Removed the documentation within Icon and IconController, and removed the module-docs.yml action. This was not as beneficial as first assumed.
- Removed ``forcedIconSize`` theme setting



--------
## [2.7.7] - September 26 2022
### Added
- Added basic compatability for VR devices. This includes different behaviour for when the Roblox menu is toggled. Credit to @cl1ents for help with this.

### Improved
- Improved RichText compatability so that icons now account for the ContentText instead of Text when determining width.
- Updated the third-party documents page which now explains that third-party applications no-longer need to do anything. TopbarPlus now handles multi-package logic internally.

### Fixed
- Fixed some third-party require logic within Icon and IconController. If more than one TopbarPlus package is required within an experience the first-required package will become the 'lead' package. No other package will run afterwards, only a reference to the lead package is returned. This prevents two-packages from running at once (such as when using HD Admin, SuperBiz Catalog, etc which also have their own TopbarPlus package).
- Fixed additional third-party require logic that would occur when the IconController was required before the Icon.



--------
## [2.7.6] - May 24 2022
### Added
- Checks to account for the new obtrusive 'Voice Chat Beta' icon.
- Mouse-click detection for controller mode hide/show toggle. Credit to @Lucke0051 for this.
  
### Fixed
- A bug with overflows caused by changing the Workspace.CurrentCamera. Credit to @Lucke0051 for this.



--------
## [2.7.5] - August 17 2021
### Improved
- The roblox hover cursor now appears when hovering over Icon buttons.



--------
## [2.7.4] - August 9 2021
### Fixed
- A bug with ResetOnRespawn where the :give() function would call right away *and* when destroyed for functions, which only triggered after two resets
- Items like captions and tips not being destroyed when active with ResetOnSpawn.

### Improved
- The fake healthbar behaviour, so that it appears now *only* when an icon is set to the right.
- Reduced the likelihood of two healthbars appearing simultaneously.



--------
## [2.7.3] - August 6 2021
### Added
- A dynamic healthbar to replace the static core healthbar which appears to the right of the screen when the localPlayer is damaged.
- ``IconController.disableHealthbar(bool)``

### Fixed
- The updating of menu and dropdown canvases when a icon is resized within them.



--------
## [2.7.2] - July 12 2021
### Fixed
- Flickering icon bug when an expanding hover effect triggered the overflow then immediately snapped back.



--------
## [2.7.1] - May 29 2021
### Added
- ``IconController.mimicCoreGui``, default is ``true``. Set to ``false`` to have the topbar persist even when ``game:GetService("StarterGui"):SetCore("TopbarEnabled", false)`` is called.
- ``IconController.setLeftOffset(number)``, defaults to 0.
- ``IconController.setRightOffset(number)``, defaults to 0.

### Fixed
- A bug which caused ``IconController.setGap`` to update incorrectly.



--------
## [2.6.1] - May 21 2021
### Added
- Compatibility for Deferred Events.

### Fixed
- The setting of captions and tips to ``nil``.



--------
## [2.5.2] - May 10 2021
### Fixed
- The clipping of some letters within the iconLabel.



--------
## [2.5.1] - May 7 2021
### Added
- ``Icon:convertLabelToNumberSpinner(numberSpinner)`` - see the API for [details and example usage](https://1foreverhd.github.io/TopbarPlus/api/icon/#convertlabeltonumberspinner).

### Improved
- Internals to support the new ``convertLabelToNumberSpinner`` method.



--------
## [2.4.1] - May 4 2021
### Added
- ``hovering`` icon state (see https://1foreverhd.github.io/TopbarPlus/ for more info), e.g. ``icon:setLabel("Nanoblox", "hovering")``
- ``repositionInfo`` action theme property
- ``Icon:give(userdata)``

### Changed
- ``toggleState`` to ``iconState`` for toggleable methods
- ``resizeTransitionInfo `` to ``resizeInfo``

### Improved
- The internal orgnisation and writing of captions and tips
- Playground examples
- The BlueGradient theme with bounces
- API and Introduction documentation

### Fixed
- A minor overflow appearance bug
- Appearance bugs with tips and captions



--------
## [2.3.3] - April 27 2021
### Added
- ``resizeTransitionInfo`` action theme property

### Fixed
- Error checking for ChatMain



--------
## [2.3.2] - April 24 2021
### Fixed
- A bug where the topbar was not always updated when an icon was constructed



--------
## [2.3.1] - March 16 2021
### Added
- ``icon.lockedSettings`` - this is used internally to prevent overflow properties being accidentally overwritten

### Fixed
- A critical bug with overflows that caused icons to disappear



--------
## [2.3.0] - February 14 2021
### Added
- ``icon:setProperty(propertName, value)`` - this will enable properties to be set within chained methods



--------
## [2.2.1] - February 13 2021
### Fixed
- An overlapping icon bug caused by yielding after requiring the Icon module



--------

## [2.2.0] - February 12 2021
### Added
- ``IconController.clearIconOnSpawn(icon)``

### Improved
- The cleanup process when ``icon:destroy()`` is called



--------

## [2.1.0] - February 2 2021
### Added
- ``icon:bindEvent(iconEventName, eventFunction)``
- ``icon:unbindEvent(iconEventName)``



--------

## [2.0.0] - January 19 2021
### Added
- Menus (dropdowns but horizontal and with scrolling support!)
- Dropdowns v2
- Labels v2
- Tips v2
- Captions v2
- Corners v2
- Chainable methods
- Automatic overflows when left-set or right-set icons exceed the boundary of the:
    - Viewport
    - Closest enabled opposite-aligned icon
    - Closest enabled center-aligned icon
- The ability to set changes for specific toggle states (instead of automatically both), e.g. ``icon:setLabel("Off", "deselected")`` and ``icon:setLabel("On", "selected")``
- Rich Text support
- ``Icon.mimic(coreIconToMimic)`` constructor to replace functions like ``IconController.createFakeChat``
- ``icon:Destroy()`` uppercase alias to assist developers who utilise PascalCase tools such as Maids
- Referencing support for third parties, see [Third Parties](https://1foreverhd.github.io/TopbarPlus/third_parties/)
- ``icon:set(settingName, value)``
- ``icon:get(settingName, value)``
- ``icon:clearNotices()``
- ``icon:setMenu(arrayOfIcons)``
- ``icon:bindToggleItem(guiObjectOrLayerCollector)``
- ``icon:unbindToggleItem(guiObjectOrLayerCollector)``
- ``icon:bindToggleKey(keyCodeEnum)``
- ``icon:unbindToggleKey(keyCodeEnum)``
- ``icon:lock()``
- ``icon:unlock()``
- ``icon:setTopPadding(offset, scale)``
- ``icon:setCornerRadius(scale, offset, toggleState)``
- ``icon:setImageYScale(yScale, toggleState)``
- ``icon:setImageRatio(ratio, toggleState)``
- ``icon:setSize(XOffset, YOffset, toggleState)``
- ``icon:join(parentIcon, featureName)``
- ``icon:leave()``
- ``icon.notified`` event
- ``icon.hoverStarted`` event
- ``icon.hoverEnded`` event
- ``icon.dropdownOpened`` event
- ``icon.dropdownClosed`` event
- ``icon.menuOpened`` event
- ``icon.menuClosed`` event
- ``IconController.setGap(offset, specificAlignment)``
- Many new properties

### Improved
- The internals and externals of themes to make then *significantly* easier to customise and apply
- Console support
- Mobile support (particularly for features like tips and captions)
- The behaviour of features like tips and captions
- Notices (now fully compatible with menus, dropdowns, etc)

### Changed
- ``Icon.new(name, imageId, order, label)`` to ``Icon.new()`` - this is to encourage users to utilise the equivalent methods instead which provide greater flexibility
- Frustrating require() dependencies to static modules
- Icon to be the parent module with others as descendants
- All IconController functions now use ``.`` instead of the incorrect ``:``
- Icon orders to be determined now by their construction sequence (instead of randomly), with the option to modify this with ``icon:setOrder``
- ``icon:setLabel(text)`` to ``icon:setLabel(text, toggleState)``
- ``icon:setImage(imageId)`` to ``icon:setImage(imageId, toggleState)``
- ``icon:setOrder(orderNumber)`` to ``icon:setOrder(orderNumber, toggleState)``
- ``icon:setLeft()`` to ``icon:setLeft(toggleState)``
- ``icon:setMid()`` to ``icon:setMid(toggleState)``
- ``icon:setRight()`` to ``icon:setRight(toggleState)``
- ``icon:setBaseZIndex(zindex)`` to ``icon:setBaseZIndex(zindex, toggleState)``
- ``icon.objects`` to ``icon.instances``
- The names of almost all instances to be more obvious and accurate

### Removed
- FakeChat support - internal changes to the Roblox Core API now make it impossible to accurately mimic their core chat icon
- ``icon:setToggleFunction``(use selected/deselected events instead)
- ``icon:setHoverFunction`` (use hoverStarted/Ended events instead)
- ``icon:createDropdown`` (replaced with ``icon:setDropdown``)
- ``icon:removeDropdown``
- ``icon:setImageSize`` (replaced with ``icon:setImageRatio`` and ``icon:setImageYScale``)
- ``icon:setCellSize`` (replaced with ``icon:setSize``)
- ``icon:setToggleMenu`` (replaced with ``icon:bindToggleItem``)
- ``icon:clearNotifications`` (replaced with ``icon:clearNotices``)
- ``icon:applyThemeToObject``
- ``icon:applyThemeToAllObjects``
- ``icon.endNotifications`` event
- ``IconController:getAllIcons`` (replaced with ``IconController.getIcons``)
- Some properties may have been removed too

### Fixed
- Console-mode rapid enabling and disabling bug
- Recursive update topbar bug