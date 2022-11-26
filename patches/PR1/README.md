This patch uses the names for signals rather than the numbers
so that on z/OS we can avoid a warning about signal 13 because it is
not a well-known POSIX signal number, and can instead use SIGPIPE.

This also has the advantage to be easier to understand for people
less familiar with the signal numbers.
