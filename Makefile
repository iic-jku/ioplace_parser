PYTHON3 ?= python3
REQ_FILES = ./requirements_dev.txt ./requirements.txt
REQ_FILES_PFX = $(addprefix -r ,$(REQ_FILES))

all: dist

.PHONY: dist
dist: venv/manifest.txt _ioplace_parser_antlr/ioParser.py
	./venv/bin/python3 setup.py sdist bdist_wheel

.PHONY: lint
lint: venv/manifest.txt
	./venv/bin/black --check .
	./venv/bin/flake8 .
	./venv/bin/mypy --check-untyped-defs .

antlr: _ioplace_parser_antlr/ioParser.py
_ioplace_parser_antlr/ioParser.py: ioLexer.g io.g
	antlr4 -Dlanguage=Python3 -o $(@D) $^

venv: venv/manifest.txt
venv/manifest.txt: $(REQ_FILES)
	rm -rf venv
	$(PYTHON3) -m venv ./venv
	PYTHONPATH= ./venv/bin/python3 -m pip install --upgrade pip
	PYTHONPATH= ./venv/bin/python3 -m pip install --upgrade wheel
	PYTHONPATH= ./venv/bin/python3 -m pip install --upgrade $(REQ_FILES_PFX)
	PYTHONPATH= ./venv/bin/python3 -m pip freeze > $@


.PHONY: clean
clean:
	rm -rf _ioplace_parser_antlr/
	rm -rf build/
	rm -rf dist/
	rm -rf htmlcov/
	rm -rf *.egg-info/
	rm -rf .antlr/
	rm -f .coverage