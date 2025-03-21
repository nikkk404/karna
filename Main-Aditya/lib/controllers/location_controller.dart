import 'package:get/get.dart';
import '../apis/apis.dart';
import '../models/vpn.dart';
import 'dart:developer';

class LocationController extends GetxController {
  final isVpnLoading = false.obs;
  final vpnList = <Vpn>[].obs;

  Future<void> getVpnServers() async {
    isVpnLoading.value = true;
    final fetchedList = await APIs.getVPNServers();
    vpnList.value = fetchedList;
    isVpnLoading.value = false;
    log('Fetched VPN List: ${vpnList.map((vpn) => vpn.toJson()).toList()}');
  }

  @override
  void onInit() {
    super.onInit();
    getVpnServers();
  }
}
