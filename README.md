# DbMgr.Scripts
Repozytorium zawiera przykładowe skrypty powershell automatyzujące operacje DbMgra:
- `ConvertDatabases.ps1` - seryjna konwersja zarejestrowanych baz danych
- `UpdateExtensions.ps1` - seryjna aktualizacja dodatków w zarejestrowanych bazach danych

## Instalacja
Aby skrypty zadziałały poprawnie należy umieścić je w katalogu z aplikacją DbMgr.exe lub ustawić w każdym ze skryptów ścieżkę do katalogu a aplikacją DbMgr.exe za pomocą polecenia:
```
Set-Location [Ścieżka do aplikacji DbMgr.exe]
```

Skrypt do aktualizacji dodatków `UpdateExtensions.ps1` wymaga także ustawienia ścieżki do katalogu z rozszerzeniami, należy w tym celu przypisać poprawną ścieżkę do zmiennej `$arguments`:
```
$arguments = @("[Ścieżka do katalogu z rozszerzeniami]")
```
