# Soar Quest

A framework to build applications faster. Built on Flutter and Firebase.

## Introduction

Soar Quest is designed to help you get straight to providing value to your users.
Therefore, it abstracts many concerns that one would traditionally have when it comes to developing applications.
Nevertheless, the developer still has full access to the full power of Flutter.

The framework provides the following set of functionality and components:

- Application builder. i.e., `SQApp`
- Authentication system, with profile screen and sign in screen
- Databases. Collections (Tables) and Docs (Items/Rows)
- Screens to display collections and docs
- Actions to perform on data
- User settings
- File storage system

The functionality is described briefly in the following sections.

## Installing

Add the following line to your dependencies in `pubspec.yaml`.

```yaml
soar_quest: ^0.6.0
```

The depndencies section will look something like:

```yaml
dependencies:
  flutter:
    sdk: flutter
  soar_quest: ^0.6.0
  firebase_core:
```

### Android Setup

To compile your app in Android, update your `minSdkVersion` to 19 (or higher), and enable `multiDex`.
You can find the settings in `android\app\build.gradle`.

```gradle
android {
  defaultConfig {
    minSdkVersion 19
    multiDexEnabled true
  }
}                                                              
```

## SQApp

The root of your application uses `SQApp`.

The framework uses many [Firebase](https://firebase.google.com/) components under the hood.
Therefore, `SQApp` has a parameter for the Firebase configuration of your project.
You can find out how to configure Firebase for your project using the `flutterfire configure` command from [here](https://firebase.google.com/docs/flutter/setup?platform=web#configure-firebase).

The following code can get you started with your first Soar Quest app.

```dart
import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import 'firebase_options.dart';

void main() async {
  await SQApp.init("My Cool App",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  SQApp.run([
    Screen("Hello World"),
    Screen("Second Screen"),
  ]);
}
```

## SQAuth

The authentication system requires the minimal configuration on your side.

Note: the authentication system only support Firebase Auth.
Therefore, Firebase should be configured.

If you add an empty drawer (side menu) to the app, a profile screen will automatically appear there.

```dart
SQApp.run([
    Screen("Hello World"),
    Screen("Second Screen"),
], drawer: SQDrawer([]));
```

Alternatively, if you would like to include the profile screen in the bottom navigation bar, use the `SQProfileScreen` screen.

```dart
SQApp.run([
    Screen("Hello World"),
    SQProfileScreen(),
]);
```

The profile screen handles all the authentication workflows.
If the user is not logged in, they will be prompted to sign in.

Other included features:

- Email verification
- Changing password (forgot passowrd)
- Editing username
- Profile fields (user data)

### User Data (Fields)

To include custom user data fields, populate the `userDocFields` parameter when creating the `SQApp`.

```dart
await SQApp.init("My Cool App",
      userDocFields: [SQStringField("Telegram Handle")],
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);
```

### User Settings

Local data used to configure the application. Example: dark mode vs light mode.
The Settings screen appears automatically in the drawer (if you include a drawer).

```dart
await UserSettings.setSettings([ SQBoolField("Enable feature X") ]);

SQApp.run([
  CollectionScreen(collection: testCollection),
], drawer: SQDrawer([]) );
```

## Data: Collections, Docs, and Fields

Compared to Google Sheets. Collections are sheets. Docs are rows. Fields are column cells.

Compared to SQL. Collections are Tables. Docs are rows (entries). Fields are data values.

Each collection has a set of fields describing the data the docs of the collection would have.

### SQCollection

There are several collections provided by SQ.
The difference if the location of storage.
The behave the same.

- `FirestoreCollection`
- `LocalCollection`
- `InMemoryCollection`

#### CollectionSlice

A way to filter some docs from a collection. TBC.

## DocCondition

### SQDoc

Each piece of information in your app is contained in a doc.
Docs have fields that contain values.

### Fields

Fields represent the data values (or types) that your docs could contain.
Soar Quest provides numerous fields. Some of them include:

- `SQStringField`. Text.
- `SQBoolField`. True/False. Yes/No.
- `SQIntField`. Integer numbers.
- `SQDoubleField`. Floating point (fractional) numbers.
- `SQRefField`. A value that points to another doc (in a collection).
- `SQInverseRefsField`. An automatically generated list of docs referring/pointing to this doc.
- `SQTimestampField`. Date (day/month/year).
- `SQTimeOfDayField`. Time of day (hour/minutes).
- `SQFileField`. Storing files.
- `SQImageField`. Storing images.

## Screens

Screens include by default the `AppBar` and bottom `NavBar`.

Screens could be extended and customized.

### DocScreen

<!-- Each document comes with a doc screen that displays -->

### Collection Screens

- `CollectionScreen`
- `GalleryScreen`
- `TableScreen`

### FormScreen

The `FormScreen` is the screen where you edit the data (fields) of an `SQDoc`.
You do not need to interact with the `FormScreen` directly.

## SQAction

Actions on data (docs).

- `GoScreenAction`
- `SetFieldsAction`
- `GoEditAction`
- `CreateDocAction`
- `DeleteDocAction`
- `OpenUrlAction`
- `CustomAction`

## File Storage

File storage is handled by Firebase Cloud Stroage.
You need to have Firebase set up to be able to upload files and images.

To use the storage capabilities, add the following fields to your collection's fields:

- `SQFileField`. For storing files.
- `SQImageField`. Fot Storing images.
