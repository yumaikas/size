(declare-project 
  :name "size"
  :author "Andrew Owen <yumaikas94@gmail.com"
  :url "https://github.com/yumaikas/cmd-utils"
  :description "A counter for the size of data sent over stdin"
  :dependencies [ "https://github.com/nate/isatty" ])

(declare-executable
  :name "size"
  :entry "size.janet")

(declare-executable
  :name "env-explode"
  :entry "env-explode.janet")

(phony "inst" ["build"] 
       (print "Installing...")
       (os/cd "build")
       (os/shell "inst size.exe")
       (os/shell "inst env-explode.exe")
       (os/cd "..")
       (print "Installed"))

