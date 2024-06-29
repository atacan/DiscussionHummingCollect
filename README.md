# Hello

`httpClient` is initialised in `buildApplication(configuration:)` and is passed to `ToDoController`

Making a request and collecting the body of the response hits the fatalError.

## Reproduciton

Run

```bash
curl -v  -X "POST" "127.0.0.1:8080"
```

hits the fatalError in NIOCore library:

```console
NIOCore/NIOThrowingAsyncSequenceProducer.swift:777: Fatal error: NIOThrowingAsyncSequenceProducer allows only a single AsyncIterator to be created
```


