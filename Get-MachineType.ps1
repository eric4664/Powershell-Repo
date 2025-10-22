function Get-MachineType {
    # Get chassis info (hardware/firmware)
    $chassis = (Get-CimInstance -ClassName Win32_SystemEnclosure).ChassisTypes
    # Get OS product type (software/OS)
    $osType  = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType

    # Default classification
    $result = "Unknown"

    # First check if it's a server OS
    switch ($osType) {
        2 { $result = "Domain Controller (Server)" }
        3 { $result = "Server" }
        1 {
            # Workstation OS → check chassis type
            switch -Regex ($chassis) {
                '8|9|10|14' { $result = "Laptop" }   # Portable, Notebook, Sub-Notebook
                '30|31'     { $result = "Tablet/Convertible" }
                '3'         { $result = "Desktop" }
                default     { $result = "Desktop" }  # Fallback
            }
        }
    }

    return $result
}

# Example usage
Get-MachineType