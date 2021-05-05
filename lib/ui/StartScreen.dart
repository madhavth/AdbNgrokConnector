import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ngrok_connector/UiHelper.dart';
import 'package:ngrok_connector/adb_helper/adb_ngrok_checker.dart';
import 'package:ngrok_connector/bloc/start_screen/start_screen_cubit.dart';
import 'package:ngrok_connector/bloc/start_screen/start_screen_state.dart';
import 'package:ngrok_connector/service/repository/DownloadRepository.dart';

import '../main.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StartScreenCubit, StartScreenState>(
              builder: (ctx, state) {
                // if(state is StartScreenSatisfiesAllConditions)
                //   {
                    return MyHomePage(title: 'Ngrok connector building');
                  // }
                // return CheckNgrokAdbInstalled();
          }),
    );
  }
}

class CheckNgrokAdbInstalled extends StatefulWidget {
  @override
  _CheckNgrokAdbInstalledState createState() => _CheckNgrokAdbInstalledState();
}

class _CheckNgrokAdbInstalledState extends State<CheckNgrokAdbInstalled> {
  double downloadProgressAdb = 0.0;

  @override
  Widget build(BuildContext context) {
    return Center(child: TextButton(onPressed: () async {
      DownloadRepository.downloadAdb(callback: (count, total)
      {
        setState(() {
          downloadProgressAdb = count/total.toDouble();
        });
      });
    },
      child: Text("Download adb --- $downloadProgressAdb"),));
  }
}

