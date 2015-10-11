{:user {:plugins [[cider/cider-nrepl "0.10.0-SNAPSHOT"]
		  [lein-auto "0.1.2"]
		  [com.jakemccrary/lein-test-refresh "0.11.0"]
                  [lein-localrepo "0.5.3"]
                  [lein-ancient "0.6.7"]]

	:dependencies [[org.clojure/tools.nrepl "0.2.11"]
                       [im.chit/vinyasa "0.4.2"] ; pull
                       [org.clojure/tools.namespace "0.2.10"] ; refresh
                       [spyscope "0.1.5"] ; fancy println
                       [leiningen "2.5.3"]
                       [io.aviso/pretty "0.1.19"]
                       [org.clojure/tools.reader "0.10.0"]
                       [pjstadig/humane-test-output "0.7.0"]
                       ;; [aprint "0.1.3"]
                       [org.clojure/tools.trace "0.7.9"]]

        :ultra {:color-scheme :solarized_dark}

        :global-vars {*print-length* 100}

        :injections [(require '[vinyasa.inject :as inject])
                     (inject/in clojure.core
                                [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]
                                clojure.core >
                                ;; [vinyasa.pull pull]
                                [clojure.tools.namespace.repl refresh]
                                [clojure.repl doc source]
                                [clojure.pprint pprint pp])

                     ;; better test output
                     (require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)

                     ;; pretty-print stack traces
                     (require 'io.aviso.repl
                              'clojure.repl
                              'clojure.main)
                     (alter-var-root #'clojure.main/repl-caught
                                     (constantly @#'io.aviso.repl/pretty-pst))
                     (alter-var-root #'clojure.repl/pst
                                     (constantly @#'io.aviso.repl/pretty-pst))

                     (require '[clojure.tools.trace :as ttrace])
                     (require '[spyscope.core :as ss])]
        :aliases {"slamhound" ["run" "-m" "slam.hound"]}}}
