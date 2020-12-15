package handler

import (
	"github.com/go-kit/kit/endpoint"
	kithttp "github.com/go-kit/kit/transport/http"
	"github.com/gorilla/mux"
	"net/http"
	"poc-golang-rest-tdd/infrastructure/http/rest/add"
)

const (
	URLAdd   = "/v1"
)

type Handler interface{
	CreateHandlder()
}

type httpHandler struct {

}

func NewHandler() *httpHandler {
	return &httpHandler{}
}

type endpoints struct {
	Add func() endpoint.Endpoint
}

func makeServerEndpoints() endpoints {
	return endpoints{
		Add:           add.MakeAddEndpoint,
	}
}

func (http httpHandler) CreateHandler() http.Handler {

	r := mux.NewRouter()
	e := makeServerEndpoints()

	r.Methods("POST").Path(URLAdd).Handler(kithttp.NewServer(
		e.Add(),
		add.DecodeRequest,
		add.EncodeResponse,
	))

	return r
}
