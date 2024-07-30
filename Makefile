# ansible
BINDIR ?= $(HOME)/.local/bin
ANSIBLE_HOME ?= $(HOME)/.ansible
ANSIBLE_PLAYBOOK := $(BINDIR)/ansible-playbook

# ansible-playbook
PLAYBOOK_HOSTS ?= localhost
PLAYBOOK_ARGS ?= --become

.DEFAULT_GOAL=help
.PHONY: help
help:
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {\
		printf "\033[36m%-10s\033[0m %s\n", $$1, substr($$0, index($$0,$$3)) \
	}' $(MAKEFILE_LIST)

.PHONY: pipx
pipx:
	command -v pipx >/dev/null || { \
		sudo apt-get update -y && \
		sudo apt-get install -y pipx; \
	}

.PHONY: ansible
ansible: pipx
	command -v ansible >/dev/null || { \
		pipx install ansible && \
		ln -sf $(HOME)/.local/pipx/venvs/ansible/bin/ansible* $(HOME)/.local/bin/; \
	}

.PHONY: install
install: ansible  ## deploy subconverter with ansible-playbook
	$(ANSIBLE_PLAYBOOK) playbook.yaml $(PLAYBOOK_ARGS) \
		-e 'playbook_hosts=$(PLAYBOOK_HOSTS)'
