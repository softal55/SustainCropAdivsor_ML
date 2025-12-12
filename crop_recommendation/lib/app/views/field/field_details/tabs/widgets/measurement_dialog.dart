import 'package:flutter/material.dart';
import 'package:crop_recommendation/app/controllers/measurement_controller.dart';
import 'package:crop_recommendation/app/models/field.dart';
import 'package:crop_recommendation/app/models/measurement.dart';
import 'package:crop_recommendation/app/models/point.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/utils/validator.dart';

class _MeasurementFormContent extends StatefulWidget {
  final Field? field;
  final Measurement? measurement;
  final MeasurementController controller;
  final bool isEditMode;
  final GlobalKey<FormState> formKey;

  const _MeasurementFormContent({
    this.field,
    this.measurement,
    required this.controller,
    required this.isEditMode,
    required this.formKey,
  });

  @override
  _MeasurementFormContentState createState() => _MeasurementFormContentState();
}

class _MeasurementFormContentState extends State<_MeasurementFormContent> {
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _nController;
  late TextEditingController _pController;
  late TextEditingController _kController;
  late TextEditingController _phController;
  late TextEditingController _rainfallController;
  late TextEditingController _temperatureController;
  late TextEditingController _humidityController;

  String? _latitudeWarning;
  String? _longitudeWarning;
  String? _nWarning;
  String? _pWarning;
  String? _kWarning;
  String? _phWarning;
  String? _rainfallWarning;
  String? _temperatureWarning;
  String? _humidityWarning;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _latitudeController = TextEditingController(
        text: widget.measurement!.point.latitude.toString(),
      );
      _longitudeController = TextEditingController(
        text: widget.measurement!.point.longitude.toString(),
      );
      _nController = TextEditingController(
        text: widget.measurement!.n.toString(),
      );
      _pController = TextEditingController(
        text: widget.measurement!.p.toString(),
      );
      _kController = TextEditingController(
        text: widget.measurement!.k.toString(),
      );
      _phController = TextEditingController(
        text: widget.measurement!.ph.toString(),
      );
      _rainfallController = TextEditingController(
        text: widget.measurement!.rainfall.toString(),
      );
      _temperatureController = TextEditingController(
        text: widget.measurement!.temperature.toString(),
      );
      _humidityController = TextEditingController(
        text: widget.measurement!.humidity.toString(),
      );
    } else {
      _latitudeController = TextEditingController();
      _longitudeController = TextEditingController();
      _nController = TextEditingController();
      _pController = TextEditingController();
      _kController = TextEditingController();
      _phController = TextEditingController();
      _rainfallController = TextEditingController();
      _temperatureController = TextEditingController();
      _humidityController = TextEditingController();
    }

    if (widget.isEditMode) {
      _updateWarning(
        _nController.text,
        'Nitrogen (N)',
        0.0,
        200.0,
        (val) => _nWarning = val,
      );
      _updateWarning(
        _pController.text,
        'Phosphorus (P)',
        0.0,
        100.0,
        (val) => _pWarning = val,
      );
      _updateWarning(
        _kController.text,
        'Potassium (K)',
        0.0,
        200.0,
        (val) => _kWarning = val,
      );
      _updateWarning(
        _phController.text,
        'pH Level',
        0.0,
        14.0,
        (val) => _phWarning = val,
      );
      _updateWarning(
        _rainfallController.text,
        'Rainfall (mm)',
        0.0,
        5000.0,
        (val) => _rainfallWarning = val,
      );
      _updateWarning(
        _temperatureController.text,
        'Temperature (°C)',
        -30.0,
        50.0,
        (val) => _temperatureWarning = val,
      );
      _updateWarning(
        _humidityController.text,
        'Humidity (%)',
        0.0,
        100.0,
        (val) => _humidityWarning = val,
      );
    }
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _phController.dispose();
    _rainfallController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    super.dispose();
  }

  void _updateWarning(
    String? value,
    String fieldName,
    double? min,
    double? max,
    Function(String?) setWarningState,
  ) {
    setState(() {
      final parsedValue = double.tryParse(value ?? '');
      if (parsedValue != null && parsedValue >= 0) {
        setWarningState(
          Validator.getNumericRangeWarning(parsedValue, fieldName, min, max),
        );
      } else {
        setWarningState(null);
      }
    });
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    String? helperText,
    String? warningText,
  }) {
    final bool hasWarning = warningText != null;
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: hasWarning ? AppColors.warning : null),
      helperText: helperText,
      helperStyle: TextStyle(color: hasWarning ? AppColors.warning : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _latitudeController,
              decoration: _buildInputDecoration(
                labelText: 'Latitude',
                helperText: _latitudeWarning,
                warningText: _latitudeWarning,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) => Validator.numericHardValidator(value, 'Latitude'),
              onChanged:
                  (value) => _updateWarning(
                    value,
                    'Latitude',
                    -90.0,
                    90.0,
                    (val) => _latitudeWarning = val,
                  ),
              enabled: !widget.isEditMode,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _longitudeController,
              decoration: _buildInputDecoration(
                labelText: 'Longitude',
                helperText: _longitudeWarning,
                warningText: _longitudeWarning,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) => Validator.numericHardValidator(value, 'Longitude'),
              onChanged:
                  (value) => _updateWarning(
                    value,
                    'Longitude',
                    -180.0,
                    180.0,
                    (val) => _longitudeWarning = val,
                  ),
              enabled: !widget.isEditMode,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nController,
              decoration: _buildInputDecoration(
                labelText: 'Nitrogen (N)',
                helperText: _nWarning,
                warningText: _nWarning,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) =>
                      Validator.numericHardValidator(value, 'Nitrogen (N)'),
              onChanged:
                  (value) => _updateWarning(
                    value,
                    'Nitrogen (N)',
                    0.0,
                    200.0,
                    (val) => _nWarning = val,
                  ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _pController,
              decoration: _buildInputDecoration(
                labelText: 'Phosphorus (P)',
                helperText: _pWarning,
                warningText: _pWarning,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) =>
                      Validator.numericHardValidator(value, 'Phosphorus (P)'),
              onChanged:
                  (value) => _updateWarning(
                    value,
                    'Phosphorus (P)',
                    0.0,
                    200.0,
                    (val) => _pWarning = val,
                  ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _kController,
              decoration: _buildInputDecoration(
                labelText: 'Potassium (K)',
                helperText: _kWarning,
                warningText: _kWarning,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) =>
                      Validator.numericHardValidator(value, 'Potassium (K)'),
              onChanged:
                  (value) => _updateWarning(
                    value,
                    'Potassium (K)',
                    0.0,
                    250.0,
                    (val) => _kWarning = val,
                  ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _phController,
              decoration: _buildInputDecoration(
                labelText: 'pH Level',
                helperText: _phWarning,
                warningText: _phWarning,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) => Validator.numericHardValidator(value, 'pH Level'),
              onChanged:
                  (value) => _updateWarning(
                    value,
                    'pH Level',
                    0.0,
                    14.0,
                    (val) => _phWarning = val,
                  ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _rainfallController,
              decoration: _buildInputDecoration(
                labelText: 'Rainfall (mm)',
                helperText: _rainfallWarning,
                warningText: _rainfallWarning,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) =>
                      Validator.numericHardValidator(value, 'Rainfall (mm)'),
              onChanged:
                  (value) => _updateWarning(
                    value,
                    'Rainfall (mm)',
                    0.0,
                    350.0,
                    (val) => _rainfallWarning = val,
                  ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _temperatureController,
              decoration: _buildInputDecoration(
                labelText: 'Temperature (°C)',
                helperText: _temperatureWarning,
                warningText: _temperatureWarning,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) =>
                      Validator.numericHardValidator(value, 'Temperature (°C)'),
              onChanged:
                  (value) => _updateWarning(
                    value,
                    'Temperature (°C)',
                    -30.0,
                    50.0,
                    (val) => _temperatureWarning = val,
                  ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _humidityController,
              decoration: _buildInputDecoration(
                labelText: 'Humidity (%)',
                helperText: _humidityWarning,
                warningText: _humidityWarning,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) =>
                      Validator.numericHardValidator(value, 'Humidity (%)'),
              onChanged:
                  (value) => _updateWarning(
                    value,
                    'Humidity (%)',
                    0.0,
                    100.0,
                    (val) => _humidityWarning = val,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAddMeasurementDialog(
  BuildContext context,
  Field field,
  MeasurementController controller,
) {
  final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Measurement'),
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: _MeasurementFormContent(
          field: field,
          controller: controller,
          isEditMode: false,
          formKey: dialogFormKey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (dialogFormKey.currentState?.validate() == true) {
                final _MeasurementFormContentState? formState =
                    (dialogFormKey.currentState as FormState).context
                        .findAncestorStateOfType<
                          _MeasurementFormContentState
                        >();

                if (formState == null) {
                  return;
                }

                final newMeasurement = Measurement(
                  id: controller.measurements.length + 1,
                  fieldId: field.id,
                  point: Point(
                    id: 0,
                    latitude: double.parse(formState._latitudeController.text),
                    longitude: double.parse(
                      formState._longitudeController.text,
                    ),
                  ),
                  n: double.parse(formState._nController.text),
                  p: double.parse(formState._pController.text),
                  k: double.parse(formState._kController.text),
                  ph: double.parse(formState._phController.text),
                  rainfall: double.parse(formState._rainfallController.text),
                  temperature: double.parse(
                    formState._temperatureController.text,
                  ),
                  humidity: double.parse(formState._humidityController.text),
                  measurementDate: DateTime.now(),
                );

                controller.addMeasurement(newMeasurement);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

void showEditMeasurementDialog(
  BuildContext context,
  Measurement measurement,
  MeasurementController controller,
) {
  final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Measurement'),
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: _MeasurementFormContent(
          measurement: measurement,
          controller: controller,
          isEditMode: true,
          formKey: dialogFormKey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (dialogFormKey.currentState?.validate() == true) {
                final _MeasurementFormContentState? formState =
                    (dialogFormKey.currentState as FormState).context
                        .findAncestorStateOfType<
                          _MeasurementFormContentState
                        >();

                if (formState == null) {
                  return;
                }

                final updatedMeasurement = Measurement(
                  id: measurement.id,
                  fieldId: measurement.fieldId,
                  point: measurement.point,
                  n: double.parse(formState._nController.text),
                  p: double.parse(formState._pController.text),
                  k: double.parse(formState._kController.text),
                  ph: double.parse(formState._phController.text),
                  rainfall: double.parse(formState._rainfallController.text),
                  temperature: double.parse(
                    formState._temperatureController.text,
                  ),
                  humidity: double.parse(formState._humidityController.text),
                  measurementDate: DateTime.now(),
                );

                controller.editMeasurement(updatedMeasurement);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
