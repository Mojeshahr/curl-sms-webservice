# Agent guide

Runnable curl examples for the Payam Resan SMS web service. One script per API
method, and every script has to work on its own.

## Rule one: English only, in every script

Every comment, message and label in `examples/v3/` is English. Persian text
inside a shell script renders as mojibake in many terminals and over `ssh`, and
it makes the file painful to edit. This is the one repository in the family
whose code comments are not Persian, and that is deliberate.

The single exception is the SMS text inside the JSON body, which is Persian
because that is the payload actually sent to the service. The two READMEs stay
Persian and English as everywhere else.

## Rule two: POSIX sh, not bash

The shebang is `#!/usr/bin/env sh` and the scripts are checked with `dash`. No
arrays, no `[[`, no `local`, no process substitution. A reader may be on a
BusyBox container, a router, or a minimal Alpine image.

## Rule three: jq is the one allowed dependency

The shell has no JSON parser, so `jq` is taken under the handbook's exception
for a language whose standard library genuinely lacks something. One dependency,
not two, and the README says why.

Do not replace it with `grep` over the response text. That breaks silently on a
different field order and teaches a habit worth unlearning.

## Rule four: the examples are the documentation

Each file carries `# docs:start` and `# docs:end`. The region between them is
lifted verbatim into the method's page on docs.payam-resan.com, so it is read by
people who have never seen this repository.

Two consequences:

- **Full-line comments are stripped** when the region is lifted. Anything the
  reader must see has to be code. The `Success` check is an `if`, not a note.
- The file name matches the reference page slug exactly: `send-bulk.sh`,
  `status-by-user-trace-id.sh`. A path with two variants gets two files, the
  plain name for `POST` and a `-get` suffix for `GET`.

Note that the `curl` tab already on every method page is generated from the
spec by the docs repository. It is not taken from here, and the two are allowed
to differ: that one is a bare request, these are runnable scripts.

## Rule five: check Success, never the status code

The service answers `200` to everything, including a wrong key and an empty
account. `curl -f` is no help at all here:

```sh
if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi
```

## Rule six: encode once, with --data-urlencode

In the two `GET` examples the query is built with `--data-urlencode`, which
encodes exactly once. Never pre-encode a value and never hand-build the query
string with `-d`.

## Rule seven: a version is a folder

A new service version means a new `examples/v<n>/`. No file inside an existing
version folder is moved or renamed; older versions still have users.

## Secrets

The key comes from `PAYAM_RESAN_API_KEY` in the environment, never from an
argument: anything on the command line is visible in the shell history and in
the process list. No key, no real phone number and no customer name goes into a
file here, not even a dead one. Example numbers are `9121112222` upward and the
example key is `123456-XXXXXXXXXXXXXXX`.

## Layout

| Path | What it holds |
|---|---|
| `examples/v3/` | one self-contained script per service operation |
| `.env.example` | the environment variables the examples read |

## Before every commit

```bash
for f in examples/v3/*.sh; do dash -n "$f" || echo "FAILED $f"; done
```

`dash -n` parses without running, which catches anything that only works in
bash. Then run them against the sandbox by swapping `V3` for `V3SandBox`, so no
message goes out.

## Git

Semantic messages, `type(scope): subject`, with no explanatory body and no
attribution trailer. Commits here are authored as Payam Resan.
