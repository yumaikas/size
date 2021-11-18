(use chidi)
(import spork/path)

(use chidi/response)

(def cors-wasm-security-headers
  {
   "Cross-Origin-Opener-Policy" "same-origin"
   "Cross-Origin-Embedder-Policy" "require-corp"
   })

(def- weekdayMap [ "Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat" ])
(def- monthMap ["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"])

(defn ts->Last-Modified: [ts] 
  (def dt (os/date ts true))
  (string/format "%s, %02d %s %04d %02d:%02d:%02d" 
                 (weekdayMap (dt :week-day)) 
                 (dt :month-day)
                 (monthMap (dt :month))
                 (dt :year)
                 (dt :hours)
                 (dt :minutes)
                 (dt :seconds)))

(defn stoic
  ```
  Serves static files in a given directory.
  ```
  [directory &opt default-index]
  (default default-index "index.html")
  (fn stoic [req]
    (def uri (req :uri))
    (def path
      (if (string/has-suffix? "/" uri)
        (path/join directory uri default-index)
        (path/join directory uri)))
    (def {:mode path-mode :modified last-modified} (os/stat path))
    (if (= :file path-mode)
      (response 200 
                (slurp path) 
                (merge 
                  (content-type (path/ext path)) 
                  { "Last-Modified" (ts->Last-Modified: last-modified) }
                  cors-wasm-security-headers))
      (not-found))))

(defn main [&] 
  (start 
    (-> (stoic ".") parse-request)
    "localhost" "8000"))
