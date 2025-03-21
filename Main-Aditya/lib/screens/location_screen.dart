import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/location_controller.dart';
import '../views/widgets/vpn_card.dart';
import 'dart:developer';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final _controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    if (_controller.vpnList.isEmpty) {
      _controller.getVpnServers().then((_) {
        log('Fetched VPN List (from LocationScreen): ${_controller.vpnList.map((vpn) => vpn.toJson()).toList()}');
      });
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('VPN Locations (${_controller.vpnList.length})'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
              onPressed: () => _controller.getVpnServers(),
              child: Icon(CupertinoIcons.refresh)),
        ),
        body: _controller.isVpnLoading.value
            ? _loadingWidget(mq)
            : _controller.vpnList.isEmpty
                ? _noVPNFound()
                : _vpnData(mq),
      ),
    );
  }

  _vpnData(Size mq) => ListView.builder(
      itemCount: _controller.vpnList.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
          top: mq.height * .015,
          bottom: mq.height * .1,
          left: mq.width * .04,
          right: mq.width * .04),
      itemBuilder: (ctx, i) => VpnCard(vpn: _controller.vpnList[i]));

  _loadingWidget(Size mq) => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('assets/lottie/loading.json',
                width: mq.width * .7),
            Text(
              'Loading VPNs...',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  _noVPNFound() => Center(
        child: Text(
          'VPNs Not Found!',
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      );
}
