#ifndef FLUTTER_PLUGIN_FDATATABLE_PLUGIN_H_
#define FLUTTER_PLUGIN_FDATATABLE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace fdatatable {

class FdatatablePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FdatatablePlugin();

  virtual ~FdatatablePlugin();

  // Disallow copy and assign.
  FdatatablePlugin(const FdatatablePlugin&) = delete;
  FdatatablePlugin& operator=(const FdatatablePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace fdatatable

#endif  // FLUTTER_PLUGIN_FDATATABLE_PLUGIN_H_
