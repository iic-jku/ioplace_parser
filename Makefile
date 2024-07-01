PYTHON3 ?= python3
ANTLR4 ?= antlr4

all: dist

.PHONY: dist
dist: venv/manifest.txt _ioplace_parser_antlr/ioParser.py
	./venv/bin/poetry build

.PHONY: lint
lint: venv/manifest.txt
	./venv/bin/black --check .
	./venv/bin/flake8 .
	./venv/bin/mypy --check-untyped-defs .

antlr: _ioplace_parser_antlr/ioParser.py
_ioplace_parser_antlr/ioParser.py: ioLexer.g io.g
	$(ANTLR4) -Dlanguage=Python3 -o $(@D) $^

venv: venv/manifest.txt
venv/manifest.txt: pyproject.toml
	rm -rf venv
	$(PYTHON3) -m venv ./venv
	PYTHONPATH= ./venv/bin/python3 -m pip install --upgrade pip
	PYTHONPATH= ./venv/bin/python3 -m pip install --upgrade wheel poetry poetry-plugin-export
	PYTHONPATH= ./venv/bin/poetry export --with dev --without-hashes --format=requirements.txt --output=requirements_tmp.txt
	PYTHONPATH= ./venv/bin/python3 -m pip install --upgrade -r requirements_tmp.txt
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
