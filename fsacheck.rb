require 'open3'
require 'logger'
 
log = Logger.new('log.txt')

URL= "https://www.fsa.go.jp/news/30/singi/kasoukenkyuukai.html"
OUT_FILE="fsa.html"
NEW_FILE="fsa_new.html"

while true

is_initial = File.exist?(OUT_FILE)

if !is_initial then
Open3.capture3("curl #{URL} > #{OUT_FILE}")
else
Open3.capture3("curl #{URL} > #{NEW_FILE}")
end
result,error,status = Open3.capture3("diff #{OUT_FILE} #{NEW_FILE}")
if result == "" then
log.info " no status change"
Open3.capture3("curl #{URL} > #{OUT_FILE}")

else
log.info "diff #{result}"
Open3.capture3("curl -X POST -H 'Authorization: Bearer UZ7GJ3fxDp53SUiam11dyQKzPyGfIGTGucOxZcTje1w' -F 'message=#{result}' https://notify-api.line.me/api/notify
")

end

sleep(10*60)

end
