import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../screens/screen.dart';
import '../../ui/sq_button.dart';
import '../sq_doc.dart';

final mapAttribution =
    AttributionWidget.defaultWidget(source: 'OpenStreetMap contributors');

final defaultLocation = LatLng(55.753361, 48.743537);

final tileLayer = TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'com.example.app',
);

MarkerLayer markerLayerFromPoint(LatLng point) => MarkerLayer(
      markers: [
        Marker(
          point: point,
          width: 80,
          height: 80,
          builder: (context) => const Icon(Icons.location_on, size: 40),
        ),
      ],
    );

class SQLocationField extends SQField<LatLng> {
  SQLocationField(super.name, {super.defaultValue, super.editable, super.show});

  @override
  LatLng? parse(source) {
    if (source is! Map<String, dynamic>) return null;
    return LatLng.fromJson(source);
  }

  @override
  serialize(value) => value?.toJson();

  @override
  formField(docScreenState) => _SQLocationFormField(this, docScreenState);
}

class _SQLocationFormField extends SQFormField<SQLocationField> {
  const _SQLocationFormField(super.field, super.docScreenState);

  @override
  Widget readOnlyBuilder(context) => SizedBox(
        height: 200,
        child: FlutterMap(
          options: MapOptions(center: field.value ?? defaultLocation),
          nonRotatedChildren: [mapAttribution],
          children: [
            tileLayer,
            if (field.value != null) markerLayerFromPoint(field.value!),
          ],
        ),
      );

  @override
  Widget fieldBuilder(context) => Column(
        children: [
          readOnlyBuilder(context),
          SQButton(
            'Edit Location',
            onPressed: () async {
              await LocationPickerScreen(locationField: field)
                  .go<List<dynamic>>(context);
              onChanged();
            },
          ),
        ],
      );
}

class LocationPickerScreen extends Screen {
  LocationPickerScreen({
    required this.locationField,
  }) : super(title: locationField.name);

  final SQLocationField locationField;

  @override
  List<Widget> appBarActions(screenState) => [
        IconButton(
            onPressed: () => screenState.exitScreen(),
            icon: const Icon(Icons.save)),
        ...super.appBarActions(screenState)
      ];

  @override
  Widget screenBody(screenState) => FlutterMap(
        options: MapOptions(
            center: locationField.value ?? defaultLocation,
            onTap: (tapPosition, point) {
              locationField.value = point;
              screenState.refreshScreen();
            }),
        nonRotatedChildren: [mapAttribution],
        children: [
          tileLayer,
          if (locationField.value != null)
            markerLayerFromPoint(locationField.value!),
        ],
      );
}
