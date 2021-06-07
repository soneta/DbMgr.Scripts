function Write-Script-Info {
  param ()

  Write-Host ""
  Write-Host " Skrypt do seryjnej konwersji baz danych, wersja 1.0`n`n" -ForegroundColor darkgray
}

function Write-Error-Message {

  param (
    $databaseName,
    $errorMessage
  )

  Write-Host " Wyst¹pi³ b³¹d:" -ForegroundColor red
  Write-Host "  nazwa bazy danych: $databaseName" -ForegroundColor red
  Write-Host "  komunikat b³êdu: $errorMessage`n" -ForegroundColor red
}

function Write-Conversion-Message {
  param (
    $databaseName,
    $versions
  )

  $systemV = $versions[0]
  $sonetaV = $versions[1]
  $snapshotsV = $versions[2]

  Write-Host ""
  Write-Host "                 Konwersja bazy danych                "
  Write-Host "------------------------------------------------------"
  Write-Host "   [nazwa]: $databaseName"
  Write-Host "  [wersja]: $systemV"
  Write-Host "            $sonetaV"
  Write-Host "            $snapshotsV`n"
}

function Invoke-Dbmgr-Command {
  param (
    $command,
    $databaseName,
    $arguments
  )

  $result = .\DbMgr $command $databaseName $arguments

  if ($LASTEXITCODE -ne 0) {
    Throw $result
  }

  return $result
}

# Set-Location [Lokalizacja aplikacji dbmgr]

Write-Script-Info

$databases = .\DbMgr list -name
Write-Host " Znaleziono bazy danych: $databases"
Write-Host " Rozpoczynam konwersjê...`n`n"

foreach ($database in $databases) {
  try {
    $versions = Invoke-Dbmgr-Command version $database

    Write-Conversion-Message $database $versions

    $result = Invoke-Dbmgr-Command convert $database

    Write-Host " Konwersja zakoñczona`n" -ForegroundColor green

  } catch {
    Write-Error-Message $database $_
  }
}

Read-Host -Prompt "`n Konwersja wszystkich baz zakoñczona, naciœnij <Enter> aby zamkn¹æ okno"