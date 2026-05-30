# microservices-proto

Repositório de contratos **Protocol Buffers (proto)** do projeto de estudo de **gRPC** e da linguagem **Go**.

> Este repositório contém apenas as definições `.proto` e o código Go gerado a partir delas. A implementação do serviço está no repositório [microservices](https://github.com/Androka2004/microservices).

---

## Sobre o projeto

O objetivo é explorar na prática:

- Definição de contratos de API com **Protocol Buffers**
- Geração de código Go a partir de arquivos `.proto`
- Compartilhamento de contratos entre serviços via módulo Go separado
- Comunicação via **gRPC**

Separar os contratos em um repositório próprio é uma prática comum em arquiteturas de microserviços: permite que múltiplos serviços (em linguagens diferentes) consumam os mesmos contratos sem duplicação.

---

## Estrutura

```
microservices-proto/
├── order/
│   └── order.proto          # Definição do serviço Order e suas mensagens
└── golang/order/
    ├── go.mod               # Módulo Go do código gerado
    ├── order.pb.go          # Código gerado (mensagens)
    └── order_grpc.pb.go     # Código gerado (serviço gRPC)
```

### Contrato do serviço Order

```protobuf
service Order {
  rpc Create(CreateOrderRequest) returns (CreateOrderResponse) {}
}
```

| Mensagem | Campos |
|---|---|
| `CreateOrderRequest` | `costumer_id` (int32), `order_items` (repeated), `total_price` (float) |
| `OrderItem` | `product_code` (string), `unit_price` (float), `quantity` (int32) |
| `CreateOrderResponse` | `order_id` (int32) |

---

## Pré-requisitos para regenerar o código

- [protoc](https://grpc.io/docs/protoc-installation/) (compilador de Protocol Buffers)
- Plugin Go: `go install google.golang.org/protobuf/cmd/protoc-gen-go@latest`
- Plugin gRPC Go: `go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest`

---

## Regenerar o código Go

Caso edite o arquivo `.proto`, regenere o código com:

```bash
protoc --go_out=golang/order \
       --go-grpc_out=golang/order \
       --proto_path=order \
       order/order.proto
```

Os arquivos gerados (`order.pb.go`, `order_grpc.pb.go`) são commitados neste repositório e consumidos pelo serviço via diretiva `replace` no `go.mod` do [microservices](https://github.com/Androka2004/microservices).

---

## Como usar em conjunto com o serviço

Clone ambos os repositórios na mesma pasta pai:

```
pasta-pai/
├── microservices/       ← implementação do serviço
└── microservices-proto/ ← este repositório
```

O `go.mod` de `microservices/order` aponta para o módulo proto via:

```
replace github.com/Androka2004/microservices-proto/golang/order => ../../microservices-proto/golang/order
```

Siga as instruções de execução no README do repositório [microservices](https://github.com/Androka2004/microservices).