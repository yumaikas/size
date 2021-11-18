(def usage
  ```
  env-explode: List PATH and other composite ENV vars with one elment per line

  env-explode VAR: 
  ```)

(defn delim-for-os [] 
  (match (os/which)
    :windows ";"
    :web (error "Does this even make sense?")
    _ ":"))

(defn main [_ & args] 
  (when (> (length args) 2)
    (eprint usage)
    (eprint "env-explode only expects up to two arguments, you suppled" (length args)))
  (match args
    [VAR DELIM] (as-> (os/getenv VAR) it
                      (string/split DELIM it)
                      (each l it
                        (print l)))
                      
    [VAR] (as-> (os/getenv VAR) it
                (string/split (delim-for-os) it)
                (each l it
                  (print l)))
    _ (do
        (eprint usage)
        (eprint "env-explode expects at least one argument"))))
