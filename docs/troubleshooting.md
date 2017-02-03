# Troubleshooting

## SSH Host key mismatch

This may happen when you attempt to run `cap [stage] deploy`, or any other
Capistrano task that tries to connect to the remote machine, which is most of
them.

Part of the error message says something like this:

```
Net::SSH::HostKeyMismatch: fingerprint [RSA fingerprint] does not match for [host or IP]
```

**Likely Cause:** You have attempted to access the server via SSH using
different host names and/or IP addresses, and in doing so have added multiple
entries for the same host into your `~/.ssh/known_hosts` file.

**Solution:** Delete your `~/.ssh/known_hosts` file. This eliminates any 
confusion caused by `known_hosts` by effectivley resetting it.