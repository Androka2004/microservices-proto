# microservices-proto

Repositório de contratos **Protocol Buffers (proto)** do projeto de estudo de **gRPC** e da linguagem **Go**.

> Este repositório contém apenas as definições `.proto` e o código Go gerado a partir delas. A implementação dos serviços está no repositório [microservices](https://github.com/Androka2004/microservices).

---

## Sobre o projeto

O objetivo é explorar na prática:

- Definição de contratos de API com **Protocol Buffers**
- Geração de código Go a partir de arquivos `.proto`
- Compartilhamento de contratos entre serviços via módulo Go separado
- Comunicação via **gRPC** entre múltiplos microserviços

Separar os contratos em um repositório próprio é uma prática comum em arquiteturas de microserviços: permite que múltiplos serviços (em linguagens diferentes) consumam os mesmos contratos sem duplicação.

---

## Estrutura

```
microservices-proto/
├── order/
│   └── order.proto              # Contrato do serviço Order
├── payment/
│   └── payment.proto            # Contrato do serviço Payment
├── shipping/
│   └── shipping.proto           # Contrato do serviço Shipping
└── golang/
    ├── order/
    │   ├── go.mod
    │   ├── order.pb.go
    │   └── order_grpc.pb.go
    ├── payment/
    │   ├── go.mod
    │   ├── payment.pb.go
    │   └── payment_grpc.pb.go
    └── shipping/
        ├── go.mod
        ├── shipping.pb.go
        └── shipping_grpc.pb.go
```

---

## Contratos

### Serviço Order

```protobuf
service Order {
  rpc Create(CreateOrderRequest) returns (CreateOrderResponse) {}
}
```

| Mensagem | Campos |
|---|---|
| `CreateOrderRequest` | `costumer_id` (int32), `order_items` (repeated OrderItem), `total_price` (float) |
| `OrderItem` | `product_code` (string), `unit_price` (float), `quantity` (int32) |
| `CreateOrderResponse` | `order_id` (int32) |

### Serviço Payment

```protobuf
service Payment {
  rpc Create(CreatePaymentRequest) returns (CreatePaymentResponse) {}
}
```

| Mensagem | Campos |
|---|---|
| `CreatePaymentRequest` | `user_id` (int64), `order_id` (int64), `total_price` (float) |
| `CreatePaymentResponse` | `payment_id` (int64), `bill_id` (int64) |

### Serviço Shipping

```protobuf
service Shipping {
  rpc Create(CreateShippingRequest) returns (CreateShippingResponse) {}
}
```

| Mensagem | Campos |
|---|---|
| `CreateShippingRequest` | `order_id` (int64), `order_items` (repeated ShippingItem) |
| `ShippingItem` | `product_code` (string), `unit_price` (float), `quantity` (int32) |
| `CreateShippingResponse` | `order_id` (int64), `delivery_days` (int32) |

O prazo de entrega é calculado pelo serviço Shipping: mínimo de 1 dia, acrescido de 1 dia a cada 5 unidades totais (`1 + total_qty / 5`).

---

## Pré-requisitos para regenerar o código

- [protoc](https://grpc.io/docs/protoc-installation/) (compilador de Protocol Buffers)
- Plugin Go: `go install google.golang.org/protobuf/cmd/protoc-gen-go@latest`
- Plugin gRPC Go: `go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest`

---

## Regenerar o código Go

Caso edite os arquivos `.proto`, regenere o código com:

```bash
# Order
protoc --go_out=golang/order \
       --go-grpc_out=golang/order \
       --proto_path=order \
       order/order.proto

# Payment
protoc --go_out=golang/payment \
       --go-grpc_out=golang/payment \
       --proto_path=payment \
       payment/payment.proto

# Shipping
protoc --go_out=golang/shipping \
       --go-grpc_out=golang/shipping \
       --proto_path=shipping \
       shipping/shipping.proto
```

Ou utilize o script `run.sh` (a partir da raiz de `microservices-proto/`) para gerar os três de uma vez:

```bash
bash run.sh
```

Os arquivos gerados são commitados neste repositório e consumidos pelos serviços via diretiva `replace` no `go.mod` de cada serviço em [microservices](https://github.com/Androka2004/microservices).

---

## Como usar em conjunto com os serviços

Clone ambos os repositórios na mesma pasta pai:

```
pasta-pai/
├── microservices/       ← implementação dos serviços
└── microservices-proto/ ← este repositório
```

O `go.mod` de cada serviço aponta para o módulo proto via diretiva `replace`:

```
replace github.com/Androka2004/microservices-proto/golang/order => ../../microservices-proto/golang/order
```

Siga as instruções de execução no README do repositório [microservices](https://github.com/Androka2004/microservices).