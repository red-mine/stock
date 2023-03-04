$db = ".\db\stock.sqlite3"
if (Test-Path $db) {
  Remove-Item -r -force $db
}
rails db:migrate
rails stocks
rails staves
