import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ngrok_connector/AdbDevice.dart';
import 'package:ngrok_connector/adb_helper/adbhelper.dart';
import 'package:ngrok_connector/bloc/adb_helper/adb_helper_cubit.dart';

import '../bloc/adb_helper/adb_helper_cubit.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdbHelperCubit, AdbHelperState>(
        listener: (_, state) async {
      if (state is AdbHelperMessageState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.message),
        ));
      } else if (state is AdbHelperShowDialogComplete) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) {
              return AlertDialog(
                title: SelectableText(
                    "Forwading Ip address from ${state.device.deviceIp} to ${state.ip}"),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await context.read<AdbHelperCubit>().killNgrok();
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  )
                ],
              );
            });
      }
    }, builder: (ctx, state) {
      final list = context.read<AdbHelperCubit>().connectedDevices;
      final isProcessing = context.read<AdbHelperCubit>().isProcessing;

      if (list.isEmpty)
        return Center(
            child: Container(
                padding: EdgeInsets.only(top: 200.h),
                child: Text(
                  "No device connected",
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
                )));

      return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return AdbItem(device: list[index]);
        },
      );
    });
  }
}

class LoadingProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 24.h,
    );
  }
}

class AdbItem extends StatelessWidget {
  final AdbDevice device;

  const AdbItem({required this.device});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.h),
      child: InkWell(
        onTap: () {
          context.read<AdbHelperCubit>().pressedItem(device);
          // context.read<AdbHelperCubit>().testingLongRunningTask();
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black, width: 2.w, style: BorderStyle.solid)),
          padding: EdgeInsets.all(8.w),
          width: 1.sw,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.deviceName,
                style: TextStyle(fontSize: 14.sp),
              ),
              Spacer(),
              Text(
                device.deviceIp,
                style: TextStyle(fontSize: 14.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
