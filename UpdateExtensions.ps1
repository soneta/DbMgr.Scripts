function Write-Script-Info {
  param ()

  Write-Host ""
  Write-Host " Skrypt do seryjnej aktualizacji rozszerze�, wersja 1.0`n`n" -ForegroundColor darkgray
}

function Write-Error-Message {

  param (
    $databaseName,
    $errorMessage
  )

  Write-Host " Wyst�pi� b��d:" -ForegroundColor red
  Write-Host "  nazwa bazy danych: $databaseName" -ForegroundColor red
  Write-Host "  komunikat b��du: $errorMessage`n" -ForegroundColor red
}

function Write-Update-Message {
  param (
    $databaseName,
    $extensions
  )

  Write-Host ""
  Write-Host "               Aktualizacja rozszerze�               "
  Write-Host "-----------------------------------------------------"
  Write-Host "   [nazwa bazy]: $databaseName"
  Write-Host "      [dodatki]: $extensions`n"
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
Write-Host " Rozpoczynam aktualizacj�...`n`n"

foreach ($database in $databases) {
  try {
    $extensions = Invoke-Dbmgr-Command listext $database

    if ($extensions -Match "Brak rozszerze�") {
      Write-Host " Brak rozszerze� w bazie danych: $database`n" -ForegroundColor yellow
      continue
    }

    if ($extensions[0] -Match "Extensions") {
      $extensions = $extensions[1..($extensions.Length - 1)]
    }

    Write-Update-Message $database $extensions

    foreach ($extension in $extensions) {
      $name = $extension.Split(" ")[0]
      $params = [regex]::matches($extension, "(-\S*) ")

      # Lokalizacja katalogu z rozszerzeniami
      $arguments = @("..\..\Assemblies\$name")

      foreach ($param in $params) {
        if ($param) {
          $arguments += $param.value.Trim()
        }
      }

      $result = Invoke-Dbmgr-Command ext $database $arguments

      Write-Host " Biblioteka $name zosta�a zaktualizowana`n" -ForegroundColor green
    }

    Write-Host " Przeprowadzam konwersj� bazy danych: $database"
    $result = Invoke-Dbmgr-Command convert $database
    Write-Host " Konwersja zako�czona`n" -ForegroundColor green
  }
  catch {
    Write-Error-Message $database $_
  }
}

Read-Host -Prompt "`n Aktualizacja rozszerze� zako�czona, naci�nij <Enter> aby zamkn�� okno"