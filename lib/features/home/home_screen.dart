import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wearable_app/features/home/home_viewmodel.dart';
import 'package:wearable_app/services/notification_service.dart';
import 'package:wearable_app/services/watch_connectivity_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(homeViewModel).messageStream();
  }

  @override
  Widget build(BuildContext context) {
    var watchViewModel = ref.watch(homeViewModel);
    var readViewModel = ref.read(homeViewModel.notifier);

    String hours = ref.read(homeViewModel).formatTime(watchViewModel.hours);
    String minutes = ref.read(homeViewModel).formatTime(watchViewModel.minutes);
    String seconds = ref.read(homeViewModel).formatTime(watchViewModel.seconds);
    bool isPaused = ref.watch(homeViewModel).isPaused;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/time-03-stroke-rounded.svg',
              ),
              Spacer(),
              Center(
                child: Text('$hours:$minutes:$seconds}',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        isPaused
                            ? readViewModel.startTimer()
                            : readViewModel.pauseTimer();
                      },
                      icon: SvgPicture.asset(isPaused
                          ? 'assets/svg/play-stroke-rounded.svg'
                          : 'assets/svg/pause-stroke-rounded.svg')),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/svg/stop-stroke-rounded.svg',
                        height: 20.0,
                      )),
                  IconButton(
                      onPressed: () {
                        readViewModel.resetTimer();
                      },
                      icon: SvgPicture.asset(
                        'assets/svg/refresh-stroke-rounded.svg',
                        height: 20.0,
                      )),
                ],
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
