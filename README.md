# mkcls
Franz Och's `mkcls`

### Recommended usage

    ./run-mkcls.pl --help

Some more details about what's going on here, as well as citation information, can be [read here](http://statmt.blogspot.com/2014/07/understanding-mkcls.html).

This wrapper script puts the output into a format that is similar to [Percy Liang's Brown clustering implementat](https://github.com/percyliang/brown-cluster), which several tools use. This lets you use `mkcls` output in place of `wcluster` in some them.

### very good, but slow clusters

    ./mkcls -c101 -n10 -ptrain.txt -Vout ISR

