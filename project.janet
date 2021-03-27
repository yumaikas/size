(declare-project 
  :name "size"
  :description "A counter for the size of data sent over stdin"
  :dependencies [ "https://github.com/nate/isatty" ])

(declare-executable
  :name "size"
  :entry "size.janet")

(phony "inst" ["build"] 
       (print "Installing...")
       (os/cd "build")
       (os/shell "inst size.exe")
       (os/cd "..")
       (print "Installed"))

