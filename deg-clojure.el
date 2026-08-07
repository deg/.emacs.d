;;; Clojure and friends  -- DISABLED, NOT LOADED

;; Kept for reference only.  init.el no longer loads this file, and nothing in
;; here runs.
;;
;; Last real revision 05Sep18; the 13May26 commit that renamed clojure.el to
;; deg-clojure.el changed no lines.  Disabled 07Aug26.
;;
;; Four of the live forms below were never Clojure-specific, and this file was
;; the whole config's only source for them, so they were copied to real homes
;; before the load line went away.  They are left here too, inert, so the file
;; still reads as it did:
;;
;;   prog-mode-hook rainbow-delimiters-mode  ->  display.el
;;   prog-mode-hook subword-mode             ->  init.el
;;   C-c ; comment-region                    ->  bindings.el
;;   <s-backspace> kill-backward-up-list     ->  bindings.el
;;
;; The Clojure-specific parts had rotted: `cider-jack-in' now takes an argument
;; the call below does not pass, and `cider-jack-in-clojurescript' no longer
;; exists in CIDER at all.  cider and clojure-mode are still in `my-packages';
;; nothing loads them now.

(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

(require 'clojure-mode)
(define-clojure-indent
  (trace-forms 'defun)
  (assoc-if 'defun)
  (firebase/watching 'defun))

;; rainbow delimiters (See color settings in init.el)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; CamelCase support for Java names
(add-hook 'prog-mode-hook 'subword-mode)


(global-set-key (kbd "<s-backspace>") 'kill-backward-up-list)
(global-set-key (kbd "C-c ;") 'comment-region)



;; deg [10:49 PM]
;; My machine gets extremely slow (freezes for many seconds) when I have a few REPLs running.  I have 32GB RAM, so I assume I have enough memory.
;; But, I notice that each java process is using about 12GB of VM.
;; My guess is that the maximum VM size of each REPL is a function of total memory, and my large memory is simply causing each Java instance to grow very large, rather than  GCing.
;; Is this correct? and, can I improve performance by limiting the size of each instance?
;;
;;
;; ghadi [10:50 PM]
;; yeah set `-Xmx` on each.  You running docker? (edited)
;;
;;
;; deg [10:52 PM]
;; No.
;;
;;
;; [10:53]
;; Running Cider+Emacs on a CLJS program, so (at least) two instances there.
;;
;;
;; [10:53]
;; Plus, lots of other cruft running on the machine: a Windows VM that also grabs about 10GB of VM, and many Chrome windows.
;;
;;
;; [10:54]
;; What is a reasonable -Xmx to set?  I assume I can specify it somewhere in project.clj?
;;
;;
;; deg [11:02 PM]
;; @ghadi - Ok, I set `:jvm-opts ["-Xmx2g"]` at the top level of my defproject.  It seems to have partially worked.  One java has dropped to VM=6.7GB, but the other is still at VM=11.2GB,
;; I assume that something (nrepl?) was not affected by the setting? And not sure why the affected one did not drop down to closer to 2GB.
;;
;;
;; adambard [11:07 PM]
;; It seems there exist both JVM_OPTS and LEIN_JVM_OPTS environment variables, perhaps playing with those a bit might be informative (via https://github.com/technomancy/leiningen/blob/master/sample.project.clj#L510)
;; GitHub
;; technomancy/leiningen
;; leiningen - Automate Clojure projects without setting your hair on fire.
;;
;;
;;
;; [11:08]
;; I'm not an expert, but it seems likely to me that leiningen itself wouldn't use the `:jvm-opts` project setting, since it couldn't read it before it was started up.
;;
;;
;; baritonehands [11:09 PM]
;; I've got a REPL middleware question: Say I wanted to add some middleware to add some restrictions to what you can eval. How difficult would that be?
;;
;;
;; [11:09]
;; More context: I'd like to add an annotation and only allow operations on annotated classes
;;
;;
;; deg [11:10 PM]
;; @adambard . Thanks, but adding :lein-jvm-opts did not seem to make any further difference.
;;
;;
;; noisesmith [11:10 PM]
;; it won’t work as a key in the project
;;
;;
;; adambard [11:10 PM]
;; you'd need to do it in your environment before spinning lein up, if the other thing I said is in any way correct
;;
;;
;; noisesmith [11:10 PM]
;; it has to be an env var
;;
;;
;; adambard [11:11 PM]
;; e.g. `LEIN_JVM_OPTS="-Xmx2g" lein repl`
;;
;;
;; deg [11:11 PM]
;; The good news is, at least for my immediate problem, just setting :jvm-opts was enough to make the machine more responsive.
;;
;;
;; noisesmith [11:11 PM]
;; @deg lein itself runs only via the jvm, it can’t use an option for its jvm that it would need a jvm to parse
;;
;;
;; [11:11]
;; which is why you then need the env var
;;
;;
;; [11:12]
;; (for startup options at least)
;;
;;
;; deg [11:12 PM]
;; But, I'd like to get that working too. I don't think I can do it easily on the command line, since I'm launching from inside emacs. But, I'll set it globally, I guess.
;;
;;
;; noisesmith [11:13 PM]
;; @deg `M-x setenv`
;;
;;
;; [11:13]
;; it’s that simple
;;
;;
;; deg [11:13 PM]
;; Oh   (head slap)
;;
;;
;; [11:13]
;; thanks
;;
;;
;; ghadi [11:13 PM]
;; @deg your VM=whatever measurement might not be accurate.
;;
;;
;; noisesmith [11:13 PM]
;; (or maybe it’s set-environment-variable - shouldn’t take long to find the thing)
;;
;;
;; ghadi [11:13 PM]
;; `jps -lvm` to ensure the command line flags to each jvm
;;
;;
;; [11:14]
;; there's also `jstat -gccapacity $pid` for lower level information about heaps
;;
;;
;; deg [11:14 PM]
;; Cool, I did not know about jps.  Or M-x setenv
;;
;;
;; adambard [11:14 PM]
;; @ghadi this easily the most helpful answer, thanks for teaching me that that command exists :slightly_smiling_face:
;;
;;
;; ghadi [11:15 PM]
;; no problem!
;;
;;
;; deg [11:16 PM]
;; Would I be showing my age if I said that the first Lisp I used professionally ran on a machine with a 16MB total address space?   So, a small part of me is REALLY amused by this whole conversation!!
;;
;;
;; [11:17]
;; (For that matter, the first Lisp I used as a student was on a machine with 256KW address space, so 16MB was pretty expansive!!
;;
;;
;; dpsutton [11:18 PM]
;; @deg this will let it prompt you if you like
;; ```(defun jack-in-with-memory (gb)
;;   (interactive "nGB of ram for lein")
;;   (let ((cider-lein-command (format "LEIN_JVM_OPTS=-Xmx%sg lein" gb)))
;;     (cider-jack-in)))
;; ```
;;
;;
;; deg [11:19 PM]
;; Thanks.  (in my case, cider-jack-in-clojurescript, but same difference) (edited)
;;
;;
;; dpsutton [11:19 PM]
;; yup
;;
;;
;; [11:20]
;; i don't know enough about interactive arg programming but i'm sure there's a way to get it to use sensible default and prompt on prefix
;;
;;
;; deg [11:20 PM]
;; https://xkcd.com/378/
;; xkcd
;; Real Programmers
;; [Title text] "Real programmers set the universal constants at the start such that the universe evolves to contain the disk with the data they want." (84kB)
;;
;;
;;
;; [11:24]
;; @dpsutton Does that command work as is for you?  I get an error "The LEIN_JVM_OPTS=-Xmx2G lein executable isn't on your 'exec-path'"
;;
;;
;; dpsutton [11:25 PM]
;; ah dang, yeah, i forgot this is before it does the check that lein is present
;;
;;
;; max-tweddell [11:25 PM]
;; o
;;
;;
;; dpsutton [11:27 PM]
;; there's a `command-global-opts` but those options go after lein, not before
;;
;;
;; [11:29]
;; if you want to submit a patch there's this line in `cider-jack-in`:   `(cmd (format "%s %s" command-resolved params)))` and if you add another %s in there and make a var for environmental params you'd be good to go
;;
;;
;; [11:29]
;; that's the actual command will be invoked. (and its the reason why we're failing command-resolved is not resolved with all the junk at the beginning)
;;
;;
;; deg [11:32 PM]
;; Thanks!  If I have some slack time, I'll try to do this. What project is it in?   (But, realistically, I've got a heap of learning curve before I'm comfortable touching the Cider emacs code, so I probably won't be able to do this)
;;
;;
;; dpsutton [11:33 PM]
;; https://github.com/clojure-emacs/cider/blob/master/cider.el#L627
;; GitHub
;; clojure-emacs/cider
;; cider - The Clojure Interactive Development Environment that Rocks for Emacs
;;
;;
;;
;; [11:33]
;; jump right in! make it your own
;;
;;
;; deg [11:34 PM]
;; :slightly_smiling_face:  I'm not saying that I won't... but I've done too many of these the past few days and gotta focus a bit on the main path.   That said, if no one else jumps in, I'll try to get to it.
;;
;;
;; dpsutton [11:34 PM]
;; dang, i actually might really want that as well. there are a bunch of env variables set in a project here at work
;;
;;
;; [11:34]
;; gotcha


(defun jack-in-with-memory (gb)
  (interactive "nGB of ram for lein: ")
  (let ((cider-lein-command (format "LEIN_JVM_OPTS=-Xmx%sg lein" gb)))
    (cider-jack-in)))

(defun jack-in-clojurescript-with-memory (gb)
  (interactive "nGB of ram for lein: ")
  (let ((cider-lein-command (format "LEIN_JVM_OPTS=-Xmx%sg lein" gb)))
    (cider-jack-in-clojurescript)))


;; (add-hook
;;  'clojure-mode-hook
;;  (lambda ()
;;    (push '("fn" . ?λ) prettify-symbols-alist) ;;  955
;;    (push '("->" . ?→) prettify-symbols-alist) ;; 8594
;;    (push '("->>" . 11246) prettify-symbols-alist) ;; double right arrow
;;    (prettify-symbols-mode 1)))

;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;; Useful bindings
;;;;;--old 01Aug16 old--;;;;   (global-set-key (kbd "C-c i") 'indent-region)
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;; Move nrepl binding to global context
;;;;;--old 01Aug16 old--;;;;   ;;26Nov14;; (global-set-key (kbd "C-c C-z") 'cider-switch-to-repl-buffer)
;;;;;--old 01Aug16 old--;;;;   ;;26Nov14;; (global-set-key (kbd "C-c M-z") 'nrepl-make-connection-default)
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;; **** [TODO] Checked up to here
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;; nrepl (see https://github.com/clojure-emacs/nrepl.el)
;;;;;--old 01Aug16 old--;;;;   (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
;;;;;--old 01Aug16 old--;;;;   ;- (setq nrepl-hide-special-buffers t)
;;;;;--old 01Aug16 old--;;;;   ;- (setq nrepl-popup-stacktraces nil)
;;;;;--old 01Aug16 old--;;;;   ;- (setq nrepl-popup-stacktraces-in-repl t)
;;;;;--old 01Aug16 old--;;;;   (setq cider-auto-select-error-buffer t)
;;;;;--old 01Aug16 old--;;;;   (setq nrepl-buffer-name-separator "-")
;;;;;--old 01Aug16 old--;;;;   (setq nrepl-buffer-name-show-port t)
;;;;;--old 01Aug16 old--;;;;   (setq cider-repl-display-in-current-window t)
;;;;;--old 01Aug16 old--;;;;   ;(set cider-repl-result-prefix ";; => ")
;;;;;--old 01Aug16 old--;;;;   ;(set cider-interactive-eval-result-prefix ";; ==> ")
;;;;;--old 01Aug16 old--;;;;   (setq cider-repl-history-file "~/repl-history.clj-repl")
;;;;;--old 01Aug16 old--;;;;   (add-to-list 'same-window-buffer-names "*nrepl*")
;;;;;--old 01Aug16 old--;;;;   ;-- (add-hook 'nrepl-repl-mode-hook 'smartparens-strict-mode)
;;;;;--old 01Aug16 old--;;;;   ;-- (add-hook 'clojure-mode-hook 'smartparens-strict-mode)
;;;;;--old 01Aug16 old--;;;;   (add-hook 'nrepl-repl-mode-hook 'smartparens-mode)
;;;;;--old 01Aug16 old--;;;;   (add-hook 'clojure-mode-hook 'smartparens-mode)
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;; nrepl-ritz debugger
;;;;;--old 01Aug16 old--;;;;   ;+ (add-hook 'nrepl-interaction-mode-hook 'my-nrepl-mode-setup)
;;;;;--old 01Aug16 old--;;;;   ;+ (defun my-nrepl-mode-setup ()
;;;;;--old 01Aug16 old--;;;;   ;+   (require 'nrepl-ritz))
;;;;;--old 01Aug16 old--;;;;   ;;26Nov14;; (global-set-key [f8] 'cider-jack-in)
;;;;;--old 01Aug16 old--;;;;   ;+ ;; Turn on when problem with Austin is fixed (see
;;;;;--old 01Aug16 old--;;;;      ;; https://degel.fogbugz.com/default.asp?160 and
;;;;;--old 01Aug16 old--;;;;      ;; https://github.com/cemerick/austin/issues/11)
;;;;;--old 01Aug16 old--;;;;   ;+ (global-set-key [f8] 'nrepl-ritz-jack-in)
;;;;;--old 01Aug16 old--;;;;   ;;26Nov14;; (global-set-key [M-f8] 'cider-restart)
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;; SLIME looks nice.
;;;;;--old 01Aug16 old--;;;;   ;;  Look at http://common-lisp.net/project/slime/doc/slime.pdf to see what was lost by nrepl.
;;;;;--old 01Aug16 old--;;;;   ;;  Also, look at clojure-test-mode, which has a slime dependency now
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;;; [TODO] IS ANY OF THIS STILL NEEDED, OR DOES CIDER COMPANY MODE REPLACE IT
;;;;;--old 01Aug16 old--;;;;   ;; ;; Auto complete
;;;;;--old 01Aug16 old--;;;;   ;; (require 'auto-complete-config)
;;;;;--old 01Aug16 old--;;;;   ;; (ac-config-default)
;;;;;--old 01Aug16 old--;;;;   ;; (define-key ac-completing-map "\M-/" 'ac-stop) ; use M-/ to stop completion
;;;;;--old 01Aug16 old--;;;;   ;; ;; ac-nrepl
;;;;;--old 01Aug16 old--;;;;   ;; (require 'ac-nrepl)
;;;;;--old 01Aug16 old--;;;;   ;; (add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
;;;;;--old 01Aug16 old--;;;;   ;; (add-hook 'cider-mode-hook 'ac-nrepl-setup)
;;;;;--old 01Aug16 old--;;;;   ;; (eval-after-load "auto-complete"
;;;;;--old 01Aug16 old--;;;;   ;;   '(add-to-list 'ac-modes 'cider-repl-mode))
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;; (eval-after-load "cider"
;;;;;--old 01Aug16 old--;;;;   ;;   '(define-key cider-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc))
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;; Clojure mode in ClojureLisp buffers.
;;;;;--old 01Aug16 old--;;;;   ;; But, also see here for much more useful stuff later:
;;;;;--old 01Aug16 old--;;;;   ;; https://github.com/brentonashworth/one/wiki/Emacs
;;;;;--old 01Aug16 old--;;;;   (add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
;;;;;--old 01Aug16 old--;;;;   (add-to-list 'auto-mode-alist '("\.cljx$" . clojure-mode))
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;
;;;;;--old 01Aug16 old--;;;;   ;; Indentation
;;;;;--old 01Aug16 old--;;;;   (require 'clojure-mode)
;;;;;--old 01Aug16 old--;;;;   (define-clojure-indent
;;;;;--old 01Aug16 old--;;;;     (ANY 2)
;;;;;--old 01Aug16 old--;;;;     (DELETE 2)
;;;;;--old 01Aug16 old--;;;;     (GET 2)
;;;;;--old 01Aug16 old--;;;;     (HEAD 2)
;;;;;--old 01Aug16 old--;;;;     (POST 2)
;;;;;--old 01Aug16 old--;;;;     (PUT 2)
;;;;;--old 01Aug16 old--;;;;     (append! 1)
;;;;;--old 01Aug16 old--;;;;     (button-group 2)
;;;;;--old 01Aug16 old--;;;;     (context 2)
;;;;;--old 01Aug16 old--;;;;     (defroutes 'defun)
;;;;;--old 01Aug16 old--;;;;     (fill-select-options 1)
;;;;;--old 01Aug16 old--;;;;     (listen! 2)
;;;;;--old 01Aug16 old--;;;;     (remote-callback 2)
;;;;;--old 01Aug16 old--;;;;     (set-html! 1)
;;;;;--old 01Aug16 old--;;;;     (set-inner-html! 1)
;;;;;--old 01Aug16 old--;;;;     (template 2))
