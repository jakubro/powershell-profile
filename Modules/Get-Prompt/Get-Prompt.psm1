Set-StrictMode -Version 2.0

function Get-Prompt($Settings) {
  if ($Settings.Compact) {
    return "$ "
  }

  $date = Get-PromptDate
  Write-Host -NoNewline $date

  if ($name = Get-PromptName) {
    Write-Host -NoNewline -ForegroundColor Green " ($name)"
  }

  $python = (Get-DefaultPython) -replace 'python', ''
  if (!$python) {
    $python = "venv"
  }
  $node = (Get-DefaultNode) -replace 'node', ''
  Write-Host -NoNewline -ForegroundColor Magenta " [py:$python | node:$node]"

  Write-Host -NoNewline -ForegroundColor Yellow " ($( Get-AwsCliCurrentProfile ))"

  $location = Get-PromptLocation
  Write-Host -NoNewline " $location"

  if ($status = Get-PromptGitStatus) {
    Write-Host -NoNewline -ForegroundColor $status.Color " [$( $status.String )]"
  }

  return " $ "
}

function Get-PromptDate {
  return Get-Date -Format "HH:mm:ss"
}

function Get-PromptLocation {
  if ($Settings.FullPath) {
    return $PWD.ProviderPath
  } else {
    return Split-Path -Leaf $PWD.ProviderPath
  }
}

function Get-PromptName {

  # todo: remove eventually
  #  if (![string]::IsNullOrWhiteSpace($env:ParentPSPromptName)) {
  #    return $env:ParentPSPromptName.Trim()
  #  }

  $python = $null
  $node = $null

  if (![string]::IsNullOrWhiteSpace($env:PythonEnvRoot)) {
    $python = Split-Path -Leaf $env:PythonEnvRoot
  }

  if (![string]::IsNullOrWhiteSpace($env:NodeEnvRoot)) {
    $node = Split-Path -Leaf $env:NodeEnvRoot
  }

  $rv = ""
  foreach ($kv in (('py', $python), ('node', $node))) {
    $key = $kv[0]
    $val = $kv[1]
    if ($val) {
      if (![string]::IsNullOrWhiteSpace($rv)) {
        $rv += " | "
      }
      $rv += "$($key):$($val)"
    }
  }
  return $rv
}

function Get-PromptGitStatus {
  $status = Get-GitStatus
  if (!$status) {
    return $null
  }

  return @{
    String = Get-PromptGitStatusString $status;
    Color = Get-PromptGitStatusColor $status;
  }
}

function Get-PromptGitStatusString($status) {
  $str = $status.Local

  if (!$status.IsBranch) {
    return ":" + $str
  }

  if (!$status.Remote) {
    return $str + " ?"
  }

  if ($status.Ahead -or $status.Behind) {
    $str += " "
  }
  if ($status.Ahead) {
    $str += $status.Ahead
    $str += [char]::ConvertFromUtf32(0x2192)  # rightwards arrow
  }
  if ($status.Behind) {
    $str += [char]::ConvertFromUtf32(0x2190)  # leftwards arrow
    $str += $status.Behind
  }

  return $str
}

function Get-PromptGitStatusColor($status) {
  if ($status.Modified) {
    return "Red"
  } else {
    return "Gray"
  }
}

function Get-AwsCliCurrentProfile {
  $profile = $env:AWS_DEFAULT_PROFILE
  if ($profile) {
    return $profile
  } else {
    return "default"
  }
}

Export-ModuleMember -Function Get-Prompt
