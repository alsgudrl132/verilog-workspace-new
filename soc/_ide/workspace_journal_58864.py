# 2025-09-15T15:42:30.261744
import vitis

client = vitis.create_client()
client.set_workspace(path="soc")

platform = client.create_platform_component(name = "platform_hc05_test",hw_design = "$COMPONENT_LOCATION/../../project_1/soc_hc05_test_wrapper.xsa",os = "standalone",cpu = "microblaze_riscv_0",domain_name = "standalone_microblaze_riscv_0")

comp = client.create_app_component(name="app_hc05_test",platform = "$COMPONENT_LOCATION/../platform_hc05_test/export/platform_hc05_test/platform_hc05_test.xpfm",domain = "standalone_microblaze_riscv_0",template = "hello_world")

vitis.dispose()

