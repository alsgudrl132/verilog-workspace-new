# 2025-09-15T15:45:49.818068
import vitis

client = vitis.create_client()
client.set_workspace(path="soc")

platform = client.get_component(name="platform_hc05_test")
status = platform.build()

comp = client.get_component(name="app_hc05_test")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

client.delete_component(name="platform_hc05_test")

client.delete_component(name="app_hc05_test")

platform = client.create_platform_component(name = "platform_hc05_test",hw_design = "$COMPONENT_LOCATION/../../project_1/soc_hc05_test_wrapper.xsa",os = "standalone",cpu = "microblaze_riscv_0",domain_name = "standalone_microblaze_riscv_0")

comp = client.create_app_component(name="app_hc05_test",platform = "$COMPONENT_LOCATION/../platform_hc05_test/export/platform_hc05_test/platform_hc05_test.xpfm",domain = "standalone_microblaze_riscv_0",template = "hello_world")

status = platform.build()

comp.build()

status = platform.build()

comp.build()

platform = client.create_platform_component(name = "platform_hc05_test_pullup",hw_design = "$COMPONENT_LOCATION/../../project_1/soc_hc05_test_wrapper2.xsa",os = "standalone",cpu = "microblaze_riscv_0",domain_name = "standalone_microblaze_riscv_0")

comp = client.create_app_component(name="app_hc05_test_pullup",platform = "$COMPONENT_LOCATION/../platform_hc05_test_pullup/export/platform_hc05_test_pullup/platform_hc05_test_pullup.xpfm",domain = "standalone_microblaze_riscv_0",template = "hello_world")

platform = client.get_component(name="platform_hc05_test_pullup")
status = platform.build()

comp = client.get_component(name="app_hc05_test_pullup")
comp.build()

