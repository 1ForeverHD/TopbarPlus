## [2.0.0] - January 19 2021
### Added
- Non-player part checking! (see methods below)
- Infinite zone volume, zero change in performance - zones can now be as large as you like with no additional impact to performance assuming characters/parts entering the zone remain their normal size or relatively small
- Zones now support MeshParts and UnionOperations (however it's recommended to use simple parts where possible as the former require additional raycast checks)
- **Methods**
    - ``findLocalPlayer()``
    - ``findPlayer(player)``
    - ``findPart(basePart)``
    - ``getPlayers()``
    - ``getParts()``
    - ``setAccuracy(enumIdOrName)`` -- this enables you to customise the frequency of checks with enums 'Precise', 'High', 'Medium' and 'Low'
    - 'Destroy' alias of 'destroy'
- **Events**
    - ``localPlayerEntered``
    - ``localPlayerExited``
    - ``playerEntered``
    - ``playerExited``
    - ``partEntered``
    - ``partExited``

### Changed
- A players whole body is now considered as apposed to just their central position
- Region checking significantly optimised (e.g. the zones region now rest on the voxel grid)
- Zones now act as a 'collective' which has significantly improved and optimised player and localplayer detection
- Removed all original aliases and events, including ``:initLoop()`` which no longer has to be called (connections are detected and handled internally automatically)
- Replaced frustrating require() dependencies with static modules
- Made Icon the parent module and others as descendants
- Removed the ``additonalHeight`` constructor argument - this caused confusion and added additional complexities to support
- ``:getRandomPoint()`` now returns ``randomVector, touchingGroupParts`` instead of ``randomCFrame, hitPart, hitIntersection``

### Fixed
- Rotational and complex geometry detection
- ``getRandomPoints()`` inaccuracies
