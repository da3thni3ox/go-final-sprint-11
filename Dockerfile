FROM golang:1.21.6 AS gobuild

WORKDIR /build

COPY . .

RUN go mod tidy && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o parcel ./


FROM alpine:3.20

RUN mkdir /app && adduser -S parcel

COPY --from=gobuild --chown=parcel:parcel /build/parcel /build/tracker.db /app/ 


WORKDIR /app
USER parcel

CMD ["/app/parcel"]
