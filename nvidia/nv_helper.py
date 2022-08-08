#!/usr/bin/env python3

from pynvml import *
from typing import cast, Callable, Any
import ctypes, sys


def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False


if __name__ == '__main__':
    nvmlInit()

    print("Driver Version:", nvmlSystemGetDriverVersion())
    print("Device Count: %i\n" % nvmlDeviceGetCount())

    for i in range(nvmlDeviceGetCount()):
        handle = nvmlDeviceGetHandleByIndex(i)
        print("Device %i:\t\t%s" % (i, nvmlDeviceGetName(handle)))
        print(
            "    DriverModel: \tCurrent=%s Pending=%s"
            % tuple(map(lambda x: ('WDDM', 'WDM(TCC)')[x], nvmlDeviceGetDriverModel(handle)))
        )
        mem_info = nvmlDeviceGetMemoryInfo(handle)
        print(
            "    Memory: \t\t%f%% (%f/%s GiB)"
            % (
                cast('int', mem_info.used) / cast('int', mem_info.total) * 100,
                cast('int', mem_info.used) / 1024**3,
                cast('int', mem_info.total) / 1024**3,
            )
        )
        print(
            "    Utilization:\tGPU=%i%%, MEM=%i%%"
            % (
                nvmlDeviceGetUtilizationRates(handle).gpu,
                nvmlDeviceGetUtilizationRates(handle).memory,
            )
        )
        print("    Temperature:\t%iC" % nvmlDeviceGetTemperature(handle, NVML_TEMPERATURE_GPU))

        print(
            "    PowerLimit             (Driver):\t%sW"
            % (nvmlDeviceGetEnforcedPowerLimit(handle) / 1000)
        )
        print(
            "    PowerLimit            (PwrMgmt):\t%sW"
            % (nvmlDeviceGetPowerManagementLimit(handle) / 1000)
        )
        print(
            "    PowerDefaultLimit     (PwrMgmt):\t%sW"
            % (nvmlDeviceGetPowerManagementDefaultLimit(handle) / 1000)
        )
        print(
            "    PowerLimitConstraints (PwrMgmt):\t%sW ~ %sW"
            % (
                nvmlDeviceGetPowerManagementLimitConstraints(handle)[0] / 1000,
                nvmlDeviceGetPowerManagementLimitConstraints(handle)[1] / 1000,
            )
        )
        print(
            "    Power Management:\t%s"
            % ('DISABLED', 'ENABLED')[nvmlDeviceGetPowerManagementMode(handle)]
        )
        print("    PowerSource:\t%s" % ('AC', 'BATTERY')[nvmlDeviceGetPowerSource(handle)])
        power_state = nvmlDeviceGetPowerState(handle)
        print(
            "    PowerState: \t%s"
            % (
                '%i (where 0 is MAX PERF and 15 is MIN PERF)' % power_state
                if 0 <= power_state <= 15
                else 'UNKNOWN'
                if power_state == 32
                else 'ERROR'
            )
        )
        print("    PowerUsage: \t%sW" % (nvmlDeviceGetPowerUsage(handle) / 1000))

        throttle_reasons = nvmlDeviceGetCurrentClocksThrottleReasons(handle)
        print(end="    ThrottleReasons:\t")
        if throttle_reasons == 0:
            print('None')
        else:
            reasons = (
                ('GpuIdle', nvmlClocksThrottleReasonGpuIdle),
                (
                    'ApplicationsClocksSetting',
                    nvmlClocksThrottleReasonApplicationsClocksSetting,
                ),
                ('SwPowerCap', nvmlClocksThrottleReasonSwPowerCap),
                ('HwSlowdown', nvmlClocksThrottleReasonHwSlowdown),
                ('SyncBoost', nvmlClocksThrottleReasonSyncBoost),
                ('SwThermalSlowdown', nvmlClocksThrottleReasonSwThermalSlowdown),
                ('HwThermalSlowdown', nvmlClocksThrottleReasonHwThermalSlowdown),
                ('HwPowerBrakeSlowdown', nvmlClocksThrottleReasonHwPowerBrakeSlowdown),
                ('DisplayClockSetting', nvmlClocksThrottleReasonDisplayClockSetting),
            )
            for name, bit in reasons:
                if throttle_reasons & bit:
                    print(end="%s " % name)
            print()

        for s, f in cast(
            'list[tuple[str,Callable[[pointer[struct_c_nvmlDevice_t]],list[c_nvmlProcessInfo_t]]]]',
            (
                ('ComputeProc', nvmlDeviceGetComputeRunningProcesses),
                ('GraphicsProc', nvmlDeviceGetGraphicsRunningProcesses),
                ('MPSComputeProc', nvmlDeviceGetMPSComputeRunningProcesses),
            ),
        ):
            print("    %s:" % s)
            for x in f(handle):
                print("        PID=%i,\tMEM=%s" % (x.pid, x.usedGpuMemory))

        target_power = float(input('Change power limit (in Watt, 0 to quit)? '))
        if target_power == 0:
            exit()
        if not is_admin():
            ctypes.windll.shell32.ShellExecuteW(
                None, "runas", sys.executable, " ".join(sys.argv), None, 1
            )
            exit(1)
        nvmlDeviceSetPowerManagementLimit(handle, int(target_power * 1000))
        print(
            "    PowerLimit             (Driver):\t%s W"
            % (nvmlDeviceGetEnforcedPowerLimit(handle) / 1000)
        )
        print(
            "    PowerLimit            (PwrMgmt):\t%s W"
            % (nvmlDeviceGetPowerManagementLimit(handle) / 1000)
        )
        input('Press enter to exit ...')
