{:user {:plugins [[cider/cider-nrepl "0.9.1"]
		  [lein-auto "0.1.2"]
		  [com.jakemccrary/lein-test-refresh "0.10.0"]
                  [lein-localrepo "0.5.3"]
                  [lein-ancient "0.6.7"]]

	:dependencies [[org.clojure/tools.nrepl "0.2.10"]
                       [spyscope "0.1.5"]
                       [org.clojure/tools.namespace "0.2.10"]
                       [leiningen #=(leiningen.core.main/leiningen-version)]
                       [io.aviso/pretty "0.1.18"]
                       [im.chit/vinyasa "0.3.4"]
                       [clj-ns-browser "1.3.1"]]

        :global-vars {*print-length* 30}

        :injections [(require 'spyscope.core)
                     (require '[vinyasa.inject :as inject])

                     (require 'io.aviso.repl
                              'clojure.repl
                              'clojure.main)

                     (inject/in clojure.core [clojure.repl apropos dir doc find-doc source [root-cause cause]])
                     ;; (inject/in clojure.core [clojure.tools.namespace.repl [refresh refresh]])
                     (inject/in clojure.core [clojure.reflect reflect])
                     (inject/in clojure.core [clojure.pprint [pprint >pprint print-table]])
                     (inject/in clojure.core [io.aviso.binary [write-binary >bin]])
                     (inject/in clojure.core [vinyasa.inject [inject inject]])
                     (inject/in clojure.core [vinyasa.pull [pull pull]])
                     (inject/in clojure.core [vinyasa.lein [lein lein]])


                     (alter-var-root #'clojure.main/repl-caught
                                     (constantly @#'io.aviso.repl/pretty-pst))
                     (alter-var-root #'clojure.repl/pst
                                     (constantly @#'io.aviso.repl/pretty-pst))]}}
