# Soar Quest

A framework to build [Telegram Mini Apps](https://core.telegram.org/bots/webapps) faster with [Flutter](https://flutter.dev/).

[![pub package](https://img.shields.io/pub/v/soar_quest.svg?&logo=Flutter&color=blue)](https://pub.dev/packages/soar_quest)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](/LICENSE)

![Soar Quest Logo](logo.png)

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

### Motivation

This project is driven by a belief that the current software engineering processes are too inefficient.
A guiding principle is that new code should be added only to provide new value to the app's user.
This would entail less code to create apps, less effort, and faster development.
Many design decisions here are inspired by No-code tools, due to the efficiency they provide for creators.

## Installing

Add the following line to your dependencies in `pubspec.yaml`.

```yaml
soar_quest: ^0.8.0
```

The depndencies section will look something like:

```yaml
dependencies:
  flutter:
    sdk: flutter
  soar_quest: ^0.8.0
```

### QR Code Scanning Setup

See instructions [here](https://pub.dev/packages/mobile_scanner/versions/3.0.0-beta.4#platform-specific-setup).

## SQApp

The root of your application uses `SQApp`.

The following code can get you started with your first Soar Quest app.

```dart
import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

void main() async {
  await SQApp.init("My Cool App");

  SQApp.run([
    Screen("Hello World"),
    Screen("Second Screen"),
  ]);
}
```

### Designing Mini Apps

Soar Quest automatically captures the user's custom [`ThemeParams`](https://core.telegram.org/bots/webapps#themeparams)
and adjusts the [Material Design 3](https://m3.material.io/) Theme.

### User Data (Fields)

To include custom user data fields, populate the `userDocFields` parameter when creating the `SQApp`.

```dart
await SQApp.init("My Cool App",
      userDocFields: [SQStringField("Telegram Handle")]);
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

- `LocalCollection`
- `InMemoryCollection`

#### CollectionSlice

`CollectionSlice` method to filter docs from a collection.
Treated by other components of SQ as an `SQCollection`.

```dart
CollectionSlice slice =
      CollectionSlice(testCollection, filter: ValueFilter("Status", "Done"));

SQApp.run([CollectionScreen(collection: slice)]);
```

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
The following piece of code shows how to create a custom screen.
Add your custom implementation inside the `screenBody` method.

```dart
class MyCustomScreen extends Screen {
  const MyCustomScreen(String title, {Key? key}) : super(title, key: key);

  @override
  State<MyCustomScreen> createState() => _MyCustomScreenState();
}

class _MyCustomScreenState extends ScreenState<MyCustomScreen> {
  @override
  Widget screenBody(BuildContext context) {
    // TODO: implement screenBody
    return super.screenBody(context);
  }
}
```

### Collection Screens

Prebuild screens that displays the docs of a collection.

- `CollectionScreen`. The default list of docs screen.
- `GalleryScreen`. A grid (2 per row) screen.
- `TableScreen`. Displays doc fields and values in table format.

```dart
SQApp.run(
  [
    CollectionScreen(collection: testCollection),
    GalleryScreen(collection: testCollection),
    TableScreen(collection: testCollection),
  ],
);
```

Use the following code to create a custom `CollectionScreen`.

```dart
class MyCustomCollectionScreen extends CollectionScreen {
  MyCustomCollectionScreen({super.title, required super.collection, super.key});

  @override
  State<MyCustomCollectionScreen> createState() => _MyCustomCollectionScreenState();
}

class _MyCustomCollectionScreenState extends CollectionScreenState<MyCustomCollectionScreen> {
  @override
  Widget screenBody(BuildContext context) {
    // TODO: implement screenBody for MyCustomCollectionScreen
    return super.screenBody(context);
  }
}
```

### DocScreen

A screen that displays the fields of a single document.

Use the following code to create a custom `DocScreen`.

```dart
class MyCustomDocScreen extends DocScreen {
  MyCustomDocScreen(super.doc,{super.key});

  @override
  State<MyCustomDocScreen> createState() => _MyCustomDocScreenState();
}

class _MyCustomDocScreenState extends DocScreenState<MyCustomDocScreen> {
  @override
  Widget screenBody(BuildContext context) {
    // TODO: implement screenBody for MyCustomDocScreen
    return super.screenBody(context);
  }
}
```

### FormScreen

The `FormScreen` is the screen where you edit the data (fields) of an `SQDoc`.
You would not need to interact with the `FormScreen` directly, unless you want to customize the form.

## SQAction

Actions on (or from) data (docs).
Actions are assigned when creating a `SQCollection`.

The following examples are the most common examples of actions provided by default:

- `SetFieldsAction`
- `GoScreenAction`
- `CreateDocAction`
- `OpenUrlAction`
- `CustomAction`

The following are a few examples of how to set actions for a collection.

```dart
late SQCollection simpleCollection;
simpleCollection = LocalCollection(id: "Simple Collection", fields: [
  SQStringField("Name"),
  SQBoolField("Magic"),
  SQStringField("Status", value: "To-Do"),
  SQIntField("Points"),
], actions: [
  SetFieldsAction("Mark as Done",
      getFields: (doc) => {
            "Status": "Done",
            "Points": (doc.value<int>("Points") ?? 0) + 1,
          }),
  CreateDocAction("Create Magic Doc",
      getCollection: () => simpleCollection,
      initialFields: (doc) => [
            SQStringField("Name", value: "Magic Doc"),
            SQBoolField("Magic", value: true),
            SQIntField("Points", value: 99),
          ]),
  CustomAction("Do Maths", customExecute: (doc, context) async {
    int x = doc.value<int>("Points") ?? 0;
    int y = x + 5;
    print("Magic number: $y");
  }),
  CustomAction("print hi",
      customExecute: (doc, context) async => print("hi")),
]);
```

## Contribution

The best way to contribute is to [suggest additions](https://github.com/ElBatanony/soar_quest/issues/new) to the package and using it in your projects.
Consider leaving a star on GitHub 😉.

## Acknowledgements

The logo was generated using the [Stable Diffusion](https://huggingface.co/spaces/stabilityai/stable-diffusion) AI image generation tool.
