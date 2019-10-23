ifeq ($(shell curl --version >/dev/null 2>&1 || echo FAIL),)
download = curl -f -L -- "$(1)" > "$@.tmp" && touch $@.tmp && mv $@.tmp $@
else ifeq ($(shell wget --version >/dev/null 2>&1 || echo FAIL),)
download = rm -f $@.tmp && \
	wget --passive -c -p -O $@.tmp "$(1)" && \
	touch $@.tmp && \
	mv $@.tmp $@
else ifeq ($(which fetch >/dev/null 2>&1 || echo FAIL),)
download = rm -f $@.tmp && \
	fetch -p -o $@.tmp "$(1)" && \
	touch $@.tmp && \
	mv $@.tmp $@
else
download = $(error Neither curl nor wget found!)
endif

# mmark
mmark_$(MMARK_VERSION)_linux_amd64.tgz:
	$(call download,https://github.com/mmarkdown/mmark/releases/download/v$(MMARK_VERSION)/mmark_$(MMARK_VERSION)_$(MMARK_OS)_$(MMARK_MACHINE).tgz)

mmark: mmark_$(MMARK_VERSION)_linux_amd64.tgz
	tar xvzf $^

.buildmmark: mmark

.uninstall_mmark:
	$(RM) mmark

# xml2rfc
.buildxml2rfc:
	pip install xml2rfc

.uninstall_xml2rfc:
	pip uninstall -y xml2rfc

clean: .uninstall_mmark .uninstall_xml2rfc
