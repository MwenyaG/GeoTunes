import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finalassignment/data/app_states.dart';
import 'package:finalassignment/data/models/place.dart';
import 'package:finalassignment/data/models/point.dart';
import 'package:finalassignment/data/models/reminder.dart';
import 'package:finalassignment/data/repository/maps.dart';
import 'package:finalassignment/widgets/buttons.dart';
import 'package:finalassignment/pages/map.dart';
import 'package:finalassignment/utils/location.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RemindersNew extends StatefulWidget {
  RemindersNew({
    Key? key,
    this.title = '',
    this.latitude = '',
    this.longitude = '',
    this.radius = '',
    this.notes,
    this.id,
    this.appBarTitle = 'New Reminder',
  }) : super(key: key);

  String title;
  String latitude;
  String longitude;
  String radius;
  String? notes;
  String? id;
  String appBarTitle;

  @override
  State<RemindersNew> createState() => _RemindersNew();
}

class _RemindersNew extends State<RemindersNew> {
  final _locationFormKey = GlobalKey<FormState>();
  final _titleFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.title;
    _latitudeController.text = widget.latitude;
    _longitudeController.text = widget.longitude;
    _radiusController.text = widget.radius;
    _notesController.text = widget.notes ?? '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _radiusController.dispose();
    _notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appStates = Provider.of<AppStates>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.appBarTitle),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _titleFormKey,
                      child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          filled: true,
                          errorStyle: TextStyle(
                            fontFamily: 'Roboto',
                          ),
                          hintText: 'Title..',
                        ),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'This should not be left empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Form(
                      key: _locationFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _latitudeController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                filled: true,
                                errorStyle: TextStyle(
                                  fontFamily: 'Roboto',
                                ),
                                hintText: 'latitude',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^[+\-]?[0]{1}[^.]')),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                              ),
                              validator: (value) {
                                return pointValidate(
                                  value,
                                  message: 'Invalid latitude',
                                  limit: 90,
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _longitudeController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                filled: true,
                                errorStyle: TextStyle(
                                  fontFamily: 'Roboto',
                                ),
                                hintText: 'longitude',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^[+\-]?[0]{1}[^.]')),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                              ),
                              validator: (value) {
                                return pointValidate(
                                  value,
                                  message: 'Invalid longitude',
                                  limit: 180,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ChooseOnMapButton(
                      onPressed: () async {
                        final pickedLocation =
                            await Navigator.of(context).push<Place>(
                          MaterialPageRoute<Place>(
                            builder: (context) {
                              return const MapPage();
                            },
                          ),
                        );

                        if (pickedLocation != null) {
                          if (mounted) {
                            setState(() {
                              _latitudeController.text =
                                  pickedLocation.position.latitude.toString();
                              _longitudeController.text =
                                  pickedLocation.position.longitude.toString();
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: _radiusController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        filled: true,
                        hintText: 'How far from location..',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                        suffixText: 'Meters',
                        suffixStyle: TextStyle(
                          fontFamily: 'Roboto',
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^[0-9]{1,7})')),
                        FilteringTextInputFormatter.deny(
                            RegExp(r'(^[0-9]{8,})')),
                        FilteringTextInputFormatter.deny(
                            RegExp(r'(^[0]{1}[0-9]+)')),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          filled: true,
                          hintText: 'Add some notes',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                          )),
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 32,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              AddReminderButton(
                buttonText:
                    widget.id != null ? ' Save Reminder' : ' Add Reminder',
                onPressed: () async {
                  // Validate inputs
                  if (_titleController.text.isEmpty) {
                    _titleFormKey.currentState!.validate();
                    return;
                  }

                  if (_latitudeController.text.isEmpty ||
                      _longitudeController.text.isEmpty) {
                    _locationFormKey.currentState!.validate();
                    return;
                  }

                  Point position = Point(
                    latitude: double.parse(_latitudeController.text),
                    longitude: double.parse(_longitudeController.text),
                  );

                  final destination = await Maps()
                      .getLocationInfo(position)
                      .onError((error, stackTrace) {
                    return Future.error(error!, stackTrace);
                  });

                  if (_radiusController.text.isEmpty) {
                    if (mounted) {
                      setState(() {
                        _radiusController.text = destination.radius.toString();
                      });
                    }
                  }
                  destination.radius = int.parse(_radiusController.text);

                  if (widget.id == null) {
                    Reminder newReminder = Reminder(
                      id: const Uuid().v4(),
                      title: _titleController.text,
                      place: destination,
                      initialDistance: 0.0,
                      isTracking: true,
                      isArrived: false,
                      notes: _notesController.text,
                    );

                    // Update the initial distance
                    newReminder.traveledDistance(position);
                    appStates.reminderAdd(newReminder);
                  } else {
                    final oldReminder = appStates.reminderRead(id: widget.id)!;
                    final newReminder = oldReminder.copy(
                      title: _titleController.text,
                      place: destination,
                      initialDistance: 0.0,
                      notes: _notesController.text,
                    );

                    newReminder.traveledDistance(position);
                    appStates.reminderUpdate(newReminder);
                  }

                  if (context.mounted) {
                    Navigator.of(context).pop<void>();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
