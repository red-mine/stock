$db = ".\db\stock.sqlite3"
if (Test-Path $db) {
  rm -r -force $db
}

rails db:migrate