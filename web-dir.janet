(use chidi)
(import spork/path)
(import janet-html :as html)
(defn .. [& args] (string ;args))

(use chidi/response)

(def cors-wasm-security-headers
  {
   "Cross-Origin-Opener-Policy" "same-origin"
   "Cross-Origin-Embedder-Policy" "require-corp"
   })

(def- weekdayMap [ "Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat" ])
(def- monthMap ["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"])

(def- CSS `body{max-width:800px;width:90%}
body,input,textarea{font-family:Verdana,sans-serif;background:#191e2a;color:#21ef9f}
td{margin:5px}a{color:#0ff}
a:visited{color:#008b8b}
#notes{border-top:1px solid #21ef9f;margin-top:20px}
code{font-family:\"Iosevka Curly Term Slab\", Iosevka, monospace}
pre code{margin-left:30px} 

table {
    border-collapse: collapse;
}

th, td {
    padding: 3px;
    border-bottom: 1px solid;
    border-right: 1px solid;
}

.form-error {
    color: yellow;
}`)

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

(defn v/layout [dirname body] 
  (html/encode 
    (html/doctype :html5)
    [:html {:lang "en"}
     [:head
      [:meta :charset "utf-8"]
      [:meta 
       :name "viewport" 
       :title 
       :content "width=device-width, initial-scale=1.0" ]
      [:style CSS] 
      ]
     [:body body]]))

(defn ls-html [path-] 
  (v/layout 
    path-
    [:div
     [:h2 (-> path- path/abspath path/basename) ]
     [:div
      [:h2 "Contents"]
      (seq [e :in (os/dir path-)]
        [:div[:a {:href (.. path- "/" e)} e]])]]))

(defn stoic
  ```
  Serves static files in a given directory.
  ```
  [directory &opt default-index]
  (default default-index "index.html")
  (fn stoic [req]
    # Explicitly avoid redirection tricks
    (def uri (->> (req :uri) (string/replace-all ".." "")))
    (def default-path (path/join directory uri default-index))
    (def default-file (os/stat default-path))
    (def path (if 
                (and (string/has-suffix? "/" uri) (os/stat default-index))
                default-path
                (path/join directory uri)))
    (def info (os/stat path))
    (cond 
      (and info (= :file (info :mode)))
      (response 200 
                (slurp path) 
                (merge 
                  (content-type (path/ext path)) 
                  { "Last-Modified" (ts->Last-Modified: (info :modified)) }
                  cors-wasm-security-headers))
      (and info default-file)
      (response 200 
               (slurp default-path)
               (merge 
                 { "Content-Type" "text/html"
                  "Last-Modified" (ts->Last-Modified: (info :modified))}))
      (and info (= :directory (info :mode)))
      (response 200 
               (ls-html path)
               (merge 
                 { "Content-Type" "text/html"
                  "Last-Modified" (ts->Last-Modified: (info :modified))}))
      (not-found))))

(defn main [&] 
  (print "Listing dirs on http://localhost:8000")
  (start 
    (-> (stoic ".") parse-request)
    "localhost" "8000"))
