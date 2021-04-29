# XRocket
[![XRocket Frameworks](https://github.com/knn90/XRocket/actions/workflows/macOS.yml/badge.svg)](https://github.com/knn90/XRocket/actions/workflows/macOS.yml) [![CI-iOS](https://github.com/knn90/XRocket/actions/workflows/CI_iOS.yml/badge.svg)](https://github.com/knn90/XRocket/actions/workflows/CI_iOS.yml)

Connect to SpaceX API to get the data of the rocket launches of SpaceX.

## What I did:
  - Separate application into frameworks, so the `XRocket` framework can be re-used.
  - Build `XRocketiOS` follow MVP design pattern.
  - Apply pagination concept when loading launches.
  - Apply prefetching and diffable datasource
  - Support dynamic font size.
  - Support Darkmode.
  - Support multiple languages with localized string.
  - Snapshot testing.
  - Unit testing.
  - Github Action.
