#!/usr/bin/env roundup

describe "train_chunker.py"

it_displays_usage_when_no_arguments() {
	./train_chunker.py 2>&1 | grep -q "usage: train_chunker.py"
}

it_needs_corpus_reader() {
	last_line=$(./train_chunker.py foo 2>&1 | tail -n 1)
	test "$last_line" "=" "ValueError: you must specify a corpus reader"
}

it_cannot_import_reader() {
	last_line=$(./train_chunker.py foo --reader nltk.corpus.reader.Foo 2>&1 | tail -n 1)
	test "$last_line" "=" "ValueError: cannot find corpus path for foo"
}

it_cannot_find_foo() {
	last_line=$(./train_chunker.py foo --reader nltk.corpus.reader.ChunkedCorpusReader 2>&1 | tail -n 1)
	test "$last_line" "=" "ValueError: cannot find corpus path for foo"
}

it_trains_treebank_chunk() {
	test "$(./train_chunker.py treebank_chunk --no-pickle --no-eval --fraction 0.5)" "=" "loading treebank_chunk
4009 chunks, training on 2005
training ub TagChunker"
}

it_trains_corpora_treebank_tagged() {
	test "$(./train_chunker.py corpora/treebank/tagged --reader nltk.corpus.reader.ChunkedCorpusReader --no-pickle --no-eval --fraction 0.5)" "=" "loading corpora/treebank/tagged
51002 chunks, training on 25501
training ub TagChunker"
}