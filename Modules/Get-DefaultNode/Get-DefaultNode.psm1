Set-StrictMode -Version 2.0

function Get-DefaultNode {
  $default = Get-OriginalCommand node
  if (($default -eq 'node12') -or ($default -eq (Get-OriginalCommand node12))) {
    return 'node12'
  } elseif (($default -eq 'node10') -or ($default -eq (Get-OriginalCommand node10))) {
    return 'node10'
  }elseif (($default -eq 'node8') -or ($default -eq (Get-OriginalCommand node8))) {
    return 'node8'
  } else {
    return $null
  }
}
