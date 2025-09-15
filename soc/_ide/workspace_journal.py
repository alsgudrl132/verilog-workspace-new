# 2025-09-15T09:53:11.072174
import vitis

client = vitis.create_client()
client.set_workspace(path="soc")

platform = client.create_platform_component(name = "platform_stop_watch_intr",hw_design = "$COMPONENT_LOCATION/../../project_1/soc_stopwatch_intr_wrapper.xsa",os = "standalone",cpu = "microblaze_riscv_0",domain_name = "standalone_microblaze_riscv_0")

comp = client.create_app_component(name="app_stop_watch_intr",platform = "$COMPONENT_LOCATION/../platform_stop_watch_intr/export/platform_stop_watch_intr/platform_stop_watch_intr.xpfm",domain = "standalone_microblaze_riscv_0",template = "hello_world")

platform = client.get_component(name="platform_stop_watch_intr")
status = platform.build()

comp = client.get_component(name="app_stop_watch_intr")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

