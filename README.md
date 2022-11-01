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
soar_quest: ^0.5.0
```

The depndencies section will look something like:

```yaml
dependencies:
  flutter:
    sdk: flutter
  soar_quest: ^0.5.0
  firebase_core:
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
