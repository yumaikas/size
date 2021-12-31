(declare-project 
  :name "cmd utils"
  :author "Andrew Owen <yumaikas94@gmail.com"
  :url "https://github.com/yumaikas/cmd-utils"
  :description "Various simple command line tools."
  :dependencies [ 
                 "https://github.com/nate/isatty" 
                 "https://github.com/swlkr/janet-html"
                 "spork"
                 ])


(declare-executable
  :name "size"
  :entry "size.janet")

(declare-executable
  :name "web-dir"
  :entry "web-dir.janet")

(declare-executable
  :name "env-explode"
  :entry "env-explode.janet")

(phony "inst" ["build"] 
       (print "Installing...")
       (os/cd "build")
       (os/shell "inst size.exe")
       (os/shell "inst env-explode.exe")
       (os/shell "inst web-dir.exe")
       (os/cd "..")
       (print "Installed"))

