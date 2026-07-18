---
name: copilot-sdk-init
description: Scaffold a new GitHub Copilot SDK project - use when starting, bootstrapping, or scaffolding a project that embeds the GitHub Copilot SDK. Defaults to TypeScript; use Go or Python only for ecosystem-specific cases.
---

# GitHub Copilot SDK Init Skill

Scaffold a new project that embeds the GitHub Copilot SDK. This skill encodes the
language preference as an explicit action so it applies even in an empty directory,
before any dependency manifest exists (which is where the `applyTo`-scoped
`copilot-sdk.instructions.md` cannot yet match).

## Language choice

**Default to TypeScript.** Only pick a secondary SDK for an ecosystem-specific reason.

| SDK | Package | Choose when |
|-----|---------|-------------|
| **TypeScript** (primary) | `@github/copilot-sdk` | Default for all new work unless a strong ecosystem reason applies. |
| **Go** (secondary) | `github.com/github/copilot-sdk/go` | Existing Go codebase; CLIs, daemons, systems/network tooling; single-binary distribution; high concurrency. |
| **Python** (secondary) | `github-copilot-sdk` | Existing Python codebase; data science / ML / notebooks; quick scripting or glue code; Python-first libraries. |

If the language is not stated, use TypeScript. If a secondary SDK is chosen, briefly
note the ecosystem-specific reason.

## Scaffolding steps

### TypeScript (default)

Prerequisites: Node.js `^20.19.0` or `>=22.12.0`.

1. `npm init -y`
2. `npm install @github/copilot-sdk`
3. `npm install -D typescript @types/node` and add a `tsconfig.json` (target ES2022, module NodeNext).
4. Create `src/index.ts` from the starter below.
5. Verify: `npx tsc --noEmit` then run.

```typescript
import { CopilotClient, approveAll } from "@github/copilot-sdk";

const client = new CopilotClient();
await client.start();

await using session = await client.createSession({
  model: "gpt-5",
  onPermissionRequest: approveAll,
});

const done = new Promise<void>((resolve) => {
  session.on("assistant.message", (e) => console.log(e.data.content));
  session.on("session.idle", () => resolve());
});

await session.send({ prompt: "What is 2+2?" });
await done;

await client.stop();
```

### Go (secondary)

Prerequisites: Go 1.24+; Copilot CLI in `PATH` (or set `COPILOT_CLI_PATH`).

1. `go mod init <module-path>`
2. `go get github.com/github/copilot-sdk/go`
3. Create `main.go` from the starter below.
4. Verify: `go build ./...` then `go run .`

```go
package main

import (
	"context"
	"fmt"
	"log"

	copilot "github.com/github/copilot-sdk/go"
)

func main() {
	client := copilot.NewClient(&copilot.ClientOptions{LogLevel: "error"})
	if err := client.Start(context.Background()); err != nil {
		log.Fatal(err)
	}
	defer client.Stop()

	session, err := client.CreateSession(context.Background(), &copilot.SessionConfig{
		Model:               "gpt-5",
		OnPermissionRequest: copilot.PermissionHandler.ApproveAll,
	})
	if err != nil {
		log.Fatal(err)
	}
	defer session.Disconnect()

	done := make(chan bool)
	session.On(func(event copilot.SessionEvent) {
		switch d := event.Data.(type) {
		case *copilot.AssistantMessageData:
			fmt.Println(d.Content)
		case *copilot.SessionIdleData:
			close(done)
		}
	})

	if _, err = session.Send(context.Background(), copilot.MessageOptions{Prompt: "What is 2+2?"}); err != nil {
		log.Fatal(err)
	}
	<-done
}
```

### Python (secondary)

Prerequisites: Python 3.11+.

1. Create a venv and activate it.
2. `pip install github-copilot-sdk`
3. `python -m copilot download-runtime` (caches the runtime binary).
4. Create `main.py` from the starter below.
5. Verify: `python main.py`

```python
import asyncio

from copilot import CopilotClient
from copilot.session_events import AssistantMessageData, SessionIdleData
from copilot.session import PermissionHandler


async def main():
    async with CopilotClient() as client:
        async with await client.create_session(
            on_permission_request=PermissionHandler.approve_all,
            model="gpt-5",
        ) as session:
            done = asyncio.Event()

            def on_event(event):
                match event.data:
                    case AssistantMessageData() as data:
                        print(data.content)
                    case SessionIdleData():
                        done.set()

            session.on(on_event)
            await session.send("What is 2+2?")
            await done.wait()


asyncio.run(main())
```

## After scaffolding

Once the dependency manifest exists (`package.json` / `go.mod` / `pyproject.toml`),
the `copilot-sdk.instructions.md` file auto-applies for the rest of the project, so
these preferences continue to steer subsequent work.
