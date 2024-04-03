import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:finalassignment/data/app_states.dart';
import 'package:finalassignment/pages/arrival_list.dart';
import 'package:finalassignment/pages/favorites_list.dart';
import 'package:finalassignment/pages/reminders_search.dart';
import 'package:finalassignment/pages/reminders_new.dart';
import 'package:finalassignment/pages/audio.dart';
import 'package:finalassignment/utils/database_ops.dart';
import 'package:finalassignment/utils/location.dart';
import 'package:finalassignment/widgets/bottom_nav_bar.dart';
import 'package:finalassignment/pages/reminders_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static const List<Widget> _navWidgetList = [
    RemindersList(),
    FavoritesList(),
    ArrivalList(),
    //Settings(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize the video player and load the video from the asset
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    positionStream.cancel();
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    writeData(context);
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        readData(context);
        break;
      case AppLifecycleState.paused:
        writeData(context);
        break;
      case AppLifecycleState.detached:
        writeData(context);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStates = Provider.of<AppStates>(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.mounted) {
        if (appStates.listening == false) {
          getCurrentLocation().then((value) {
            appStates.setCurrent(value.position);
            handlePositionUpdates(context);
            appStates.setListening(true);
          });
        }

        if (appStates.loaded == false) {
          readData(context);
          appStates.setLoaded(true);
        }
      }
    });

    return WillPopScope(
      onWillPop: () async {
        if (appStates.selectedAll().isNotEmpty) {
          appStates.selectedClear();
          return false;
        }
        writeData(context);
        return true;
      },
      child: Stack(
        children: [
          // Use VideoPlayer widget to display the video from the network URL

          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              actions: [
                appStates.bottomNavBarIndex == 1 &&
                    appStates.favoriteAll().isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    appStates.favoriteClear();
                  },
                  icon: const Icon(
                    Icons.clear_all,
                    size: 30,
                  ),
                )
                    : const SizedBox.shrink(),
                appStates.selectedAll().isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    final selected = appStates.selectedAll();
                    for (int i = 0; i < selected.length; ++i) {
                      appStates.favoriteAdd(
                          appStates.reminderRead(id: selected[i])!.place);
                    }
                    appStates.selectedClear();
                  },
                  icon: const Icon(
                    Icons.favorite_rounded,
                    size: 32,
                    color: Colors.pinkAccent,
                  ),
                )
                    : const SizedBox.shrink(),
                appStates.selectedAll().isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    final selected = appStates.selectedAll();
                    for (int i = 0; i < selected.length; ++i) {
                      appStates.reminderDelete(id: selected[i]);
                    }
                    appStates.selectedClear();
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    size: 32,
                    //color: Colors.red
                  ),
                )
                    : const SizedBox.shrink(),
                appStates.selectedAll().isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    if (appStates.selectedAll().length == 1) {
                      final reminder =
                      appStates.reminderRead(id: appStates.selectedAll()[0])!;

                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (context) {
                            return RemindersNew(
                              appBarTitle: 'Edit Reminder',
                              title: reminder.title,
                              latitude:
                              reminder.place.position.latitude.toString(),
                              longitude:
                              reminder.place.position.longitude.toString(),
                              radius: reminder.place.radius.toString(),
                              notes: reminder.notes,
                              id: reminder.id,
                            );
                          },
                        ),
                      );
                      appStates.selectedClear();
                    }
                    appStates.selectedClear();
                  },
                  icon: const Icon(
                    Icons.mode_edit_outline_outlined,
                    size: 32,
                    color: Colors.blueAccent,
                  ),
                )
                    : const SizedBox.shrink(),
                appStates.selectedAll().isNotEmpty
                    ? const SizedBox.shrink()
                    : appStates.bottomNavBarIndex == 0
                    ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (context) {
                          return const RemindersSearch();
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.manage_search_sharp,
                    size: 32,
                    color: Colors.blueAccent,
                  ),
                )
                    : const SizedBox.shrink(),
                appStates.selectedAll().isNotEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                  onPressed: () {
                    if (appStates.notify == true) {
                      FlutterRingtonePlayer.stop();
                      appStates.setRinging(false);
                      appStates.setNotify(false);
                    } else {
                      appStates.setNotify(true);
                    }
                  },
                  icon: Icon(
                    appStates.notify == true
                        ? Icons.notifications_on
                        : Icons.notifications_off_outlined,
                    color: appStates.notify == true
                        ? Theme.of(context).colorScheme.onBackground
                        : Theme.of(context).colorScheme.onTertiary,
                    size: 32,
                  ),
                ),
              ],
              elevation: 0,
              leading: null,
              title: appStates.selectedAll().isNotEmpty
                  ? IconButton(
                icon: const Icon(
                  Icons.cancel_presentation_rounded,
                  size: 32,
                ),
                onPressed: () {
                  appStates.selectedClear();
                },
              )
                  : const Text(
                'GeoTunes',
                style: TextStyle(
                  color: Colors.blueGrey, // Set your desired color here
                ),
              ),
              centerTitle: true,
            ),
            bottomNavigationBar: const AppBottomNavBar(),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // New floating button above the current one
                if (appStates.bottomNavBarIndex == 0)
                  FloatingActionButton(
                    elevation: 0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AudioPlayerApp(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.audio_file_sharp,
                    ),
                  ),
                const SizedBox(height: 16), // Adjust the spacing as needed
                // Current floating button
                if (appStates.bottomNavBarIndex == 0)
                  FloatingActionButton(
                    elevation: 0,
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (context) {
                            return RemindersNew();
                          },
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.notification_add,
                    ),
                  ),
              ],
            ),
            body: SafeArea(
              child: _navWidgetList.elementAt(appStates.bottomNavBarIndex),
            ),
          ),
        ],
      ),
    );
  }
}
