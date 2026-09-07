<div align="center">

<a href="https://payam-resan.com">
  <img src=".github/assets/logo.svg" width="64" height="64" alt="Payam Resan">
</a>

<h1>curl examples for the Payam Resan SMS web service</h1>

Talk to the <a href="https://payam-resan.com"><b>Payam Resan SMS panel</b></a> with curl<br>
One runnable script per API method

[![API](https://img.shields.io/badge/API-V3-0a7cbd)](https://payam-resan.com)
[![curl](https://img.shields.io/badge/curl-7.18%2B-073551)](https://curl.se)
[![jq](https://img.shields.io/badge/jq-1.6%2B-3b7dd8)](https://jqlang.github.io/jq/)
[![License](https://img.shields.io/badge/license-MIT-6e7781)](LICENSE)

<a href="README.md">فارسی</a> · <b>English</b>

</div>

<sub>Looking for another language? The same examples exist for the others at
[github.com/Mojeshahr](https://github.com/Mojeshahr).</sub>

---

## Quick start

```bash
git clone https://github.com/Mojeshahr/curl-sms-webservice.git
cd curl-sms-webservice

export PAYAM_RESAN_API_KEY='123456-XXXXXXXXXXXXXXX'
export PAYAM_RESAN_SENDER='30004040'

./examples/v3/account-info.sh
```

Start with `account-info.sh`. It sends nothing, spends no credit, and if it
answers then both the key and the connection are fine.

## This repository earns its place before any language does

When a send is not working, the first question is whether the fault is in your
code or in the account and the network. One `curl` answers it and ends the
argument. That is why it has a repository of its own, and why a `curl` tab sits
beside every method's sample in every language.

Its second audience is the person with no programming language involved at all:
a cron script, a CI hook, or a line in a monitoring server that has to raise an
alert.

## Why jq is a dependency

These repositories have a no-dependency rule, and this is its one exception
here. The shell has no JSON parser. The alternative is `grep` over the response
text, which is the wrong lesson and worse when copied: a different field order
or one extra space breaks it silently.

So `jq` comes in, the way the Java repository took Gson. One dependency, well
known, and one command to install:

```bash
sudo apt install jq       # Debian and Ubuntu
sudo dnf install jq       # Fedora and RHEL
brew install jq           # macOS
```

On Windows without `jq`, the
[powershell-sms-webservice](https://github.com/Mojeshahr/powershell-sms-webservice)
repository does all of this with `Invoke-RestMethod` and no external tool.

## The methods

| Example | Method | What it does |
|---|---|---|
| [account-info.sh](examples/v3/account-info.sh) | `AccountInfo` | Credit and active lines |
| [send.sh](examples/v3/send.sh) | `Send` | Simple send over `GET` |
| [send-bulk.sh](examples/v3/send-bulk.sh) | `SendBulk` | One text to many recipients, with tracking ids |
| [send-multiple.sh](examples/v3/send-multiple.sh) | `SendMultiple` | A separate text per recipient |
| [token-list.sh](examples/v3/token-list.sh) | `TokenList` | The account's templates |
| [send-token-single.sh](examples/v3/send-token-single.sh) | `SendTokenSingle` | Send a template to one number |
| [send-token-single-get.sh](examples/v3/send-token-single-get.sh) | `SendTokenSingle` | The same, over `GET` |
| [send-token-multi.sh](examples/v3/send-token-multi.sh) | `SendTokenMulti` | One template, many recipients |
| [status-by-id.sh](examples/v3/status-by-id.sh) | `StatusById` | Status by the service's id |
| [status-by-user-trace-id.sh](examples/v3/status-by-user-trace-id.sh) | `StatusByUserTraceId` | Status by your own id |
| [get-inbox.sh](examples/v3/get-inbox.sh) | `GetInbox` | Messages people sent to your lines |

## Before sending anything real

There is a sandbox server that answers exactly like production but sends no
message and spends no credit. Swap `V3` for `V3SandBox` in the URL. The one
exception is `TokenList`, which the sandbox does not implement.

## The scripts are written in English

Unlike the other repositories, the comments and error messages in these files
are English. That is not a preference: Persian text inside a shell script comes
out garbled in many terminals and over `ssh`, and it makes the file hard to
edit.

The one place Persian appears is the message text inside the JSON body, because
that is the data actually being sent to the service.

## Things that will save you time

**Do not read the HTTP status code.** The service answers `200` to everything,
including a wrong key, so even `curl -f` does not help here. Decide on the
`Success` field, as every example does.

**Do not swap `--data-urlencode` for `-d`.** In `send.sh` that switch encodes
the text exactly once. Encode it yourself as well and the message arrives full
of `%D8`.

**Recipient numbers carry no leading zero.** Use `9121112222`, or
`989121112222` with the country code. A number that does not start with `9` or
`989` returns error code `13`.

**Send a unique `UserTraceId` per recipient.** After a timeout it is the only
way to learn whether the message was registered.

## Key safety

The key is a secret, and with `curl` it has two hazards of its own.

Never put it on the command line. Anything passed as an argument is visible in
the shell history and in the system process list, which means any other user on
that machine can read it. The examples read it from the environment for exactly
this reason.

And in production, leave the `Send` method and the `GET` template variant
alone. There the key sits in the URL, where it is written to the web server log
and the `Referer` header.

If a key leaks, issue a new one from the panel. A deleted key never comes back.

## Layout

| Path | What it holds |
|---|---|
| `examples/v3/` | One self-contained script per service operation |
| `.env.example` | The environment variables the examples read |

The `v3` in the path is deliberate. A new service version means a new
`examples/v<n>/`, with the existing folder left alone.

## Documentation and support

The full guide is at [docs.payam-resan.com](https://docs.payam-resan.com). The
machine-readable OpenAPI description is in
[sms-webservice-spec](https://github.com/Mojeshahr/sms-webservice-spec).

## License

MIT. Full text in [`LICENSE`](LICENSE).
