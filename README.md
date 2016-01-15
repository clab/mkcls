# mkcls
Franz Och's `mkcls`

### Overview
`mkcls` is a suite of algorithms for clustering words based on bigram contextual similarity written by Franz Och. The quality of the clusters is quite good relative those produced by similar clustering algorithms.

### Recommended usage

    ./run-mkcls.pl --help

This wrapper script helps set up the arguments to `mkcls` properly, and puts the output into a format that is similar to the one used by [Percy Liang's Brown clustering implemention](https://github.com/percyliang/brown-cluster), which several tools use. This lets you use `mkcls` output in place of `wcluster`'s, which can give slightly better results in some applications.

### More information

Details about what's going on inside `mkcls`, as well as citation information, can be [found here](http://statmt.blogspot.com/2014/07/understanding-mkcls.html).


