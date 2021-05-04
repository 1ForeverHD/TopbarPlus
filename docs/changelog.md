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