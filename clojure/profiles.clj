{:user {:plugins [[cider/cider-nrepl "0.9.0"]
		  [lein-auto "0.1.2"]
		  [com.jakemccrary/lein-test-refresh "0.9.0"]
                  [lein-localrepo "0.5.3"]
                  [lein-ancient "0.6.7"]]

	:dependencies [[org.clojure/tools.nrepl "0.2.10"]
                       [spyscope "0.1.5"]
                       [org.clojure/tools.namespace "0.2.10"]
                       [io.aviso/pretty "0.1.18"]
                       [jsg-utils "0.1.0-SNAPSHOT"]
                       [im.chit/vinyasa "0.3.4"]
                       [clj-ns-browser "1.3.1"]
                       [org.clojure/clojurescript "0.0-3308"]]

        :global-vars {*print-length* 30}

        :injections [(require 'spyscope.core)
                     (require 'vinyasa.inject)

                     (vinyasa.inject/inject 'clojure.core
                                            '[[vinyasa.inject [inject inject]]
                                              [vinyasa.pull [pull pull]]
                                              [vinyasa.lein [lein lein]]
                                              [clojure.repl apropos dir doc find-doc source [root-cause cause]]
                                              [clojure.reflect reflect]
                                              [clojure.tools.namespace.repl [refresh refresh]]
                                              [clojure.pprint [pprint >pprint print-table]]
                                              [io.aviso.binary [write-binary >bin]]
                                              [jsg-utils.core show-available-methods]
                                              ])

                     (require 'io.aviso.repl
                              'clojure.repl
                              'clojure.main)
                     (alter-var-root #'clojure.main/repl-caught
                                     (constantly @#'io.aviso.repl/pretty-pst))
                     (alter-var-root #'clojure.repl/pst
                                     (constantly @#'io.aviso.repl/pretty-pst))
                     ]}}
