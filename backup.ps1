Set-StrictMode -Version 2.0

# what to backup & where to save the backup
$timestamp = [DateTime]::UtcNow.ToString("yyyyMMddHHmmssZ")
$source = "C:\dev\src"
$destination = "D:\archive\src_$timestamp.rar"

# clean old backups
try {
  Remove-Item D:\archive\* -Include "*.rar"
} catch { }

# WinRar arguments explanation:
#     a                 create archive
#     -t                test files after archiving
#     -k                lock archive
#     -ibck             run in background
#     -ma5
#     -m5               use best compression method
#     -md1024m          use dictionary of size 1024MB
#     -htb-oi:131072
#     -qo-
#     --                stop switches scanning

& "${env:ProgramFiles}\WinRAR\WinRAR.exe" a -t -k -ibck -ma5 -m5 -md1024m -htb-oi:131072 -qo- -- $destination $source
