(use isatty)

(defn main [& args]
  (defn has-flag [flag] 
    (find |(= flag $) args))


  (when (or 
          (has-flag "help") 
          (has-flag "--help")
          (has-flag "--usage")
          (has-flag "-?") 
          (has-flag "/?"))
(print ```
    size - Measures the size of the output sent to its stdin. 

    If stdin is a tty, size refuses to run, since it's not meant for that.

    Example:
    echo "My small text" | size
    > Stdin was 1 lines, 3 words, and 15 bytes

    Flags:

    -?/--help/help/--usage: Show this messsage

    -KB: Display byte count in kilobytes
    -MB: Display byte count in megabytes
    -GB: Display byte counte in gigabytes.
```)
    (os/exit 0))

  (when (isatty? stdin)
    (print "Please provide input on stdin. /? or --help for usage info")
    (os/exit 1))

    
  (var lines 0)
  (var words 0)
  (var bytes 0)
  (defn tally-word [word] (++ words) true)
  (defn tally-line [line] (++ lines) true)
  (def tally-pat (peg/compile ~{
                   :line (drop (cmt (<- (1 (+ "\r\n" (set "\n\r")))) ,tally-line))
                   :word (drop (cmt (<- (some :S)) ,tally-word))
                   :main (any (+ :line :word 1)) }))
  (defn tally [buf] 
    (+= bytes (length buf))
    (peg/match tally-pat buf))

  (prompt :done
          (forever 
            (def buf (:read stdin 4026))
            (tally buf)
            (if (< (length buf) 4026)
              (return :done))))

  (defn byte-size []
    (cond 
      (has-flag "-KB") [(/ bytes 1024) " kilobytes" ]
      (has-flag "-MB") [(/ bytes 1024 1024) " megabytes" ]
      (has-flag "-GB") [(/ bytes 1024 1024 1024 ) " gigabytes" ]
      [bytes " bytes "]))

  (print "Stdin was " lines " lines, " words " words, and " ;(byte-size)))
