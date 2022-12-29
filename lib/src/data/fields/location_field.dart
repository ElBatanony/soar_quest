import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../screens/screen.dart';
import '../../ui/button.dart';
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
    if (source is Map<String, dynamic> && source.containsKey('coordinates'))
      return LatLng.fromJson(source);
    return super.parse(source);
  }

  @override
  serialize(value) => value?.toJson();

  @override
  formField(docScreen) => SQLocationFormField(this, docScreen);
}

class SQLocationFormField extends SQFormField<LatLng, SQLocationField> {
  const SQLocationFormField(super.field, super.docScreen);

  @override
  Widget readOnlyBuilder(context) => SizedBox(
        height: 200,
        child: FlutterMap(
          options: MapOptions(center: getDocValue() ?? defaultLocation),
          nonRotatedChildren: [mapAttribution],
          children: [
            tileLayer,
            if (getDocValue() != null) markerLayerFromPoint(getDocValue()!),
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
              await LocationPickerScreen(formField: this)
                  .go<List<dynamic>>(context);
            },
          ),
        ],
      );
}

class LocationPickerScreen extends Screen {
  LocationPickerScreen({
    required this.formField,
  }) : super(formField.field.name);

  final SQLocationFormField formField;

  @override
  List<Widget> appBarActions() => [
        IconButton(onPressed: exitScreen, icon: const Icon(Icons.save)),
        ...super.appBarActions()
      ];

  @override
  Widget screenBody(screenState) => FlutterMap(
        options: MapOptions(
            center: formField.getDocValue() ?? defaultLocation,
            onTap: (tapPosition, point) {
              formField.setDocValue(point);
              screenState.refreshScreen();
            }),
        nonRotatedChildren: [mapAttribution],
        children: [
          tileLayer,
          if (formField.getDocValue() != null)
            markerLayerFromPoint(formField.getDocValue()!),
        ],
      );
}
