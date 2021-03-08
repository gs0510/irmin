.PHONY: all clean test fuzz bench-pack bench-layers bench doc examples
.SILENT: dataset/trace.json bench-tree bench-layers

all:
	dune build

test:
	dune runtest

dataset/trace.json:
	if [ ! -d "dataset" ]; then git clone https://github.com/icristescu/dataset.git; fi
	if [ ! -f "trace.json" ]; then tar -xzvf dataset/trace.tar.gz; fi

bench-tree: dataset/trace.json
	dune exec -- bench/irmin-pack/tree.exe trace.json --mode quick -j

bench-layers:
	dune exec -- ./bench/irmin-pack/layers.exe -n 2005 -b 2 -j

bench: bench-layers bench-tree

fuzz:
	dune build @fuzz --no-buffer

examples:
	dune build @examples

clean:
	dune clean

doc:
	dune build @doc
