{:user {:plugins [[cider/cider-nrepl "0.15.0-SNAPSHOT"]
                  [refactor-nrepl "2.3.0-SNAPSHOT"]
                  [lein-ancient "0.6.8"]
                  ;; [venantius/ultra "0.3.4"] ; repl colors ; 0.4.0 fails, try later
                  [jonase/eastwood "0.2.3"]
                  ;; [jonase/eastwood "0.2.1"] ; linting
                  ;; [lein-kibit "0.0.8"] ; idiomatic code
                  ;; [lein-bikeshed "0.2.0"] ; more linting
                  ;; [datomic-schema-grapher "0.0.1"] ; make pictures of schema
                  ;; [lein-autoreload "0.1.0"] ; sync file -> repl
                  ]
        :dependencies [[org.clojure/tools.nrepl "0.2.12"]
                       [org.clojure/tools.namespace "0.3.0-alpha3"]
                       [im.chit/vinyasa "0.3.4"] ; pull ; 0.4.2 fails, try later
                       [spyscope "0.1.5"] ; fancy println
                       ;; [alembic "0.3.2"] ; deps loading
                       ;; [io.aviso/pretty "0.1.18"] ; stacktrace
                       ;; [pjstadig/humane-test-output "0.7.0"] ; better test out
                       ;; [slamhound "1.5.5"] ; ns form cleaner
                       ;; [clj-ns-browser "1.3.1"]
                       ;; [aprint "0.1.3"] ; another pprint
                       ;; [org.clojure/tools.trace "0.7.8"] ; trace
                       ;; [datomic-schema-grapher "0.0.1"]
                       ]

        :ultra {:color-scheme :solarized_dark}

        ; :repl-options {:init (do (require 'aprint.core))}
        :injections
        [(require '[vinyasa.inject :as inject])
         (inject/in
           clojure.core
           ; [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]
           clojure.core -
           ; [vinyasa.pull pull]
           [clojure.tools.namespace.repl refresh]
           [clojure.repl doc source]
           [clojure.test run-tests]
           ;; [alembic.still distill load-project]

           #_[clojure.tools.trace trace]
           #_[aprint.core aprint]
           #_[clojure.pprint pprint pp]
           #_[clojure.java.shell sh])

         (require 'spyscope.core)

         ;; https://github.com/boot-clj/boot/wiki/Repl-reloading
         ;; (require '[clojure.tools.namespace.repl :as r])
         ;; (apply r/set-refresh-dirs ["src"])

         ;; ;; better test output
         ;; (require 'pjstadig.humane-test-output)
         ;;             (pjstadig.humane-test-output/activate!)

         ;; ;; another version of pretty print
         ;; (require 'aprint.core)
         ;; (alter-var-root #'clojure.core/print
         ;;                 (constantly @#'aprint.core/aprint))

         ;; ;; pretty-print stack traces
         ;; (require 'io.aviso.repl
         ;;          'clojure.repl
         ;;          'clojure.main)
         ;; (alter-var-root #'clojure.main/repl-caught
         ;;                 (constantly @#'io.aviso.repl/pretty-pst))
         ;; (alter-var-root #'clojure.repl/pst
         ;;                 (constantly @#'io.aviso.repl/pretty-pst))

         ;; (require '[clojure.tools.trace :as t])
         ]
        ;; :aliases {"slamhound" ["run" "-m" "slam.hound"]}
        ; :jvm-opts ["-XX:MaxPermSize=512m"]
        }}

;; :datomic {:install-location "/Users/rburrows/datomic-pro-0.9.4324"}
;; http://z.caudate.me/give-your-clojure-workflow-more-flow/
#_{:user {:plugins [[cider/cider-nrepl "0.13.0-SNAPSHOT"]
                  [refactor-nrepl "2.3.0-SNAPSHOT"]
                  [lein-ancient "0.6.8"]
                  [jonase/eastwood "0.2.3"]
                  ;; [venantius/ultra "0.3.4"] ; repl colors ; 0.4.0 fails, try later
                  ;; [jonase/eastwood "0.2.1"] ; linting
                  ;; [lein-kibit "0.0.8"] ; idiomatic code
                  ;; [lein-bikeshed "0.2.0"] ; more linting
                  ;; [datomic-schema-grapher "0.0.1"] ; make pictures of schema
                  ;; [lein-autoreload "0.1.0"] ; sync file -> repl
                  ]
        :dependencies [[org.clojure/tools.nrepl "0.2.12"]
                       [org.clojure/tools.namespace "0.3.0-alpha3"]
                       [im.chit/vinyasa "0.3.4"] ; pull ; 0.4.2 fails, try later
                       [spyscope "0.1.5"] ; fancy println
                       ;; [alembic "0.3.2"] ; deps loading
                       ;; [io.aviso/pretty "0.1.18"] ; stacktrace
                       ;; [pjstadig/humane-test-output "0.7.0"] ; better test out
                       ;; [slamhound "1.5.5"] ; ns form cleaner
                       ;; [clj-ns-browser "1.3.1"]
                       [org.clojure/tools.trace "0.7.9"]
                       ;; [aprint "0.1.3"] ; another pprint
                       ;; [org.clojure/tools.trace "0.7.8"] ; trace
                       ;; [datomic-schema-grapher "0.0.1"]
                       ]

        :ultra {:color-scheme :solarized_dark}

        ; :repl-options {:init (do (require 'aprint.core))}
        :injections
        [(require '[vinyasa.inject :as inject])
         (inject/in
           clojure.core
           ; [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]
           clojure.core -
           ; [vinyasa.pull pull]
           [clojure.tools.namespace.repl refresh]
           [clojure.repl doc source]
           [clojure.test run-tests]
           ;; [alembic.still distill load-project]

           #_[clojure.tools.trace trace]
           #_[aprint.core aprint]
           #_[clojure.pprint pprint pp]
           #_[clojure.java.shell sh])

         (require 'spyscope.core)

         ;; https://github.com/boot-clj/boot/wiki/Repl-reloading
         (require '[clojure.tools.namespace.repl :as r])
         (apply r/set-refresh-dirs ["src"])

         ;; better test output
         (require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)

         ;; another version of pretty print
         (require 'aprint.core)
         (alter-var-root #'clojure.core/print
                         (constantly @#'aprint.core/aprint))

         ;; pretty-print stack traces
         (require 'io.aviso.repl
                  'clojure.repl
                  'clojure.main)
         (alter-var-root #'clojure.main/repl-caught
                         (constantly @#'io.aviso.repl/pretty-pst))
         (alter-var-root #'clojure.repl/pst
                         (constantly @#'io.aviso.repl/pretty-pst))

         (require '[clojure.tools.trace :as t])
         ]
        ;; :aliases {"slamhound" ["run" "-m" "slam.hound"]}
        ; :jvm-opts ["-XX:MaxPermSize=512m"]
        }}

;; :datomic {:install-location "/Users/rburrows/datomic-pro-0.9.4324"}
;; http://z.caudate.me/give-your-clojure-workflow-more-flow/


#_{:user {:plugins [[refactor-nrepl "2.3.0-SNAPSHOT"]
                  [cider/cider-nrepl "0.13.0-SNAPSHOT"]
                  [lein-auto "0.1.2"]
                  [com.jakemccrary/lein-test-refresh "0.14.0"]
                  [lein-localrepo "0.5.3"]
                  [lein-ancient "0.6.10"]
                  [lein-git-deps "0.0.2"]]

        :dependencies [;;[clj-http "3.0.1"] ; here b/c lein uses 0.9 which causes problems
                       [org.clojure/tools.nrepl "0.2.12"]
                       [im.chit/vinyasa "0.3.4"] ; pull
                       [org.clojure/tools.namespace "0.2.10"] ; refresh
                       [spyscope "0.1.5"]
                       [leiningen "2.6.1"]
                       [io.aviso/pretty "0.1.26"]
                       [org.clojure/tools.reader "0.10.0"]
                       [pjstadig/humane-test-output "0.8.0"]
                       [org.clojure/tools.trace "0.7.9"]
                       [alembic "0.3.2"]
                       [difform "1.1.2"]
                       [lein-cloverage "1.0.6"]]

        :test-refresh {:notify-command ["terminal-notifier" "-title" "Tests" "-message"]}
        :ultra {:color-scheme :solarized_dark}
        :global-vars {*print-length* 100}

        :injections [(require 'spyscope.core)
                     (require '[vinyasa.inject :as inject])
                     (require 'io.aviso.repl)
                     (require 'com.georgejahad.difform)

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
                     (require '[spyscope.core :as ss])

                     (inject/in ;; the default injected namespace is `.`

                      ;; note that `:refer, :all and :exclude can be used
                      [vinyasa.inject :refer [inject [in inject-in]]]
                      [vinyasa.lein :exclude [*project*]]
                      [vinyasa.reimport :refer [reimport]]

                      ;; imports all functions in vinyasa.pull
                      [alembic.still [distill pull]]

                      ;; inject into clojure.core
                      clojure.core
                      [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]
                      [clojure.repl doc]

                      ;; inject into clojure.core with prefix
                      clojure.core >
                      [clojure.pprint pprint]
                      [clojure.java.shell sh]
                      [clojure.tools.namespace.repl refresh]
                      [clojure.repl doc source]
                      [clojure.pprint pprint pp]
                      [com.georgejahad.difform difform])]

        #_:aliases #_{"slamhound" ["run" "-m" "slam.hound"]
                  "ancient!" ["do" "ancient" "upgrade" ":recursive" ":all" ":no-tests,"
                              "ancient" "upgrade-profiles" ":recursive" ":all"]}}}


#_{:user {:plugins [[refactor-nrepl "2.3.0-SNAPSHOT"]
                  [cider/cider-nrepl "0.13.0-SNAPSHOT"]
                  [lein-auto "0.1.2"]
                  [com.jakemccrary/lein-test-refresh "0.14.0"]
                  [lein-localrepo "0.5.3"]
                  [lein-ancient "0.6.10"]
                  [lein-git-deps "0.0.2"]
                  [venantius/ultra "0.3.4"]]

        :dependencies [;;[clj-http "3.0.1"] ; here b/c lein uses 0.9 which causes problems
                       [org.clojure/tools.nrepl "0.2.12"]
                       [im.chit/vinyasa "0.3.4"] ; pull
                       [org.clojure/tools.namespace "0.2.10"] ; refresh
                       [spyscope "0.1.5"]
                       [leiningen "2.6.1"]
                       [io.aviso/pretty "0.1.26"]
                       [org.clojure/tools.reader "0.10.0"]
                       [pjstadig/humane-test-output "0.8.0"]
                       [org.clojure/tools.trace "0.7.9"]
                       [alembic "0.3.2"]
                       [difform "1.1.2"]
                       [lein-cloverage "1.0.6"]]

        :test-refresh {:notify-command ["terminal-notifier" "-title" "Tests" "-message"]}

        :ultra {:color-scheme :solarized_dark}

        :global-vars {*print-length* 100}

        :injections [(require 'spyscope.core)
                     (require '[vinyasa.inject :as inject])
                     (require 'io.aviso.repl)
                     (require 'com.georgejahad.difform)

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
                     (require '[spyscope.core :as ss])

                     (inject/in ;; the default injected namespace is `.`

                      ;; note that `:refer, :all and :exclude can be used
                      [vinyasa.inject :refer [inject [in inject-in]]]
                      [vinyasa.lein :exclude [*project*]]
                      [vinyasa.reimport :refer [reimport]]

                      ;; imports all functions in vinyasa.pull
                      [alembic.still [distill pull]]

                      ;; inject into clojure.core
                      clojure.core
                      [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]
                      [clojure.repl doc]

                      ;; inject into clojure.core with prefix
                      clojure.core >
                      [clojure.pprint pprint]
                      [clojure.java.shell sh]
                      [clojure.tools.namespace.repl refresh]
                      [clojure.repl doc source]
                      [clojure.pprint pprint pp]
                      [com.georgejahad.difform difform])]

        :aliases {"slamhound" ["run" "-m" "slam.hound"]
                  "ancient!" ["do" "ancient" "upgrade" ":recursive" ":all" ":no-tests,"
                              "ancient" "upgrade-profiles" ":recursive" ":all"]}}}
