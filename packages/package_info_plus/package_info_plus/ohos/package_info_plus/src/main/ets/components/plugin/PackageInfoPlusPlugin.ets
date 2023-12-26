import {
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import MethodChannel, {
  MethodCallHandler,
  MethodResult
} from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import MethodCall from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCall';
import HashMap from '@ohos.util.HashMap';
import common from '@ohos.app.ability.common';

/** PackageInfoPlusPlugin **/
export default class PackageInfoPlusPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private context: common.Context | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "PackageInfoPlusPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "dev.fluttercommunity.plus/package_info")
    this.channel.setMethodCallHandler(this)
    this.context = binding.getApplicationContext();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
    this.context = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getAll") {
      let infoMap = new HashMap<String, String>();
      if (this.context != null) {
        infoMap.set("appName", this.context.applicationInfo.name);
        infoMap.set("packageName", "");
        infoMap.set("version", "");
        infoMap.set("buildNumber", "");
        infoMap.set("buildSignature", "");
        infoMap.set("installerStore", "");
      }

      result.success(infoMap)
    } else {
      result.notImplemented()
    }
  }
}
