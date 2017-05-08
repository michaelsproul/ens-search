# Ethereum Name Search

This is a little tool for finding nice [Ethereum Name Service][ens] names that are available early
in the 8-week gradual release period.

You can find out more about ENS here: https://registrar.ens.domains/

Names are gradually released based on their hash, so this tool works by hashing permutations
of words from a list. Given the following file, `example.txt`...

```
ethereum
cat
party
```

...running the tool yields the top names which are 2-word permutations of this list:

```
$ ./run.sh example.txt 2
catethereum.eth available at 2017-05-06 06:27:31 UTC
partycat.eth available at 2017-05-11 01:36:00 UTC
ethereumparty.eth available at 2017-05-19 00:02:12 UTC
ethereum.eth available at 2017-05-22 20:21:00 UTC
ethereumcat.eth available at 2017-05-29 15:53:37 UTC
catparty.eth available at 2017-06-02 20:36:43 UTC
partyethereum.eth available at 2017-06-26 07:31:31 UTC
```

You can try longer names by increasing the "permutation limit" (the 2 that we passed earlier).

```
$ ./run.sh example.txt 3
catethereum.eth available at 2017-05-06 06:27:31 UTC
partycatethereum.eth available at 2017-05-06 09:08:00 UTC
partyethereumcat.eth available at 2017-05-09 14:24:34 UTC
partycat.eth available at 2017-05-11 01:36:00 UTC
catethereumparty.eth available at 2017-05-11 11:56:23 UTC
ethereumparty.eth available at 2017-05-19 00:02:12 UTC
ethereum.eth available at 2017-05-22 20:21:00 UTC
catpartyethereum.eth available at 2017-05-22 22:45:58 UTC
ethereumcat.eth available at 2017-05-29 15:53:37 UTC
catparty.eth available at 2017-06-02 20:36:43 UTC
ethereumcatparty.eth available at 2017-06-10 14:25:27 UTC
ethereumpartycat.eth available at 2017-06-22 11:08:14 UTC
partyethereum.eth available at 2017-06-26 07:31:31 UTC
```

Now the tool finds some longer things like `partycatethereum.eth`, which is already available!

## Installation

I wrote this in Haskell for fun, but that might mean it's hard for you to install :(

Probably the easiest way to get going is to install the Haskell build tool Stack, using
the instructions from here: https://docs.haskellstack.org/en/stable/README/

Once you have Stack it should be a matter of:

```
$ # Installing GHC
$ cd ens-search
$ stack setup
$ # Building the project
$ stack build
$ # Running the tool!
$ ./run.sh example.txt 2
```

Please file an issue (or better yet, open a pull request) if you run into build issues!

## License

BSD3, Copyright (c) Michael Sproul 2017.

[ens]: https://registrar.ens.domains/
