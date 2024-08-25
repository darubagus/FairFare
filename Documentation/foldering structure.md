
# FairFare Feature-Based Folder Structure

```
FairFare/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── FairFareApp.swift
├── Common/
│   ├── Extensions/
│   ├── Utilities/
│   └── UIComponents/
├── Core/
│   ├── Models/
│   ├── Services/
│   │   ├── NetworkService.swift
│   │   └── StorageService.swift
│   └── Protocols/
├── Features/
│   ├── Authentication/
│   │   ├── RIBs/
│   │   │   ├── Login/
│   │   │   └── Registration/
│   │   ├── Models/
│   │   └── Services/
│   ├── BillSplitting/
│   │   ├── RIBs/
│   │   │   ├── BillCreation/
│   │   │   ├── BillSplitCalculator/
│   │   │   └── BillHistory/
│   │   ├── Models/
│   │   └── Services/
│   ├── GroupManagement/
│   │   ├── RIBs/
│   │   │   ├── GroupCreation/
│   │   │   ├── GroupList/
│   │   │   └── GroupDetail/
│   │   ├── Models/
│   │   └── Services/
│   └── DebtTracking/
│       ├── RIBs/
│       │   ├── DebtOverview/
│       │   └── DebtSettlement/
│       ├── Models/
│       └── Services/
├── Resources/
│   ├── Assets.xcassets/
│   └── Localizable.strings
└── SupportingFiles/
    └── Info.plist
```

## Explanation:

1. **App/**: Contains app-level files for initialization.

2. **Common/**: Shared utilities, extensions, and UI components used across features.

3. **Core/**: Core models, services, and protocols used throughout the app.

4. **Features/**: Main feature modules, each containing its own RIBs, models, and services.
   - Each feature (Authentication, BillSplitting, etc.) has its own folder.
   - Within each feature, RIBs are organized into subfolders.
   - Feature-specific models and services are kept within the feature folder.

5. **Resources/**: App-wide resources like assets and localization files.

6. **SupportingFiles/**: Configuration files like Info.plist.

This structure allows each feature to be self-contained, making it easier to work on individual features or even extract them into separate modules if needed in the future.
