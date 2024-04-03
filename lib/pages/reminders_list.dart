import 'package:flutter/material.dart';
import 'package:finalassignment/data/app_states.dart';
import 'package:finalassignment/data/models/place.dart';
import 'package:finalassignment/utils/format.dart';
import 'package:finalassignment/utils/location.dart';
import 'package:finalassignment/widgets/place_holders.dart';
import 'package:provider/provider.dart';

class RemindersList extends StatelessWidget {
  const RemindersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appStates = Provider.of<AppStates>(context);

    return appStates.reminderAll().isEmpty
        ? const EmptySpace(comment: 'No Reminders Yet')
        : FutureBuilder<Place>(
            future: getCurrentLocation(),
            builder: (BuildContext context, AsyncSnapshot<Place> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: appStates.reminderAll().length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          appStates.selectedAll().isNotEmpty
                              ? appStates.selectedRead(index: index)
                                  ? Icon(
                                      Icons.check_circle,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : Icon(
                                      Icons.check_circle_outline,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                              : const SizedBox.shrink(),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color:
                                    Theme.of(context).colorScheme.tertiary,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 30,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (appStates.selectedAll().isNotEmpty) {
                                    if (appStates.selectedRead(index: index) ==
                                        true) {
                                      appStates.selectedDelete(appStates
                                          .reminderRead(index: index)!
                                          .id);
                                    } else {
                                      appStates.selectedAdd(appStates
                                          .reminderRead(index: index)!
                                          .id);
                                    }
                                  }
                                },
                                onLongPress: () {
                                  if (appStates.selectedAll().isNotEmpty) {
                                    appStates.selectedClear();
                                  } else {
                                    appStates.selectedAdd(appStates
                                        .reminderRead(index: index)!
                                        .id);
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              topLeft: Radius.circular(16),
                                            ),
                                            child: LinearProgressIndicator(
                                              minHeight: 25,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              value: appStates
                                                  .reminderRead(index: index)!
                                                  .traveledDistancePercent(
                                                      appStates.getCurrent()),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${intFormat(appStates.reminderRead(index: index)!.remainderDistance(appStates.getCurrent()).round())} meters away',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      width: double.infinity,
                                      child: Text(
                                        appStates
                                            .reminderRead(index: index)!
                                            .title,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                      ),
                                      decoration: const BoxDecoration(),
                                      child: ListTile(
                                        dense: true,
                                        leading: Switch(
                                          onChanged: (value) {
                                            appStates.reminderUpdate(appStates
                                                .reminderRead(index: index)!
                                                .copy(isTracking: value));
                                          },
                                          value: appStates
                                              .reminderRead(index: index)!
                                              .isTracking,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          side: BorderSide.none,
                                        ),
                                        subtitle: Text(
                                          '${appStates.reminderRead(index: index)!.place.position.latitude}, ${appStates.reminderRead(index: index)!.place.position.longitude}',
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 11,
                                            height: 3,
                                            color: Colors.blueAccent,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        title: Text(
                                          appStates
                                              .reminderRead(index: index)!
                                              .place
                                              .displayName!,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            height: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                return const EmptySpace(comment: 'You dont yet have reminders');
              }
            });
  }
}
