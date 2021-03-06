CASK ?= cask

-include makefile-local

ifdef EMACS
EMACS_ENV=EMACS=$(EMACS)
endif


.DEFAULT_GOAL=all

all: install test

.default: all

install:
	$(EMACS_ENV) $(CASK) install

test: install just-test

just-test:
	$(EMACS_ENV) $(CASK) emacs --batch -q \
	--directory=. \
	--load "assess-discover" \
	--funcall assess-discover-run-and-exit-batch

org:
	$(EMACS_ENV) $(CASK) emacs --debug --script build.el -- gen-org

html: org
	$(EMACS_ENV) $(CASK) emacs --debug --script build.el -- gen-html

install-test:
	echo [install] Installation Test Starting
	$(MAKE) -C test/install-test/ test

travis:
	$(MAKE) test install-test html 2>&1 | grep --invert-match "newer than"

COMMIT_DATE = $(shell date +%y-%m-%d-%H-%m)
DISTRIB-LENTIC=../distrib-lentic

# commit-distrib: info
# 	cp lentic*.info $(DISTRIB-LENTIC)
# 	cd $(DISTRIB-LENTIC);git pull;git add -A;git commit -m "automated-commit $(COMMIT_DATE)"

clean:
	-rm lentic.org
	-rm lentic-*.org
	-rm lenticular.html


-include Makefile-local

.PHONY: test org
