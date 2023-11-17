#include "include/fdatatable/fdatatable_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fdatatable_plugin.h"

void FdatatablePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fdatatable::FdatatablePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
