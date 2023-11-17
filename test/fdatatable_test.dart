import 'package:flutter_test/flutter_test.dart';
import 'package:fdatatable/fdatatable.dart';
import 'package:fdatatable/fdatatable_platform_interface.dart';
import 'package:fdatatable/fdatatable_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFdatatablePlatform
    with MockPlatformInterfaceMixin
    implements FdatatablePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FdatatablePlatform initialPlatform = FdatatablePlatform.instance;

  test('$MethodChannelFdatatable is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFdatatable>());
  });

  test('getPlatformVersion', () async {
    Fdatatable fdatatablePlugin = Fdatatable();
    MockFdatatablePlatform fakePlatform = MockFdatatablePlatform();
    FdatatablePlatform.instance = fakePlatform;

    expect(await fdatatablePlugin.getPlatformVersion(), '42');
  });
}
