//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <location/location_plugin.h>
#include <object_detection/object_detection_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  LocationPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LocationPlugin"));
  ObjectDetectionPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ObjectDetectionPlugin"));
}
