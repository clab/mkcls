# mkcls
Franz Och's `mkcls`

### Overview
`mkcls` is a suite of algorithms for clustering words based on bigram contextual similarity written by Franz Och. The quality of the clusters is quite good relative those produced by similar techniques and may be useful.

### Recommended usage

    ./run-mkcls.pl --help

This wrapper script puts the output into a format that is similar to [Percy Liang's Brown clustering implementat](https://github.com/percyliang/brown-cluster), which several tools use. This lets you use `mkcls` output in place of `wcluster` in some them.

### More information

Details about what's going on inside `mkcls`, as well as citation information, can be [found here](http://statmt.blogspot.com/2014/07/understanding-mkcls.html).


