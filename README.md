# Offline Botanist

An open-source app for getting to know the plants around you, fully offline. Log the plants you
find, record where and when you saw them, and keep notes on how each one is prepared, for example
as a tea.

It is part of a series of edge AI apps that run on the phone, with no server needed.

> **Safety.** Many edible and medicinal plants have toxic lookalikes. Nothing in this app is
> medical advice or a positive identification. Never prepare or eat a plant unless an expert
> source confirms what it is.

## Layout

| Path | What lives there |
|------|------------------|
| `packages/botany_core/` | Plant records and the field log. Pure Dart, no Flutter. Most logic goes here. |
| `lib/` | The Flutter app (Android for now). |

## Checks

CI runs these on every pull request. Run them locally before you push:

```bash
cd packages/botany_core && dart format . && dart analyze --fatal-infos && dart test
cd ../.. && flutter analyze --fatal-infos && flutter test
```

## License

MIT
