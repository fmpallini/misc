# In preparation for the next OneUI upgrade I've created a PowerShell script to enable in batch all uninstalled applications with the debloat method. This aims to ensure that you won't face issues after the OS update.
# The commands here should be run after the adb server is connected to the device.

./adb shell pm list packages -s --user 0 > installed_system_packages.txt
./adb shell pm list packages -s -u --user 0 > all_system_packages.txt

$installedPackages = (Get-Content -Path .\installed_system_packages.txt) | Sort-Object -Unique

Get-Content -Path .\all_system_packages.txt | Where-Object { $installedPackages -notcontains $_ } | Out-File .\uninstalled_packages.txt

ForEach($line in Get-Content -Path .\uninstalled_packages.txt) {
    $cmd = $line.Replace("package:","./adb shell cmd package install-existing ")
    Invoke-Expression $cmd
}