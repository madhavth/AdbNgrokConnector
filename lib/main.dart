import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngrok_connector/adb_helper/adbhelper.dart';
import 'package:ngrok_connector/bloc/adb_helper/adb_helper_cubit.dart';
import 'package:ngrok_connector/storage.dart';
import 'package:ngrok_connector/ui/MainScreen.dart';
import 'package:ngrok_connector/ui/StartScreen.dart';
import 'package:process_run/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/start_screen/start_screen_cubit.dart';
import 'ui/MainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.initSharedPreference();
  runApp(ScreenUtilInit(designSize: Size(320, 480), builder: () => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngrok connector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
          providers: [BlocProvider(create: (ctx) => AdbHelperCubit()),
            BlocProvider(create: (ctx)=> StartScreenCubit(),)
          ],
          child: StartScreen()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String output = "";
  var shell = Shell();

  void _incrementCounter() async {
    context.read<AdbHelperCubit>().testFileText = "something new ";
    context.read<AdbHelperCubit>().getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customAppBar(),
            SizedBox(
              height: 10.h,
            ),
            Expanded(child: SingleChildScrollView(child: MainScreen())),
            BlocBuilder<AdbHelperCubit, AdbHelperState>(
              builder: (context, state) {
                final list = context.read<AdbHelperCubit>().connectedDevices;
                final isLoading = context.read<AdbHelperCubit>().isProcessing;

                return Column(
                  children: [
                    isLoading? LoadingProgress():SizedBox(),
                    Text("${AdbHelper.getShellInstance().path}", style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold
                    ),),
                    Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Text(list.isNotEmpty
                            ? 'click on the list element to start ngrok session'
                            : "add a device then click refresh to show the connected device")),
                  ],
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget customAppBar() {
    return Column(
      children: [
        Text(
          "Connected devices",
          style: TextStyle(fontSize: 20.sp),
        )
      ],
    );
  }
}
